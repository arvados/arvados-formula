{%- set curr_tpldir = tpldir %}
{%- set tpldir = 'arvados' %}
{%- from "arvados/map.jinja" import arvados with context %}
{%- set tpldir = curr_tpldir %}

snake_oil_certs:
  pkg.installed:
    - name: openssl
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
            'keep0',
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
          -out /etc/ssl/certs/ssl-cert-snakeoil.pem \
          -keyout /etc/ssl/private/ssl-cert-snakeoil.key > /tmp/snake_oil_certs.output 2>&1 && \
        chmod 0644 /etc/ssl/certs/ssl-cert-snakeoil.pem && \
        chmod 0640 /etc/ssl/private/ssl-cert-snakeoil.key
    - unless: test -f /etc/ssl/private/ssl-cert-snakeoil.key
    - require:
      - pkg: openssl

{%- if grains.get('os_family') == 'Debian' %}
ssl_certs:
  pkg.installed:
    - name: ssl-cert
    - require_in:
      - sls: postgres

snake_oil_certs_permissions:
  cmd.run:
    - name: |
        chown root:ssl-cert /etc/ssl/private/ssl-cert-snakeoil.key
    - require:
      - pkg: ssl_certs
{%- endif %}
