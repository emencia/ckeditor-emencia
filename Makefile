PYTHON_INTERPRETER=python3
VENV_PATH=.venv
PIP=$(VENV_PATH)/bin/pip
TWINE=$(VENV_PATH)/bin/twine
PYTEST=$(VENV_PATH)/bin/pytest
PACKAGE_NAME=ckeditor-emencia
PACKAGE_SLUG=`echo $(PACKAGE_NAME) | tr '-' '_'`
APPLICATION_NAME=ckeditor_emencia

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo
	@echo "  install               -- to install this project with virtualenv and Pip"
	@echo ""
	@echo "  clean                 -- to clean EVERYTHING (Warning)"
	@echo "  clean-install         -- to clean Python side installation"
	@echo "  clean-pycache         -- to remove all __pycache__, this is recursive from current directory"
	@echo ""
	@echo "  tests                 -- to launch base test suite using Pytest"
	@echo "  quality               -- to launch every tests suites and check release"
	@echo ""
	@echo "  check-release         -- to build package and check it with Twine before making a release"
	@echo "  release               -- to release package for latest version on PyPi (once release has been pushed to repository)"
	@echo

clean-pycache:
	@echo ""
	@echo "==== Clear cache ===="
	@echo ""
	find . -type d -name "__pycache__"|xargs rm -Rf
	find . -name "*\.pyc"|xargs rm -f
	rm -Rf .pytest_cache
	rm -Rf .tox
.PHONY: clean-pycache

clean-install:
	@echo ""
	@echo "==== Clear installation ===="
	@echo ""
	rm -Rf $(VENV_PATH)
	rm -Rf $(PACKAGE_SLUG).egg-info
.PHONY: clean-install

clean: clean-install clean-pycache
.PHONY: clean

venv:
	@echo ""
	@echo "==== Install virtual environment ===="
	@echo ""
	virtualenv -p $(PYTHON_INTERPRETER) $(VENV_PATH)
.PHONY: venv

install: venv
	@echo ""
	@echo "==== Install everything for development ===="
	@echo ""
	$(PIP) install -e .[dev]
.PHONY: install

tests:
	$(PYTEST) -vv tests/
.PHONY: tests

build-package:
	@echo ""
	@echo "==== Build package ===="
	@echo ""
	rm -Rf dist
	$(VENV_PATH)/bin/python setup.py sdist
.PHONY: build-package

check-release: build-package
	@echo ""
	@echo "==== Check package ===="
	@echo ""
	$(TWINE) check dist/*
.PHONY: check-release

release: build-package
	@echo ""
	@echo "==== Release ===="
	@echo ""
	$(TWINE) upload dist/*
.PHONY: release

quality: tests check-release
	@echo ""
	@echo "♥ ♥ Everything should be fine ♥ ♥"
	@echo ""
.PHONY: quality
