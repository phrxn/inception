docker-compose=docker-compose
domain=mydomain.42.fr

nginx=nginx
mariadb=mariadb
wordpress=wordpress

all: make_folders add_domain_to_host_file
	sudo $(docker-compose) -f ./srcs/docker-compose.yml up -d

up:
	sudo $(docker-compose) -f ./srcs/docker-compose.yml up -d

down:
	sudo $(docker-compose) -f ./srcs/docker-compose.yml down

prune: down
	- sudo docker rmi $(nginx) $(mariadb) $(wordpress)
	- sudo docker volume rm volume-mariadb volume-wordpress
	- sudo rm -rf /home/$(domain)/data/

$(nginx):
	sudo $(docker-compose) --env-file ./srcs/.env -f ./srcs/docker-compose.yml up -d --build $(nginx)

$(mariadb):
	sudo $(docker-compose) --env-file ./srcs/.env -f ./srcs/docker-compose.yml up -d --build $(mariadb)

$(wordpress):
	sudo $(docker-compose) --env-file ./srcs/.env -f ./srcs/docker-compose.yml up -d --build $(wordpress)

make_folders:
	sudo mkdir -p /home/$(domain)/data/$(mariadb)
	sudo mkdir -p /home/$(domain)/data/$(wordpress)

add_domain_to_host_file:
	@if ! sudo grep -q $(domain) /etc/hosts; then \
	    echo "127.0.0.1 $(domain)" | sudo tee -a /etc/hosts > /dev/null; \
	fi

re : prune all
