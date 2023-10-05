release: clean
	python setup.py sdist upload
	python setup.py bdist_wheel upload

dist: clean
	python setup.py sdist
	python setup.py bdist_wheel
	ls -l dist

packagecloud: clean
	python setup.py bdist_wheel
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

.PHONY: release dist install clean-tox clean-pyc clean-build test unit integration
