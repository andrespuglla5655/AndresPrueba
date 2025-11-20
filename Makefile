APP_NAME=andres
IMAGE_NAME=ghcr.io/andrespuglla5655/andresprueba
STACK_FILE=stack.yml

tag:
	docker build -t $(IMAGE_NAME):latest .
	docker tag $(IMAGE_NAME):latest $(IMAGE_NAME):$(shell git rev-parse --short HEAD)

build:
	docker build -t $(IMAGE_NAME):latest .

pull:
	docker pull $(IMAGE_NAME):latest

test:
	docker run -d -p 101:101 --name test-andres $(IMAGE_NAME):latest
	sleep 5
	curl -f http://localhost:101
	docker rm -f test-andres

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
	make pull
	make deploy

clean:
	docker image prune -f
	docker container prune -f

login:
	echo ${GHCR_TOKEN} | docker login ghcr.io -u andrespuglla5655 --password-stdin

push:
	make login
	make tag
	docker push $(IMAGE_NAME):latest
	docker push $(IMAGE_NAME):$(shell git rev-parse --short HEAD)