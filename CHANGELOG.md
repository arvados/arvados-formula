# Changelog

## [1.0.2](https://github.com/saltstack-formulas/arvados-formula/compare/v1.0.1...v1.0.2) (2020-10-17)


### Bug Fixes

* **dispatcher:** add missing files for local dispatcher ([eb73d56](https://github.com/saltstack-formulas/arvados-formula/commit/eb73d564b0b36810c56a39bbb2e75267521bfe5c))

## [1.0.1](https://github.com/saltstack-formulas/arvados-formula/compare/v1.0.0...v1.0.1) (2020-10-16)


### Bug Fixes

* **config:** prevent duplicated, undesired entries ([d9ede82](https://github.com/saltstack-formulas/arvados-formula/commit/d9ede8264d9a9cbbd6eab15f98abc2326488bc7b))


### Documentation

* **examples:** improve consistency in naming ([73a0b42](https://github.com/saltstack-formulas/arvados-formula/commit/73a0b42b03c3a8c247712ce5e64b7215686e9cef))

# [1.0.0](https://github.com/saltstack-formulas/arvados-formula/compare/v0.3.0...v1.0.0) (2020-10-15)

# [0.3.0](https://github.com/saltstack-formulas/arvados-formula/compare/v0.2.1...v0.3.0) (2020-10-14)


### Continuous Integration

* **pre-commit:** add to formula [skip ci] ([703e004](https://github.com/saltstack-formulas/arvados-formula/commit/703e0047f809f20919e47718cfe074e4dd8f3b70))
* **pre-commit:** enable/disable `rstcheck` as relevant [skip ci] ([860adf0](https://github.com/saltstack-formulas/arvados-formula/commit/860adf045fae4506b3af5d1ee7f2ac2530df125a))
* **pre-commit:** finalise `rstcheck` configuration [skip ci] ([9539adf](https://github.com/saltstack-formulas/arvados-formula/commit/9539adf89eb2543309278f6e48c1146de3cd12d1))


### Documentation

* **readme:** fix `rstcheck` violation [skip ci] ([bceb58a](https://github.com/saltstack-formulas/arvados-formula/commit/bceb58ada62e79bf9387a352669dfb0eb722b730)), closes [/travis-ci.org/github/myii/arvados-formula/builds/731605195#L255](https://github.com//travis-ci.org/github/myii/arvados-formula/builds/731605195/issues/L255)


### Features

* **components,version:** add extra components, new version ([4bf9501](https://github.com/saltstack-formulas/arvados-formula/commit/4bf9501a14f86845865244ee3ffb03a34707d36c))


### Styles

* **libtofs.jinja:** use Black-inspired Jinja formatting [skip ci] ([64798a8](https://github.com/saltstack-formulas/arvados-formula/commit/64798a8c8f9d720de1e346b20e87ecbbffe56e2a))

## [0.2.1](https://github.com/saltstack-formulas/arvados-formula/compare/v0.2.0...v0.2.1) (2020-06-16)


### Bug Fixes

* **init:** enable all sub-modules ([dd5b832](https://github.com/saltstack-formulas/arvados-formula/commit/dd5b832e0209950b97f3d84c1bce71e96a5cde41))


### Continuous Integration

* **kitchen:** use `saltimages` Docker Hub where available [skip ci] ([ffc372d](https://github.com/saltstack-formulas/arvados-formula/commit/ffc372d4134debada69126f178493e0e7d6b68b3))
* **kitchen+travis:** adjust matrix to add `3000.3` [skip ci] ([34c3f28](https://github.com/saltstack-formulas/arvados-formula/commit/34c3f2889fd2f4d058c9c56972cc3b3fca28c417))
* **travis:** add notifications => zulip [skip ci] ([71b9243](https://github.com/saltstack-formulas/arvados-formula/commit/71b9243248531e8180fb9918564b0fbd744b89c8))


### Documentation

* **examples:** fix websocket nginx example stanza ([f1f4904](https://github.com/saltstack-formulas/arvados-formula/commit/f1f4904bce70447c910b07ba8745f05be7e1d1ae))

# [0.2.0](https://github.com/saltstack-formulas/arvados-formula/compare/v0.1.0...v0.2.0) (2020-05-05)


### Continuous Integration

* **kitchen+travis:** adjust matrix to use `3000.2` instead of `3000.1` ([37f0adf](https://github.com/saltstack-formulas/arvados-formula/commit/37f0adfc826461b2522cd0e5852c27a408543f41))


### Features

* **semantic-release:** standardise for this formula ([3d4138e](https://github.com/saltstack-formulas/arvados-formula/commit/3d4138ef0c1ad1863989aa38d6e1a0b10490b977))
