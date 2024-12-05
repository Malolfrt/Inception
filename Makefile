all:
	mkdir -p /home/mlefort/data/mariadb
	mkdir -p /home/mlefort/data/wordpress
	docker compose -f ./srcs/docker-compose.yml build
	docker compose -f ./srcs/docker-compose.yml up -d

logs:
	docker logs wordpress
	docker logs mariadb
	docker logs nginx

clean:
	docker container stop nginx mariadb wordpress
	docker network rm inception

fclean:
	@sudo rm -rf /home/mlefort/data/mariadb/*
	@sudo rm -rf /home/mlefort/data/wordpress/*
	@docker system prune -af

rm:
	docker stop $(docker ps -qa); docker rm $(docker ps -qa); docker rmi -f $(docker images -qa); docker volume rm $(docker volume ls -q); docker network rm $(docker network ls -q) 2>/dev/null
	docker system prune -af

re: fclean all

.Phony: all logs clean fclean rm