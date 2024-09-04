import sublime_plugin


class DotenvCommand(sublime_plugin.WindowCommand):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    @property
    def project_path(self):
        return self.window.extract_variables().get("project_path")
