#!/bin/sh
set -eu

echo "[INFO] Starting MariaDB entrypoint..."

# ----------------------------
# Load secrets
# ----------------------------
[ -f "$DB_ROOT_PWD" ] || { echo "[ERROR] Missing root password secret"; exit 1; }
[ -f "$WP_DB_PWD" ] || { echo "[ERROR] Missing WP DB password secret"; exit 1; }

DB_ROOT_PASSWORD="$(cat "$DB_ROOT_PWD")"
WP_DB_PASSWORD="$(cat "$WP_DB_PWD")"

DB_NAME="${DB_NAME:-wordpress}"

# ----------------------------
# Initialize database if empty
# ----------------------------
if [ ! -f "/var/lib/mysql/.initialized" ]; then
    echo "[INFO] Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    echo "[INFO] Starting temporary MariaDB..."
    mysqld_safe --user=mysql &
    MYSQL_PID=$!

    # Wait for DB to be ready
    i=30
    while [ "$i" -gt 0 ]; do
        if mysql -u root >/dev/null 2>&1 <<EOF
SELECT 1;
EOF
        then
            break
        fi
        echo "[INFO] MariaDB init in progress..."
        sleep 1
        i=$((i - 1))
    done

    if [ "$i" -eq 0 ]; then
        echo "[ERROR] MariaDB did not start"
        exit 1
    fi

    echo "[INFO] Creating database and user..."

    mysql -u root <<-EOSQL
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
        CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`
        CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
        CREATE USER IF NOT EXISTS '${WP_DB_USER}'@'%' IDENTIFIED BY '${WP_DB_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${WP_DB_USER}'@'%';
        FLUSH PRIVILEGES;
EOSQL
echo $WP_DB_USER
echo $WP_DB_PASSWORD
    if [ $? -ne 0 ]; then
        echo "[ERROR] Failed to initialize database"
        exit 1
    fi

    echo "[INFO] Database initialization complete."

    touch /var/lib/mysql/.initialized

    mysqladmin -u root -p"${DB_ROOT_PASSWORD}" shutdown
    wait "$MYSQL_PID"
fi

# ----------------------------
# Start MariaDB (PID 1)
# ----------------------------
echo "[INFO] Starting MariaDB in foreground..."
exec mysqld --user=mysql --console
