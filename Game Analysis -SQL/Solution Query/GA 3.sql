-- Q6)  Find Level and its corresponding Level code wise sum of lives earned excluding level 0.
-- Arrange in asecending order of level.

SELECT ld.Level , 
L1_Code,
L2_Code,
SUM(Lives_Earned) AS 'Total_Live_Earned'
FROM level_details ld  
JOIN player_details pd USING(P_ID)
WHERE ld.level in (1,2)
GROUP BY 1,2,3
ORDER BY 1 ASC;

-- Q7) Find Top 3 score based on each dev_id and Rank them in increasing order using Row_Number.
--  Display difficulty as well. 

WITH cte1 AS (
SELECT dev_id AS 'Device_ID',Difficulty,
score AS 'Score',
ROW_NUMBER() OVER(partition by dev_id ORDER BY score ASC) AS 'Rank_Row'
FROM level_details)

SELECT * FROM cte1 WHERE Rank_Row <= 3;


-- Q8) Find first_login datetime for each device id

SELECT dev_id AS 'Device_ID',
MIN(start_datetime)
FROM level_details
GROUP BY 1;

-- Q9) Find Top 5 score based on each difficulty level and Rank them in 
-- increasing order using Rank. Display dev_id as well.

WITH cte AS  (
SELECT dev_id,
difficulty,
score,
RANK() OVER(PARTITION BY difficulty ORDER BY score ASC) AS 'Rank_R'
FROM level_details)

SELECT * FROM cte WHERE Rank_R <=5;

-- Q10) Find the device ID that is first logged in(based on start_datetime) for each player(p_id).
--  Output should contain player id, device id and first login datetime.

SELECT p_id AS 'Player_ID',
dev_id AS 'Device_ID',
MIN(start_datetime) AS 'First_Login_Datetime'
FROM level_details
GROUP BY 1,2;