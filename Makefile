packagecloud: clean
	python setup.py bdist_wheel
	package_cloud push aptible/captain-comeback/python dist/captain_comeback_sweetness_adapter-*

COMMIT_ID := $(shell git rev-parse --short HEAD)
packagecloud-branch: clean
	bumpversion major --new-version 0.0.0-$(COMMIT_ID) --no-commit
	python setup.py bdist_wheel
	git stash push -m auto_stash_$(COMMIT_ID)
	package_cloud push aptible/captain-comeback/python dist/captain_comeback_sweetness_adapter-*

install:
	docker compose build

clean: clean-tox clean-build clean-pyc

clean-build:
	rm -fr build/
	rm -fr dist/
	rm -fr *.egg-info

clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +

clean-tox:
	rm -rf .tox/

unit:
	# docker compose run adapter nose2 -v

integration: install
	docker compose run adapter integration/test.sh

test: unit integration

.PHONY: release dist install clean-tox clean-pyc clean-build test unit integration packagecloud packagecloud-branch
