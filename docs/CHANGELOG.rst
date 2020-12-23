
Changelog
=========

`1.1.4 <https://github.com/saltstack-formulas/arvados-formula/compare/v1.1.3...v1.1.4>`_ (2020-12-23)
---------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **apt:** update repository URL (\ `b1b06f9 <https://github.com/saltstack-formulas/arvados-formula/commit/b1b06f9d72917d55a6622eddf43a896432ffd8c4>`_\ )

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **commitlint:** ensure ``upstream/master`` uses main repo URL [skip ci] (\ `24c9b5d <https://github.com/saltstack-formulas/arvados-formula/commit/24c9b5d1e79a22189c93902ec7099dd9dc656f71>`_\ )
* **gitlab-ci:** add ``rubocop`` linter (with ``allow_failure``\ ) [skip ci] (\ `7a3adcc <https://github.com/saltstack-formulas/arvados-formula/commit/7a3adcc682b1c9f5a4a44a34306425484a843799>`_\ )
* **gitlab-ci:** use GitLab CI as Travis CI replacement (\ `e3ad2e8 <https://github.com/saltstack-formulas/arvados-formula/commit/e3ad2e84ade6d1c3112e5f278b71b065f6cc7a66>`_\ )

`1.1.3 <https://github.com/saltstack-formulas/arvados-formula/compare/v1.1.2...v1.1.3>`_ (2020-12-07)
---------------------------------------------------------------------------------------------------------

Documentation
^^^^^^^^^^^^^


* **examples:** reduce snakeoil cert days to 1yr (\ `0bc7de5 <https://github.com/saltstack-formulas/arvados-formula/commit/0bc7de5ca4bf431ddebcedd6a38fb911a2234fdf>`_\ )

`1.1.2 <https://github.com/saltstack-formulas/arvados-formula/compare/v1.1.1...v1.1.2>`_ (2020-12-07)
---------------------------------------------------------------------------------------------------------

Documentation
^^^^^^^^^^^^^


* **examples:** add missing SAN to snakeoil ssl cert (\ `a68f6fa <https://github.com/saltstack-formulas/arvados-formula/commit/a68f6fa7e39be665dcea0becc7dad2628e715b29>`_\ )
* **examples:** better organization and naming (\ `fa49dbe <https://github.com/saltstack-formulas/arvados-formula/commit/fa49dbe833c7867ac95da84f9b36c8114cd89039>`_\ )
* **examples:** improve helper snakeoil ssl certs (\ `fcec3ef <https://github.com/saltstack-formulas/arvados-formula/commit/fcec3ef0a2623e8d51def868ccf4622b7c200be4>`_\ )

`1.1.1 <https://github.com/saltstack-formulas/arvados-formula/compare/v1.1.0...v1.1.1>`_ (2020-11-24)
---------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **creds:** remove underscores (\ `64c887c <https://github.com/saltstack-formulas/arvados-formula/commit/64c887ce15cd538dc1cc003d2cde2773cd1d291e>`_\ )
* **crunch-dispatch-local:** re-enable crunch-run.sh to tune docker call (\ `0fdc919 <https://github.com/saltstack-formulas/arvados-formula/commit/0fdc919736977fbffdd4ba76ef0f41c67f279842>`_\ )
* **dispatcher:** add missing crunch-dispatch-local config file (\ `91e5896 <https://github.com/saltstack-formulas/arvados-formula/commit/91e5896ec5fad6edbb8cc2574cd02f6ddd5f3a1c>`_\ )

Documentation
^^^^^^^^^^^^^


* **single_host:** fix hostnames and tests (\ `6c52de7 <https://github.com/saltstack-formulas/arvados-formula/commit/6c52de7c70c90784df58e6dbc6c43a71b9cc7e7c>`_\ )

Tests
^^^^^


* **dispatcher:** add helper state (\ `1bddf7e <https://github.com/saltstack-formulas/arvados-formula/commit/1bddf7efba4c6abeaa1a530664672bffa965998d>`_\ )
* **dispatcher:** cert needs to match each hostname (\ `2ac8a85 <https://github.com/saltstack-formulas/arvados-formula/commit/2ac8a85f91b60ebe5fb337bfcbeb09836842ed85>`_\ )

`1.1.0 <https://github.com/saltstack-formulas/arvados-formula/compare/v1.0.2...v1.1.0>`_ (2020-11-03)
---------------------------------------------------------------------------------------------------------

Features
^^^^^^^^


* **distro:** add centos-7 support (\ `ba5e37e <https://github.com/saltstack-formulas/arvados-formula/commit/ba5e37ebc18049d4340388fc0c19dcb2a78d6a86>`_\ )

`1.0.2 <https://github.com/saltstack-formulas/arvados-formula/compare/v1.0.1...v1.0.2>`_ (2020-10-17)
---------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **dispatcher:** add missing files for local dispatcher (\ `eb73d56 <https://github.com/saltstack-formulas/arvados-formula/commit/eb73d564b0b36810c56a39bbb2e75267521bfe5c>`_\ )

