-- 1 up

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id SERIAL NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL,
    email TEXT NOT NULL,
    password_hash TEXT NOT NULL, -- BCrypt
    admin BOOLEAN NOT NULL DEFAULT false,

    registered_at TIMESTAMP WITH TIME ZONE NOT NULL,
    confirmed_at TIMESTAMP WITH TIME ZONE,  -- NULL until confirmed
    password_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE UNIQUE INDEX users_name_unique_idx ON users USING BTREE(LOWER("name"));
CREATE UNIQUE INDEX users_email_unique_idx ON users USING BTREE(LOWER(email));

-- Codes for password reset URLs etc.
DROP TABLE IF EXISTS user_keys;
CREATE TABLE user_keys (
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    purpose TEXT NOT NULL,
    key_hash TEXT NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    PRIMARY KEY (user_id, purpose)
);
CREATE UNIQUE INDEX user_keys_user_id_purpose_unique_idx ON user_keys USING BTREE(user_id, purpose);

-- Data for emails we send (password reset for example)
DROP TABLE IF EXISTS emails;
CREATE TABLE emails (
    id SERIAL NOT NULL PRIMARY KEY,
    email_to TEXT NOT NULL,
    template_name TEXT NOT NULL,
    "data" JSON NOT NULL,
    queued_at TIMESTAMP WITH TIME ZONE NOT NULL,
    sent_at TIMESTAMP WITH TIME ZONE -- NULL until actually sent.
);

DROP TABLE IF EXISTS countries;
CREATE TABLE countries (
    id SERIAL NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL,
    emoji TEXT NOT NULL
);
CREATE UNIQUE INDEX countries_name_unique_idx ON countries USING BTREE("name");

DROP TABLE IF EXISTS songs;
CREATE TABLE songs (
    id SERIAL NOT NULL PRIMARY KEY,
    artist TEXT NOT NULL,
    title TEXT NOT NULL,
    album TEXT NOT NULL,
    "image" TEXT NOT NULL,    -- /public/images/160/${image} - size is 160x160
    country_id INTEGER NOT NULL REFERENCES countries(id) ON DELETE RESTRICT,

    summary_markdown TEXT NOT NULL,
    summary_html TEXT NOT NULL,
    full_markdown TEXT NOT NULL,
    full_html TEXT NOT NULL,

    author_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,

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
    id SERIAL NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);
CREATE UNIQUE INDEX tags_name_idx ON tags USING BTREE(name);

DROP TABLE IF EXISTS song_tags;
CREATE TABLE song_tags (
    tag_id  INT NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    song_id INT NOT NULL REFERENCES songs(id) ON DELETE CASCADE,
    PRIMARY KEY (tag_id, song_id)
);

CREATE INDEX song_tags_song_tag_idx ON song_tags USING BTREE(song_id, tag_id);

CREATE TABLE comments (
    id SERIAL NOT NULL PRIMARY KEY,
    song_id INT NOT NULL REFERENCES songs(id) ON DELETE CASCADE,
    author_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    parent_id INT REFERENCES comments(id) ON DELETE CASCADE,
    comment_markdown TEXT NOT NULL,
    comment_html TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    approved_at TIMESTAMP WITH TIME ZONE DEFAULT NULL
);
CREATE INDEX comments_song_id_idx ON comments USING BTREE(song_id);
CREATE INDEX comments_author_id_idx ON comments USING BTREE(author_id);
CREATE INDEX comments_parent_id_idx ON comments USING BTREE(parent_id);

CREATE TABLE links (
    id SERIAL NOT NULL PRIMARY KEY,
    song_id INT NOT NULL REFERENCES songs(id) ON DELETE CASCADE,
    "name" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    description TEXT NOT NULL,
    priority INTEGER NOT NULL DEFAULT 0,
    extras TEXT
);

CREATE INDEX links_song_id_idx ON links USING BTREE(song_id);

CREATE TABLE content (
    "name" TEXT NOT NULL PRIMARY KEY,
    title TEXT NOT NULL,
    markdown TEXT NOT NULL,
    html TEXT NOT NULL,
    author_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Support for cascade on foreign key constraints
CREATE INDEX content_author_id_idx ON content USING BTREE(author_id);

-- 1 down
DROP TABLE IF EXISTS content;
DROP TABLE IF EXISTS links;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS song_tags;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS songs;
DROP TABLE IF EXISTS countries;
DROP TABLE IF EXISTS emails;
DROP TABLE IF EXISTS user_keys;
DROP TABLE IF EXISTS users;
