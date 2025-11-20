# Otimização de Rentabilidade Industrial: Papel e Celulose 🌲🏭

Este projeto é um estudo de caso de Engenharia de Dados e Analytics focado na análise de eficiência operacional (Margem Bruta) de grandes empresas do setor de Papel e Celulose (Suzano, Klabin, Irani).

O objetivo é transformar dados contábeis públicos e desestruturados da CVM em insights estratégicos de "Cost Optimization".

## 🏗️ Arquitetura da Solução (Modern Data Stack)

O projeto segue uma arquitetura ELT (Extract, Load, Transform):

1.  **Ingestão (Python):** Scripts automatizados que coletam arquivos `.zip` e `.csv` diretamente do portal de dados abertos da CVM.
2.  **Armazenamento (PostgreSQL):** Data Warehouse local para centralização dos dados brutos (`raw`) e modelados (`analytics`).
3.  **Transformação (dbt Core):**
    * Limpeza de dados e tratamento de tipagem.
    * Modelagem de dados financeiros (Pivotagem de DRE vertical para horizontal).
    * Enriquecimento com dados cadastrais (Seeds).
4.  **Visualização (Power BI):** Dashboard para análise comparativa de KPIs.

## 🛠️ Tecnologias Utilizadas

* **Linguagem:** Python 3.10+
* **Bibliotecas:** Pandas, SQLAlchemy, Requests
* **Engenharia Analítica:** dbt (data build tool)
* **Banco de Dados:** PostgreSQL
* **Controle de Versão:** Git & GitHub

## 📂 Estrutura do Projeto

```text
.
├── data/              # Arquivos locais (ignorados pelo git)
├── dbt_project/       # Projeto de transformação dbt
│   ├── models/        # Modelos SQL (Staging e Marts)
│   └── seeds/         # Arquivos CSV de dados mestres (tickers, empresas)
├── src/               # Scripts Python de Extração e Carga (EL)
├── notebooks/         # Análises exploratórias e rascunhos
└── requirements.txt   # Dependências do projeto
```

## 🚀Como Executar

1. **Configuração do ambiente:**
```
# Clone o repositório
git clone [https://github.com/gabvilla/projeto-analise-custos-ind)

# Crie e ative o ambiente virtual
python -m venv .venv
source .venv/bin/activate  # Linux/Mac
.\.venv\Scripts\Activate   # Windows

# Instale as dependências
pip install -r requirements.txt
```
2. **Execução do pipeline:**
Certifique-se de ter um banco PostgreSQL rodando e configure as credenciais
```
# 1. Rodar a ingestão dos dados brutos
python src/01_ingestao_cvm.py

# 2. Carregar dados auxiliares (Seeds)
cd dbt_project
dbt seed

# 3. Executar as transformações e criar as tabelas finais
dbt build
```
*Desenvolvido como projeto de portfólio focado em Engenharia de Dados e Business Intelligence.*
