#!/usr/bin/env python3
from __future__ import annotations

import os
import stat
from argparse import ArgumentParser, ArgumentTypeError
from collections.abc import Iterable
from pathlib import Path
from typing import NamedTuple, TypeVar

HERE: Path = Path(__file__).resolve().parent

_P = TypeVar("_P", Path, str, bytes)


class PathType(object):
    def __init__(
        self,
        exists: bool = False,
        dir_okay: bool = True,
        file_okay: bool = True,
        resolve: bool = False,
    ):
        self.exists = exists
        self.dir_okay = dir_okay
        self.file_okay = file_okay
        self.resolve = resolve

    def __call__(self, value: str) -> Path:
        p = Path(value)
        if self.resolve:
            p = p.resolve()
        try:
            st = p.stat()
        except OSError:
            if not self.exists:
                return p
            raise ArgumentTypeError(f"{value!r} does not exist")

        if not self.dir_okay and stat.S_ISDIR(st.st_mode):
            raise ArgumentTypeError("Argument was a directory.")
        if not self.file_okay and stat.S_ISREG(st.st_mode):
            raise ArgumentTypeError("Argument was a file.")
        return p


def iter_dirs(paths: Iterable[_P]) -> Iterable[_P]:
    return (p for p in paths if os.path.isdir(p))


def only_dirs(paths: Iterable[_P]) -> list[_P]:
    return list(iter_dirs(paths))


class Args(NamedTuple):
    search_path: Path
    exclude: list[str]
    only: list[str]
    force: bool
    dry_run: bool
    packages: Path

    @classmethod
    def from_parser(cls: type["Args"], parser: ArgumentParser) -> "Args":
        return cls(**vars(parser.parse_args()))

    def dirs(self) -> list[Path]:
        exclude_dirs = set(iter_dirs(self.search_path / e for e in set(self.exclude)))
        dirs: list[Path] = []
        for d in iter_dirs(self.search_path.iterdir()):
            if d not in exclude_dirs:
                dirs.append(d)

        if self.only:
            only = set(iter_dirs(self.search_path / e for e in set(self.only)))
            dirs = [d for d in dirs if d in only]
        dirs.sort()
        return dirs


class ToLink(NamedTuple):
    src: Path
    dest: Path


def get_args():
    parser = ArgumentParser(
        description="Symlink directories to the Sublime Text packages folder.",
        epilog=(
            "To find the Packages path, run `sublime.packages_path()` in the "
            "Sublime Text console."
        ),
    )
    parser.add_argument(
        "-s",
        "--search-path",
        type=PathType(file_okay=False),
        default=HERE,
        help="where to look for directories",
    )
    group = parser.add_argument_group("directories", "Specify directories")
    group.add_argument(
        "-e", "--exclude", action="append", help="Ignore named directories", default=[]
    )
    group.add_argument(
        "-o",
        "--only",
        action="append",
        help="Only copy the named directories",
        default=[],
    )
    parser.add_argument(
        "-f",
        "--force",
        action="store_true",
        help="Remove and recreate links if they already exist",
    )
    parser.add_argument(
        "-n", "--dry-run", action="store_true", help="Don't actually link anything"
    )
    parser.add_argument(
        "packages",
        type=PathType(file_okay=False, resolve=True),
        help="The Sublime Text packages path",
    )
    return Args.from_parser(parser)


def get_packages_path():
    import subprocess

    subl_args = ["subl", "--command", "copy_packages_path"]
    print("Running: `", " ".join(subl_args), "`", sep="")
    subprocess.run(subl_args, check=True)
    pbpaste_args = ["pbpaste"]
    print("Running: `", " ".join(pbpaste_args), "`", sep="")
    pbpaste_cmd = subprocess.run(["pbpaste"], check=True, text=True)
    return pbpaste_cmd.stdout


def make_link(to_link: ToLink, force: bool, dry_run: bool):
    src, dest = to_link
    if force and dest.exists():
        dest.unlink()
    if not dry_run:
        dest.symlink_to(src, target_is_directory=True)
    else:
        print("Would link:", end=" ")
    print(f"{src.name} -> {dest}")


def main():
    args = get_args()
    to_link: list[ToLink] = []
    print("Packages path:", args.packages)
    for d in args.dirs():
        pkg_dir = args.packages / d.name
        if args.force or not pkg_dir.is_symlink():
            to_link.append(ToLink(d, pkg_dir))
        else:
            rel = os.path.relpath(d, args.search_path)
            print("Already linked:", rel)

    for elem in to_link:
        make_link(elem, args.force, args.dry_run)


if __name__ == "__main__":
    main()
