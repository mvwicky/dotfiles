# import os

# import sublime_plugin

# HERE = os.path.dirname(os.path.abspath(__file__))
# # print(HERE)


# capture_script = os.path.join(HERE, "capture_completions.zsh")
# cap_exists = os.path.isfile(capture_script)


# def selection_start(sel):
#     return min(sel.a, sel.b)


# def selection_end(sel):
#     return max(sel.a, sel.b)


# class CompListener(sublime_plugin.EventListener):
#     def on_query_completions(self, view, prefix, locations):
#         if not cap_exists:
#             return None
#         sel = selection_start(view.sel()[0])
#         if view.score_selector(sel, "source.shell") == 0:
#             return None
#         if view.score_selector(sel, "string.quoted") > 0:
#             return None
#         if view.score_selector(sel, "comment") > 0:
#             return None
#         return None
