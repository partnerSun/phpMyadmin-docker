FROM registry.cn-beijing.aliyuncs.com/partnersun/alpine:3.4

# Install dependencies
RUN apk add --no-cache php5-mysqli php5-xml php5-gd php5-zlib php5-bz2 php5-zip php5-openssl php5-curl php5-opcache php5-json nginx php5-fpm supervisor

# Include keyring to verify download
COPY phpmyadmin.keyring /

# Copy configuration
COPY etc /etc/

# Copy main script
COPY run.sh /run.sh
COPY phpMyAdmin.tar.gz ./phpMyAdmin.tar.gz
COPY phpMyAdmin.tar.gz.asc ./phpMyAdmin.tar.gz.asc
RUN chmod u+rwx /run.sh

# Calculate download URL
ENV VERSION 4.6.5.2
ENV URL https://files.phpmyadmin.net/phpMyAdmin/${VERSION}/phpMyAdmin-${VERSION}-all-languages.tar.gz
LABEL version=$VERSION

# Download tarball, verify it using gpg and extract
#RUN set -x \
RUN GNUPGHOME="$(mktemp -d)" \
    && export GNUPGHOME \
    && apk add --no-cache gnupg nano \
    && gpgv --keyring /phpmyadmin.keyring phpMyAdmin.tar.gz.asc phpMyAdmin.tar.gz \
    && apk del --no-cache gnupg \
    && rm -rf "$GNUPGHOME" \
    && tar xzf phpMyAdmin.tar.gz \
    && rm -f phpMyAdmin.tar.gz phpMyAdmin.tar.gz.asc
    
RUN mv phpMyAdmin-$VERSION-all-languages /www \
    && mv /www/doc/html /www/htmldoc \
    && rm -rf /www/doc \
    && mkdir /www/doc \
    && mv /www/htmldoc /www/doc/html \
    && rm /www/doc/html/.buildinfo /www/doc/html/objects.inv \
    && rm -rf /www/js/jquery/src/ /www/js/openlayers/src/ /www/setup/ /www/examples/ /www/test/ /www/po/ /www/templates/test/ /www/phpunit.xml.* /www/build.xml  /www/composer.json /www/RELEASE-DATE-$VERSION \
    && sed -i "s@define('CONFIG_DIR'.*@define('CONFIG_DIR', '/etc/phpmyadmin/');@" /www/libraries/vendor_config.php \
    && chown -R root:nobody /www \
    && find /www -type d -exec chmod 750 {} \; \
    && find /www -type f -exec chmod 640 {} \;

COPY ./nginx.conf /etc/nginx.conf
# Add volume for sessions to allow session persistence
VOLUME /sessions

# We expose phpMyAdmin on port 80
EXPOSE 80

ENTRYPOINT [ "/run.sh" ]
CMD ["phpmyadmin"]
