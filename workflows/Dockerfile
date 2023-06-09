FROM quay.io/redhat-github-actions/k8s-tools-runner:latest as runner
# FROM quay.io/redhat-github-actions/runner:latest as runner

## Image for a GitHub Action runner

LABEL org.opencontainers.image.source https://github.com/bio2kg/bio2kg-etl

USER root

# RUN dnf -y upgrade  # seems to not work
RUN dnf -y install make automake gcc gcc-c++ kernel-devel pugixml
# conda install -y -c anaconda make gcc

RUN chown -R $UID:$GID /opt
USER $UID

# Install conda version manually
# ARG conda_version="4.10.3"
# ARG miniforge_patch_number="0"
# ARG miniforge_python="Mambaforge"
# ARG miniforge_arch="x86_64"
# ARG miniforge_version="${conda_version}-${miniforge_patch_number}"
# ENV miniforge_installer="${miniforge_python}-${miniforge_version}-Linux-${miniforge_arch}.sh"

ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 
ENV PATH="${CONDA_DIR}/bin:${PATH}" 
    # LC_ALL=en_US.UTF-8 \
    # HOME="/home/${NB_USER}" \
    # CONDA_VERSION="${conda_version}"

# Automatically download the latest release of conda miniforge
RUN export download_url=$(curl -s https://api.github.com/repos/conda-forge/miniforge/releases/latest | grep browser_download_url | grep -P "Mambaforge-\d+((\.|-)\d+)*-Linux-x86_64.sh" | grep -v sha256 | cut -d '"' -f 4) && \
    echo "Downloading latest miniforge from $download_url" && \
    curl -Lf -o miniforge.sh $download_url && \
    # curl -Lf "https://github.com/conda-forge/miniforge/releases/download/${miniforge_version}/${miniforge_installer}" -o miniforge.sh && \
    /bin/bash "miniforge.sh" -f -b -p "${CONDA_DIR}" && \
    rm "miniforge.sh" && \
    conda config --system --set auto_update_conda false && \
    conda config --system --set show_channel_urls true

RUN conda install --quiet -y \
    conda \
    pip \
    wget unzip \
    nodejs \
    yarn \
    openjdk \
    maven \
    sbt
    # pugixml
RUN conda update --all --quiet -y && \
    conda clean --all -f -y 

ADD ../requirements.txt .
# RUN conda install --file requirements.txt && \
RUN pip install -r requirements.txt && \
    rm requirements.txt

# Download latest RML mapper in /opt/rmlmapper.jar
RUN curl -s https://api.github.com/repos/RMLio/rmlmapper-java/releases/latest \
    | grep browser_download_url | grep .jar | cut -d '"' -f 4 \
    | wget -O /opt/rmlmapper.jar -qi -

# $(yarn global bin)
ENV PATH="$PATH:$HOME/.yarn/bin"

# RUN echo "export PATH=\"$PATH:$(yarn global bin)\"" >> .profile

RUN yarn global add @rmlio/yarrrml-parser

RUN yarn --cwd /opt add shex
# RUN yarn add rocketrml