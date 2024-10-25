FROM continuumio/miniconda3
LABEL authors="JIMM LUCAS" \
      description="Docker image containing ENVIROMENt with all the tools for WGS ONT"

COPY nanoporeWGS.yml /tmp/nanoporeWGS.yml

WORKDIR /tmp

RUN conda env create -f nanoporeWGS.yml

RUN echo "conda activate nanopore" >> ~/.bashrc

ENV PATH /opt/conda/envs/nanopore/bin:$PATH

WORKDIR /home

CMD ["/bin/bash"]
