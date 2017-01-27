
## Play ##

http://rts.linuxzando.com.br

## Setup ##

### Pra rodar o projeto ###

Ruby: 2.3.1
Rails: 4.2.6

sudo apt-get install imagemagick libmagickwand-dev
cd rts-web
bundle install
rake db:create db:migrate db:seed RAILS_ENV=development
rails server

### Mysql ###

Criar usuário:
username: rts-web
password: 123456


## Desenvolvimento ##

### Rodando o jogo ###

rails s
Entrar com admin (admin, 1234)
Acessar a url /admin
clicar em RESET WORLD

### COMANDOS DEV ###
**rails s** rodar o game \n
**rake game:reset_server** reseta a base de dados e gera um novo mapa \n
**rake game:rec999** enche os recursos de todos os jogadores \n
**rake game:resolve_events** termina todos os eventos do jogo

### ------------------------------ ###

### Containers ###
* ter docker instalado (https://docs.docker.com/engine/installation/)

### dockerfile mysql 

* cd container/mysql 
* docker build nome_container .
* docker run nome_container
