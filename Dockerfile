FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    make \
    texlive-latex-base \
    texlive-latex-recommended \
    texlive-fonts-extra \
    texlive-lang-german \
    && rm -rf /var/lib/apt/lists/*

ARG USER_NAME=dev
ARG USER_ID=1000
ARG GROUP_ID=1000

RUN groupadd -g ${GROUP_ID} ${USER_NAME}; \
    useradd -l --uid ${USER_ID} --gid ${GROUP_ID} ${USER_NAME}

USER ${USER_NAME}

WORKDIR /tmp/work

ENTRYPOINT ["/usr/bin/pdflatex", "-interaction=nonstopmode"]
