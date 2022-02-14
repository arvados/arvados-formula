.. _readme_apt_keyrings:

apt repositories' keyrings
==========================

Debian family of OSes deprecated the use of `apt-key` to manage repositories' keys
in favor of using `keyring files` which contain a binary OpenPGP format of the key
(also known as "GPG key public ring")

As arvados don't provide such key files, we created it pulling the
official key from its site and install the resulting file.

See https://doc.arvados.org/main/install/packages.html#debian for details

.. code-block:: bash

   $ curl -fsSL https://apt.arvados.org/pubkey.gpg | \
       gpg --dearmor --output arvados-archive-keyring.gpg
