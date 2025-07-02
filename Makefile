default_branch := develop
branch := $(default_branch)
profile := all

.PHONY: init update status all switch

default: all

# Initialize the submodules
init:
	git submodule update --init --recursive

# Update the submodules and merge the changes
update:
	git submodule update --remote --merge

# Show the status of the submodules
status:
	git submodule status

# Init and update the submodules
all: init update

# Switch the branch of the submodules
switch:
	@echo "Switching to $(branch) branch"
	@git submodule foreach ' \
		if git checkout $(branch); then \
			echo "Successfully switched to $(branch)"; \
		else \
			echo "Failed to switch to $(branch), switching to $(default_branch)"; \
			git checkout $(default_branch); \
		fi'

# Create a .env file from the template
env:
	@echo "Creating .env file from template"
	@cp .template.env .env

# Docker compose commands
up:
		docker compose --profile $(profile) up -d

# Deploy services
deploy:
		docker compose --profile $(profile) up --pull always -d

# Build services or a specific service
build:
		docker compose --profile $(profile) up --build -d

# Clean containers, networks, and volumes
clean:
	@echo "Cleaning up the services"
	docker compose down --volumes --remove-orphans --rmi local

# Build and run services
# Deprecated: Use `build` instead
#up-core:
#	docker compose --profile core up --build

#up-infra:
#	docker compose --profile infra up --build