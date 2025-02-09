set shell := ["bash", "-uc"]
set positional-arguments

# List all available recipes
@help:
  just --list

# Create a git repo if not exists, install dependencies and pre-commit hooks
@init: ensure-git install


@install:
  #!/bin/bash
  set -euxo pipefail
  echo "Installing dependencies..."
  rye sync

  echo "Installing pre-commit hooks..."
  rye run pre-commit install --install-hooks

# Update the lockfile (e.g. after manually editing `pyproject.toml`)
@lock:
  rye lock

# Update dependencies and update pre-commit hooks
@update-hooks:
  echo "Updating pre-commit hooks..."
  rye run pre-commit install-hooks
  rye run pre-commit autoupdate

# Format code with black and isort
@fmt:
  rye run ruff format -- src tests
  rye run ruff check --select=I001 --fix src tests

# Lint the project with Ruff
@lint:
  rye run ruff check -- src tests

# Perform static type checking with mypy
@typecheck:
  rye run mypy -- src tests

# Audit dependencies with pip-audit
@audit:
  rye run pip-audit
  rye run deptry -- src tests

# Run all pre-release checks
pre-release: fmt lint typecheck audit check-bump

# Bump the version
@bump: check-bump
  rye run cz bump

# Run pre-commit checks
pre-commit:
  git add . & rye run pre-commit run

# Release a new version
release: fmt audit lint typecheck bump
  git push
  git push --tag

# Commit with conventional commits
@commit:
  rye run cz commit

alias c := commit

# Run all CI checks
ci: fmt lint typecheck audit check-bump

# Run all tests
test:
  rye run pytest --cov=src/ --cov-report=term-missing --cov-report=html --disable-warnings

# Set default version of the documentation
@set-default-docs-version:
  rye run mike set-default latest

# Serve documentation locally
serve-doc:
  rye run mkdocs serve --config-file=mkdocs.yml

# Live preview the documentation as it would be on production
preview-docs:
  rye run mike serve --config-file=mkdocs.yml

# Check whether the commit messages follow the conventional commit format
check-commits:
  #! /usr/bin/env zsh
  set -euo pipefail

  local revs
  revs=($(git rev-list origin/main..HEAD))

  if [[ $#revs -eq 0 ]]; then
    echo "No commits to check."
    exit 0
  else
    rye run cz check --rev-range origin/main..HEAD
  fi

# Check the version can be bumped without errors
@check-bump:
  rye run cz bump --dry-run

# Assert a command is available
[private]
needs *commands:
  #!/bin/bash
  set -euxo pipefail
  for cmd in "$@"; do
    if ! command -v $cmd &> /dev/null; then
      echo "$cmd binary not found. Did you forget to install it?"
      exit 1
    fi
  done

# Create a local git repo if not in one
[private]
@ensure-git:
  #!/bin/bash
  set -euxo pipefail
  just needs git
  if ! git rev-parse --is-inside-work-tree &> /dev/null; then
    git init
  fi
