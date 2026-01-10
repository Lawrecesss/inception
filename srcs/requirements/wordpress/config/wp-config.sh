#!/bin/sh
set -eu

log() {
    echo "[INFO] $1"
}

error() {
    echo "[ERROR] $1" >&2
    exit 1
}

# ----------------------------
# Load secrets (simple & safe)
# ----------------------------
[ -f "$WP_DB_PWD" ] || error "Missing DB password secret"
[ -f "$WP_ADMIN_PWD" ] || error "Missing admin password secret"
[ -f "$WP_USER_PWD" ] || error "Missing user password secret"

WP_DB_PASSWORD="$(cat "$WP_DB_PWD")"
WP_ADMIN_PASSWORD="$(cat "$WP_ADMIN_PWD")"
WP_USER_PASSWORD="$(cat "$WP_USER_PWD")"

export WP_DB_PASSWORD WP_ADMIN_PASSWORD WP_USER_PASSWORD

log "Starting WordPress initialization..."

# ----------------------------
# Wait for database
# ----------------------------
log "Waiting for database connection..."

i=1
while [ "$i" -le 60 ]; do
    if mysql \
        -h"$WP_DB_HOST" \
        -u"$WP_DB_USER" \
        -p"$WP_DB_PASSWORD" \
        "$WP_DB_NAME" \
        -e "SELECT 1;" >/dev/null 2>&1; then
        log "Database is ready!"
        break
    fi

    log "Attempt $i/60: Database not ready..."
    i=$((i + 1))
    sleep 2
done

mysql \
    -h"$WP_DB_HOST" \
    -u"$WP_DB_USER" \
    -p"$WP_DB_PASSWORD" \
    "$WP_DB_NAME" \
    -e "SELECT 1;" >/dev/null 2>&1 \
    || error "Could not connect to database after 120 seconds"

# ----------------------------
# WordPress configuration
# ----------------------------
cd /var/www/html

if [ ! -f wp-config.php ]; then
    log "Creating wp-config.php..."

    wp config create \
        --dbname="$WP_DB_NAME" \
        --dbuser="$WP_DB_USER" \
        --dbpass="$WP_DB_PASSWORD" \
        --dbhost="$WP_DB_HOST" \
        --allow-root

    log "wp-config.php created"
else
    log "wp-config.php already exists"
fi

# ----------------------------
# Install WordPress
# ----------------------------
if ! wp core is-installed --allow-root >/dev/null 2>&1; then
    log "Installing WordPress..."

    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="$WP_SITE_NAME" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="admin@${DOMAIN_NAME}" \
        --skip-email \
        --allow-root

    log "Creating normal user..."

    wp user create \
        "$WP_USER" \
        "user@${DOMAIN_NAME}" \
        --user_pass="$WP_USER_PASSWORD" \
        --allow-root

    log "WordPress installed successfully"
else
    log "WordPress already installed"
fi

# ----------------------------
# Permissions (42-safe)
# ----------------------------
log "Setting permissions..."

chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;
chmod -R 775 /var/www/html/wp-content

log "Permissions set"

# ----------------------------
# Start PHP-FPM (PID 1)
# ----------------------------
log "Starting PHP-FPM..."
exec php-fpm -F
