-- Not that bad, I'm not sure if there's a better way (with the current logic/table).
-- Could be improved by changing the import and the in-table representation of datas,
-- but this is clearly working, and without much over processing, appart from 9 subqueries :3

-- Sqlite3 was used for this. 

-- Setup the file:
-- $ touch database.db

-- Run the script
-- $ sqlite3 database.db < triangles.sql


-- Setup the database
DROP TABLE IF EXISTS triangles;
CREATE TABLE triangles(side1 smallint, side2 smallint, side3 smallint);

-- Import the data
-- The data.csv contains all sides separated by comma
-- In vim, import the raw data and run:
-- :%s/^\s\+//g
-- :%s/\s\+/,/g
.mode csv
.import data.csv triangles

-- Count all possible triangles
SELECT COUNT(*) FROM triangles
WHERE side1 + side2 > side3
AND   side1 + side3 > side2
AND   side2 + side3 > side1;

-- Count the number of lines from three different queries.
--  Each query build a "row" of the next three rows, taking only the column 1, then 2, then 3.
--  e.g.
--      1 | 2 | 3
--      4 | 5 | 6
--      7 | 8 | 9
--  will output
--      1 | 4 | 7
SELECT COUNT(*) FROM (

  -- Select the side1 from the first row
  SELECT  a.side1                                               AS s1,
  -- Select the side1 from the second row
  (SELECT b.side1 FROM triangles b WHERE b.ROWID = a.ROWID + 1) AS s2,
  -- Select the side1 from the third row
  (SELECT c.side1 FROM triangles c WHERE c.ROWID = a.ROWID + 2) AS s3
  FROM triangles a
  -- Select only 1 over 3 first rows, prevent overlapping results
  WHERE a.ROWID % 3 == 1
  -- Same logic as above
  AND s1 + s2 > s3
  AND s1 + s3 > s2
  AND s2 + s3 > s1 

  UNION ALL

  -- Repeat with side2 ...
  SELECT  a.side2                                               AS s1,
  (SELECT b.side2 FROM triangles b WHERE b.ROWID = a.ROWID + 1) AS s2,
  (SELECT c.side2 FROM triangles c WHERE c.ROWID = a.ROWID + 2) AS s3
  FROM triangles a
  WHERE a.ROWID % 3 == 1
  AND s1 + s2 > s3
  AND s1 + s3 > s2
  AND s2 + s3 > s1 

  UNION ALL

  -- ... and with side3
  SELECT  a.side3                                               AS s1,
  (SELECT b.side3 FROM triangles b WHERE b.ROWID = a.ROWID + 1) AS s2,
  (SELECT c.side3 FROM triangles c WHERE c.ROWID = a.ROWID + 2) AS s3
  FROM triangles a
  WHERE a.ROWID % 3 == 1
  AND s1 + s2 > s3
  AND s1 + s3 > s2
  AND s2 + s3 > s1

);

