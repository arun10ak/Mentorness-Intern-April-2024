-- Q1) Extract P_ID,Dev_ID,PName and Difficulty_level of all players at level 0

SELECT ld.P_ID AS 'Player_ID',
	ld.Dev_Id AS 'Device_ID',
    pd.PName AS 'Player Name',
    difficulty AS 'Difficulty_Level'
FROM level_details ld
JOIN player_details pd USING(P_ID)
WHERE Level = 0;

-- Q2) Find Level1_code wise Avg_Kill_Count where lives_earned is 2 and atleast 3 stages are crossed

SELECT pd.L1_Code AS 'Level1_Code',
	AVG(ld.kill_count) AS  'Avg_Kill_Count'
FROM player_details pd
JOIN level_details ld USING(P_ID)
WHERE Lives_Earned = 2 AND Stages_crossed >=3
GROUP BY pd.L1_Code;

-- Q3) Find the total number of stages crossed at each diffuculty level where for Level2 with players use zm_series devices.
-- Arrange the result in decsreasing order of total number of stages crossed.

SELECT Difficulty AS 'Difficulty_Level',
sum(Stages_crossed) AS ' Total_No._of_Stages'
FROM level_details
WHERE Level =2 AND Dev_Id LIKE '%zm_%'
GROUP BY 1
ORDER BY 2 DESC;

-- Q4) Extract P_ID and the total number of unique dates for those players who have played games on multiple days.

SELECT p_id AS 'Player_ID',
COUNT(distinct(start_datetime)) AS 'Total_No._of_Unique_Dates'
FROM level_details 
GROUP BY 1
HAVING  COUNT(distinct(start_datetime)) > 1;

-- Q5) Find P_ID and level wise sum of kill_counts where kill_count is greater than avg kill count for the Medium difficulty.

SELECT p_id AS 'Player_ID',
level AS 'Level',
SUM(Kill_Count) AS 'Kill_Counts'
FROM level_details
WHERE kill_count > (SELECT AVG(kill_count) FROM level_details WHERE difficulty = 'Medium')
GROUP BY 1,2;
