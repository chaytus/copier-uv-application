"""Jinja2 extensions for the project."""

import re
import subprocess
import unicodedata
from datetime import date

from jinja2.ext import Extension


def git_user_name(default: str) -> str:
    """Get the git username."""
    return subprocess.getoutput("git config user.name").strip() or default


def git_user_email(default: str) -> str:
    """Get the git user email."""
    return subprocess.getoutput("git config user.email").strip() or default


def slugify(value, separator="-"):
    """Convert a string to a slug."""
    value = unicodedata.normalize("NFKD", str(value)).encode("ascii", "ignore").decode("ascii")
    value = re.sub(r"[^\w\s-]", "", value.lower())
    return re.sub(r"[-_\s]+", separator, value).strip("-_")


class GitExtension(Extension):
    """Jinja2 extension to get git user information."""

    def __init__(self, environment):
        super().__init__(environment)
        environment.filters["git_user_name"] = git_user_name
        environment.filters["git_user_email"] = git_user_email


class SlugifyExtension(Extension):
    """Jinja2 extension to slugify a string."""

    def __init__(self, environment):
        super().__init__(environment)
        environment.filters["slugify"] = slugify


class CurrentYearExtension(Extension):
    """Jinja2 extension to get the current year."""

    def __init__(self, environment):
        super().__init__(environment)
        environment.globals["current_year"] = date.today().year
