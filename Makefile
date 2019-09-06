SHELL = /bin/sh
PREFIX = $(shell pwd)
# VERSION=$(shell git describe --tags)
VERSION=1.0
SRC_DIRS=comment post-py ui

build/all: $(addprefix build/,$(SRC_DIRS)) build/prometheus build/blackbox-exporter
push/all : $(addprefix push/,$(SRC_DIRS)) push/prometheus push/blackbox-exporter

$(addprefix build/,$(SRC_DIRS)):
	@echo '>> building $(notdir $@) image <<'
	@docker build -t $(USER_NAME)/$(notdir $@):$(VERSION) $(PREFIX)/src/$(notdir $@)/

$(addprefix push/,$(SRC_DIRS) prometheus blackbox-exporter):
	@echo '>> pushing $(notdir $@) image <<'
	@docker push $(USER_NAME)/$(notdir $@):$(VERSION)

$(addprefix rmi/,$(SRC_DIRS) prometheus blackbox-exporter):
	@echo '>> remove $(notdir $@) image <<'
	@docker rmi $(USER_NAME)/$(notdir $@):$(VERSION)

up:
	@echo '>> running app <<'
	@docker-compose --project-directory docker -f docker/docker-compose.yml up -d

down:
	@echo '>> stoping app <<'
	@docker-compose --project-directory docker -f docker/docker-compose.yml down

$(addprefix up/,$(SRC_DIRS) prometheus blackbox-exporter):
	@docker-compose --project-directory docker -f docker/docker-compose.yml up -d $(notdir $@)

$(addprefix kill/,$(SRC_DIRS) prometheus blackbox-exporter):
	docker-compose --project-directory docker -f docker/docker-compose.yml kill $(notdir $@)

build/blackbox-exporter:
	@echo '>> building blackbox-exporter image <<'
	@docker build -t $(USER_NAME)/blackbox-exporter:$(VERSION) $(PREFIX)/monitoring/blackbox_exporter/

build/prometheus:
	@echo '>> building prometheus image <<'
	@docker build -t $(USER_NAME)/prometheus:$(VERSION) $(PREFIX)/monitoring/prometheus/
