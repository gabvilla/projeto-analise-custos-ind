import pandas as pd
import requests
import zipfile
import io
from sqlalchemy import create_engine
import os

# --- CONFIGURAÇÕES ---
# URL da CVM para as DREs (Demonstração de Resultado) anuais
# Vamos pegar 2023 como exemplo inicial
ANO = '2023'
URL_CVM_DFP = f"https://dados.cvm.gov.br/dados/CIA_ABERTA/DOC/DFP/DADOS/dfp_cia_aberta_{ANO}.zip"

# Conexão com o Banco (ADAPTE AQUI SUA SENHA)
# Formato: postgresql://usuario:senha@localhost:5432/nome_do_banco
DB_CONNECTION = 'postgresql://postgres:%40Ju150619@localhost:5432/custos_industria'

def main():
    print(f"🚀 Iniciando download de dados de {ANO}...")
    
    # 1. Baixar o arquivo ZIP da CVM
    response = requests.get(URL_CVM_DFP)
    
    if response.status_code == 200:
        print("✅ Download concluído! Extraindo arquivo de DRE...")
        
        # 2. Abrir o ZIP na memória (sem salvar no disco pra ser mais rápido)
        with zipfile.ZipFile(io.BytesIO(response.content)) as z:
            
            # Procuramos especificamente o arquivo de DRE CONSOLIDADA (visão do grupo todo)
            nome_arquivo_csv = f"dfp_cia_aberta_DRE_con_{ANO}.csv"
            
            # 3. Ler o CSV direto do ZIP para o Pandas
            # A CVM usa codificação ISO-8859-1 e separador ponto-e-vírgula
            with z.open(nome_arquivo_csv) as f:
                df = pd.read_csv(f, sep=';', encoding='ISO-8859-1')
                
        print(f"📊 Dados carregados no Python: {df.shape[0]} linhas encontradas.")
        
        # 4. Salvar no PostgreSQL (Load)
        print("💾 Salvando no PostgreSQL...")
        
        engine = create_engine(DB_CONNECTION)
        
        # 'if_exists="replace"' recria a tabela se ela já existir.
        # 'index=False' não envia o índice do pandas como coluna.
        df.to_sql(f'dre_bruta_{ANO}', engine, if_exists='replace', index=False)
        
        print("🏆 Sucesso! Tabela criada no banco.")
        
    else:
        print(f"❌ Erro ao baixar: {response.status_code}")

if __name__ == "__main__":
    main()