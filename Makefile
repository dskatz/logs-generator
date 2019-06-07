NAME=logs-generator

default: build

.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: ## go build for default arch
	go build -o bin/$(NAME) logs_generator.go

.PHONY: docker
docker: ## build within a docker container
	docker build -t $(NAME)  .

.PHONY: clean
clean: ## clean all 'dist' targets
	rm -rf ./_dist ./$(NAME)*
	rm -rf ./bin/$(NAME)


