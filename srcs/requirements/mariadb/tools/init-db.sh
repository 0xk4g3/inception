#!/bin/bash

# Exit on any error
set -e

echo "========================================"
echo "MariaDB Initialization Script"
echo "========================================"

# Check if MySQL data directory is initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MySQL data directory..."
    
    # Initialize MySQL data directory
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    
    echo "✓ MySQL data directory initialized!"
fi

# Start MySQL temporarily in background for setup
echo "Starting MySQL temporarily for configuration..."
mysqld --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;

-- Delete anonymous users
DELETE FROM mysql.user WHERE User='';

-- Delete test database
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

-- Create WordPress database
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};

-- Create WordPress user
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';

-- Grant all privileges on WordPress database to user
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

-- Set root password
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

-- Create root user that can connect from anywhere (for debugging)
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

-- Apply changes
FLUSH PRIVILEGES;
EOF

echo "✓ Database and users created!"
echo ""
echo "========================================"
echo "Database Configuration:"
echo "  - Database: ${MYSQL_DATABASE}"
echo "  - User: ${MYSQL_USER}"
echo "  - Root password: SET"
echo "========================================"
echo ""
echo "Starting MariaDB server..."

# Start MariaDB in foreground
exec mysqld --user=mysql --console
