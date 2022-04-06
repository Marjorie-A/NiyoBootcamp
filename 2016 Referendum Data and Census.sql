-- 2016 EU REFERENDUM IN THE UK & 2011 UK CENSUS
-- PEOPLE IN THE UK VOTED ON WHETHER TO REMAIN OR LEAVE THE EU 


-- RETRIEVE 2016 EU REFERENDUM DATA IN THE UK
SELECT * FROM Referendum_UK.referendum;


-- FIND HOW MANY AREAS VOTED, THE TOTAL NUMBER OF ELECTORATES, THE TOTAL VALID VOTE, THE TOTAL LEAVE AND REMAIN VOTES
-- ALSO FIND THE AVERAGE TURNOUT, LEAVE AND REMAIN %
SELECT COUNT(Area) AS 'Total Number of Areas',
SUM(Electorate) AS 'Total Electorate)',
SUM(`Valid Votes`) AS 'Total Valid Votes',
SUM(`Leave`) AS 'Total Leave Votes',
SUM(`Remain`) AS 'Total Remain Votes',
ROUND(AVG(`Percent Turnout`),1)  AS 'Avg % Turnout',
ROUND(AVG(`Percent Leave`),1)  AS 'Avg % Leave', 
ROUND(AVG(`Percent Remain`),1)  AS 'Avg % Remain'
FROM Referendum_UK.referendum;
-- Total sum of electorate is 46,500,001.
-- The total number of areas featured in this Referendum is 382.
-- The total valid votes was 33,551,983.
-- The total leave vote was 17,410,742 vs remain 16,141,241.
-- The Leave vote was greater than the remain vote.
-- On average 73.8% of voters turnout vs what was expected (electorate).
-- With this information we know that the electorates voted that the UK should leave the EU.
-- With 53% of people voting to leave and 47% of people voting to remain in the EU


-- FOR AREAS THAT VOTED TO LEAVE FIND AVERAGE VALID VOTES, TURNOUT %, REJECTED VOTES %
-- ALSO AVERAGE LEAVE % AND AVERAGE REMAIN % 
SELECT ROUND(AVG(`Valid Votes`),0) AS 'Average Valid Votes',
ROUND(AVG(`Percent Turnout`),1)  AS 'Avg % Turnout',
ROUND(AVG(`Percent Rejected`),2)  AS 'Avg % Votes Rejected',
ROUND(AVG(`Percent Leave`),1)  AS 'Avg % Leave', 
ROUND(AVG(`Percent Remain`),1)  AS 'Avg % Remain'
FROM Referendum_UK.referendum
WHERE `Percent Leave` > `Percent Remain`;
-- In the areas that voted a majority leave, the average valid vote per area was 81,552.
-- The average % of voters that turned out was 74.2%.
-- In the leave areas, the voting ratio of leave to remain was 6:4.


-- FIND AREAS THAT VOTED TO LEAVE
SELECT AREA, `Valid Votes`, `Percent Turnout`, `Percent Leave`, `Percent Remain` 
FROM Referendum_UK.referendum
WHERE `Percent Leave` > `Percent Remain`;
-- 263 areas were reported to have a higher % of leave voters than remain.
-- 69% of the overall area's that voted, skued towards leaving.
-- Whereas only 31% of the areas voted to remain.
-- These are areas where the leave voters won a majority.
-- In the areas that voted leave Birmingham, Cornwall and Wiltshire had the top 3 valid votes.


