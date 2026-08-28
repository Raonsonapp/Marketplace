-- The country columns default to 'TJ', so dropping them loses only the
-- distinction between a Tajik and a Russian row; the reference tables go
-- with them.
DROP INDEX IF EXISTS idx_stores_country;
ALTER TABLE users     DROP COLUMN IF EXISTS country;
ALTER TABLE stores    DROP COLUMN IF EXISTS country;
ALTER TABLE addresses DROP COLUMN IF EXISTS country;
DROP TABLE IF EXISTS cities;
DROP TABLE IF EXISTS countries;
