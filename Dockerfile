#target: dromie/lineage-tui
FROM alpine:3.15
ARG FZF_VERSION=0.42.0
ARG KUBECTL_VERSION=v1.27.0
ARG KREW_VERSION=latest

RUN apk --no-cache add git
RUN wget https://github.com/junegunn/fzf/releases/download/${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz -O -|tar xvzC /usr/bin
RUN wget https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -O /usr/bin/kubectl && chmod +x /usr/bin/kubectl
RUN wget https://github.com/kubernetes-sigs/krew/releases/${KREW_VERSION}/download/krew-linux_amd64.tar.gz -O -|tar xvzC /usr/bin && /usr/bin/krew-linux_amd64 install krew 
ENV PATH=${PATH}:/root/.krew/bin
RUN kubectl krew install lineage
RUN apk --no-cache add bash jq moreutils screen vim dialog
ENV EDITOR=vim
ADD lineage /usr/bin/
