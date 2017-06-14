release: clean
	python setup.py sdist upload
	python setup.py bdist_wheel upload

dist: clean
	python setup.py sdist
	python setup.py bdist_wheel
	ls -l dist

install: clean
	python setup.py install

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
	# python setup.py nosetests

integration: install
	integration/test.sh

test: unit integration

.PHONY: release dist install clean-tox clean-pyc clean-build test unit integration
