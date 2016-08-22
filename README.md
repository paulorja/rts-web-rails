## Setup ##

### Ruby ###

* sudo apt-get update
* sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev

* cd
* git clone https://github.com/rbenv/rbenv.git ~/.rbenv
* echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
* echo 'eval "$(rbenv init -)"' >> ~/.bashrc
* exec $SHELL

* git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
* echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
* exec $SHELL

* rbenv install 2.3.1
* rbenv global 2.3.1
* ruby -v

* gem install bundler

### Rails ###

* curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
* sudo apt-get install -y nodejs

* gem install rails -v 4.2.6
* rbenv rehash

### Mysql

* sudo apt-get install mysql-server mysql-client libmysqlclient-dev


### Pra rodar o projeto ###

* sudo apt-get install imagemagick libmagickwand-dev
* cd rts-web
* bundle install
* rake db:create db:migrate db:seed RAILS_ENV=development
* rails server

### Projeto rodando ###

* Entrar com admin (admin, 1234)
* Acessar a url localhost:3000/admin
* clicar em RESET WORLD
* FIM
