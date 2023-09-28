FROM nvidia/cuda:11.1.1-devel-ubuntu20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TERM xterm-256color

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
        git \
		python3 \
        python3-pip \
		python3-venv \
        python3-dev \
        python3-opencv \
        libglib2.0-0 \
		curl \
		tmux \
		wget \
		npm \
		unzip \
		ssh

COPY nvim.appimage nvim.appimage
RUN chmod u+x nvim.appimage
RUN ./nvim.appimage --appimage-extract
RUN ln -s /squashfs-root/AppRun /usr/bin/nvim
COPY nvim-config.tgz nvim-config.tgz
RUN tar zxvf nvim-config.tgz
RUN mkdir /root/.config
RUN mv nvim /root/.config/nvim
COPY tmux.conf /root/.tmux.conf

RUN mkdir /var/run/sshd
# RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
COPY id_rsa_peter.pub /root/.ssh/authorized_keys

# Set the working directory
WORKDIR /root

# Upgrade pip
# Install any python packages you need
COPY requirements.txt requirements.txt
RUN python3 -m pip install --user --upgrade pip
RUN python3 -m pip install -r requirements.txt

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
CMD ["/usr/sbin/sshd", "-D"]
# CMD ["bash", "-l"]
