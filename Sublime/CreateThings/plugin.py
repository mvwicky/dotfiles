import enum
import logging
import logging.config
import os
import sys
from pathlib import Path
from typing import Any, List, Mapping, MutableSequence, Tuple, Union

import sublime
import sublime_plugin


def configure_logging(name: str, level: int) -> logging.Logger:
    fmt = "[{asctime}] [{levelname:7}] {name}:{filename} {message}"
    logging.config.dictConfig(
        {
            "loggers": {name: {"handlers": ["stream"], "level": level}},
            "handlers": {
                "stream": {
                    "level": level,
                    "class": "logging.StreamHandler",
                    "formatter": "stream",
                }
            },
            "formatters": {"stream": {"style": "{", "format": fmt}},
            "version": 1,
        }
    )
    return logging.getLogger(name)


logger = configure_logging("new-python-file", logging.INFO)


class TemplateOption(enum.Flag):
    NOTHING = enum.auto()
    LOGGING = enum.auto()
    ANNOTATIONS = enum.auto()

    ALL = LOGGING | ANNOTATIONS

    def get_template(self) -> str:
        parts = []
        if self & TemplateOption.ANNOTATIONS:
            parts.append("from __future__ import annotations")
        if self & TemplateOption.LOGGING:
            if parts:
                parts.append("")
            parts.extend(["import logging", "", "logger = logging.getLogger(__name__)"])
        if parts:
            parts.append("")
        return "\n".join(parts)


TEMPLATES: List[Tuple[str, TemplateOption]] = [
    ("Blank", TemplateOption.NOTHING),
    ("Logger", TemplateOption.LOGGING),
    ("Annotations import", TemplateOption.ANNOTATIONS),
    ("Logger and Annotations", TemplateOption.ALL),
]


class TemplateOptionsInputHandler(sublime_plugin.ListInputHandler):
    def __init__(self) -> None:
        super().__init__()

    def list_items(self):
        items = [sublime.ListInputItem(label, value.name) for label, value in TEMPLATES]
        logger.debug("items: %r", items)
        return items

    def preview(self, value: str):
        try:
            options = TemplateOption[value]
        except KeyError:
            return value
        else:
            return sublime.Html("<pre>{0}</pre>".format(options.get_template()))

    def initial_text(self):
        text = super().initial_text()
        logger.debug("initial-text=%s", text)
        return text


class LocationInputHandler(sublime_plugin.TextInputHandler):
    """Get file location.

    TODO: Show child directories, if the current input is a directory.
    """

    def __init__(self, initial_path: str):
        super().__init__()
        self.initial_path = initial_path
        if not self.initial_path.endswith(os.sep):
            self.initial_path = "".join((self.initial_path, os.sep))

    def get_current_path(self, text: str) -> Path:
        return Path(os.path.normpath(text))

    def validate(self, text: str) -> bool:
        return not os.path.isfile(self.get_current_path(text))

    def initial_text(self) -> str:
        return self.initial_path

    def get_folder_components(self, path: Path) -> str:
        parts: list[str] = []
        parents = reversed(path.parents)
        for parent in parents:
            css_class = "not-a-dir" if not parent.is_dir() else "is-a-dir"
            parts.append('<span class="{0}">{1}</span>'.format(css_class, parent.name))
        return os.sep.join(parts)

    def preview(self, text: str) -> sublime.Html:
        path = self.get_current_path(text)
        file_class = "is-a-file" if os.path.isfile(path) else "not-a-file"
        file = '<span class="file {file_class}">{file}</span>'.format(
            file_class=file_class, file=os.path.basename(path)
        )
        logger.debug("%s", file)
        folder = self.get_folder_components(path)
        html = """<body id="new-python-file-placeholder">
            <style>
                span.not-a-dir {{
                    color: var(--yellowish);
                    font-weight: bold;
                }}
                span.file {{
                    font-weight: bold;
                }}
                span.not-a-file {{
                    color: var(--greenish);
                }}
                span.is-a-file {{
                    color: var(--redish);
                }}
            </style>
            {folder}{sep}{file}
        </body>
        """.format(folder=folder, sep=os.path.sep, file=file)
        return sublime.Html(html)

    def initial_selection(self) -> List[Tuple[int, int]]:
        return [(len(self.initial_path), len(self.initial_path))]

    def next_input(self, args):
        return TemplateOptionsInputHandler()


class NewPythonFileCommand(sublime_plugin.WindowCommand):
    encoding = "utf-8"

    path: Union[str, None] = None
    view: Union[sublime.View, None] = None

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.current_path: Union[str, None] = None

    def run(
        self,
        paths: Union[MutableSequence[str], None] = None,
        location: Union[str, None] = None,
        template_options: Union[str, None] = None,
    ):
        self.current_path = None
        logger.debug("paths=%r", paths)
        self.path = self.get_dir(None)
        if paths:
            self.path = self.get_dir(paths)
            logger.debug("self.path=%s", self.path)
            self.view = self.window.show_input_panel(
                "File Name",
                self.path,
                self.on_path_selected,  # type: ignore
                self.on_change,
                self.on_cancel,
            )
        elif location and template_options:
            self.on_path_selected(location, template_options)

    def input(self, args: Mapping[str, Any]) -> LocationInputHandler:
        paths = args.get("paths", None)
        self.path = self.get_dir(paths)
        return LocationInputHandler(self.path)

    def input_description(self) -> str:
        return "File Name"

    def clear_view(self):
        if self.view is not None:
            self.view = None

    def get_dir(self, paths: Union[MutableSequence[str], None]) -> str:
        logger.debug("paths=%r", paths)
        window = self.window
        if paths is not None:
            path = paths.pop()
            if os.path.isfile(path):
                path = os.path.dirname(path)
        else:
            view = window.active_view()
            if view:
                file_name = view.file_name()
                if file_name is None:
                    path = os.path.dirname(window.project_file_name() or os.getcwd())
                else:
                    path = os.path.dirname(file_name)
        if not path.endswith(os.sep):
            path = "".join((path, os.sep))
        return path

    def on_path_selected(self, data: str, template: Union[str, None]):
        self.clear_view()
        logger.debug("data=%r", data)
        if self.path is not None:
            file = os.path.normpath(os.path.join(self.path, data))
            if os.path.isfile(file):
                sublime.error_message("File already exists.")
                return
            if template:
                try:
                    options = TemplateOption[template]
                except KeyError:
                    return
                self.create_file(file, options)
                self.current_path = file

    def create_file(self, file: str, template: TemplateOption):
        with open(file, "wt", encoding=self.encoding) as f:
            f.write(template.get_template())
        view = self.window.open_file(file)
        view.run_command("move_to", {"to": "eof"})

    def on_change(self, data: str):
        print("changed", repr(data))

    def on_cancel(self):
        self.clear_view()
        print("Canceled")


def plugin_unloaded():
    from . import lib

    lib_name = lib.__name__
    to_pop: List[str] = []
    for mod_name in sys.modules:
        if lib_name in mod_name:
            to_pop.append(mod_name)
    if to_pop:
        print(to_pop)
        [sys.modules.pop(mod) for mod in to_pop]
