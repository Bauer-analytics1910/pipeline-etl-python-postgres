# Pipeline de ETL: Correlação de Vendas B2B e Sazonalidade Climática 🍦☀️

Este projeto apresenta um pipeline de ETL (Extração, Transformação e Carga) ponta a ponta projetado para analisar o impacto da temperatura ambiente no volume de vendas de uma indústria de alimentos frios (focada em açaí, sorvetes e bases para milkshake). 

O objetivo principal é correlacionar dados históricos de faturamento e volume de pedidos B2B com a variação de temperatura média real diária obtida através de uma API pública.

---

## 💻 Tecnologias e Ferramentas Utilizadas

* **Linguagem de Programação:** Python (versão 3.x)
* **Bibliotecas Python:** `Pandas` (manipulação de dados), `Requests` (consumo de API)
* **Banco de Dados:** PostgreSQL (Servidor local)
* **Gerenciador de Banco de Dados:** DBeaver Community
* **Visualização de Dados (WIP):** Power BI Desktop

---

## 📐 Arquitetura do Pipeline (ETL)

O fluxo de dados foi desenhado para simular o ambiente real de uma engenharia de dados corporativa:
<img width="718" height="307" alt="Diagrama_Pipeline_ETL drawio" src="https://github.com/user-attachments/assets/4f2272ae-4e1d-4554-b65d-6338cb3e65a4" />


### 1. Extração (Extract)
* **Vendas Internas:** Simulação automatizada via script Python para gerar uma base de 3.000 registros históricos de vendas B2B ao longo do ano de 2025, incorporando regras reais de sazonalidade comercial de alta temporada (meses quentes) e baixa temporada (meses frios).
* **Clima:** Consumo direto via biblioteca `Requests` da API pública **Open-Meteo**, extraindo as temperaturas médias diárias da região do ABC Paulista (coordenadas de São Caetano do Sul) referentes ao ano completo de 2025.

### 2. Transformação (Transform)
* Unificação de ambos os datasets no Python utilizando a data como chave de cruzamento (`Merge/Join`).
* Tratamento de tipos de dados (Datas e Valores monetários).
* Padronização dos nomes dos campos para minúsculas (`snake_case`) visando a performance física e facilidade de escrita de queries no PostgreSQL.

### 3. Carga (Load)
* Estruturação física das tabelas no PostgreSQL.
* Carga otimizada das linhas via assistente de importação rápida de arquivos consolidados `.csv` no DBeaver.

---

## 🗄️ Modelagem de Dados (Star Schema)

Para garantir que o banco de dados seja escalável e performático para ferramentas de Business Intelligence (BI), a estrutura foi normalizada seguindo o modelo **Star Schema** (Esquema Estrela), dividindo-se entre:

* **Tabela Fato:**
    * `fato_vendas_clima` (Armazena as métricas quantitativas de volume, faturamento e a temperatura registrada no dia do pedido).
* **Tabelas Dimensão:**
    * `dim_clientes` (Armazena o cadastro único de clientes).
    * `dim_produtos` (Armazena o portfólio de produtos e seus respectivos preços de tabela).

---

## 📊 SQL Analytics: Queries e Inteligência de Negócio

Antes de iniciar as visualizações gráficas, o banco de dados foi testado com queries analíticas diretas no DBeaver. O projeto conta com uma **View física** que armazena regras de negócios complexas direto no servidor do banco:
### Criação da View (`vw_top3_produtos_calor`):
```sql
CREATE OR REPLACE VIEW vw_top3_produtos_calor AS
SELECT 
    f.produto,
    SUM(f.quantidade) AS total_vendido,
    ROUND(AVG(f.temperatura_media), 2) AS temp_media_periodo
FROM fato_vendas_clima f
WHERE temperatura_media > 22.0
GROUP BY produto
ORDER BY total_vendido DESC
LIMIT 3;

Essa visualização permite que qualquer ferramenta de relatório consulte de forma extremamente otimizada os produtos mais relevantes em dias quentes:

SELECT * FROM vw_top3_produtos_calor;

📂 Estrutura do Repositório
O projeto está organizado da seguinte forma:

├── dados_brutos/               # Arquivos CSV originais de vendas e clima gerados no Python.
├── scripts_python/             # Scripts executados no Google Colab (.py ou .ipynb).
├── sql_scripts/                # Scripts SQL de criação de tabelas, povoamento e views.
│   ├── 01_setup_tabelas.sql    # Documentação do projeto.
│   ├── 02_povoamento_dimensoes.sql
│   └── 03_views_analiticas.sql
└── README.md                   

🚧 Próximos Passos (Em Desenvolvimento)

[ ] Integração final do banco de dados local PostgreSQL com o Power BI Desktop.

[ ] Desenvolvimento de métricas em DAX para analisar variações percentuais de faturamento por faixa de temperatura.

[ ] Criação de painel gerencial interativo com visualizações de dispersão para comprovar a correlação estatística entre temperatura e demanda B2B.
