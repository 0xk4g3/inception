DOCKER_COMPOSE = docker-compose
DOCKER_COMPOSE_FILE = ./srcs/docker-compose.yml

.PHONY: build kill down clean fclean restart

build:
	sudo mkdir -p /home/hbendjab/data/db
	sudo mkdir -p /home/hbendjab/data/wordpress
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up --build -d

kill:
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) kill

down:
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) down

clean:
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) down -v

fclean: clean
	sudo rm -rf /home/hbendjab/data/db
	sudo rm -rf /home/hbendjab/data/wordpress
	docker system prune -a -f

restart: clean build
