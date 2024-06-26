FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TERM xterm-256color

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
        git \
		neovim \
		ripgrep \
		python3-full \
        python3-opencv \
        libglib2.0-0 \
		curl \
		tmux \
		wget \
		npm \
		unzip \
		ssh


RUN git clone https://github.com/LazyVim/starter ~/.config/nvim
COPY tmux.conf /root/.tmux.conf

RUN mkdir /var/run/sshd
# RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
COPY id_rsa_peter.pub /root/.ssh/authorized_keys

# Set the working directory
WORKDIR /root

# Upgrade pip
# Install any python packages you need
COPY requirements.txt requirements.txt

RUN python3 -m venv /root/cpu-venv
RUN /root/cpu-venv/bin/python3 -m pip install --upgrade pip
RUN /root/cpu-venv/bin/python3 -m pip install -r requirements.txt

# install current nodejs
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
ENV NODE_MAJOR=20
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update && apt-get install -y nodejs

RUN echo 'export PS1="{\[\e[32m\]\u\[\e[m\]@\[\e[36m\]docker\[\e[m\]:\w_\$?}$ "' >> /root/.bash_profile
RUN echo "alias tmux='tmux -u'" >> /root/.bash_profile
RUN echo "alias l='ls --color=auto'" >> /root/.bash_profile
RUN echo "alias ls='ls --color=auto'" >> /root/.bash_profile
# CMD ["bash", "-l"]
