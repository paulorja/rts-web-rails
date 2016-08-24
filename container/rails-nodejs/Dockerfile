FROM ubuntu:14.04

ENV PATH $HOME/.rbenv/plugins/ruby-build/bin:$HOME/.rbenv/bin:$PATH

ENV RAILS_ENV development

RUN \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git-core \
    curl zlib1g-dev build-essential libssl-dev libreadline-dev \
    libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev \
    libcurl4-openssl-dev python-software-properties libffi-dev \
    imagemagick libmagickwand-dev libmysqlclient-dev && \
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv && \
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc && \
    exec $SHELL && \
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build && \
    echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc && \
    exec $SHELL && \
    rbenv install 2.3.1 && \
    rbenv global 2.3.1 && \
    gem install bundler && \
    curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash - && \
    sudo apt-get install -y nodejs && \
    gem install rails -v 4.2.6 && \
    rbenv rehash && \
    mkdir -p ~/.ssh 

ADD key/id_rsa ~/.ssh/id_rsa 
ADD key/id_rsa.pub ~/.ssh/id_rsa.pub

RUN \
    ssh-keyscan -t rsa bitbucket.org >> ~/.ssh/known_hosts && \
    git clone git@bitbucket.org:paulorja/rts-web.git ~/rts-web && \
    cd ~/rts-web && \
    bundle install && \
    rake db:create db:migrate db:seed && \
    rails server 

# Expose ports.
EXPOSE 3000