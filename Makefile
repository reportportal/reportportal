default_branch := develop
branch := $(default_branch)

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