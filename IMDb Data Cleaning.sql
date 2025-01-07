-- Project Objective: Transform dirty data into clean data for further analysis
/* Such data cleaning involves resolving duplicate entries, 
addressing missing data, 
and correcting inconsistencies within the dataset */

SET SQL_SAFE_UPDATES = 0;

SELECT column_name, data_type
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'imdb_data';

-- check for duplicate data in title
SELECT title, COUNT(*) duplicate
FROM imdb_data
GROUP BY title
HAVING COUNT(*) > 1; 
-- no duplicate found

-- check distinct content_rating column
SELECT DISTINCT content_rating
FROM imdb_data;

-- replace NOT RATED and ' ' as UNRATED
-- replace APPROVED as G
SELECT DISTINCT content_rating, 
	CASE WHEN content_rating = 'NOT RATED' OR content_rating = '' THEN 'UNRATED'
    WHEN content_rating = 'APPROVED' THEN 'G'
    ELSE content_rating 
    END AS cleaned_content_rating
FROM imdb_data;

ALTER TABLE imdb_data
ADD cleaned_content_rating TEXT;

UPDATE imdb_data
SET cleaned_content_rating = CASE 
								WHEN content_rating = 'NOT RATED' OR content_rating = '' THEN 'UNRATED'
                                WHEN content_rating = 'APPROVED' THEN 'G'
                                ELSE content_rating 
                                END;

-- confirm changes
SELECT DISTINCT cleaned_content_rating
FROM imdb_data;

-- check distinct genre column
SELECT DISTINCT genre
FROM imdb_data;
-- no missing or misspelled genre is found

-- check distinct duration column
SELECT DISTINCT duration
FROM imdb_data
WHERE duration < 0 OR duration IS NULL OR duration = '';
-- no missing or invalid duration is found

-- clean actors_list column
SELECT REGEXP_REPLACE(actors_list, '\\[|\\]|u\'|\'', '') AS cleaned_actors_list
FROM imdb_data;

ALTER TABLE imdb_data
ADD cleaned_actors_list TEXT;

UPDATE imdb_data
SET cleaned_actors_list = REGEXP_REPLACE(actors_list, '\\[|\\]|u\'|\'', '');

-- confirm changes
SELECT DISTINCT cleaned_actors_list
FROM imdb_data;

-- cleaned imdb_data
SELECT * 
FROM imdb_data;
