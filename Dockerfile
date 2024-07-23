#target: dromie/lineage-tui

FROM alpine:3.15 as downloader
ARG FZF_VERSION=0.42.0
ARG KUBECTL_VERSION=v1.27.0
ARG KREW_VERSION=latest
ARG CRANK_VERSION=v1.16.0
RUN apk --no-cache add curl 
RUN curl -L https://github.com/junegunn/fzf/releases/download/${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz|tar xvzC /usr/bin
RUN curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/bin/kubectl && chmod +x /usr/bin/kubectl
RUN curl -L https://github.com/kubernetes-sigs/krew/releases/${KREW_VERSION}/download/krew-linux_amd64.tar.gz |tar xvzC /usr/bin 
RUN curl -Lo "/usr/bin/crank" "https://releases.crossplane.io/stable/${CRANK_VERSION}/bin/linux_amd64/crank" && chmod +x /usr/bin/crank

FROM alpine:3.15
RUN apk --no-cache add git 
COPY --from=downloader /usr/bin/fzf /usr/bin/
COPY --from=downloader /usr/bin/kubectl /usr/bin/
COPY --from=downloader /usr/bin/krew-linux_amd64 /usr/bin/
RUN /usr/bin/krew-linux_amd64 install krew 
ENV PATH=${PATH}:/root/.krew/bin
RUN kubectl krew install lineage
RUN apk --no-cache add bash jq moreutils screen vim dialog
ENV EDITOR=vim
COPY --from=downloader /usr/bin/crank /usr/bin/
ADD lineage /usr/bin/
