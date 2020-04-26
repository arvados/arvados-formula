.. _readme:

arvados-formula
================

|img_travis| |img_sr|

.. |img_travis| image:: https://travis-ci.com/saltstack-formulas/arvados-formula.svg?branch=master
   :alt: Travis CI Build Status
   :scale: 100%
   :target: https://travis-ci.com/saltstack-formulas/arvados-formula
.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release

A SaltStack formula to install and configure an `Arvados cluster <https://arvados.org>`_.

.. contents:: **Table of Contents**

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

If you need (non-default) configuration, please pay attention to the ``pillar.example`` file and/or `Special notes`_ section.

Contributing to this repo
-------------------------

**Commit message formatting is significant!!**

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

Special notes
-------------

Arvados **requires** a Postgres database for its API server and SSL for communications. If you don't satisfy these two requirements, things
won't work. It also uses an Nginx server as a redirector but probably almost any other webserver/redirector can be used instead.

We suggest you use the `postgres-formula <https://github.com/saltstack-formulas/postgres-formula/>`_,
the `nginx-formula <https://github.com/saltstack-formulas/nginx-formula/>`_ and the
`letsencrypt-formula <https://github.com/saltstack-formulas/letsencrypt-formula/>`_ to install satisfy these dependencies.
In the FIXME directory there are some example pillar YAMLs to set up these packages as Arvados needs it.

Also, please note that the individual subcomponents `clean` states **won't remove the config**: as the config is common to all the suite
components and they can be installed in the same host, removing it with a subcomponent might break others.

If you want to remove the config in a host where you're removing a subcomponent, use the `arvados.config.clean` state after the
`arvados.<subcomponent>.clean` state.

The `arvados.clean` state will remove everything, config included, and can be used in any host to remove all of arvados files.

Available states
----------------

.. contents::
   :local:

``arvados``
^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

This installs the WHOLE arvados suite in a single host,
manages the arvados configuration file and then
starts the associated arvados services.

``arvados.clean``
^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

this state will undo everything performed in the ``arvados`` meta-state in reverse order, i.e.
stops the services, removes the configuration file and then uninstalls the packages.

``arvados.config``
^^^^^^^^^^^^^^^^^^^

This state will configure the arvados cluster. As all the arvados components use the same config
file, any of the following components will include this state and you will rarely need to call it
independently. You can still do, as to get a parsed config file to use somewhere else.

``arvados.repo``
^^^^^^^^^^^^^^^^

This state will configure the arvados repository.

``arvados.repo.clean``
^^^^^^^^^^^^^^^^^^^^^^^

This state will remove the arvados repository configuration.

``arvados.shell``
^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

This state installs an `arvados shell node <https://doc.arvados.org/master/install/install-shell-server.html>`_.

``arvados.shell.clean``
^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

this state will undo everything performed in the ``arvados.shell`` meta-state in reverse order, i.e.
uninstalls the packages and gems.

``arvados.shell.package``
^^^^^^^^^^^^^^^^^^^^^^^^^

This state will install the arvados shell packages and gems only.

``arvados.shell.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will remove the packages and gems of the arvados shell node.

















``arvados.service``
^^^^^^^^^^^^^^^^^^^^

This state will start the arvados service and has a dependency on ``arvados.config``
via include list.

``arvados.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will stop the arvados service and disable it at boot time.

``arvados.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^

This state will remove the configuration of the arvados service and has a
dependency on ``arvados.service.clean`` via include list.

``arvados.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will remove the arvados package and has a depency on
``arvados.config.clean`` via include list.

Testing
-------

Linux testing is done with ``kitchen-salt``.

Requirements
^^^^^^^^^^^^

* Ruby
* Docker

.. code-block:: bash

   $ gem install bundler
   $ bundle install
   $ bin/kitchen test [platform]

Where ``[platform]`` is the platform name defined in ``kitchen.yml``,
e.g. ``debian-10-3000-1-py3``.

``bin/kitchen converge``
^^^^^^^^^^^^^^^^^^^^^^^^

Creates the docker instance and runs the ``arvados`` main state, ready for testing.

``bin/kitchen verify``
^^^^^^^^^^^^^^^^^^^^^^

Runs the ``inspec`` tests on the actual instance.

``bin/kitchen destroy``
^^^^^^^^^^^^^^^^^^^^^^^

Removes the docker instance.

``bin/kitchen test``
^^^^^^^^^^^^^^^^^^^^

Runs all of the stages above in one go: i.e. ``destroy`` + ``converge`` + ``verify`` + ``destroy``.

``bin/kitchen login``
^^^^^^^^^^^^^^^^^^^^^

Gives you SSH access to the instance for manual testing.

