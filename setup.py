#!/usr/bin/env python
# coding: utf-8
import os
from setuptools import setup, find_packages

HERE = os.path.dirname(__file__)

with open(os.path.join(HERE, 'README.md')) as readme_file:
    readme = readme_file.read()

with open(os.path.join(HERE, 'requirements.txt')) as f:
    requirements = [l.strip() for l in f.readlines()]

with open(os.path.join(HERE, 'test_requirements.txt')) as f:
    test_requirements = [l.strip() for l in f.readlines()]

setup(
    name='captain_comeback_sweetness_adapter',
    version='0.1.0',
    description="Captain Comeback Restart Adapter that pushes a RecoverContainer Task to Sweetness",
    long_description=readme,
    author="Thomas Orozco",
    author_email='thomas@aptible.com',
    url='https://github.com/aptible/captain_comeback_sweetness_adapter',
    packages=find_packages(include=['captain_comeback_sweetness_adapter']),
    include_package_data=True,
    install_requires=requirements,
    license="MIT license",
    zip_safe=False,
    keywords='captain_comeback_sweetness_adapter',
    classifiers=[
        'Development Status :: 2 - Pre-Alpha',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: MIT License',
        'Natural Language :: English',
        "Programming Language :: Python :: 2",
        'Programming Language :: Python :: 2.6',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.3',
        'Programming Language :: Python :: 3.4',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.11',
    ],
    test_suite='captain_comeback_sweetness_adapter.test',
    tests_require=test_requirements
)
