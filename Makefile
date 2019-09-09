SHELL = /bin/sh
PREFIX = $(shell pwd)
# VERSION=$(shell git describe --tags)
VERSION=1.0
# SRC_DIRS=comment post-py ui

SERVICES=comment post-py ui blackbox-exporter prometheus mongo-exporter

build/all: $(addprefix build/,$(SERVICES))
push/all : $(addprefix push/,$(SERVICES))

$(addprefix build/,$(SERVICES)):
	@echo '>> building $(notdir $@) image <<'
	@docker build -t $(USER_NAME)/$(notdir $@):$(VERSION) $(PREFIX)/src/$(notdir $@)/

$(addprefix push/,$(SERVICES)):
	@echo '>> pushing $(notdir $@) image <<'
	@docker push $(USER_NAME)/$(notdir $@):$(VERSION)

$(addprefix rmi/,$(SERVICES)):
	@echo '>> remove $(notdir $@) image <<'
	@docker rmi $(USER_NAME)/$(notdir $@):$(VERSION)

$(addprefix up/,$(SERVICES)):
	@docker-compose --project-directory docker -f docker/docker-compose.yml up -d $(notdir $@)

$(addprefix kill/,$(SERVICES)):
	docker-compose --project-directory docker -f docker/docker-compose.yml kill $(notdir $@)

up:
	@echo '>> running app <<'
	@docker-compose --project-directory docker -f docker/docker-compose.yml up -d

down:
	@echo '>> stoping app <<'
	@docker-compose --project-directory docker -f docker/docker-compose.yml down

# $(addprefix up/,$(SRC_DIRS) prometheus blackbox-exporter):
# 	@docker-compose --project-directory docker -f docker/docker-compose.yml up -d $(notdir $@)

# $(addprefix kill/,$(SRC_DIRS) prometheus blackbox-exporter):
# 	docker-compose --project-directory docker -f docker/docker-compose.yml kill $(notdir $@)

# build/blackbox-exporter:
# 	@echo '>> building blackbox-exporter image <<'
# 	@docker build -t $(USER_NAME)/blackbox-exporter:$(VERSION) $(PREFIX)/monitoring/blackbox_exporter/

# build/prometheus:
# 	@echo '>> building prometheus image <<'
# 	@docker build -t $(USER_NAME)/prometheus:$(VERSION) $(PREFIX)/monitoring/prometheus/

# $(addprefix build/,$(SRC_DIRS)):
# 	@echo '>> building $(notdir $@) image <<'
# 	@docker build -t $(USER_NAME)/$(notdir $@):$(VERSION) $(PREFIX)/src/$(notdir $@)/
