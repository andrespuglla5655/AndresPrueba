from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "<h1>Hola desde Flask con Traefik 🚀</h1>"

@app.route('/saludo/<nombre>')
def saludo(nombre):
    return f"<h2>Hola {nombre}, bienvenido a andres.byronrm.com</h2>"

@app.route('/health')
def health():
    return {"status": "healthy"}, 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=101)