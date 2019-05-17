-- 1 up
DROP TABLE IF EXISTS songs;
CREATE TABLE songs (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    artist TEXT NOT NULL,
    title TEXT NOT NULL,
    album TEXT,

    markdown TEXT NOT NULL,
    html TEXT NOT NULL,
    date_created TIMESTAMP WITH TIME ZONE NOT NULL,
    date_modified TIMESTAMP WITH TIME ZONE NOT NULL,
    date_released TEXT NOT NULL,
    date_published TIMESTAMP WITH TIME ZONE NULL  -- null = "hide for now"
);

-- For sorting by publication date
CREATE UNIQUE INDEX songs_date_published_idx ON users USING BTREE(date_published);



-- 1 down
DROP TABLE IF EXISTS songs;
