-- Review "helpful" votes (the like affordance): a denormalized counter on
-- reviews plus a per-user vote table so a user can toggle their own vote and
-- can't inflate the count by voting twice.
ALTER TABLE reviews ADD COLUMN IF NOT EXISTS helpful_count integer NOT NULL DEFAULT 0;

CREATE TABLE IF NOT EXISTS review_helpful_votes (
    review_id  uuid NOT NULL REFERENCES reviews(id) ON DELETE CASCADE,
    user_id    uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (review_id, user_id)
);
