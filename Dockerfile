# Imagen base oficial de Python
FROM python:3.11-slim

# Establecer directorio de trabajo
WORKDIR /app

# Copiar archivos de dependencias
COPY requirements.txt .

# Instalar dependencias
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código
COPY app.py /app

# Exponer el puerto donde corre Flask
EXPOSE 5000

# Comando por defecto
CMD ["python", "app.py"]