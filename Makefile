SRC := \
	document.tex \
	content/letter.tex

DOCKER_IMAGE ?= docker-pdflatex
DOCKER_USER_NAME := $(shell whoami)
DOCKER_USER_ID := $(shell id -u $(DOCKER_USER_NAME))
DOCKER_GROUP_ID := $(shell id -g $(DOCKER_USER_NAME))

PDFLATEX := docker run -it --rm -v $(PWD):/tmp/work $(DOCKER_IMAGE)

OUTDIR ?= build
OUTJOB ?= $(shell basename `pwd`)
OUTFILE := $(OUTDIR)/$(OUTJOB).pdf

view: $(OUTFILE)
	@echo "Done"
	okular $(OUTFILE)

all: $(OUTFILE)
	@echo "Done"

clean:
	rm -rf $(OUTDIR)

container: Dockerfile
	docker build \
		--build-arg USER_NAME=$(DOCKER_USER_NAME) \
		--build-arg USER_ID=$(DOCKER_USER_ID) \
		--build-arg GROUP_ID=$(DOCKER_GROUP_ID) \
		-t $(DOCKER_IMAGE) .

$(OUTDIR):
	mkdir -p $(OUTDIR)

$(OUTFILE): $(SRC) $(OUTDIR) container
	$(PDFLATEX) -output-directory $(OUTDIR) -jobname=$(OUTJOB) document.tex
	$(PDFLATEX) -output-directory $(OUTDIR) -jobname=$(OUTJOB) document.tex
