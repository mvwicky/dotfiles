"""Autocomplete bootstrap classes.

Originally from: github.com/proficientdesigners/sublime-text-bs4-autocomplete/
"""
import json
import logging
import logging.config
from pathlib import Path
from typing import Any, List, Union, Iterable

import sublime
import sublime_plugin

HERE = Path(__file__).parent
CLASSES_FILE = HERE / "bootstrap_classes.json"
VERSION = "4.4"
CLASS_SELECTOR = "text.html meta.attribute-with-value.class"
DATA_SELECTOR = "text.html meta.tag - text.html punctuation.definition.tag.begin"
CLASS_COMPLETIONS: List[str] = []
DATA_COMPLETIONS: List[str] = []
LIMIT = 250

NAME = "bootstrap4"


def configure_logger(name: str, level: int) -> logging.Logger:
    logging.Formatter.default_msec_format = "%s.%03d"
    fmt = "[{asctime}] [{levelname:7}] {name}:{filename}#{lineno} {message}"
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
            "incremental": True,
        }
    )
    return logging.getLogger(name)


logger = configure_logger(NAME, logging.DEBUG)


def load_class_completions() -> Iterable[sublime.CompletionItem]:
    data = json.loads(CLASSES_FILE.read_bytes())
    classes = data.get("classes", [])
    version = data.get("version", VERSION)
    kind = (sublime.KIND_ID_MARKUP, "c", "")
    annotation = "Bootstrap {0}".format(version)
    return (sublime.CompletionItem(c, annotation, kind=kind) for c in classes)


class BootstrapCompletions(sublime_plugin.EventListener):
    def on_query_completions(
        self, view: sublime.View, prefix: str, locations: List[int]
    ) -> Union[List[Any], None]:
        loc = locations[0]
        if view.match_selector(loc, CLASS_SELECTOR):
            cursor = loc - len(prefix) - 1
            start = max(0, cursor - LIMIT - len(prefix))
            line = view.substr(sublime.Region(start, cursor))
            parts = line.split("=")
            if len(parts) > 1 and parts[-2].strip().endswith("class"):
                if not CLASS_COMPLETIONS:
                    logger.debug("Loading class completions")
                    CLASS_COMPLETIONS.extend(load_class_completions())
                    logger.debug(
                        "Loaded class completions (%d classes)", len(CLASS_COMPLETIONS)
                    )
                return CLASS_COMPLETIONS
        elif view.match_selector(loc, DATA_SELECTOR):
            return DATA_COMPLETIONS
        return None
