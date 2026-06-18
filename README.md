# PokeOps DevOps - Fase 2

Projeto acadêmico da disciplina **DevOps na Prática** - Fase 2: Entrega Contínua, Monitoramento e Segurança.

Repositório público do projeto:

`https://github.com/demotrini/pokeops-devops-fase1`

> Observação: o projeto foi iniciado na Fase 1 e expandido na Fase 2. Por isso, o repositório original foi mantido para preservar o histórico.

## Objetivo

Evoluir a base criada na Fase 1 para um fluxo DevOps mais completo, contemplando:

- pipeline de CI/CD com GitHub Actions;
- containerização da aplicação com Docker;
- deploy local automatizado com Docker Compose;
- scripts de deploy, rollback e logs;
- orquestração demonstrativa com Kubernetes;
- validações de teste, infraestrutura, health check e observabilidade básica.

## Estrutura do projeto

```text
.
├── .github/workflows/
│   ├── ci.yml
│   └── cicd.yml
├── app/
│   ├── __init__.py
│   └── main.py
├── docs/
│   └── fluxo-devops.md
├── k8s/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── README.md
├── scripts/
│   ├── deploy.sh
│   ├── logs.sh
│   └── rollback.sh
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── README.md
├── tests/
│   └── test_app.py
├── .dockerignore
├── Dockerfile
├── docker-compose.yml
├── pytest.ini
├── requirements.txt
└── README.md
```

## Execução local sem Docker

```bash
python -m venv .venv
source .venv/bin/activate   # Linux/macOS
# .venv\Scripts\activate  # Windows
pip install -r requirements.txt
python -m flask --app app.main run --debug
```

Aplicação: `http://127.0.0.1:5000`  
Health check: `http://127.0.0.1:5000/health`

## Testes automatizados

```bash
pytest -v
```

## Build e execução com Docker

```bash
docker build -t pokeops-api:latest .
docker run --rm -p 5000:5000 pokeops-api:latest
```

## Deploy com Docker Compose

```bash
docker compose up -d --build
docker compose ps
docker compose logs --tail=100 pokeops-api
```

## Scripts de operação

```bash
chmod +x scripts/*.sh
./scripts/deploy.sh
./scripts/logs.sh
./scripts/rollback.sh
```

## Pipeline CI/CD

O workflow `.github/workflows/cicd.yml` executa:

1. checkout do repositório;
2. instalação de dependências Python;
3. testes automatizados com Pytest;
4. validação dos scripts Terraform;
5. build da imagem Docker;
6. execução de container temporário para smoke test;
7. deploy demonstrativo com Docker Compose;
8. coleta de logs da aplicação.

Links diretos:

- CI: `https://github.com/demotrini/pokeops-devops-fase1/actions/workflows/ci.yml`
- CI/CD: `https://github.com/demotrini/pokeops-devops-fase1/actions/workflows/cicd.yml`
- Dockerfile: `https://github.com/demotrini/pokeops-devops-fase1/blob/main/Dockerfile`
- Docker Compose: `https://github.com/demotrini/pokeops-devops-fase1/blob/main/docker-compose.yml`
- Scripts: `https://github.com/demotrini/pokeops-devops-fase1/tree/main/scripts`
- Kubernetes: `https://github.com/demotrini/pokeops-devops-fase1/tree/main/k8s`
- Terraform: `https://github.com/demotrini/pokeops-devops-fase1/tree/main/terraform`

## Infraestrutura como Código

A pasta `terraform/` contém a infraestrutura alvo na AWS criada na Fase 1: VPC, subnet pública, Internet Gateway, tabela de rotas, Security Group e EC2.

Para validar:

```bash
cd terraform
terraform init -backend=false
terraform fmt -check -recursive
terraform validate
```

## Segurança e observabilidade

- Container executa com usuário não-root.
- `.dockerignore` evita envio de arquivos desnecessários para o build context.
- `HEALTHCHECK` valida `/health` automaticamente.
- Docker Compose limita rotação de logs com `max-size` e `max-file`.
- Scripts coletam logs e status dos containers.
- Variável `allowed_ssh_cidr` permite restringir SSH no Terraform antes de uso real.

## Orquestração com Kubernetes

Os arquivos em `k8s/` representam uma alternativa de orquestração com duas réplicas, service interno, readiness probe, liveness probe e limites de recursos.

```bash
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```
