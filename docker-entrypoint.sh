#!/usr/bin/env sh
CONFIG_PATH=/config
TEMPLATES="http.conf.template
    nginx.conf.template
    tls.conf.template"

function render_template() {
    eval "echo \"$(cat $1)\""
}

function generate_configs() {
    for item in ${TEMPLATES}; do
        render_template ${CONFIG_PATH}/${item} > ${CONFIG_PATH}/${item%.template}
        rm ${CONFIG_PATH}/${item}
    done
}

if [[ "${DOMAIN?}" -a "${SERVER_NAMES?}" ]]; then
    generate_configs
    mkdir /etc/ssl/${DOMAIN}
    mkdir /var/log/nginx/${DOMAIN}
    cp ${CONFIG_PATH}/http.conf /etc/nginx/conf.d/default.conf
    cp ${CONFIG_PATH}/nginx.conf /etc/nginx/
    cp ${CONFIG_PATH}/tls.conf /etc/nginx/
    cp -r /home/cyberchef/build/prod/* ${ROOT_DIR:-/var/lib/nginx/html}
fi

exec "$@"
