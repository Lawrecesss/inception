This project has been created as part of the 42 curriculum by lshein.

Inception
🧩 Description

Inception is a system-administration and DevOps project from the 42 curriculum.
The goal of the project is to introduce containerization concepts by building a secure and reproducible multi-service infrastructure using Docker.

This project deploys a fully containerized web stack consisting of:

Nginx – HTTPS reverse proxy with TLS 1.2/1.3 enabled

WordPress – PHP-based CMS

MariaDB – relational database for WordPress

Key security properties:

HTTPS-only (port 443 only)

TLS v1.2 and v1.3 enabled

One container per service

Inter-service communication only through a Docker network

Persistent storage using Docker volumes

🚀 Instructions
🔧 Requirements

Docker

Docker Compose

GNU Make

sudo rights (to edit /etc/hosts for local domain)

🏗️ Build & Run

The project is orchestrated with Docker Compose and controlled with a Makefile.

Build and start everything:

make


Stop services:

make down


Rebuild:

make re


Full cleanup (containers, images, volumes):

make fclean

🌐 Accessing the Website

The project must be accessible through the domain:

lshein.42.sg


Only HTTPS over port 443 is enabled.
HTTP is disabled.

✅ Enabling the domain name locally

Add the following entry to your /etc/hosts file:

127.0.0.1   lshein.42.sg


Steps:

Open hosts file

sudo nano /etc/hosts


Add the line above

Save and exit

Now open in your browser:

https://lshein.42.fr


Your browser may warn about self-signed certificate — this is expected in local setups.

📦 Project Description — Docker & Design Choices

This project recreates a small production-like infrastructure using containerization.

🧠 Main design choices

OS-level virtualization via Docker

one service per container

Docker Compose manages orchestration

Makefile automates commands

custom Docker network

volumes for database and WordPress persistence

TLS v1.2 and v1.3 only

Nginx listens exclusively on port 443

Data flow overview:

Client → Nginx (HTTPS 443) → WordPress (php-fpm) → MariaDB

🔐 TLS Configuration Summary

TLS v1.2 and v1.3 enabled

Port 443 only

Self-signed or generated certificate

HTTP disabled/redirected

Secure ciphers preferred

🐳 Concept Comparisons
Virtual Machines vs Docker
Virtual Machines	Docker Containers
Hardware virtualization	OS-level
Heavy, each runs full OS	Lightweight
Slow boot	Fast startup
Strong isolation	Process isolation
Secrets vs Environment Variables
Environment Variables	Docker Secrets
Visible in env	Mounted as files
Simple	More secure
Good for dev	Best for prod
Docker Network vs Host Network
Docker Network	Host Network
Isolated	No isolation
Default choice	Higher risk
Separate IP space	Uses host IP
Docker Volumes vs Bind Mounts
Docker Volumes	Bind Mounts
Managed by Docker	Direct host path
Persistent app data	Dev convenience
Backups easy	Manual control

Usage in this project:

MariaDB data → volume

WordPress files → volume

📚 Resources

Official documentation:

Docker

Docker Compose

Nginx

MariaDB

WordPress

🤖 AI Usage Disclosure

AI was used for:

README writing assistance

grammar improvement

restructuring explanations

AI was not used to:

write Dockerfiles

configure Nginx/MariaDB

implement project logic

All configurations were written manually and understood.
