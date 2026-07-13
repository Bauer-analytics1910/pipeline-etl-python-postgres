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

📊 Visualização de Dados e Inteligência de Negócios (Power BI)

<img width="886" height="499" alt="Captura de tela dashboard_b2b_pg1" src="https://github.com/user-attachments/assets/84343ef6-357f-43a7-a556-032800dd15c6" />

<img width="885" height="497" alt="Captura de tela dashboard_b2b_pg2" src="https://github.com/user-attachments/assets/bbebac98-a091-4f82-bda8-aeaac7d6e52c" />



A etapa final do projeto consistiu em transformar os dados modelados em um painel interativo voltado para a tomada de decisão da diretoria comercial. O design da interface (UI/UX) foi inteiramente prototipado no Figma, visando uma navegação intuitiva e redução da carga cognitiva.

O dashboard foi dividido em duas visões principais: Desempenho Geral e Análise de Sazonalidade.

📈 Métricas de Destaque (KPIs)
Faturamento Total: R$ 10,20 Mi

Volume Faturado: 107 Mil unidades

Ticket Médio B2B: R$ 3,40 Mil

🎯 Principais Insights e Ações Estratégicas
Através do uso de fórmulas DAX avançadas e cruzamento do histórico de vendas com a temperatura média diária, o projeto respondeu a perguntas complexas de negócios e gerou as seguintes recomendações:

A Prova Matemática da Sazonalidade (Correlação Térmica)

O Dado: O modelo de dispersão construído revela uma alta elasticidade da demanda B2B em relação ao clima, com o volume de pedidos acelerando exponencialmente em dias com temperaturas acima de 25°C (atingindo picos de receita na casa de R$ 1,36 Mi em meses quentes como março).

Ação Operacional: Integração da previsão meteorológica ao PCP (Planejamento de Produção) para antecipar a fabricação de lotes, como Cremes de Cupuaçu 5L e Bases de Milkshake, otimizando a logística de entrega em ondas de calor.

Risco de Concentração e Curva ABC

O Dado: Os 5 maiores clientes da fábrica representam 13,15% de toda a receita gerada durante o alto verão.

Ação Comercial: Criação de campanhas de descontos progressivos focadas na Curva B (clientes de médio porte) para diluir o risco de dependência e garantir um piso de faturamento seguro nos meses de baixa temporada.

Plano de Contenção para o Inverno

O Dado: A análise comparativa de ritmo diário comprovou uma contração exata de 38,32% no faturamento durante os períodos frios (temperaturas médias abaixo de 22°C).

Ação Comercial: Direcionamento da equipe de prospecção para focar ativamente na venda de bases de milkshake, além de criar campanhas incentivando a carteira atual a adotar receitas de inverno (como Affogato e bebidas quentes) para blindar o fluxo de caixa da empresa.
