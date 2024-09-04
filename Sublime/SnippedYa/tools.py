import sublime
import sublime_plugin


class EnableInputHandler(sublime_plugin.ListInputHandler):
    def list_items(self):
        return [("Enable", True), ("Disable", False)]


class SetLogCommandsCommand(sublime_plugin.ApplicationCommand):
    def run(self, enable):
        if enable is not None:
            sublime.log_commands(enable)

    def input(self, args):
        return EnableInputHandler()


class SetLogInputCommand(sublime_plugin.ApplicationCommand):
    def run(self, enable):
        if enable is not None:
            sublime.log_input(enable)

    def input(self, args):
        return EnableInputHandler()


# def plugin_loaded():
#     def disable_vintage():
#         return sublime.run_command("disable_packages", {"packages": ["Vintage"]})

#     sublime.set_timeout_async(disable_vintage, 5000)
