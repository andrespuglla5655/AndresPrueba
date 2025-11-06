# Variables
SERVICE_NAME=holaflask
IMAGE_NAME=holaflask
REGISTRY=ghcr.io

# Construir la imagen
build:
	docker build -t $(IMAGE_NAME) .

# Levantar el servicio Flask
up:
	docker run -d -p 5000:5000 --name $(SERVICE_NAME) $(IMAGE_NAME)

# Ver logs del servicio Flask
logs:
	docker logs -f $(SERVICE_NAME)

# Ver logs de Traefik
traefik-logs:
	docker logs -f traefik

# Detener y eliminar el contenedor
down:
	docker rm -f $(SERVICE_NAME) || true

# Reconstruir completamente el servicio
rebuild: down build up

# Limpiar imágenes huérfanas
clean:
	docker system prune -f

# Ver el dashboard de Traefik
dashboard:
	echo "Abre tu navegador en http://localhost:8080"

# Construir imagen para múltiples plataformas
build-multi:
	docker buildx build --platform linux/amd64,linux/arm64 -t $(IMAGE_NAME) .

# Publicar en GitHub Packages
publish:
	docker buildx build --platform linux/amd64,linux/arm64 -t $(REGISTRY)/$(IMAGE_NAME):latest . --push

# Ejecutar pruebas
test:
	docker run --rm $(IMAGE_NAME) python -m pytest tests/

# Ejecutar linter
lint:
	docker run --rm -v $(PWD):/app $(IMAGE_NAME) flake8 .

# Verificar sintaxis de Python
check-syntax:
	docker run --rm $(IMAGE_NAME) python -m py_compile app.py