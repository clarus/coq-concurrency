FROM ubuntu
MAINTAINER Guillaume Claret

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y gcc make git
RUN apt-get install -y curl m4 ruby
RUN apt-get install -y ocaml

# OPAM 1.2
WORKDIR /root
RUN curl -L https://github.com/ocaml/opam/archive/1.2.0.tar.gz |tar -xz
WORKDIR opam-1.2.0
RUN ./configure
RUN make lib-ext
RUN make
RUN make install

# Initialize OPAM
RUN opam init
ENV OPAMJOBS 4

# Coq
RUN opam install -y coq

# Tools
RUN apt-get install -y inotify-tools

# Coq repositories
RUN opam repo add coq-stable https://github.com/coq/opam-coq-repo.git
RUN opam repo add coq-unstable https://github.com/coq/opam-coq-repo-unstable.git

# Dependencies
RUN opam install -y coq:list-string

# Build
ADD . /root/coq-concurrency
WORKDIR /root/coq-concurrency
RUN eval `opam config env`; ./configure.sh && make -j

# Continuous build
CMD eval `opam config env`; ./configure.sh && while inotifywait *.v; do make; done