-- FOR AREAS THAT VOTED TO REMAIN
-- FIND AVERAGE VALID VOTES, TURNOUT %, REJECTED VOTES %
-- ALSO AVERAGE LEAVE % AND AVERAGE REMAIN % 
SELECT ROUND(AVG(`Valid Votes`),0) AS 'Average Valid Votes',
ROUND(AVG(`Percent Turnout`),1)  AS 'Avg % Turnout',
ROUND(AVG(`Percent Rejected`),2)  AS 'Avg % Votes Rejected',
ROUND(AVG(`Percent Remain`),1)  AS 'Avg % Remain',
ROUND(AVG(`Percent Leave`),1)  AS 'Avg % Leave'
FROM Referendum_UK.referendum
WHERE `Percent Remain` > `Percent Leave`;
-- The average valid votes in the areas that voted remain was 101712.
-- The average valid vote in areas in which remain won is 25% than in areas that leave won.
-- The average % of voters that turnout was 74.2%.
-- The average turnout % in the areas that remain won is 72.7%, which is lower than the areas that voted remain (74.2%).
-- On average in the remain areas, there was a remain to leave vote ratio of 6:4.
-- This is a very similar voting ratio in areas that wanted to leave of 6:4 also.
 
 
-- IN TERMS OF THE AREAS THAT VOTED LEAVE
-- FIND THE AREAS IN EACH REGION, AVERAGE PERCENT TURNOUT
-- THE TOTAL VALID VOTES AND THEIR AVERAGE % REMAIN VS AVERAGE % LEAVE
-- THIS SHOULD BE GROUPED BY REGION
SELECT Region,
COUNT(AREA) AS 'Total Number of Areas',
SUM(`Valid Votes`) AS 'Total Valid Votes', 
ROUND(AVG(`Percent Turnout`),1) AS 'Average % Turnout', 
ROUND(AVG(`Percent Leave`),1) AS 'Average % Leave',
ROUND(AVG(`Percent Remain`),1) AS 'Average % Remain'
FROM Referendum_UK.referendum
WHERE `Percent Leave` > `Percent Remain`
GROUP BY Region;
-- South East had the highest number of areas in which leave won a majority at 43, followed by East at 42.
-- Those 2 regions had the highest number of valid votes at 3,127,052 followed by 2,947,512 respectively.


-- BY AREA, FIND AREAS THAT HAD EITHER A REMAIN MAJORITY, LEAVE MAJORITY AND CLOSELY CONTESTED
-- CRITERIA FOR REMAIN MAJORITY IS WHEN PERCENT REMAIN IS GREATER THAN PERCENT LEAVE BY 10%
-- CRITERIA FOR REMAIN MAJORITY IS WHEN PERCENT REMAIN IS LESS THAN PERCENT LEAVE BY 10%
-- EVERYTHING ELSE CAN BE CLASSED AS CLOSELY CONTESTED
SELECT Area,
Region,
`Valid Votes`, 
`Percent Turnout`, 
`Percent Remain`,
`Percent Leave`,
ROUND(`Percent Remain` - `Percent Leave`, 1) AS Margin,
CASE 
WHEN `Percent Remain` - `Percent Leave` > 10 THEN 'Remain Majority'
WHEN `Percent Remain` - `Percent Leave` < -10 THEN 'Leave Majority'
ELSE 'Closely Contested'
END AS 'Status'
FROM Referendum_UK.referendum;
-- This query uncovers how voting differs across areas.
-- Looking at the top 3 areas with the highest valid votes, Northern Ireland, Birmingham & Leeds.
-- The % Turnout Rate in these areas were below the average rate of 73.8%
-- Northern Ireland voted Remain Majority, with Birmingham voting to Leave but closely contested and Leeds voting to Remain but also closely contested.


-- BASED ON THE CRITERIA OF THE PREVIOUS QUERY FIND THE STATUS OF REGIONS
-- THAT ARE SKUED TOWARDS LEAVE MAJORITY, REMAIN MAJORITY OR CLOSELY CONTESTED
SELECT Region, Count(Area) AS 'Total Number of Areas',
ROUND(AVG(`Valid Votes`),0) AS 'Average Valid Votes', 
ROUND(AVG(`Percent Turnout`),1) AS 'Average % Turnout', 
ROUND(AVG(`Percent Remain`),1) AS 'Average % Remain',
ROUND(AVG(`Percent Leave`),1) AS 'Average % Leave',
ROUND(AVG(`Percent Remain`) - AVG(`Percent Leave`), 1) AS Margin,
CASE 
WHEN AVG(`Percent Remain`) - AVG(`Percent Leave`) > 10 THEN 'Remain Majority'
WHEN AVG(`Percent Remain`) - AVG(`Percent Leave`) < -10 THEN 'Leave Majority'
ELSE 'Closely Contested'
END AS 'Status'
FROM Referendum_UK.referendum
-- WHERE `Percent Remain` > `Percent Leave`
GROUP BY Region
ORDER BY Region;
-- We can see that out of the 12 regions, we have over 50% of them voting leave majority.
-- We have 3 voting to remain majority.
-- We then have 3 closely contested regions, which voted to Leave. 




