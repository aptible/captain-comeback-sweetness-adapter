Captain Comeback Sweetness Adapter
==================================

Aptible internal adapter for [Captain Comeback](https://github.com/aptible/captain-comeback).

# Requirements

You probably want to `pip install bump2version` and `gem install package_cloud`.

# Making changes

Be sure to bump the version if you intend to release, eg `bumpversion minor` or `bumpversion patch`.

When a new version is committed to the Master branch, a new wheel will be published [to Packagecloud](https://packagecloud.io/aptible/captain-comeback)

# Testing changes

* Create a branch, add your changes
* Run `make test` to be sure the tests that will run in CI pass locally
* Make sure your changes are committed, and publish a package to packagecloud: `make packagecloud-branch`
* Grab the package version from the last line of the output (it will be version `0.0.0-$(GIT_COMMIT)`)
* Update your stack's setting, eg `chamber write sbx-alex/sweetness/settings captain_comeback_sweetness_adapter_version 0.0.0-deadbeaf12`
* Run the captain-comeback recipe against your stack, eg `create_operation! stack, 'run_recipe', command: 'aptible::captain_comeback'`

# Releasing

* AMI's will always be built using the latest version in Packagecloud.
* Running the `aptible::captain_comback` recipe on an instance will, by default, upgrade it to the latest version.
* You can set "requirement specifiers" with sweetness settings `captain_comeback_sweetness_adapter_version`, eg "==0.2.0" or ">=0.1.9" if we need to use a specific version, or downgrade.
