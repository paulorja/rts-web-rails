## Setup ##

### Link to play ###

http://rts.linuxzando.com.br


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

### ------------------------------ ###

### COMANDOS DEV ###
* **rails s** rodar o game
* **rake game:reset_server** reseta a base de dados e gera um novo mapa
* **rake game:rec999** enche os recursos de todos os jogadores
* **rake game:resolve_events** termina todos os eventos do jogo

### Ruby ###

* Ruby: 2.3.1
* Rails: 4.2.6

### Mysql

* Criar usuário mysql:
* username: rts-web
* password: 123456

### Containers ###
* ter docker instalado (https://docs.docker.com/engine/installation/)

### dockerfile mysql 

* cd container/mysql 
* docker build nome_container .
* docker run nome_container
