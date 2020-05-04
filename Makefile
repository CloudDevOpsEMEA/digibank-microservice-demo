# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

MICROSERVICES_FOLDER=./microservices

# DOCKER TASKS

build: ## Build all the containers
		cd ${MICROSERVICES_FOLDER}/accounts && $(MAKE) build
		cd ${MICROSERVICES_FOLDER}/authentication && $(MAKE) build
		cd ${MICROSERVICES_FOLDER}/bills && $(MAKE) build
		cd ${MICROSERVICES_FOLDER}/portal && $(MAKE) build
		cd ${MICROSERVICES_FOLDER}/support && $(MAKE) build
		cd ${MICROSERVICES_FOLDER}/transactions && $(MAKE) build
		cd ${MICROSERVICES_FOLDER}/userbase && $(MAKE) build

build-nc: ## Build all the containers without caching
		cd ${MICROSERVICES_FOLDER}/accounts && $(MAKE) build-nc
		cd ${MICROSERVICES_FOLDER}/authentication && $(MAKE) build-nc
		cd ${MICROSERVICES_FOLDER}/bills && $(MAKE) build-nc
		cd ${MICROSERVICES_FOLDER}/portal && $(MAKE) build-nc
		cd ${MICROSERVICES_FOLDER}/support && $(MAKE) build-nc
		cd ${MICROSERVICES_FOLDER}/transactions && $(MAKE) build-nc
		cd ${MICROSERVICES_FOLDER}/userbase && $(MAKE) build-nc

release: build-nc publish ## Make a release by building and publishing all `{version}` and `latest` tagged containers
		cd ${MICROSERVICES_FOLDER}/accounts && $(MAKE) release
		cd ${MICROSERVICES_FOLDER}/authentication && $(MAKE) release
		cd ${MICROSERVICES_FOLDER}/bills && $(MAKE) release
		cd ${MICROSERVICES_FOLDER}/portal && $(MAKE) release
		cd ${MICROSERVICES_FOLDER}/support && $(MAKE) release
		cd ${MICROSERVICES_FOLDER}/transactions && $(MAKE) release
		cd ${MICROSERVICES_FOLDER}/userbase && $(MAKE) release

publish: publish-latest publish-version ## Publish all `{version}` and `latest` tagged containers
		cd ${MICROSERVICES_FOLDER}/accounts && $(MAKE) publish
		cd ${MICROSERVICES_FOLDER}/authentication && $(MAKE) publish
		cd ${MICROSERVICES_FOLDER}/bills && $(MAKE) publish
		cd ${MICROSERVICES_FOLDER}/portal && $(MAKE) publish
		cd ${MICROSERVICES_FOLDER}/support && $(MAKE) publish
		cd ${MICROSERVICES_FOLDER}/transactions && $(MAKE) publish
		cd ${MICROSERVICES_FOLDER}/userbase && $(MAKE) publish

publish-latest: tag-latest ## Publish all `latest` tagged container
		cd ${MICROSERVICES_FOLDER}/accounts && $(MAKE) publish-latest
		cd ${MICROSERVICES_FOLDER}/authentication && $(MAKE) publish-latest
		cd ${MICROSERVICES_FOLDER}/bills && $(MAKE) publish-latest
		cd ${MICROSERVICES_FOLDER}/portal && $(MAKE) publish-latest
		cd ${MICROSERVICES_FOLDER}/support && $(MAKE) publish-latest
		cd ${MICROSERVICES_FOLDER}/transactions && $(MAKE) publish-latest
		cd ${MICROSERVICES_FOLDER}/userbase && $(MAKE) publish-latest

publish-version: tag-version ## Publish all `{version}` tagged containers
		cd ${MICROSERVICES_FOLDER}/accounts && $(MAKE) publish-version
		cd ${MICROSERVICES_FOLDER}/authentication && $(MAKE) publish-version
		cd ${MICROSERVICES_FOLDER}/bills && $(MAKE) publish-version
		cd ${MICROSERVICES_FOLDER}/portal && $(MAKE) publish-version
		cd ${MICROSERVICES_FOLDER}/support && $(MAKE) publish-version
		cd ${MICROSERVICES_FOLDER}/transactions && $(MAKE) publish-version
		cd ${MICROSERVICES_FOLDER}/userbase && $(MAKE) publish-version

