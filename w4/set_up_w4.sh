#!/usr/bin/env bash

. /filmpac/wordpress-setup/.env

echo ""; echo "* * *"
echo "Running WordPress setup script (environment: ${ENVIRONMENT}) ..."
echo "* * *"; echo "";

wp maintenance-mode activate


#
# WordPress config file additions
#

echo ""; echo "* * *"
echo "Configuring WordPress with FILMPAC custom settings for the ${ENVIRONMENT} environment ..."
echo "* * *"; echo "";

[ -f /opt/bitnami/wordpress/wp-config.php ] && rm -rf ls /opt/bitnami/wordpress/wp-config.php
wp config create --dbname="${DB_NAME}" --dbuser="${DB_USER}" --dbhost="${DB_HOST}" --dbpass="${DB_PASSWORD}" \
  --extra-php << PHP
$(cat "/filmpac/wordpress-setup/config.${ENVIRONMENT}.txt")
PHP


#
# WordPress Plugins
#

echo ""; echo "* * *"
echo "Installing the \"must use\" plugins ..."
echo "* * *"; echo "";

# NOTE These special functions _must_ be installed _before_ anything else.
mkdir -p /opt/bitnami/wordpress/wp-content/mu-plugins
cp /filmpac/wordpress-setup/mu-plugins/* /opt/bitnami/wordpress/wp-content/mu-plugins/

echo ""; echo "* * *"
echo "Installing WooCommerce and other basic plugins ..."
echo "* * *"; echo "";

wp plugin install --activate \
  advanced-custom-fields \
  jwt-authentication-for-wp-rest-api \
  woocommerce \
  woocommerce-gateway-paypal-powered-by-braintree \
  woocommerce-gateway-stripe \
  wordpress-seo \
  wp-rest-cache \
  wp-search-with-algolia

echo ""; echo "* * *"
echo "Installing proprietary plugins, including FILMPAC plugins ..."
echo "* * *"; echo "";

wp plugin install --activate "https://${DEPLOY_USER}@github.com/FILMPAC/filmpac-data-extensions/archive/master.zip"
wp plugin install --activate "https://${DEPLOY_USER}@github.com/FILMPAC/filmpac-download-tracker/archive/master.zip"
wp plugin install --activate "https://${DEPLOY_USER}@github.com/FILMPAC/filmpac-rest-api-extensions/archive/master.zip"
wp plugin install --activate "https://${DEPLOY_USER}@github.com/btraas/sku-shortlink-for-woocommerce/archive/master.zip"
wp plugin install --activate "https://${DEPLOY_USER}@github.com/woocommerce/action-scheduler-disable-default-runner/archive/master.zip"
wp plugin install --activate "https://${DEPLOY_USER}@github.com/wp-premium/gravityforms/archive/master.zip"
wp plugin install --activate "https://${DEPLOY_USER}@github.com/wp-premium/woocommerce-subscriptions/archive/master.zip"
wp plugin install --activate /filmpac/wordpress-setup/premium-plugins/*.zip


#
# WordPress Theme(s)
#

echo ""; echo "* * *"
echo "Installing the FILMPAC W4 theme ..."
echo "* * *"; echo "";

# Delete all but one WordPress-provided theme
# (This does not delete the active theme [usually "twentytwentyone"], which we will keep for troubleshooting purposes.)
wp theme delete --all
# Install and activate the FILMPAC "no theme" theme (for details, see the theme's README)
wp theme install --activate "https://${DEPLOY_USER}@github.com/FILMPAC/filmpac-w4-theme/archive/master.zip"


#
# Cleanup
#

echo ""; echo "* * *"
echo "Cleaning up ..."
echo "* * *"; echo "";

# Get rid of the WordPress-provided plugins
wp plugin delete akismet hello
# Get rid of the Bitnami-provided plugins
wp plugin delete all-in-one-wp-migration all-in-one-seo-pack amp amazon-polly \
  google-analytics-for-wordpress jetpack simple-tags w3-total-cache
wp cache flush
wp wp-rest-cache flush

wp maintenance-mode deactivate


echo ""; echo "* * *"
echo "Great! You should now be able to access the service's REST API JSON-Schema docs at ${WP_SITEURL}/wp-json."
echo "* * *"; echo "";
