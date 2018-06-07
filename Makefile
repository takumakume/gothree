TEST ?= $(shell go list ./... | grep -v vendor)
VERSION = $(shell cat version)
REVISION = $(shell git describe --always)

INFO_COLOR=\033[1;34m
RESET=\033[0m
BOLD=\033[1m

default: build

deps: ## Install dependencies
	@echo "$(INFO_COLOR)==> $(RESET)$(BOLD)Installing Dependencies$(RESET)"
	go get -u github.com/golang/dep/...
	dep ensure

depsdev: deps ## Installing dependencies for development
	go get github.com/golang/lint/golint
	go get -u github.com/tcnksm/ghr
	go get github.com/mitchellh/gox

test: ## Run test
	@echo "$(INFO_COLOR)==> $(RESET)$(BOLD)Testing$(RESET)"
	go test -v $(TEST) -timeout=30s -parallel=4
	go test -race $(TEST)

vet: ## Exec go vet
	@echo "$(INFO_COLOR)==> $(RESET)$(BOLD)Vetting$(RESET)"
	go vet $(TEST)

lint: ## Exec golint
	@echo "$(INFO_COLOR)==> $(RESET)$(BOLD)Linting$(RESET)"
	golint -set_exit_status $(TEST)
