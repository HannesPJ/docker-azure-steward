FROM ubuntu:cosmic

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV AZURE_CLI_VERSION "0.10.13"
ENV NODEJS_APT_ROOT "node_6.x"
ENV NODEJS_VERSION "6.10.0"
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


RUN apt-get update && apt-get install apt-utils -y
RUN apt-get install -y default-jre
RUN apt-get install -qqy --no-install-recommends\
    apt-transport-https \
    dialog \
    build-essential \
    curl \
    ca-certificates \
    git \
    lsb-release \
    python-all \
    rlwrap \
    vim \
    nano \
    jq \
    php-cli \
    php-mbstring \
    php-curl \
    php-zip \
    php-dom \
    php-intl \
    php-gd \
    php-xml \
    unzip

# Install Node.js & NPM
RUN curl -sL https://deb.nodesource.com/setup_11.x\
    && apt-get install -y nodejs npm

# Install composer & steward
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    mkdir steward && cd steward && composer require lmc/steward && \
    ./vendor/bin/steward install --no-interaction

# install Azure
RUN    npm install --global azure-cli@${AZURE_CLI_VERSION} --loglevel=error --no-update-notifier && \
    azure telemetry -d && \
    azure --completion >> ~/azure.completion.sh && \
    echo 'source ~/azure.completion.sh' >> ~/.bashrc && \
    azure

RUN azure config mode arm

ENV EDITOR vim
