# relatorio-executivo-sql
Projeto de portfólio, relatório executivo de vendas usando CTEs e Windows Functions no SQL Server.

# 📊 Relatório Executivo Comercial & Análise YoY (AdventureWorksDW)

Este projeto apresenta uma análise executiva de desempenho comercial utilizando dados do banco **AdventureWorksDW2025**. O objetivo é transformar dados relacionais complexos de um ambiente de Data Warehouse em relatórios acionáveis que permitam à diretoria avaliar o faturamento, participação de mercado (*Market Share*), comportamento histórico de crescimento (*Year-over-Year*) e posição das subcategorias de produtos.

---

## 🎯 Problema de Negócio

A equipe executiva precisava de uma visão consolidada do desempenho das subcategorias de produtos com base no histórico de vendas dos Estados Unidos. As principais perguntas de negócio e suas conclusões foram:

1. **Desempenho Financeiro:** Qual o faturamento total por subcategoria a cada ano?
   > **Resposta:** O faturamento é fortemente liderado pelo segmento de bicicletas (*Road Bikes* e *Mountain Bikes*), superando a marca de US$ 1 milhão anuais por subcategoria. Produtos menores, como acessórios e vestuário (*Helmets*, *Tires and Tubes*), mantêm volume financeiro menor (US$ 30k a US$ 150k/ano), porém constante.

2. **Crescimento Histórico (YoY):** Como as vendas de cada subcategoria evoluíram em relação ao ano anterior?
   > **Resposta:** Houve expansão contínua nas vendas entre 2012 e 2013, com crescimentos anuais médios entre +20% e +45%. Subcategorias acessórias apresentaram as maiores acelerações percentuais de crescimento YoY recente devido às vendas casadas (*cross-selling*).

3. **Participação de Mercado (Market Share):** Qual a representatividade percentual de cada subcategoria no faturamento total do ano?
   > **Resposta:** Observa-se alta concentração de receita: apenas 3 subcategorias de bicicletas concentram mais de 75% a 80% do faturamento total do negócio, enquanto todas as demais linhas dividem os 20% a 25% restantes (*cauda longa*).

4. **Posicionamento Comercial (Ranking):** Como as subcategorias se posicionam no ranking geral de vendas e dentro da sua própria categoria principal?
   > **Resposta:** No ranking geral, *Road Bikes* (#1) e *Mountain Bikes* (#2) mantêm liderança isolada. Nas categorias secundárias, *Helmets* lidera o segmento de *Accessories* e *Jerseys* é a #1 na categoria *Clothing*.
---

## 🛠️ Tecnologias e Conceitos de SQL Utilizados

- **SGBD:** Microsoft SQL Server / T-SQL
- **Database:** `AdventureWorksDW2025` (Modelagem Dimensional)
- **Tabelas Relacionadas:**
  - `FactInternetSales` (Tabela de Fatos de Vendas)
  - `DimProduct`, `DimProductSubcategory`, `DimProductCategory` (Dimensões de Produtos)
  - `DimSalesTerritory` (Dimensão Geográfica)
  - `DimDate` (Dimensão de Tempo)

### Conceitos Técnicos Aplicados:
- **Common Table Expressions (CTEs):** Estruturação do código em camadas lógicas legíveis e reutilizáveis.
- **Window Functions (Funções de Janela):**
  - `LAG()`: Para buscar o faturamento do ano anterior e calcular a variação *Year-over-Year*.
  - `SUM() OVER(PARTITION BY ...)`: Para calcular o faturamento global do ano e extrair o *Market Share %*.
  - `DENSE_RANK() OVER(PARTITION BY ... ORDER BY ...)`: Para gerar rankings comerciais dinâmicos globais e por categoria.
- **Tratamento de Dados:** Tratamento de valores `NULL` e prevenção de divisão por zero utilizando `ISNULL()`, `COALESCE()` e comandos relacionais `CASE`.

