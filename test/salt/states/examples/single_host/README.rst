Helper states for all-in-one setup
==================================

These states are helpful for setting up an all-in-one Arvados host.

* `host_entries.sls`: adds a bunch of host entries in the `/etc/hosts` file of
  the host instance, so all Arvados' components can find each other correctly,
  using meaningful names.

* `snakeoil_certs.sls`: Arvados uses SSL/TLS for communications, so you'll need
  certificates for the different hosts. If you can't provide valid certificates
  issued by a recognized CA, this state will create a SnakeOil CA and issue 
  certificates signed by it.

  The certs can't be self-signed because some of the libraries that Arvados
  uses require certs issued by a CA. For this reason, if you use this state,
  you'll need to copy the created CA cert to your certificates' directory.
