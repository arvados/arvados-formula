snake_oil_certs:
{%- if grains.os_family in ('RedHat',) %}
  pkg.installed:
    - name: openssl
  cmd.run:
    - name: |
        cat > /tmp/openssl.cnf <<-CNF
        RANDFILE                = /dev/urandom
        [ req ]
        default_bits            = 2048
        default_keyfile         = privkey.pem
        distinguished_name      = req_distinguished_name
        prompt                  = no
        policy                  = policy_anything
        req_extensions          = v3_req
        x509_extensions         = v3_req
        [ req_distinguished_name ]
        commonName                      = {{ grains.fqdn }}
        [ v3_req ]
        basicConstraints        = CA:FALSE
        CNF
        mkdir -p /etc/ssl/certs/  /etc/ssl/private/ && \
        openssl req -config /tmp/openssl.cnf -new -x509 -days 3650 -nodes -sha256 \
          -out /etc/ssl/certs/ssl-cert-snakeoil.pem \
          -keyout /etc/ssl/private/ssl-cert-snakeoil.key > /tmp/snake_oil_certs.output 2>&1
    - unless: test -f /etc/ssl/private/ssl-cert-snakeoil.key
    - require:
      - pkg: openssl
{%- else %}
  pkg.installed:
    - name: ssl-cert
{%- endif %}