`1.0.1 <https://github.com/saltstack-formulas/arvados-formula/compare/v1.0.0...v1.0.1>`_ (2020-10-16)
---------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **config:** prevent duplicated, undesired entries (\ `d9ede82 <https://github.com/saltstack-formulas/arvados-formula/commit/d9ede8264d9a9cbbd6eab15f98abc2326488bc7b>`_\ )

Documentation
^^^^^^^^^^^^^


* **examples:** improve consistency in naming (\ `73a0b42 <https://github.com/saltstack-formulas/arvados-formula/commit/73a0b42b03c3a8c247712ce5e64b7215686e9cef>`_\ )

`1.0.0 <https://github.com/saltstack-formulas/arvados-formula/compare/v0.3.0...v1.0.0>`_ (2020-10-15)
---------------------------------------------------------------------------------------------------------

`0.3.0 <https://github.com/saltstack-formulas/arvados-formula/compare/v0.2.1...v0.3.0>`_ (2020-10-14)
---------------------------------------------------------------------------------------------------------

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **pre-commit:** add to formula [skip ci] (\ `703e004 <https://github.com/saltstack-formulas/arvados-formula/commit/703e0047f809f20919e47718cfe074e4dd8f3b70>`_\ )
* **pre-commit:** enable/disable ``rstcheck`` as relevant [skip ci] (\ `860adf0 <https://github.com/saltstack-formulas/arvados-formula/commit/860adf045fae4506b3af5d1ee7f2ac2530df125a>`_\ )
* **pre-commit:** finalise ``rstcheck`` configuration [skip ci] (\ `9539adf <https://github.com/saltstack-formulas/arvados-formula/commit/9539adf89eb2543309278f6e48c1146de3cd12d1>`_\ )

Documentation
^^^^^^^^^^^^^


* **readme:** fix ``rstcheck`` violation [skip ci] (\ `bceb58a <https://github.com/saltstack-formulas/arvados-formula/commit/bceb58ada62e79bf9387a352669dfb0eb722b730>`_\ ), closes `/travis-ci.org/github/myii/arvados-formula/builds/731605195#L255 <https://github.com//travis-ci.org/github/myii/arvados-formula/builds/731605195/issues/L255>`_

Features
^^^^^^^^


* **components,version:** add extra components, new version (\ `4bf9501 <https://github.com/saltstack-formulas/arvados-formula/commit/4bf9501a14f86845865244ee3ffb03a34707d36c>`_\ )

Styles
^^^^^^


* **libtofs.jinja:** use Black-inspired Jinja formatting [skip ci] (\ `64798a8 <https://github.com/saltstack-formulas/arvados-formula/commit/64798a8c8f9d720de1e346b20e87ecbbffe56e2a>`_\ )

`0.2.1 <https://github.com/saltstack-formulas/arvados-formula/compare/v0.2.0...v0.2.1>`_ (2020-06-16)
---------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **init:** enable all sub-modules (\ `dd5b832 <https://github.com/saltstack-formulas/arvados-formula/commit/dd5b832e0209950b97f3d84c1bce71e96a5cde41>`_\ )

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **kitchen:** use ``saltimages`` Docker Hub where available [skip ci] (\ `ffc372d <https://github.com/saltstack-formulas/arvados-formula/commit/ffc372d4134debada69126f178493e0e7d6b68b3>`_\ )
* **kitchen+travis:** adjust matrix to add ``3000.3`` [skip ci] (\ `34c3f28 <https://github.com/saltstack-formulas/arvados-formula/commit/34c3f2889fd2f4d058c9c56972cc3b3fca28c417>`_\ )
* **travis:** add notifications => zulip [skip ci] (\ `71b9243 <https://github.com/saltstack-formulas/arvados-formula/commit/71b9243248531e8180fb9918564b0fbd744b89c8>`_\ )

Documentation
^^^^^^^^^^^^^


* **examples:** fix websocket nginx example stanza (\ `f1f4904 <https://github.com/saltstack-formulas/arvados-formula/commit/f1f4904bce70447c910b07ba8745f05be7e1d1ae>`_\ )

`0.2.0 <https://github.com/saltstack-formulas/arvados-formula/compare/v0.1.0...v0.2.0>`_ (2020-05-05)
---------------------------------------------------------------------------------------------------------

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **kitchen+travis:** adjust matrix to use ``3000.2`` instead of ``3000.1`` (\ `37f0adf <https://github.com/saltstack-formulas/arvados-formula/commit/37f0adfc826461b2522cd0e5852c27a408543f41>`_\ )

Features
^^^^^^^^


* **semantic-release:** standardise for this formula (\ `3d4138e <https://github.com/saltstack-formulas/arvados-formula/commit/3d4138ef0c1ad1863989aa38d6e1a0b10490b977>`_\ )
