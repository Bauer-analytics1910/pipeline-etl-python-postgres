--top 3 produtos mais vendidos em dias com temperatura acima de 25°C
-- Criando a View analítica para os dias quentes

CREATE OR REPLACE VIEW vw_top3_produtos_calor AS
SELECT 
    f.produto,
    SUM(f.quantidade) AS total_vendido,
    ROUND(AVG(f.temperatura_media), 2) AS temp_media_periodo
FROM fato_vendas_clima f
WHERE temperatura_media > 25.0
GROUP BY produto
ORDER BY total_vendido DESC
LIMIT 3;

-- Análise de volume de vendas em dias frios (Temperatura < 17°C)
CREATE OR REPLACE VIEW vw_vendas_dias_frios AS
SELECT 
    f.produto,
    SUM(f.quantidade) AS total_vendido,
    ROUND(AVG(f.temperatura_media), 2) AS temp_media_periodo
FROM fato_vendas_clima f
WHERE f.temperatura_media < 17.0
GROUP BY f.produto
ORDER BY total_vendido DESC;

-- 3. Visão de faturamento mensal e temperatura média
CREATE OR REPLACE VIEW vw_faturamento_mensal AS
SELECT 
    TO_CHAR(data_pedido, 'YYYY-MM') AS mes,
    SUM(quantidade) AS volume_total_vendido,
    SUM(valor_total) AS faturamento_total,
    ROUND(AVG(temperatura_media), 2) AS temperatura_media_mes
FROM fato_vendas_clima
GROUP BY TO_CHAR(data_pedido, 'YYYY-MM')
ORDER BY mes;

-- 4. Top 5 Clientes com maior faturamento (Curva ABC usando JOIN)
CREATE OR REPLACE VIEW vw_top5_clientes AS
SELECT 
    c.nome_cliente,
    COUNT(f.data_pedido) AS total_pedidos_realizados,
    SUM(f.quantidade) AS volume_comprado,
    SUM(f.valor_total) AS faturamento_total
FROM fato_vendas_clima f
JOIN dim_clientes c ON f.cliente_id = c.cliente_id
GROUP BY c.nome_cliente
ORDER BY faturamento_total DESC
LIMIT 5;

-- 5. Ticket médio e performance geral por produto
CREATE OR REPLACE VIEW vw_performance_produtos AS
SELECT 
    produto,
    SUM(quantidade) AS volume_total,
    SUM(valor_total) AS faturamento_total,
    ROUND(SUM(valor_total) / COUNT(data_pedido), 2) AS ticket_medio_por_pedido
FROM fato_vendas_clima
GROUP BY produto
ORDER BY faturamento_total DESC;