-- LOOKING AT VOTING PREFERENCE BY AGE USING THE 2011 CENSUS DATA
-- THE CENSUS DATA IS FROM 2011 SO THERE WILL BE SOME LIMITS IN THE DATA IN REGARDS TO THE 2016 EU REFERENDUM
-- ALSO IT WILL NOT TAKE INTO ACCOUNT BIRTH/ DEATH OR THOSE THAT MOVED AREAS WITHIN THOSE 5 YEARS THAT PASSED
-- WITH THAT BEING SAID I HAVE ADJUSTED THE DATA ACCORDINGLY AND SHIFTED THE AGE BY 5 YEARS
-- AS THE REFERENDUM TOOK PLACE IN 2016 BUT THE CENSUS DATA IS FROM 2011 I ADJUSTED THE AGE RANGE TO TAKE THAT INTO CONSIDERATION
-- ALSO THERE WAS AN AGE GROUP OF 15 - 19, IN THE UK YOU CAN VOTE FROM 18 BUT AS WE COULD NOT BREAK THIS DOWN, SO I REMOVED THAT AGE RANGE FROM THE ADJUSTED CENSUS TABLE
-- THERE ARE STILL SOME LIMITS TO THE CENSUS DATA IT HAD 5 AREAS MISSING FROM THE REFERENDUM KING'S LYNN AND WEST NORFOLK, GIBRALTAR, ISLE OF ANGLESEY, VALE OF GLAMORGAN & RHONDDA CYNON TAF
-- THE ORIGINAL CENSUS FILE IS UPLOADED AS CENSUS AND THE ADJUSTED AS ADJUSTED CENSUS, I WILL BE LOOKING AT THE ADJUSTED CENSUS FOR DATA


-- RETRIEVE ADJUSTED CENSUS FOR THE UK
SELECT * FROM Referendum_UK.adjustedcensus;

-- ACCORDING TO PEWRESEARCH.ORG MILLENNIALS ARE CLASSED AS BEING BORN BETWEEN 1981 AND 1996.
-- WITH THAT BEING SAID THE OLDEST MILLENNIAL WOULD BE 35 YEARS AT THE TIME OF THE EU REFERENDUM IN THE UK AND THE YOUNGEST WOULD HAVE BEEN 20.
-- FIND THE PERCENTAGE OF 20 - 35 (MILLENNIALS) IN THE ELECTORATE AREAS TO UNDERCOVER HOW MILLENNIALS VOTED.
SELECT ref.Area,
CASE 
WHEN ref.`Percent Remain` - ref.`Percent Leave` > 10 THEN 'Remain Majority'
WHEN ref.`Percent Remain` - ref.`Percent Leave` < -10 THEN 'Leave Majority'
ELSE 'Closely Contested'
END AS 'Status',
ROUND(100 * (ac.`Age 20 to 24` + ac.`Age 25 to 29` + ac.`Age 30 to 34`) / (ac.`Age 20 to 24` + ac.`Age 25 to 29` + ac.`Age 30 to 34` +  ac.`Age 40 to 44` + ac.`Age 45 to 49` + ac.`Age 50 to 54` + ac.`Age 55 to 59` + ac.`Age 60 to 64` + ac.`Age 65 to 69` + ac.`Age 70 to 74` + ac.`Age 75 to 79` + ac.`Age 80 to 84` + ac.`Age 85 to 89`), 1) AS `% of Under 35s`,
ROUND(ref.`Valid Votes`,0) AS 'Average Valid Votes', 
ROUND(ref.`Percent Turnout`,1) AS 'Average % Turnout', 
ROUND(ref.`Percent Remain`,1) AS 'Average % Remain',
ROUND(ref.`Percent Leave`,1) AS 'Average % Leave',
ROUND(ref.`Percent Remain` - ref.`Percent Leave`, 1) AS Margin
FROM
     Referendum_UK.referendum ref INNER JOIN Referendum_UK.adjustedcensus ac
    ON ref.Area = ac.Area;
-- In the top 5 areas with the highest % of under 35's, remain votes won in all 5, 4 of the 5 areas had remain win a majority while 1 was closely contested.

