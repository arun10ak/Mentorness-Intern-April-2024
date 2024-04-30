-- Q11) For each player and date, how many kill_count played so far by the player. 
-- That is, the total number of games played -- by the player until that date.
-- a) window function
SELECT
    p_id AS 'Player_ID',
    start_datetime AS 'Date',
    SUM(kill_count) OVER (PARTITION BY p_id ORDER BY start_datetime ) AS Total_Kill_Count
FROM
    level_details;
    
-- b) without window function
SELECT
    t1.p_id,
    t1.start_datetime,
    SUM(t2.kill_count) AS total_kill_count
FROM
    level_details t1
JOIN
    level_details t2
ON
    t1.p_id = t2.p_id
    AND t1.start_datetime >= t2.start_datetime
GROUP BY
    t1.p_id, t1.start_datetime
ORDER BY
    t1.p_id, t1.start_datetime;
    
-- Without Cummulative total
SELECT
    p_id AS 'Player_ID',
    start_datetime AS 'Date',
    SUM(kill_count)
FROM level_details
GROUP BY 1,2;

-- Q12) Find the cumulative sum of stages crossed over a start_datetime 

SELECT DATE(start_datetime) AS 'Start_Datetime' ,
Stages_crossed,
SUM(Stages_crossed) OVER(PARTITION BY DATE(start_datetime) ORDER BY Stages_crossed ROWS BETWEEN UNBOUNDED PRECEDING AND 0 PRECEDING) AS 'Cummulative_Total_Stages'
FROM level_details;

-- Q13) Find the cumulative sum of an stages crossed over a start_datetime for each player id but exclude the most recent start_datetime

WITH CTE AS (
    SELECT 
        p_id AS 'Player_ID',
        start_datetime AS 'Start_Datetime',
        stages_crossed AS 'Stages_Crossed' ,
        ROW_NUMBER() OVER (PARTITION BY p_id ORDER BY start_datetime DESC) AS 'rn'
    FROM 
        level_details
)
SELECT 
    Player_ID,
    Start_Datetime,
    Stages_Crossed,
    SUM(stages_crossed) OVER (PARTITION BY player_id ORDER BY start_datetime ASC ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS cumulative_sum
FROM 
    CTE
WHERE 
    rn > 1;

-- Q14) Extract top 3 highest sum of score for each device id and the corresponding player_id
WITH cte AS(
SELECT dev_id AS 'Device_ID',
p_id AS 'Player_ID',
SUM(Score) AS 'Total_Score',
RANK() OVER (PARTITION BY dev_id ORDER BY SUM(score) DESC) AS score_rank
FROM level_details
GROUP BY 1,2)

SELECT Device_ID,
Player_ID,
Total_Score
FROM  CTE
WHERE score_rank <= 3;

-- Q15) Find players who scored more than 50% of the avg score scored by sum of scores for each player_id

WITH cte1 AS (
SELECT p_id , SUM(score) AS total 
FROM level_details
GROUP BY 1),

 cte2 AS (
SELECT * , AVG(total) OVER() as avg_total  FROM cte1 group by p_id)

SELECT p_id,total, avg_total
FROM cte2
WHERE total > 0.5 * avg_total;

-- OR --

SELECT 
    p_id,total_score,avg_score
FROM 
    (SELECT 
         p_id,
         SUM(score) AS total_score,
         AVG(SUM(score)) OVER () AS avg_score
     FROM 
         level_details
     GROUP BY 
         p_id) AS player_scores
WHERE 
    total_score > avg_score * 0.5














