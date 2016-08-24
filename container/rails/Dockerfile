FROM ubuntu:14.04

ENV RBENV_HOME /root/rbenv/

ENV PATH RBENV_HOME/plugins/ruby-build/bin:RBENV_HOME/shims\
:RBENV_HOME/bin:RBENV_HOME/shims:RBENV_HOME/bin:RBENV_HOME/shims\
:RBENV_HOME/bin:RBENV_HOME/shims:RBENV_HOME/bin:RBENV_HOME/shims\
:RBENV_HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH

ENV RAILS_ENV development

ENV PORT 8080

RUN \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git-core \
    curl zlib1g-dev build-essential libssl-dev libreadline-dev \
    libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev \
    libcurl4-openssl-dev python-software-properties libffi-dev \
    imagemagick libmagickwand-dev libmysqlclient-dev && \
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv && \
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc && \
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build && \
    exec $SHELL 

RUN \
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
    chmod +x start_server.sh && \
    bash start_server.sh $PORT

# Expose ports.
EXPOSE $PORT
