FROM ubuntu:latest

# Set environment variables for OpenLDAP installation
ENV DEBIAN_FRONTEND=noninteractive
ENV LDAP_ADMIN_PASSWORD=secret
ENV LDAP_DOMAIN=mydomain.com
ENV LDAP_ORGANIZATION=myorg
ENV LDAP_BASE_DN=dc=mydomain,dc=com
ENV LDAP_MANAGER_DN=cn=admin,dc=mydomain,dc=com
ENV LDAP_MANAGER_PASSWORD=admin

# Install OpenLDAP and LDAP utilities
RUN apt-get update && \
    apt-get install -y slapd ldap-utils && \
    rm -rf /var/lib/apt/lists/*

# Configure OpenLDAP
RUN echo "slapd slapd/internal/generated_adminpw password $LDAP_ADMIN_PASSWORD" | debconf-set-selections && \
    echo "slapd slapd/internal/adminpw password $LDAP_ADMIN_PASSWORD" | debconf-set-selections && \
    echo "slapd slapd/password2 password $LDAP_ADMIN_PASSWORD" | debconf-set-selections && \
    echo "slapd slapd/password1 password $LDAP_ADMIN_PASSWORD" | debconf-set-selections && \
    echo "slapd slapd/dump_database_destdir string /var/backups/slapd-VERSION" | debconf-set-selections && \
    echo "slapd slapd/domain string $LDAP_DOMAIN" | debconf-set-selections && \
    echo "slapd shared/organization string $LDAP_ORGANIZATION" | debconf-set-selections && \
    echo "slapd slapd/backend string MDB" | debconf-set-selections && \
    echo "slapd slapd/purge_database boolean true" | debconf-set-selections && \
    echo "slapd slapd/move_old_database boolean true" | debconf-set-selections && \
    echo "slapd slapd/no_configuration boolean false" | debconf-set-selections && \
    echo "slapd slapd/dump_database select when needed" | debconf-set-selections && \
    echo "slapd slapd/allow_ldap_v2 boolean false" | debconf-set-selections && \
    echo "slapd slapd/invalid_config boolean true" | debconf-set-selections && \
    echo "slapd slapd/mirrormode boolean false" | debconf-set-selections && \
    echo "slapd slapd/dbc_remove boolean true" | debconf-set-selections && \
    echo "slapd slapd/password_mismatch note" | debconf-set-selections && \
    echo "slapd slapd/ppolicy_schema_needs_update select abort installation" | debconf-set-selections && \
    echo "slapd slapd/backend_upgrade boolean true" | debconf-set-selections && \
    echo "slapd slapd/override bool true" | debconf-set-selections && \
    echo "slapd slapd/allow_ldap_v2 note" | debconf-set-selections && \
    echo "slapd slapd/dump_database_progress select" | debconf-set-selections && \
    echo "slapd slapd/move_old_database_warning note" | debconf-set-selections && \
    echo "slapd slapd/password_retype note" | debconf-set-selections && \
    echo "slapd slapd/upgrade_slapcat_failure error" | debconf-set-selections && \
    echo "slapd slapd/password1 seen true" | debconf-set-selections && \
    slapd -d 0 && \
    ldapadd -x -D $LDAP_MANAGER_DN -w $LDAP_MANAGER_PASSWORD -f /etc/ldap/schema/cosine.ldif &&
    ldapadd -x -D $LDAP_MANAGER_DN -w $LDAP_MANAGER_PASSWORD -f /etc/ldap/schema/nis.ldif &&
    ldapadd -x -D $LDAP_MANAGER_DN -w $LDAP_MANAGER_PASSWORD -f /etc/ldap/schema/inetorgperson.ldif &&
    ldapadd -x -D $LDAP_MANAGER_DN -w $LDAP_MANAGER_PASSWORD -f /etc/ldap/schema/misc.ldif &&
    ldapadd -x -D $LDAP_MANAGER_DN -w $LDAP_MANAGER_PASSWORD -f /etc/ldap/schema/openldap.ldif &&
    ldapadd -x -D $LDAP_MANAGER_DN -w $LDAP_MANAGER_PASSWORD -f /etc/ldap/schema/ppolicy.ldif &&
    ldapadd -x -D $LDAP_MANAGER_DN -w $LDAP_MANAGER_PASSWORD -f /etc/ldap/schema/samba.ldif &&
    ldapadd -x -D $LDAP_MANAGER_DN -w $LDAP_MANAGER_PASSWORD -f /etc/ldap/schema/sudo.ldif &&
    echo "dn: $LDAP_BASE_DN" > /tmp/base.ldif &&
    echo "objectClass: top" >> /tmp/base.ldif &&
    echo "objectClass: dcObject" >> /tmp/base.ldif &&
    echo "objectClass: organization" >> /tmp/base.ldif &&
    echo "o: $LDAP_ORGANIZATION" >> /tmp/base.ldif &&
    echo "dc: $(echo $LDAP_DOMAIN | sed 's/./,dc=/g')" >> /tmp/base.ldif &&
    echo "" >> /tmp/base.ldif &&
    echo "dn: $LDAP_MANAGER_DN,$LDAP_BASE_DN" >> /tmp/base.ldif &&
    echo "objectClass: organizationalRole" >> /tmp/base.ldif &&
    echo "cn: Manager" >> /tmp/base.ldif &&
    echo "userPassword: $(slappasswd -s $LDAP_MANAGER_PASSWORD)" >> /tmp/base.ldif &&
    echo "" >> /tmp/base.ldif &&
    ldapadd -x -D $LDAP_MANAGER_DN -w $LDAP_MANAGER_PASSWORD -f /tmp/base.ldif &&
    rm /tmp/base.ldif

    #Expose OpenLDAP ports
    EXPOSE 389
    EXPOSE 636

    #Start OpenLDAP service
    CMD ["slapd", "-d", "0"]

    #Metadata
    LABEL maintainer="connectwithpravinmali@gmail.com"
