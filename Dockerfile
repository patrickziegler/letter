FROM ubuntu:22.04

# preventing interactive tzinfo config on `apt-get install cmake`
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

# Use docker run -u <USER_NAME> instead of setting the user here
#
# Not setting the user here allows to use the same Dockerfile with
# rootless podman and not having to modify the shared folders with
# `podman unshare chown ...`
#
# USER ${USER_NAME}

WORKDIR /tmp/work

ENTRYPOINT ["/usr/bin/pdflatex", "-interaction=nonstopmode"]
