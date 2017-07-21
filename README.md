## Setup ##

### Run ###
```
Ruby: 2.3.1
Rails: 4.2.6

sudo apt-get install imagemagick libmagickwand-dev
cd rts-web
bundle install
rake db:create db:migrate db:seed RAILS_ENV=development
rails server
```
### Mysql ###
```
Create user:
username: rts-web
password: 123456
```

## Development ##

### Run server ###
```
rails s
Enter with admin (admin, 1234)
URL: /admin
click: RESET WORLD
```
### RAKE DEV COMMANDS ###
```
**rails s** run server
**rake game:reset_server** reset database and generate a new map
**rake game:rec999** send 999999 recourses to all players
**rake game:resolve_events** finish all events
```
### ------------------------------ ###

### Containers ###
* install docker (https://docs.docker.com/engine/installation/)

### dockerfile mysql 

* cd container/mysql 
* docker build nome_container .
* docker run nome_container
