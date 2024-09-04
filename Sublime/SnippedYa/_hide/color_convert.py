import colorsys
import re

import sublime_plugin

h_digit = "(?P<{0}>[a-f0-9]{{{n}}})"
names = ["red", "green", "blue"]

_hex_start = "^#?"


def make_hex_re(n):
    nc = int(n / len(names))
    rgb_pattern = "".join([h_digit.format(name, n=nc) for name in names])
    a_pattern = "".join([h_digit.format("alpha", n=nc), "?"])
    full_pattern = "".join([rgb_pattern, a_pattern])
    return re.compile(full_pattern.join([_hex_start, "$"]), re.I)


_hex_three = "".join([h_digit.format(name, n=1) for name in names])
_hex_six = "".join([h_digit.format(name, n=2) for name in names])


# HEX_THREE_RE = re.compile(_hex_three.join([_hex_start, "$"]), re.I)
# HEX_SIX_RE = re.compile(_hex_six.join([_hex_start, "$"]), re.I)
HEX_THREE_RE = make_hex_re(3)
HEX_SIX_RE = make_hex_re(6)


def selection_start(sel):
    return min(sel.a, sel.b)


def selection_end(sel):
    return max(sel.a, sel.b)


def rgb_hex(s):
    mat = HEX_THREE_RE.match(s) or HEX_SIX_RE.match(s)
    if mat is None:
        return None
    parts = mat.groups()
    values = []
    for part in parts:  # type: str
        if part is not None:
            if len(part) == 1:
                part = part * 2
            values.append(int(part, 16) / 255)
        else:
            values.append(1)
    # assert len(values) == 4
    return values


class ConvertColorCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        print("Running ConvertColorCommand")
        sel = self.view.sel()[0]
        substr = self.view.substr(sel)
        rgb_hex(substr)
        # print(selection_start(sel), selection_end(sel), self.view.substr(sel))
        # print(self.view.sel())


def plugin_loaded():
    return
    print(colorsys.rgb_to_hls(*rgb_hex("012")[:3]))
    print(rgb_hex("012b"))
    mat = HEX_THREE_RE.match("012")
    if mat:
        print(mat.groups())
    mat = HEX_SIX_RE.match("123456aa")
    print(rgb_hex("123456aa"))
    if mat:
        print(mat.groupdict())
