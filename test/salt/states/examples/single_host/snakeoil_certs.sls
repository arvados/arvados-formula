{%- set curr_tpldir = tpldir %}
{%- set tpldir = 'arvados' %}
{%- from "arvados/map.jinja" import arvados with context %}
{%- set tpldir = curr_tpldir %}

arvados_test_salt_states_examples_single_host_snakeoil_certs_openssl_pkg_installed:
  pkg.installed:
    - name: openssl

arvados_test_salt_states_examples_single_host_snakeoil_certs_arvados_snake_oil_cert_cmd_run:
  cmd.run:
    - name: |
        cat > /tmp/openssl.cnf <<-CNF
        [req]
        default_bits = 2048
        prompt = no
        default_md = sha256
        x509_extensions = v3_req
        distinguished_name = dn
        [dn]
        C   = CC
        ST  = SomeState
        L   = SomeLocation
        O   = ArvadosFormula
        OU  = R&D
        CN  = {{ arvados.cluster.name }}.{{ arvados.cluster.domain }}
        emailAddress = admin@{{ arvados.cluster.name }}.{{ arvados.cluster.domain }}
        [v3_req]
        subjectAltName = @alt_names
        [alt_names]
        {%- for entry in grains.get('ipv4') %}
        IP.{{ loop.index }} = {{ entry }}
        {%- endfor %}
        {%- for entry in [
            'keep',
            'collections',
            'download',
            'ws',
            'workbench',
            'workbench2',
          ]
        %}
        DNS.{{ loop.index }} = {{ entry }}.{{ arvados.cluster.name }}.{{ arvados.cluster.domain }}
        {%- endfor %}
        CNF

        mkdir -p /etc/ssl/certs/  /etc/ssl/private/ && \
        openssl req -config /tmp/openssl.cnf -new -x509 -days 3650 -nodes -sha256 \
          -out /etc/ssl/certs/arvados-snakeoil-cert.pem \
          -keyout /etc/ssl/private/arvados-snakeoil-cert.key > /tmp/snake_oil_certs.output 2>&1 && \
        chmod 0644 /etc/ssl/certs/arvados-snakeoil-cert.pem && \
        chmod 0640 /etc/ssl/private/arvados-snakeoil-cert.key
    - unless: test -f /etc/ssl/private/arvados-snakeoil-cert.key
    - require:
      - pkg: arvados_test_salt_states_examples_single_host_snakeoil_certs_openssl_pkg_installed

{%- if grains.get('os_family') == 'Debian' %}
arvados_test_salt_states_examples_single_host_snakeoil_certs_ssl_cert_pkg_installed:
  pkg.installed:
    - name: ssl-cert
    - require_in:
      - sls: postgres

snake_oil_certs_permissions:
  cmd.run:
    - name: |
        chown root:ssl-cert /etc/ssl/private/arvados-snakeoil-cert.key
    - require:
      - cmd: arvados_test_salt_states_examples_single_host_snakeoil_certs_arvados_snake_oil_cert_cmd_run
      - pkg: arvados_test_salt_states_examples_single_host_snakeoil_certs_ssl_cert_pkg_installed
{%- endif %}
