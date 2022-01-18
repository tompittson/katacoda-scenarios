FROM ubuntu:18.04

# install cowsay
RUN apt-get update \
    && apt-get install -y cowsay=3.03+dfsg2-4 --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# "cowsay" installs to /usr/games
ENV PATH=$PATH:/usr/games
ENV MESSAGE="Moooooo!"

CMD cowsay $MESSAGE