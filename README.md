# Gerenciamento de Ponto Eletrônico

Banco de dados do trabalho de Banco de Dados (DCC060-A), em PostgreSQL 16.

## Pré-requisitos

- [Docker](https://docs.docker.com/get-docker/) com o Docker Compose

## Subir o banco

Na raiz do projeto:

```bash
docker compose up -d
```

Na primeira vez, o PostgreSQL executa sozinho os scripts da pasta `sql/` e cria as tabelas.

Para conferir se deu certo:

```bash
docker compose exec db psql -U ponto -d ponto_eletronico -c "\dt"
```

Devem aparecer 21 tabelas.

## Acessar o banco

Pelo terminal:

```bash
docker compose exec db psql -U ponto -d ponto_eletronico
```

Ou por um cliente gráfico (DBeaver, pgAdmin etc.):

| Campo   | Valor              |
| ------- | ------------------ |
| Host    | `localhost`        |
| Porta   | `5432`             |
| Banco   | `ponto_eletronico` |
| Usuário | `ponto`            |
| Senha   | `ponto`            |

## Desligar

```bash
docker compose down
```

Os dados continuam salvos para a próxima vez.

## Alterou algum arquivo `.sql`?

Os scripts só rodam quando o banco é criado do zero. Depois de alterar o SQL, recrie o banco:

```bash
docker compose down -v
docker compose up -d
```

> ⚠️ O `-v` apaga todos os dados do banco.

## Problemas comuns

- **Porta 5432 ocupada:** já existe um PostgreSQL rodando na máquina. No `docker-compose.yml`, troque `"5432:5432"` por `"5433:5432"` e conecte na porta `5433`.
- **Tabelas não foram criadas:** veja o erro com `docker compose logs db`.
