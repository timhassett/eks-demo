FROM --platform=linux/arm64 fedora:latest
RUN dnf install -y unzip helm git
RUN curl https://releases.hashicorp.com/terraform/1.3.6/terraform_1.3.6_linux_arm64.zip -o terraform.zip && \
    unzip terraform.zip && \
    install -o root -g root -m 0755 terraform /usr/local/bin/terraform && \
    rm terraform terraform.zip

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && ./aws/install && \
    rm -r awscliv2.zip ./aws

RUN curl -LO "https://dl.k8s.io/release/v1.26.0/bin/linux/arm64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl
