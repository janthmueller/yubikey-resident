# Use the latest Ubuntu image
FROM ubuntu:latest

# Set noninteractive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Update packages and install OpenSSH server and YubiKey Manager
RUN apt update && \
    apt install -y openssh-server yubikey-manager && \
    apt clean

# Copy the entrypoint script into the container
COPY keygen.sh /usr/local/bin/keygen.sh
RUN chmod +x /usr/local/bin/keygen.sh