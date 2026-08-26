DROP TABLE IF EXISTS review_helpful_votes;
ALTER TABLE reviews DROP COLUMN IF EXISTS helpful_count;
