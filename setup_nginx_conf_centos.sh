#!/bin/bash

CURRENT_DIR=`pwd`

NGX_CONF_DIR="/etc/nginx"
NGX_CONF_PATH="${NGX_CONF_DIR}/nginx.conf"

NGX_MODULE_DIR="${NGX_CONF_DIR}/modules"
NGX_MODULE_PASSENGER_PATH="${NGX_MODULE_DIR}/passenger.conf"

NGX_SITES_AVAILABLE_DIR="${NGX_CONF_DIR}/sites-available"
NGX_SITES_ENABLED_DIR="${NGX_CONF_DIR}/sites-enabled"

NGX_VHOST_EXAMPLE_FILE="railsapp_example.vhost"
NGX_VHOST_EXAMPLE_PATH="${NGX_SITES_AVAILABLE_DIR}/${NGX_VHOST_EXAMPLE_FILE}"


mv ${NGX_CONF_PATH} ${NGX_CONF_DIR}/nginx.conf.orignal
curl -o ${NGX_CONF_PATH} "http://deploy.bzpalm.net/nginx/nginx_centos.conf"

mkdir $NGX_MODULE_DIR
mkdir $NGX_SITES_AVAILABLE_DIR
mkdir $NGX_SITES_ENABLED_DIR


curl -o $NGX_VHOST_EXAMPLE_PATH "http://deploy.bzpalm.net/nginx/railsapp_example.vhost"
cd $NGX_SITES_ENABLED_DIR
ln -s $NGX_SITES_AVAILABLE_DIR/$NGX_VHOST_EXAMPLE_FILE
cd -

# passenger module

curl -o $NGX_MODULE_PASSENGER_PATH "http://deploy.bzpalm.net/nginx/modules/passenger.conf"
curl -o /tmp/update_passenger_config.rb "http://deploy.bzpalm.net/nginx/modules/update_vars_with_local.rb"
ruby /tmp/update_passenger_config.rb $NGX_MODULE_PASSENGER_PATH
rm -f /tmp/update_passenger_config.rb

echo "#--------------------------------------------"
echo "#  Completed."
echo "#                  - Oxygen Computing Inc."
echo "#--------------------------------------------"
echo
