FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalar OpenSSH Server, Sudo y Python (necesario para Ansible)
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Crear directorio de ejecución para sshd
RUN mkdir -p /var/run/sshd

# Crear usuario ansible con contraseña ansible
RUN useradd -m -s /bin/bash ansible && \
    echo "ansible:ansible" | chpasswd

# Otorgar privilegios sudo sin contraseña al usuario ansible
RUN echo "ansible ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Configurar SSH para permitir autenticación por contraseña
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
