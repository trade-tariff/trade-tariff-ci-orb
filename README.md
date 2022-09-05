# Trade Tariff CI Orb

[![CircleCI Build Status](https://circleci.com/gh/trade-tariff/trade-tariff-ci-orb.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/trade-tariff/trade-tariff-ci-orb) [![CircleCI Orb Version](https://badges.circleci.com/orbs/trade-tariff/trade-tariff-ci-orb.svg)](https://circleci.com/orbs/registry/orb/trade-tariff/trade-tariff-ci-orb) [![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/trade-tariff/trade-tariff-ci-orb/master/LICENSE) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/orbs)

This project contains commands and jobs to be used across the CI pipelines in the other Trade Tariff repos

Additional READMEs are available in each directory.

## Resources

[CircleCI Orb Registry Page](https://circleci.com/orbs/registry/orb/trade-tariff/trade-tariff-ci-orb) - The official registry page of this orb for all versions, executors, commands, and jobs described.
[CircleCI Orb Docs](https://circleci.com/docs/2.0/orb-intro/#section=configuration) - Docs for using and creating CircleCI Orbs.

### How to Contribute

Raise a pull request [pull requests](https://github.com/trade-tariff/trade-tariff-ci-orb/pulls) against this repository!

### How to Publish

- Create and push a branch with your new features.
- When ready to publish a new production version, create a Pull Request from _feature branch_ to `main`.
- The title of the pull request must contain a special semver tag: `[semver:<segment>]` where `<segment>` is replaced by one of the following values.

| Increment | Description                       |
| --------- | --------------------------------- |
| major     | Issue a 1.0.0 incremented release |
| minor     | Issue a x.1.0 incremented release |
| patch     | Issue a x.x.1 incremented release |
| skip      | Do not issue a release            |

Example: `[semver:major]`

- Squash and merge. Ensure the semver tag `[semver:patch]` is preserved and entered as a part of the first line (title) of the commit message.
- On merge, the orb will be automatically published to the repository

_Notes:_

- If merging multiple commits - they will be squashed and you will need to edit the commit message to add the `[semver:patch]` tag in the title
- If merging a single commit - you will not be able to edit the commit message, so to release, the commit message must have `[semver:patch]` in the first line

For further questions/comments about this or other orbs, visit the Orb Category of [CircleCI Discuss](https://discuss.circleci.com/c/orbs).
