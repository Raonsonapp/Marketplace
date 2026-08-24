-- Deliberately a no-op. By the time anyone runs this database's downward
-- migrations, real orders/reviews/carts may already reference these seed
-- rows (products, stores, categories) via foreign keys — deleting them
-- here could cascade into real user data. This project's own standing
-- rule (see docs/SMS_PROVIDERS.md-adjacent history) is to never run
-- schema- or data-destroying SQL against the shared Supabase project
-- without it being deliberate and reviewed, not an automatic side effect
-- of a rollback.
SELECT 1;
