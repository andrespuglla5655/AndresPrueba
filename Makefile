APP_NAME=andres
STACK_FILE=stack.yml
VPS_USER=
VPS_HOST=
VPS_PORT=22

build:
	docker build -t $(APP_NAME):latest .

build-push:
	docker build -t ghcr.io/andrespuglla5655/andresprueba:latest .
	docker push ghcr.io/andrespuglla5655/andresprueba:latest

deploy:
	docker stack deploy --with-registry-auth -c $(STACK_FILE) $(APP_NAME)

logs:
	docker service logs -f $(APP_NAME)_$(APP_NAME)

rm:
	docker stack rm $(APP_NAME)

ps:
	docker service ls

restart:
	make rm
	sleep 5
	make build
	make deploy

vps-deploy: build-push
	scp $(STACK_FILE) $(VPS_USER)@$(VPS_HOST):/home/$(VPS_USER)/deploy1/
	ssh -p $(VPS_PORT) $(VPS_USER)@$(VPS_HOST) "cd /home/$(VPS_USER)/deploy1 && docker network create traefik-public || true && docker stack deploy -c stack.yml andres"

vps-logs:
	ssh -p $(VPS_PORT) $(VPS_USER)@$(VPS_HOST) "docker service logs -f andres_andres"

vps-rm:
	ssh -p $(VPS_PORT) $(VPS_USER)@$(VPS_HOST) "docker stack rm andres"