FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key and repository
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list

# Install Docker daemon and CLI
RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

COPY ./all_images.tar /images/all_images.tar

CMD [ "sh","-c","dockerd & sleep 5 && docker load < /images/all_images.tar && tail -f /dev/null" ]