# Imagem base leve para executar a aplicação Flask
FROM python:3.11-slim

# Evita geração de arquivos .pyc e melhora logs em containers
ENV PYTHONDONTWRITEBYTECODE=1         PYTHONUNBUFFERED=1         FLASK_APP=app.main:app

WORKDIR /app

# Instala dependências primeiro para aproveitar cache de build
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip         && pip install --no-cache-dir -r requirements.txt

# Copia a aplicação e os testes para dentro da imagem
COPY app ./app
COPY tests ./tests
COPY pytest.ini ./pytest.ini

# Usuário não-root como prática básica de segurança
RUN adduser --disabled-password --gecos "" appuser         && chown -R appuser:appuser /app
USER appuser

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3       CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:5000/health')" || exit 1

CMD ["python", "-m", "flask", "run", "--host=0.0.0.0", "--port=5000"]
