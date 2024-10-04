#!/usr/bin/env python3

import os
from pathlib import Path


def _path_from_env(name: str, default: Path) -> Path:
    if (value := os.environ.get(name)) and (path := Path(value)).is_absolute():
        return path
    return default


HOME = Path.home()
XDG_CONFIG_HOME = _path_from_env("XDG_CONFIG_HOME", HOME / ".config")


def main():
    print(f"{HOME=!s}")
    print(f"{XDG_CONFIG_HOME=!s}")


if __name__ == "__main__":
    main()
