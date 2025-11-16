# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: hbendjab <hbendjab@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/11/16 18:00:00 by hbendjab          #+#    #+#              #
#    Updated: 2024/11/16 18:00:00 by hbendjab         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Colors for output
RED = \033[0;31m
GREEN = \033[0;32m
YELLOW = \033[0;33m
BLUE = \033[0;34m
NC = \033[0m # No Color

# Directories
DATA_DIR = /home/hbendjab/data
DB_DIR = $(DATA_DIR)/db
WP_DIR = $(DATA_DIR)/wordpress

# Docker Compose file
COMPOSE = srcs/docker-compose.yml

# Default target
all: up

# Create data directories
$(DATA_DIR):
	@echo "$(BLUE)Creating data directories...$(NC)"
	@mkdir -p $(DB_DIR)
	@mkdir -p $(WP_DIR)
	@echo "$(GREEN)✓ Data directories created!$(NC)"

# Build and start containers
up: $(DATA_DIR)
	@echo "$(BLUE)Building and starting containers...$(NC)"
	@docker-compose -f $(COMPOSE) up -d --build
	@echo "$(GREEN)✓ Inception is running!$(NC)"
	@echo "$(YELLOW)Access your site at: https://hbendjab.42.fr$(NC)"

# Build images without starting
build: $(DATA_DIR)
	@echo "$(BLUE)Building Docker images...$(NC)"
	@docker-compose -f $(COMPOSE) build
	@echo "$(GREEN)✓ Images built successfully!$(NC)"

# Start containers (without building)
start:
	@echo "$(BLUE)Starting containers...$(NC)"
	@docker-compose -f $(COMPOSE) start
	@echo "$(GREEN)✓ Containers started!$(NC)"

# Stop containers
stop:
	@echo "$(YELLOW)Stopping containers...$(NC)"
	@docker-compose -f $(COMPOSE) stop
	@echo "$(GREEN)✓ Containers stopped!$(NC)"

# Stop and remove containers
down:
	@echo "$(YELLOW)Stopping and removing containers...$(NC)"
	@docker-compose -f $(COMPOSE) down
	@echo "$(GREEN)✓ Containers removed!$(NC)"

# Show container status
status:
	@echo "$(BLUE)Container Status:$(NC)"
	@docker-compose -f $(COMPOSE) ps

# Show logs
logs:
	@docker-compose -f $(COMPOSE) logs -f

# Show logs for specific service
logs-nginx:
	@docker-compose -f $(COMPOSE) logs -f nginx

logs-wordpress:
	@docker-compose -f $(COMPOSE) logs -f wordpress

logs-mariadb:
	@docker-compose -f $(COMPOSE) logs -f mariadb

# Clean containers and images
clean: down
	@echo "$(RED)Removing Docker images...$(NC)"
	@docker-compose -f $(COMPOSE) down --rmi all
	@echo "$(GREEN)✓ Images removed!$(NC)"

# Full clean (including volumes)
fclean: clean
	@echo "$(RED)Removing volumes and data...$(NC)"
	@docker-compose -f $(COMPOSE) down --volumes
	@sudo rm -rf $(DB_DIR)/*
	@sudo rm -rf $(WP_DIR)/*
	@echo "$(GREEN)✓ All data cleaned!$(NC)"

# Rebuild everything from scratch
re: fclean all

# Show help
help:
	@echo "$(BLUE)Inception Makefile Commands:$(NC)"
	@echo ""
	@echo "  $(GREEN)make$(NC) or $(GREEN)make all$(NC)     - Build and start all containers"
	@echo "  $(GREEN)make build$(NC)          - Build Docker images only"
	@echo "  $(GREEN)make up$(NC)             - Build and start containers"
	@echo "  $(GREEN)make start$(NC)          - Start existing containers"
	@echo "  $(GREEN)make stop$(NC)           - Stop running containers"
	@echo "  $(GREEN)make down$(NC)           - Stop and remove containers"
	@echo "  $(GREEN)make status$(NC)         - Show container status"
	@echo "  $(GREEN)make logs$(NC)           - Show all container logs"
	@echo "  $(GREEN)make logs-nginx$(NC)     - Show NGINX logs"
	@echo "  $(GREEN)make logs-wordpress$(NC) - Show WordPress logs"
	@echo "  $(GREEN)make logs-mariadb$(NC)   - Show MariaDB logs"
	@echo "  $(GREEN)make clean$(NC)          - Remove containers and images"
	@echo "  $(GREEN)make fclean$(NC)         - Remove everything (including data)"
	@echo "  $(GREEN)make re$(NC)             - Rebuild everything from scratch"
	@echo "  $(GREEN)make help$(NC)           - Show this help message"
	@echo ""

.PHONY: all up build start stop down status logs logs-nginx logs-wordpress logs-mariadb clean fclean re help
