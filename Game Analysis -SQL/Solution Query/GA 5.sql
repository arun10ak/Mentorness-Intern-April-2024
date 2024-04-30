-- Q16) Create a stored procedure to find top n headshots_count based on each dev_id and Rank them in increasing order
-- using Row_Number. Display difficulty as well.
-- For Top 3

WITH cte AS (
SELECT dev_id AS 'Device_ID',
difficulty AS 'Difficulty_Level',
Headshots_Count,
ROW_NUMBER() OVER(PARTITION BY dev_id ORDER BY Headshots_Count ASC) as 'rn'
FROM level_details)

SELECT Device_ID,Difficulty_Level,Headshots_Count
FROM cte
WHERE rn <=3;

-- Stored Procedure

CREATE DEFINER=`root`@`localhost` PROCEDURE `top n headshots_count`(
in_top_N INT)
BEGIN
WITH cte AS (
SELECT dev_id AS 'Device_ID',
difficulty AS 'Difficulty_Level',
Headshots_Count,
ROW_NUMBER() OVER(PARTITION BY dev_id ORDER BY Headshots_Count DESC) as 'rn'
FROM level_details)

SELECT Device_ID,Difficulty_Level,Headshots_Count
FROM cte
WHERE rn <=in_top_N
END;


-- Q17) Create a function to return sum of Score for a given player_id.

SELECT SUM(score) AS Total
FROM level_details
WHERE p_id = 211;

CREATE DEFINER=`root`@`localhost` FUNCTION `get_score_by_playerid`(player_id INT) RETURNS int
    DETERMINISTIC
BEGIN
	declare Total INT;

	SELECT sum(score) INTO Total
	FROM level_details
	WHERE p_id  = player_id;

	RETURN Total ;
END
