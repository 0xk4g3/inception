COMPOSE_FILE = srcs/docker-compose.yml
DATA_PATH = /home/$(USER)/data

all: build up

build:
	mkdir -p $(DATA_PATH)/wordpress
	mkdir -p $(DATA_PATH)/mariadb
	docker-compose -f $(COMPOSE_FILE) build

up:
	docker-compose -f $(COMPOSE_FILE) up -d

down:
	docker-compose -f $(COMPOSE_FILE) down

start:
	docker-compose -f $(COMPOSE_FILE) start

stop:
	docker-compose -f $(COMPOSE_FILE) stop

clean: down
	docker system prune -af
	docker volume rm $$(docker volume ls -q) 2>/dev/null || true

fclean: clean
	sudo rm -rf $(DATA_PATH)/wordpress
	sudo rm -rf $(DATA_PATH)/mariadb

re: fclean all

.PHONY: all build up down start stop clean fclean re
