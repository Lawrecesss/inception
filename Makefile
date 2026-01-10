NAME = inception

DOCKER_COMPOSE = docker compose -f srcs/docker-compose.yml

all: up

up:
	mkdir -p /home/lshein/data/db
	mkdir -p /home/lshein/data/wp
	$(DOCKER_COMPOSE) up --build -d

down:
	$(DOCKER_COMPOSE) down

clean:
	$(DOCKER_COMPOSE) down -v

fclean: clean
	docker system prune -af --volumes
	sudo rm -rf /home/lshein/data

re: fclean up

.PHONY: all up down clean fclean re
