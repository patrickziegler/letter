SRC := \
	document.tex \
	content/letter.tex

CONT_IMAGE ?= pdflatex-dist
CONT_USER_NAME := $(shell id -nu)
CONT_USER_ID := $(shell id -u $(CONT_USER_NAME))
CONT_GROUP_ID := $(shell id -g $(CONT_USER_NAME))

ifeq "$(shell which podman)" ""
	PDFLATEX := docker run -it --rm -v ${CURDIR}:/tmp/work -u $(CONT_USER_NAME) $(CONT_IMAGE)
else
	PDFLATEX := podman run -it --rm -v ${CURDIR}:/tmp/work $(CONT_IMAGE)
endif

OUTDIR ?= build
OUTJOB ?= $(shell basename `pwd`)
OUTFILE := $(OUTDIR)/$(OUTJOB).pdf

view: $(OUTFILE)
	@echo "Done"
	xdg-open $(OUTFILE)

all: $(OUTFILE)
	@echo "Done"

clean:
	rm -rf $(OUTDIR)

container: Dockerfile
	docker build \
		--build-arg USER_NAME=$(CONT_USER_NAME) \
		--build-arg USER_ID=$(CONT_USER_ID) \
		--build-arg GROUP_ID=$(CONT_GROUP_ID) \
		-t $(CONT_IMAGE) .

$(OUTDIR):
	mkdir -p $(OUTDIR)

$(OUTFILE): $(SRC) $(OUTDIR) container
	$(PDFLATEX) -output-directory $(OUTDIR) -jobname=$(OUTJOB) document.tex
	$(PDFLATEX) -output-directory $(OUTDIR) -jobname=$(OUTJOB) document.tex
