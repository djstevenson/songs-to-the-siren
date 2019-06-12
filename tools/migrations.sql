-- 1 up

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL,
    email TEXT NOT NULL,
    password_hash TEXT NOT NULL, -- BCrypt
    admin BOOLEAN NOT NULL DEFAULT false,

    registered_at TIMESTAMP WITH TIME ZONE NOT NULL,
    confirmed_at TIMESTAMP WITH TIME ZONE,  -- NULL until confirmed
    password_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE UNIQUE INDEX users_name_unique_idx ON users USING BTREE(LOWER(name));
CREATE UNIQUE INDEX users_email_unique_idx ON users USING BTREE(LOWER(email));

-- Codes for password reset URLs etc.
DROP TABLE IF EXISTS user_keys;
CREATE TABLE user_keys (
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    purpose TEXT NOT NULL,
    key_hash TEXT NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    PRIMARY KEY (user_id, purpose)
);

-- Data for emails we send (password reset for example)
DROP TABLE IF EXISTS emails;
CREATE TABLE emails (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    email_from TEXT NOT NULL,
    email_to TEXT NOT NULL,
    template_name TEXT NOT NULL,
    "data" JSON NOT NULL,
    queued_at TIMESTAMP WITH TIME ZONE NOT NULL,
    sent_at TIMESTAMP WITH TIME ZONE -- NULL until actually sent.
);

DROP TABLE IF EXISTS songs;
CREATE TABLE songs (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    artist TEXT NOT NULL,
    title TEXT NOT NULL,
    album TEXT,
    country TEXt NOT NULL,

    summary_markdown TEXT NOT NULL,
    summary_html TEXT NOT NULL,
    full_markdown TEXT NOT NULL,
    full_html TEXT NOT NULL,

    author_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,

    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE,
    released_at TEXT NOT NULL,

     -- null = "not published, so don't show it"
    published_at TIMESTAMP WITH TIME ZONE
);

-- For sorting by publication date
CREATE INDEX songs_published_at_idx ON songs USING BTREE(published_at);

-- Support for cascade on foreign key constraints
CREATE INDEX songs_author_id_idx ON songs USING BTREE(author_id);

DROP TABLE IF EXISTS tags;
CREATE TABLE tags (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);
CREATE UNIQUE INDEX tags_name_idx ON tags USING BTREE(name);

DROP TABLE IF EXISTS song_tags;
CREATE TABLE song_tags (
    tag_id  BIGINT NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    song_id BIGINT NOT NULL REFERENCES songs(id) ON DELETE CASCADE,
    PRIMARY KEY (tag_id, song_id)
);

CREATE INDEX song_tags_song_tag_idx ON song_tags USING BTREE(song_id, tag_id);

CREATE TABLE comments (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    song_id BIGINT NOT NULL REFERENCES songs(id) ON DELETE CASCADE,
    author_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    parent_id BIGINT REFERENCES comments(id) ON DELETE CASCADE,
    comment_markdown TEXT NOT NULL,
    comment_html TEXT NOT NULL,
    created_at  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    approved_at  TIMESTAMP WITH TIME ZONE DEFAULT NULL
);
CREATE INDEX comments_song_id_idx ON comments USING BTREE(song_id);
CREATE INDEX comments_author_id_idx ON comments USING BTREE(author_id);
CREATE INDEX comments_parent_id_idx ON comments USING BTREE(parent_id);

-- 1 down
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS song_tags;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS songs;
DROP TABLE IF EXISTS emails;
DROP TABLE IF EXISTS user_keys;
DROP TABLE IF EXISTS users;
