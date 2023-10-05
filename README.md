Captain Comeback Sweetness Adapter
==================================

Aptible internal adapter for [Captain Comeback](https://github.com/aptible/captain-comeback).

# Requirements

You probably want to `pip install bump2version` and `gem install package_cloud`.

# Making changes

Be sure to bump the version if you intend to release, eg `bumpversion minor` or `bumpversion patch`.

When the new version is committed to the Master branch, a new wheel will be published [to Packagecloud](https://packagecloud.io/aptible/captain-comeback)

# Testing changes

* Create a branch, add your changes
* Run `make test` to be sure the tests that will run in CI pass locally
* Make sure your changes are committed, and publish a package to packagecloud: `make packagecloud-branch`

