# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Support support for other operating systems (RedHat, Debian and FreeBSD)
- New parameters for service configuration (`$service_enable`, `$service_ensure`,
  `$service_name` to customize the service name, `$package_ensure` to allow 'latest' or 
  a specific version number)
- Add poolmon support

### Changed
- Minium required puppet version is now 4.9 for Hiera 5 support
- Module structure has been completely rewritten, uses standard module layout now
- Rename parameter `$packages_install` to `$package_manage`
- Lots of lint/style changes

### Fixed
- `require` on service would fail if `$package_manage` was `false`

## 0.1.0 - 2017-07-31
Initial release

[Unreleased]: https://github.com/oxc/puppet-dovecot/compare/v0.1.0...HEAD
