with dist_map AS (
    --Discrepancy in task description and column names, but I'll assume
    --task description is correct and MAP table maps dimension_2 values
    SELECT distinct dimension_1 AS dimension_2, correct_dimension_2
      FROM MAP
),
joined_tabs AS (
    SELECT nvl(A.dimension_1,B.dimension_1) AS dimension_1, 
           nvl(A.dimension_2,B.dimension_2) AS dimension_2, 
           nvl(A.measure_1,0) AS measure_1, 
           nvl(B.measure_2,0) AS measure_2
      FROM A
      FULL OUTER JOIN B
        ON A.dimension_1 = B.dimension_1
       AND A.dimension_2 = B.dimension_2 
),
aggs AS (
    SELECT SUM(t.measure_1) AS measure_1,
           SUM(t.measure_2) AS measure_2,
           t.dimension_1,
           t.dimension_2
      FROM joined_tabs t
     WHERE t.dimension_1 IS NOT NULL
       AND t.dimension_2 IS NOT NULL
)
SELECT ag.measure_1, ag.measure_2, ag.dimension_1, d.correct_dimension_2 AS dimension_2
  FROM aggs ag
  JOIN dist_map d
    ON d.dimension_2 = ag.dimension_2