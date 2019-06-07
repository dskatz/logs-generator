NAME=logs-generator

default: build

.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: ## go build for default arch
	CGO_ENABLED=0 GOARM=7 GOARCH=amd64 go build -a -installsuffix cgo --ldflags '-w' -o bin/$(NAME) logs_generator.go

.PHONY: docker
docker: ## build within a docker container
	docker build -t $(NAME)  .


run: docker
	docker run -i \
  	-e "LOGS_GENERATOR_LINES_TOTAL=10" \
  	-e "LOGS_GENERATOR_DURATION=1s" \
		-e "LOGS_GENERATOR_MAX_KB=8000" \
		logs-generator:latest

.PHONY: clean
clean: ## clean all 'dist' targets
	rm -rf ./_dist ./$(NAME)*
	rm -rf ./bin/$(NAME)


