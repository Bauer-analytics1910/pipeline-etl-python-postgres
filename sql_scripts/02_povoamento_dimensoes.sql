-- Alimentando a tabela de clientes
INSERT INTO dim_clientes (cliente_id, nome_cliente)
SELECT DISTINCT cliente_id, 'Cliente ' || cliente_id
FROM fato_vendas_clima;

-- Alimentando a tabela de produtos
INSERT INTO dim_produtos (nome_produto, valor_unitario)
SELECT DISTINCT produto, valor_unitario
FROM fato_vendas_clima;