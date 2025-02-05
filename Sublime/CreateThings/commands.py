import logging
from functools import partial
from html.entities import html5
from typing import List, Optional

import sublime
import sublime_plugin

from . import lib
from .lib.log import configure_logging

logger = configure_logging("create-things", logging.INFO)


class ReplInputHandler(sublime_plugin.TextInputHandler):
    def next_input(self, args):
        return TestInputHandler()


class TestInputHandler(sublime_plugin.ListInputHandler):
    def list_items(self):
        return sorted(html5.keys())

    def preview(self, value):
        return "Character: {}".format(html5.get(value))


class CopyPackagesPathCommand(sublime_plugin.ApplicationCommand):
    def run(self, test: Optional[str] = None, repl: Optional[str] = None):
        sublime.set_clipboard(sublime.packages_path())
        window = sublime.active_window()
        if window.is_status_bar_visible():
            view = window.active_view()
            if view:
                view.set_status("copy_packages", "Packages Path Copied")
                sublime.set_timeout_async(partial(self.clear_status, view), 1000)

    def clear_status(self, view: sublime.View):
        view.erase_status("copy_packages")


# class SetPythonInterpreterCommand(sublime_plugin.EventListener):
#     @classmethod
#     def is_applicable(cls, settings: sublime.Settings):
#         print(settings.to_dict())
#         print("")
#         return False

#     # def on_init(self, views: List[sublime.View]):
#     #     py_views = (v for v in views if v.match_selector(0, "source.python"))
#     #     [self.set_interpreter(v) for v in py_views]

#     def on_load_async(self, view: sublime.View):
#         if view.match_selector(0, "source.python"):
#             self.set_interpreter(view)

#     def set_interpreter(self, view: sublime.View):
#         settings = view.settings()
#         if settings.get("python_interpreter") is None:
#             logger.info("Setting `python_interpreter` on %s", view.file_name())
#         else:
#             logger.info("`python_interpreter` already set on %s", view.file_name())


# class DeleteAndCloseFileCommand(sublime_plugin.TextCommand):
#     def run(self, edit):
#         pass


def plugin_unloaded():
    import sys

    to_pop: List[str] = []
    for mod_name in sys.modules:
        if lib.__name__ in mod_name:
            to_pop.append(mod_name)
    logger.debug("Unloading %d module%s", len(to_pop), "" if len(to_pop) == 1 else "s")
    for mod_name in to_pop:
        sys.modules.pop(mod_name)
