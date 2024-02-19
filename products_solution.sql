-- Task 1

SELECT COUNT(*) AS missing_year
FROM products
WHERE year_added IS NULL;

-- Task 2
WITH ModifiedData AS (
    SELECT
        product_id,
        COALESCE(product_type, 'Unknown') AS product_type,
        COALESCE(
            CASE 
                WHEN brand IS NULL OR brand = '-' THEN 'Unknown'
                ELSE brand
            END, 'Unknown'
        ) AS brand,
        COALESCE(CAST(REPLACE(weight, ' grams', '') AS DECIMAL), 
            COALESCE((SELECT AVG(CAST(REPLACE(weight, ' grams', '') AS DECIMAL)) FROM products WHERE weight IS NOT NULL), 0)
        ) AS weight,
        COALESCE(ROUND(CAST(price AS DECIMAL), 2), 
            COALESCE((SELECT AVG(price) FROM products WHERE price IS NOT NULL), 0)
        ) AS price,
        COALESCE(average_units_sold, 0) AS average_units_sold,
        COALESCE(CAST(year_added AS SIGNED), 2022) AS year_added,
        COALESCE(UPPER(stock_location), 'Unknown') AS stock_location
    FROM
        products
)

SELECT
    product_id,
    product_type,
    brand,
    weight,
    price,
    average_units_sold,
    year_added,
    stock_location
FROM
    ModifiedData;

-- Task 3
SELECT product_type, MIN(price) AS min_price, MAX(price) AS max_price
FROM products
GROUP BY product_type;

-- Task 4
SELECT
    product_id,
    price,
    average_units_sold
FROM
    products
WHERE
    (product_type = 'Meat' OR product_type = 'Dairy')
    AND average_units_sold > 10;
