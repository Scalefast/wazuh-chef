# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.1] - 2021-08-19

### Added

- This changelog.
- A Berksfile configuration file.

### Changed

- Chef minimum version lowered to Chef 14.
- `wazuh_agent` metadata now points to [Scalefast's repo fork](https://github.com/Scalefast/wazuh-chef).

### Fixed

- Cookstyle.
- Missing `platform_family?('suse')` on `repository.rb` recipe for custom SUSE code.

[Unreleased]: https://github.com/Scalefast/wazuh-chef/compare/v0.1.1...master
[0.1.1]: https://github.com/Scalefast/wazuh-chef/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/Scalefast/wazuh-chef/tags/v0.1.0
