with staging as (
    select * from {{ ref('stg_dre_papel_celulose') }}
),

pivot_dados as (
    select
        -- ATUALIZAÇÃO: Usando as novas colunas do Seed
        nome_empresa_analise as empresa,
        ticker,
        cnpj,
        data_referencia,
        
        -- Lógica de agregação (Receita)
        sum(case when codigo_conta LIKE '3.01%' and length(codigo_conta) = 4 then valor else 0 end) as receita_liquida,
        
        -- Lógica de agregação (Custo)
        sum(case when codigo_conta LIKE '3.02%' and length(codigo_conta) = 4 then valor else 0 end) as custo_produtos_vendidos
        
    from staging
    where codigo_conta LIKE '3.01%' OR codigo_conta LIKE '3.02%'
    -- ATUALIZAÇÃO: O Group By precisa refletir as novas colunas
    group by nome_empresa_analise, ticker, cnpj, data_referencia
)

select
    empresa,
    ticker,
    data_referencia,
    receita_liquida,
    custo_produtos_vendidos,
    
    (receita_liquida + custo_produtos_vendidos) as lucro_bruto,
    
    case 
        when receita_liquida = 0 then 0
        else ((receita_liquida + custo_produtos_vendidos) / receita_liquida) * 100 
    end as margem_bruta_percentual

from pivot_dados
where receita_liquida <> 0 and data_referencia = '2023-12-31'
order by margem_bruta_percentual desc