FROM alpine:3.12

ENV FLUX_VERSION=1.13.0
ENV HELM_VERSION=2.13.1
ENV HADOLINT_VERSION=1.16.3
ENV GIT_CHGLOG_VERSION=0.9.1
ENV YAMLLINT_VERSION=1.15.0

RUN apk update \
 && apk upgrade \
 && apk --no-cache add \
    gawk \
    curl \
    git \
    bash \
    py3-pip \
    openssh-client \
 && rm -fr /var/lib/apk/*
 
 ## fluxctl
RUN curl -LO "https://github.com/weaveworks/flux/releases/download/${FLUX_VERSION}/fluxctl_linux_amd64" \
 && chmod +x fluxctl_linux_amd64 \
 && mv fluxctl_linux_amd64 /usr/local/bin/fluxctl \
 ## yamllint
 && pip install yamllint==${YAMLLINT_VERSION} \
 ## helm
 && curl -LO "https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz" \
 && tar zxf "helm-v${HELM_VERSION}-linux-amd64.tar.gz" linux-amd64/helm \
 && mv linux-amd64/helm /usr/local/bin/ \
 && rmdir linux-amd64 \
 && rm "helm-v${HELM_VERSION}-linux-amd64.tar.gz" \
 ## helm plugins
 && mkdir -p "${HOME}/.helm/plugins" \
 && helm plugin install https://github.com/chartmuseum/helm-push \
 ## git-semver
 && git clone https://github.com/PennState/git-semver.git \
 && git-semver/install.sh \
 ## hadolint
 && curl -LO "https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64" \
 && chmod a+x hadolint-Linux-x86_64 \
 && mv hadolint-Linux-x86_64 /usr/local/bin/hadolint \
 ## git-chglog
 && curl -LO "https://github.com/git-chglog/git-chglog/releases/download/${GIT_CHGLOG_VERSION}/git-chglog_linux_amd64" \
 && chmod +x git-chglog_linux_amd64 \
 && mv git-chglog_linux_amd64 /usr/local/bin/git-chglog \
 ## chmod
 && chmod +x /usr/local/bin/*

## git-chglog config
ADD chglog /chglog
