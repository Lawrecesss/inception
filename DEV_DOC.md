# Developer Documentation: **Inception Project**

## Purpose

This document describes how developers can set up, build, run, and maintain the **Inception** project from scratch. It provides step-by-step instructions for configuring the environment, building the project, managing containers, handling secrets, and maintaining persistent data.

---

## **1. Prerequisites**

Before starting with the **Inception** project, ensure the following tools and environment are set up:

- **Linux Virtual Machine**: A Linux-based VM is recommended for running Docker and Docker Compose.
- **Docker Engine**: Required for containerizing the services.
  - Install Docker by following the official instructions [here](https://docs.docker.com/get-docker/).
  - Ensure Docker is running:
    ```bash
    sudo systemctl status docker
    ```
- **Docker Compose**: Needed to manage multi-container Docker applications.
  - Install Docker Compose from [here](https://docs.docker.com/compose/install/).
- **Make**: A build automation tool used for running commands within the project.
  - Install Make with `sudo apt install make` (Linux) or using Homebrew (`brew install make` on macOS).

---

## **2. Project Structure**

The Inception project is organized as follows:

```bash
Inception/
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
├── secrets/
│   ├── db_root_pwd.txt
│   ├── wp_db_pwd.txt
│   ├── wp_admin_pwd.txt
│   └── wp_user_pwd.txt
└── srcs/
    ├── docker-compose.yml
    ├── requirements/
    │   ├── nginx/
    │   │   ├── Dockerfile
    │   │   └── conf/
    │   │       └── nginx.conf
    │   ├── wordpress/
    │   │   ├── Dockerfile
    │   │   └── tools/
    │   │       └── wp-config.sh
    │   └── mariadb/
    │       ├── Dockerfile
    │       └── tools/
    │           └── entrypoint.sh
```

## 3. Secrets Configuration

The `secrets/` directory contains sensitive configuration files such as passwords and credentials. These secrets are passed to the containers via Docker Compose and must not be committed to version control.

Secrets in the `secrets/` directory:

- `db_root_pwd.txt`: Password for the MariaDB root user.
- `wp_db_pwd.txt`: Password for the WordPress database user.
- `wp_admin_pwd.txt`: Password for the WordPress admin user.
- `wp_user_pwd.txt`: Password for the default WordPress user.

Important: These files should be kept secure and should never be committed to the repository.

## 4. Launching the Stack

You can launch the services using Docker Compose:

```bash
make up
```

This is equivalent to running:

```bash
docker compose up -d --build
```

This command:

- Starts the Docker containers for Nginx, MariaDB, and WordPress.
- Builds the containers if they have not been built previously.
- Runs the containers in detached mode (`-d`).

## 5. Managing Containers with Makefile

The `Makefile` provides several useful commands to manage the lifecycle of your Docker containers.

- Restart the services (stop and then start containers):

```bash
make re
```

- Stop services (without removing containers or volumes):

```bash
make down
```

- Remove everything, including volumes:

```bash
make fclean
```

## 7. Volumes & Data Persistence

Docker volumes are used to store persistent data outside the container filesystem. These volumes ensure that data persists even if the containers are stopped or rebuilt.

Volume Mappings:

- MariaDB data: `/home/lshein/data/db`
  - Purpose: Stores all the database files to ensure persistence of your MariaDB data.

- WordPress data: `/home/lshein/data/wp`
  - Purpose: Stores WordPress website files, themes, plugins, and configuration files.

Important Notes:

- Data survives container rebuilds unless the volumes are explicitly removed.
- If you need to back up the data, ensure you regularly back up the `/home/lshein/data/` directory.

## 8. Networking

The Inception project uses Docker’s default bridge network for container communication. A dedicated Docker bridge network is used.

Containers communicate via their service names (for example: `mariadb`, `wordpress`, `nginx`).

Network configurations such as `host` or `--link` are forbidden. Only container names should be used for inter-container communication.

## 9. Process Management (PID 1)

Each container in the Inception project runs a single main process (for example: `nginx`, `mysqld`, `php-fpm`). We avoid using processes like `tail -f` or `sleep infinity`, which could result in infinite loops or hanging containers.

Important Process Notes:

- Nginx runs as the main foreground process in the Nginx container.
- MariaDB runs as the main foreground process in the MariaDB container.
- WordPress runs as the main foreground process using PHP-FPM for handling dynamic content.

## 10. Debugging Tips

When things go wrong, here are some tools and commands to help with troubleshooting:

- View logs for all containers:

```bash
docker compose logs -f
```

- Access a running container’s shell (example: WordPress container):

```bash
docker exec -it wordpress sh
```

- Inspect a Docker volume to see its details and location on the host system:

```bash
docker volume inspect <volume_name>
```

## 11. Maintenance

Routine Maintenance Tasks:

- Update Nginx certificates: If you need to update SSL certificates for Nginx, rebuild the Nginx Docker image:

```bash
make up
```

- Update WordPress files: Modify files in the WordPress volume (for example: `wp-content/themes/`).
- Backup Data: Ensure that `/home/lshein/data/` is regularly backed up to avoid data loss, particularly the `mariadb_data` and `wordpress_data` volumes.

docker compose logs -f


Access a running container’s shell (example: WordPress container):

docker exec -it wordpress sh


Inspect a Docker volume to see its details and location on the host system:

docker volume inspect <volume_name>

11. Maintenance
Routine Maintenance Tasks:

Update Nginx certificates: If you need to update SSL certificates for Nginx, you can rebuild the Nginx Docker image:

make up


Update WordPress files: You can update WordPress files by modifying the files in the WordPress volume (e.g., wp-content/themes/).

Backup Data: Ensure that /home/nsan/data/ is regularly backed up to avoid data loss, particularly the mariadb_data and wordpress_data volumes.