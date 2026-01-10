# User Documentation: Inception Project

Welcome to the Inception project! This document will guide you through the process of interacting with the various services provided, managing containers, and troubleshooting your environment.

## 1. Services Provided by the Stack

The Inception project includes the following services:

Nginx: A web server for serving the frontend of the website.

MariaDB: A database server for handling the backend data of WordPress.

WordPress: A content management system (CMS) for the website.

## 2. Starting and Stopping the Project

You can easily manage the project using Makefile commands. Here’s how to start and stop the services:

### Starting the Project

To build and start the services, run:
`make up`

### Stopping the Project

To stop the services without removing the containers, use:
`make down`

### Stopping and Removing Containers with Volumes

To stop and remove containers along with their associated volumes (database data, etc.), use:
`make clean`

### Completely Cleaning Up (Remove Containers, Images, and Local Volumes)

If you want to clear all containers, images, and volumes, run:
`make fclean`

## 3. Accessing the Website and Admin Panel

* Website Access

The website for your project can be accessed at:
http://lshein.42.fr

* Admin Panel Access

The WordPress admin panel can be accessed at:
http://lshein.42.fr/wp-admin

## 4. Configuring Paths and Secret Files

Environment variables are defined in .env and passwords are stored securely using Docker secrets.

## 5. Checking Service Status

You can check the status of the services to ensure they are running correctly:

**Check Running Services**

To check if all services are running correctly, run the following:
`docker ps`

This will list all running Docker containers, including Nginx, MariaDB, and WordPress. Ensure that all containers are listed and running.

**Check Logs**

You can view logs for individual services to check for any errors:

Nginx Logs:

`docker logs <nginx_container_name>`


MariaDB Logs:

`docker logs <mariadb_container_name>`


WordPress Logs:

`docker logs <wordpress_container_name>`

**Check Website Access**

Open the browser and visit http://lshein.42.fr to ensure the website loads.

If the website does not load, check the Nginx container logs for potential issues.

**Check Admin Panel Access**

Visit http://lshein.42.fr/wp-admin to ensure you can access the WordPress admin panel. If login fails, check if the WordPress container is running and verify the credentials.