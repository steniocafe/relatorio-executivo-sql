USE AdventureWorksDW2025;


WITH VendasSubcategoriaPorAno AS (
    SELECT 
        PC.EnglishProductCategoryName AS Categoria,
        PS.EnglishProductSubcategoryName AS Subcategoria,
        ST.SalesTerritoryCountry AS Pais,
        D.CalendarYear AS Ano,
        SUM(FIS.SalesAmount) AS FaturamentoTotal
    FROM FactInternetSales FIS
    INNER JOIN DimProduct AS P ON P.ProductKey = FIS.ProductKey
    INNER JOIN DimProductSubcategory AS PS ON PS.ProductSubcategoryKey = P.ProductSubcategoryKey
    INNER JOIN DimProductCategory AS PC ON PC.ProductCategoryKey = PS.ProductCategoryKey
    INNER JOIN DimSalesTerritory AS ST ON ST.SalesTerritoryKey = FIS.SalesTerritoryKey 
    INNER JOIN DimDate AS D ON D.DateKey = FIS.OrderDateKey 
    WHERE 
        ST.SalesTerritoryCountry = 'United States' 
    GROUP BY 
        PC.EnglishProductCategoryName, 
        PS.EnglishProductSubcategoryName,
        ST.SalesTerritoryCountry,
        D.CalendarYear
),
CalculoMétricas AS (
    SELECT 
        Categoria,
        Subcategoria,
        Pais,
        Ano,
        FaturamentoTotal,
        -- Faturamento do Ano Anterior da mesma Subcategoria
        LAG(FaturamentoTotal, 1) OVER (PARTITION BY Subcategoria ORDER BY Ano ASC) AS FaturamentoAnoAnterior,
        -- Market Share em relação ao Total do Ano Vigente (%)
        ROUND((FaturamentoTotal / SUM(FaturamentoTotal) OVER (PARTITION BY Ano)) * 100, 2) AS PercentualMarketShare,
        -- Ranking Geral no Ano
        DENSE_RANK() OVER (PARTITION BY Ano ORDER BY FaturamentoTotal DESC) AS RankingGeral,
        -- Ranking Dentro da Categoria no Ano
        DENSE_RANK() OVER (PARTITION BY Ano, Categoria ORDER BY FaturamentoTotal DESC) AS RankingNaCategoria
    FROM VendasSubcategoriaPorAno
)
SELECT 
    Ano,
    Pais,
    Categoria,
    Subcategoria,
    ROUND(FaturamentoTotal, 2) AS FaturamentoTotal,
    ROUND(ISNULL(FaturamentoAnoAnterior, 0), 2) AS FaturamentoAnoAnterior,
    -- Variação Absoluta ($)
    ROUND(FaturamentoTotal - ISNULL(FaturamentoAnoAnterior, 0), 2) AS VariacaoAbsoluta,
    -- Variação Percentual (% YoY)
    CASE 
        WHEN FaturamentoAnoAnterior IS NULL OR FaturamentoAnoAnterior = 0 THEN NULL
        ELSE ROUND(((FaturamentoTotal - FaturamentoAnoAnterior) / FaturamentoAnoAnterior) * 100, 2)
    END AS CrescimentoYoY_Percentual,
    PercentualMarketShare,
    RankingGeral,
    RankingNaCategoria
FROM CalculoMétricas
ORDER BY 
    Subcategoria, 
    Ano ASC;
