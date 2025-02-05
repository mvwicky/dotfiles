import os
import sys
from typing import Dict, List

import sublime
import sublime_plugin


def plugin_unloaded():
    from . import lib

    lib_name = lib.__name__
    to_pop: List[str] = []
    for mod_name in sys.modules:
        if lib_name in mod_name:
            to_pop.append(mod_name)
    if to_pop:
        print([sys.modules.pop(mod) for mod in to_pop])


class LocationInputHandler(sublime_plugin.TextInputHandler):
    def __init__(self, initial_path: str):
        super().__init__()
        self.initial_path = initial_path
        if not self.initial_path.endswith(os.sep):
            self.initial_path = "".join((self.initial_path, os.sep))

    def validate(self, text):
        return not os.path.isdir(os.path.normpath(text))

    def initial_text(self):
        return self.initial_path

    def description(self, text):
        print(self.initial_path)
        return self.initial_path


class NewPythonPackageCommand(sublime_plugin.WindowCommand):
    encoding = "utf-8"

    def description(self):
        return "New Python Package"

    def run(self, *args, **kwargs):
        print(args, kwargs)
        # self.on_done(location)

    def input(self, args: Dict[str, List[str]]):
        dirs = args.get("dirs", None)
        if dirs and isinstance(dirs, list) and isinstance(dirs[-1], str):
            path = dirs.pop()
        else:
            project_file_name = self.window.project_file_name()
            if project_file_name:
                path = os.path.dirname(project_file_name)
            else:
                view = self.window.active_view()
                if view:
                    file_name = view.file_name()
                    if file_name:
                        path = os.path.dirname(file_name)
                return
        return LocationInputHandler(path)

    def on_done(self, data):
        new_pkg_dir = os.path.normpath(data)
        new_pkg_name = os.path.basename(new_pkg_dir)
        if os.path.isdir(new_pkg_dir):
            sublime.error_message("Directory already exists.")
            return
        print("Creating {0} package at {1}".format(new_pkg_name, new_pkg_dir))
        os.makedirs(new_pkg_dir)
        init_file = os.path.join(new_pkg_dir, "__init__.py")
        with open(init_file, "wt"):
            pass

    def on_change(self, data):
        pass

    def on_cancel(self):
        print("Canceled")
