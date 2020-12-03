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

In the `Arvados repository <https://github.com/arvados/arvados/>`_ you can find `a provision script <https://github.com/arvados/arvados/tree/master/tools/salt-install>`_
to deploy a single-node, all-in-one Arvados cluster (The script uses this formula to get a cluster up and running in Saltstack's master-less mode).

The `single-node` install does not include SLURM: it is intended for an `all-in-one-host` installation,
so it uses `crunch-dispatch-local` to run containers in the same instance.

The provision script can be run anywhere, so you can run it in an AWS instance and you'll get a `single-node` Arvados cluster there.

The Arvados formula allows you to `install any dispatcher available <https://github.com/saltstack-formulas/arvados-formula/blob/master/pillar.example#L182-L191>`_,
provided you configure the pillars the way you need them.

Arvados currently has three dispatchers:

* **crunch-dispatch-local** (for single node installations),
* **arvados-dispatch-cloud** (for dynamic compute on AWS or Azure) and
* **crunch-dispatch-slurm** (for SLURM integration).

Requisites
----------

Arvados **requires** a Postgres database for its API server and SSL for communications. If you don't satisfy these two requirements, things
won't work. It also uses an Nginx server as a redirector but probably almost any other webserver/redirector can be used instead.

We suggest you use the `postgres-formula <https://github.com/saltstack-formulas/postgres-formula/>`_,
the `nginx-formula <https://github.com/saltstack-formulas/nginx-formula/>`_ and the
`letsencrypt-formula <https://github.com/saltstack-formulas/letsencrypt-formula/>`_ to satisfy these dependencies.
In the **test/salt/pillar/examples/** directory there are example pillar YAMLs to set up these packages, using the mentioned formulas
as Arvados needs them.a

In the **test/salt/states/examples/** directory there are some example helper states to set up a few requirements for single-node
(all-in-one) Arvados host.

Usage
-----

As Arvados is a *suite* of tools that can be installed in different hosts and configured to interact, this formula is split in
those components, which can be installed or removed independently of the other components. This means that you'll get flexibility
to install your cluster as you prefer at the expense of having to take care on some steps:

The formula has the following components/submodules available:

* `api <https://doc.arvados.org/install/install-api-server.html>`_: installs the Arvados API server packages. Requires a running
  Postgres database and an Nginx+Passenger server.
* `config <https://doc.arvados.org/v2.0/admin/config.html>`_: creates and deploys a valid Arvados config file. This state is automatically
  include in all the components that require it (at the moment, all but `shell`), so you will rarely need to invoke this state manually.
* `controller <https://doc.arvados.org/v2.0/install/install-api-server.html>`_: installs the Arvados API controller.
* `keepproxy <https://doc.arvados.org/v2.0/install/install-keepproxy.html>`_: installs and configures the Arvados Keepproxy gateway
  to the Keep storages.
* `keepstore <https://doc.arvados.org/v2.0/install/install-keepstore.html>`_: installs and configures an Arvados Keep storages.
* `keepweb <https://doc.arvados.org/v2.0/install/install-keep-web.html>`_: installs and configures the WebDAV access to the Keep storages.
* `repo <https://doc.arvados.org/v2.0/install/packages.html>`_: configures the repositories to install arvados. It's enabled by default.
* `shell <https://doc.arvados.org/v2.0/install/install-shell-server.html>`_: installs the user CLI apps to communicate with the cluster.
* `websocket <https://doc.arvados.org/v2.0/install/install-ws.html>`_: installs the websocket notifcations gateway.
* `workbench <https://doc.arvados.org/v2.0/install/install-workbench-app.html>`_: installs the webUI to communicate with the cluster.
* `workbench2 <https://doc.arvados.org/v2.0/install/install-workbench2-app.html>`_: installs the next generation webUI for Arvados.

If you just use the `arvados` meta-state, it will install all the components in a single host.

Also, please note that the individual subcomponents' `clean` states **won't remove the config file**: as the config is common to all the suite
components and they can be installed in the same host, removing it with a subcomponent might break others.

If you want to remove the config in a host where you're removing a subcomponent, use the `arvados.config.clean` state after the
`arvados.<subcomponent>.clean` state.

Finally, the `arvados.clean` meta-state will remove everything, config included, and can be used in any host to remove all of arvados files.

Available states
----------------

For each of the components, there are *meta-states* named after the component that will include other states in the component subdir
that perform the actual work.

For example, using *arvados.keepstore* will include, in order:

* arvados.keepstore.package.install
* arvados.config.file
* arvados.keepstore.service.running

while using *arvados.keepstore.clean* will include, in order:

* arvados.keepstore.service.clean
* arvados.keepstore.package.clean

Or you can use individual states, like

* arvados.keepstore.package.install
* arvados.keepstore.service.clean

to get the *keepstore* package installed with the service stopped.

The generic description for the states is

.. contents::
   :local:

``arvados``
^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

This installs the *WHOLE* arvados suite in a single host,
manages the arvados configuration file and then
starts the associated arvados services.

``arvados.clean``
^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

This state will undo everything performed in the ``arvados`` meta-state in reverse order, i.e.
stops the services, removes the configuration file and then uninstalls the packages.


``arvados.config``
^^^^^^^^^^^^^^^^^^

This state will configure the arvados cluster. As all the arvados components use the same config
file, any of the following components will include this state and you will rarely need to call it
independently. You can still do, ie, to get a parsed config file to use somewhere else.

``arvados.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^

This state will remove the configuration of the arvados node.

``arvados.repo``
^^^^^^^^^^^^^^^^

This state will configure the arvados repository.

``arvados.repo.clean``
^^^^^^^^^^^^^^^^^^^^^^

This state will remove the arvados repository configuration.


``arvados.<component>``
^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

This state will install the package, configure the component (if applicable) and start the service (if applicable).

``arvados.<component>.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

This state will undo everything performed in the ``arvados.<component>`` meta-state in reverse order, i.e.
stop the service and uninstall the package/s.

``arvados.<component>.package``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will install the arvados <component> package/s only.

``arvados.<component>.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will remove the packages of the arvados <component> node and has a depency on
``arvados.<component>.service.clean`` via include list (if applicable).

``arvados.<component>.service``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will start the arvados service and has a dependency on ``arvados.config``
via include list.

``arvados.<component>.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will stop the arvados service and disable it at boot time.


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

