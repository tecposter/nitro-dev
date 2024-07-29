FROM amazonlinux:latest

RUN yum update -y && yum upgrade -y && yum groupinstall "Development Tools" -y 
# RUN dnf install aws-nitro-enclaves-cli -y && dnf install aws-nitro-enclaves-cli-devel -y
RUN dnf install pkg-config openssl-devel -y
RUN dnf install docker -y

RUN groupadd -f docker && groupmod -g 970 docker  && adduser zjh --home /home/zjh/ && usermod -aG docker zjh

USER zjh
WORKDIR /home/zjh

# Get Rust
# RUN curl -sSf https://sh.rustup.rs | bash -s -- -y
# ENV PATH="/home/zjh/.cargo/bin:${PATH}"

