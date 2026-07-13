	--1. Criando a tabela Fato de clientes e Clima
	
CREATE TABLE fato_vendas_clima (
    data_pedido DATE,
    cliente_id INT,
    produto VARCHAR(150),
    quantidade INT,
    valor_unitario NUMERIC(10, 2),
    valor_total NUMERIC(10, 2),
    temperatura_media NUMERIC(5, 2)
);

-- 2. Criando a tabela de Dimensão Cliente
CREATE TABLE dim_clientes (
    cliente_id INT PRIMARY KEY,
    nome_cliente VARCHAR(50)
);

-- 3. Criando a tabela de Dimensão Produto
CREATE TABLE dim_produtos (
    produto_id SERIAL PRIMARY KEY,
    nome_produto VARCHAR(150),
    valor_unitario NUMERIC(10, 2)