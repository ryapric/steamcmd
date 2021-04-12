SHELL := /usr/bin/env bash -eu

docker-build:
	@docker build -t steamcmd:latest .

docker-run:
	@docker run -dit -e app_name=$(app_name) --name $(app_name)-steamcmd-server steamcmd:latest