tag: tag-latest tag-version ## Generate all container tags for the `{version}` ans `latest` tags
		cd ${MICROSERVICES_FOLDER}/accounts && $(MAKE) tag
		cd ${MICROSERVICES_FOLDER}/authentication && $(MAKE) tag
		cd ${MICROSERVICES_FOLDER}/bills && $(MAKE) tag
		cd ${MICROSERVICES_FOLDER}/portal && $(MAKE) tag
		cd ${MICROSERVICES_FOLDER}/support && $(MAKE) tag
		cd ${MICROSERVICES_FOLDER}/transactions && $(MAKE) tag
		cd ${MICROSERVICES_FOLDER}/userbase && $(MAKE) tag

tag-latest: ## Generate all containers `{version}` tag
		cd ${MICROSERVICES_FOLDER}/accounts && $(MAKE) tag-latest
		cd ${MICROSERVICES_FOLDER}/authentication && $(MAKE) tag-latest
		cd ${MICROSERVICES_FOLDER}/bills && $(MAKE) tag-latest
		cd ${MICROSERVICES_FOLDER}/portal && $(MAKE) tag-latest
		cd ${MICROSERVICES_FOLDER}/support && $(MAKE) tag-latest
		cd ${MICROSERVICES_FOLDER}/transactions && $(MAKE) tag-latest
		cd ${MICROSERVICES_FOLDER}/userbase && $(MAKE) tag-latest

tag-version: ## Generate all containers `latest` tag
		cd ${MICROSERVICES_FOLDER}/accounts && $(MAKE) tag-version
		cd ${MICROSERVICES_FOLDER}/authentication && $(MAKE) tag-version
		cd ${MICROSERVICES_FOLDER}/bills && $(MAKE) tag-version
		cd ${MICROSERVICES_FOLDER}/portal && $(MAKE) tag-version
		cd ${MICROSERVICES_FOLDER}/support && $(MAKE) tag-version
		cd ${MICROSERVICES_FOLDER}/transactions && $(MAKE) tag-version
		cd ${MICROSERVICES_FOLDER}/userbase && $(MAKE) tag-version

stop: ## Stop and remove all running container
		cd ${MICROSERVICES_FOLDER}/accounts && $(MAKE) stop 2>/dev/null || true
		cd ${MICROSERVICES_FOLDER}/authentication && $(MAKE) stop 2>/dev/null || true
		cd ${MICROSERVICES_FOLDER}/bills && $(MAKE) stop 2>/dev/null || true
		cd ${MICROSERVICES_FOLDER}/portal && $(MAKE) stop 2>/dev/null || true
		cd ${MICROSERVICES_FOLDER}/support && $(MAKE) stop 2>/dev/null || true
		cd ${MICROSERVICES_FOLDER}/transactions && $(MAKE) stop 2>/dev/null || true
		cd ${MICROSERVICES_FOLDER}/userbase && $(MAKE) stop 2>/dev/null || true
		docker stop mongo 2>/dev/null ; docker rm mongo 2>/dev/null || true

run: ## Run the full demo with docker-compose
		docker-compose up

kubernetes_install: ## Install digibank application using kubectl
		kubectl apply -f ./kubernetes -namespace ${NAMESPACE}

kubernetes_remove: ## Remove digibank application using kubectl
		kubectl delete -f ./kubernetes -namespace ${NAMESPACE}

helm_install: ## Install digibank application using helm
		helm install digibank ./helm/digibank --namespace ${NAMESPACE} --values ./helm/digibank/values-digibank-udf.yaml

helm_remove: ## Remove digibank application using helm
		helm uninstall digibank --namespace ${NAMESPACE}
