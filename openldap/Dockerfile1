FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

# Install OpenLDAP
RUN apt-get update && \
    apt-get install -y slapd ldap-utils && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /etc/ldap/slapd.d/* && \
    rm -rf /var/lib/ldap/*

# Set up the OpenLDAP configuration
COPY ldap.conf /etc/ldap/ldap.conf
COPY slapd.conf /etc/ldap/slapd.conf
COPY bootstrap.ldif /etc/ldap/bootstrap.ldif
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose LDAP ports
EXPOSE 389 636

# Start OpenLDAP
ENTRYPOINT ["/entrypoint.sh"]
CMD ["slapd", "-d", "0"]
