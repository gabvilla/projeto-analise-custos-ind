with fonte_dre as (
    select * from public.dre_bruta_2023
),

empresas_selecionadas as (
    -- Puxamos nossa lista VIP de empresas (o CSV que você criou)
    select * from {{ ref('empresas_foco') }}
),

renomeado as (
    select
        dre."DENOM_CIA" as nome_empresa_cvm,
        emp.nome_referencia as nome_empresa_analise, -- Nome bonito padronizado
        emp.ticker,
        dre."CNPJ_CIA" as cnpj,
        dre."DT_FIM_EXERC" as data_referencia,
        
        TRIM(dre."CD_CONTA") as codigo_conta,
        dre."DS_CONTA" as descricao_conta,
        dre."VL_CONTA" as valor
        
    from fonte_dre dre
    -- O PULO DO GATO: Inner Join filtra automaticamente.
    -- Se o CNPJ não estiver no CSV, essa linha é descartada.
    inner join empresas_selecionadas emp
        on dre."CNPJ_CIA" = emp.cnpj
)

select * from renomeado