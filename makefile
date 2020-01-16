# Go
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get
BINARY_NAME=srcds_proxy
DIST_DIR=build
OS_Linux=linux
OS_Windows=windows
OS_Mac=darwin
ARCH_386=386
ARCH_AMD64=amd64

# Replacing "RM" command for Windows PowerShell.
RM = rm -rf
ifeq ($(OS),Windows_NT)
    RM = Remove-Item -Recurse -Force
endif

# Replacing "MKDIR" command for Windows PowerShell.
MKDIR = mkdir -p
ifeq ($(OS),Windows_NT)
    MKDIR = New-Item -ItemType Directory
endif

# Replacing "CP" command for Windows PowerShell.
CP = cp -R
ifeq ($(OS),Windows_NT)
	CP = powershell -Command Copy-Item -Recurse -Force
endif

# Replacing "GOPATH" command for Windows PowerShell.
GOPATHDIR = $GOPATH
ifeq ($(OS),Windows_NT)
    GOPATHDIR = $$env:GOPATH
endif
.DEFAULT_GOAL := build-all

test:
	$(GOTEST) -v ./...
clean:
	$(GOCLEAN)
	-@$(RM) $(DIST_DIR)/*
deps:
	@$(GOGET)
# Cross compile for go
build-all: build-prepare clean
	@$(MKDIR) ./$(DIST_DIR)/$(BINARY_NAME)_$(OS_Linux)_$(ARCH_386)
	@$(MKDIR) ./$(DIST_DIR)/$(BINARY_NAME)_$(OS_Linux)_$(ARCH_AMD64)
	@$(MKDIR) ./$(DIST_DIR)/$(BINARY_NAME)_$(OS_Windows)_$(ARCH_386)
	@$(MKDIR) ./$(DIST_DIR)/$(BINARY_NAME)_$(OS_Windows)_$(ARCH_AMD64)
	@$(MKDIR) ./$(DIST_DIR)/$(BINARY_NAME)_$(OS_Mac)_$(ARCH_386)
	@$(MKDIR) ./$(DIST_DIR)/$(BINARY_NAME)_$(OS_Mac)_$(ARCH_AMD64)
	@gox \
	-os="$(OS_Windows) $(OS_Mac) $(OS_Linux)" \
	-arch="$(ARCH_386) $(ARCH_AMD64)" \
	--output "./$(DIST_DIR)/$(BINARY_NAME)_{{.OS}}_{{.Arch}}/$(BINARY_NAME)"
build-prepare:
	@$(GOGET) github.com/mitchellh/gox
build-linux: build-prepare 
	@$(MKDIR) ./$(DIST_DIR)/$(BINARY_NAME)_$(OS_Linux)_$(ARCH_386)
	@$(MKDIR) ./$(DIST_DIR)/$(BINARY_NAME)_$(OS_Linux)_$(ARCH_AMD64)
	@gox \
	-os="$(OS_Linux)" \
	-arch="$(ARCH_386) $(ARCH_AMD64)" \
	--output "../$(DIST_DIR)/$(BINARY_NAME)_{{.OS}}_{{.Arch}}/$(BINARY_NAME)"
build-windows: build-prepare
	@$(MKDIR) ./$(DIST_DIR)/$(BINARY_NAME)_$(OS_Windows)_$(ARCH_386)
	@$(MKDIR) ./$(DIST_DIR)/$(BINARY_NAME)_$(OS_Windows)_$(ARCH_AMD64)
	@gox \
	-os="$(OS_Windows)" \
	-arch="$(ARCH_386) $(ARCH_AMD64)" \
	--output "./$(DIST_DIR)/$(BINARY_NAME)_{{.OS}}_{{.Arch}}/$(BINARY_NAME)"
build-mac: build-prepare
	@$(MKDIR) ./$(DIST_DIR)/$(BINARY_NAME)_$(OS_Mac)_$(ARCH_386)
	@$(MKDIR) ./$(DIST_DIR)/$(BINARY_NAME)_$(OS_Mac)_$(ARCH_AMD64)
	@ gox \
	-os="$(OS_Mac)" \
	-arch="$(ARCH_386) $(ARCH_AMD64)" \
	--output "./$(DIST_DIR)/$(BINARY_NAME)_{{.OS}}_{{.Arch}}/$(BINARY_NAME)"