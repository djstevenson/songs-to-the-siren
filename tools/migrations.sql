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
    "image" TEXT NOT NULL,
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
    comment_bbcode TEXT NOT NULL,
    comment_html TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    approved_at TIMESTAMP WITH TIME ZONE DEFAULT NULL
);
CREATE INDEX comments_song_id_idx ON comments USING BTREE(song_id);
CREATE INDEX comments_author_id_idx ON comments USING BTREE(author_id);
CREATE INDEX comments_parent_id_idx ON comments USING BTREE(parent_id);


-- Priority determines the order the links appear in the list
-- at the end of a song article.  In ascending priority.
-- 0 = don't put link in the list.
CREATE TABLE links (
    id SERIAL NOT NULL PRIMARY KEY,
    song_id INT NOT NULL REFERENCES songs(id) ON DELETE CASCADE,
    identifier TEXT NOT NULL,
    "class" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    description TEXT NOT NULL,
    priority INTEGER NOT NULL DEFAULT 0,
    extras TEXT
);

CREATE UNIQUE INDEX links_song_id_identifier_idx ON links USING BTREE(song_id, identifier);

CREATE TABLE content (
    "name" TEXT NOT NULL PRIMARY KEY,
    title TEXT NOT NULL,
    markdown TEXT NOT NULL,
    html TEXT NOT NULL,
    author_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE INDEX content_author_id_idx ON content USING BTREE(author_id);

CREATE TABLE comment_edits (
    id SERIAL NOT NULL PRIMARY KEY,
    comment_id INT NOT NULL REFERENCES comments(id) ON DELETE CASCADE,
    reason TEXT NOT NULL,
    editor_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    edited_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);
CREATE INDEX comment_edits_comment_id_idx ON comment_edits USING BTREE(comment_id);


-- 1 down
DROP TABLE IF EXISTS comment_edits;
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


-- 2 up Add title/text fields to links
ALTER TABLE links ADD COLUMN title TEXT NOT NULL DEFAULT '';
ALTER TABLE links ADD COLUMN link_text TEXT NOT NULL DEFAULT 'link text here';

-- 2 down
ALTER TABLE links DROP COLUMN title;
ALTER TABLE links DROP COLUMN link_text;

-- 3 up Add css class name to links
ALTER TABLE links ADD COLUMN css TEXT NOT NULL DEFAULT 'default';

-- 3 down
ALTER TABLE links DROP COLUMN css;

-- 4 up Drop link_text, we're using "Description" for that
ALTER TABLE links DROP COLUMN IF EXISTS link_text;

-- 4 down
ALTER TABLE links ADD COLUMN link_text TEXT NOT NULL DEFAULT 'link text here';

-- Repeat the '4' migration cos I originally messed it up in production
-- (I had '4 up' twice, instead of a '4 up' and a '4 down').

-- 5 up
ALTER TABLE links DROP COLUMN IF EXISTS link_text;

-- 5 down
ALTER TABLE links DROP COLUMN IF EXISTS link_text;
ALTER TABLE links ADD COLUMN link_text TEXT NOT NULL DEFAULT 'link text here';

-- 6 up Default = 1x thru 4x
ALTER TABLE songs ADD COLUMN max_resolution INTEGER NOT NULL DEFAULT 4;

-- 6 down
ALTER TABLE songs DROP COLUMN IF EXISTS max_resolution;

-- 7 up Change countries to a text field
ALTER TABLE songs ADD COLUMN country TEXT NOT NULL DEFAULT '';
UPDATE songs SET country='🇬🇧' where country_id=1;
UPDATE songs SET country='🇺🇸' where country_id=2;
UPDATE songs SET country='🇨🇦' where country_id=3;
UPDATE songs SET country='🇬🇧 🇺🇸' where country_id=4;
UPDATE songs SET country='🇸🇪' where country_id=5;
UPDATE songs SET country='🇦🇺' where country_id=6;
UPDATE songs SET country='🇯🇲' where country_id=7;
UPDATE songs SET country='🇮🇪' where country_id=8;
UPDATE songs SET country='🇧🇪' where country_id=9;
UPDATE songs SET country='🇫🇷' where country_id=10;
UPDATE songs SET country='🇩🇪' where country_id=11;
UPDATE songs SET country='🇮🇸' where country_id=12;
ALTER TABLE songs DROP COLUMN country_id;
DROP TABLE IF EXISTS countries;

-- 7 down
DROP TABLE IF EXISTS countries;
CREATE TABLE countries (
    id SERIAL NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL,
    emoji TEXT NOT NULL
);
CREATE UNIQUE INDEX countries_name_unique_idx ON countries USING BTREE("name");
INSERT INTO countries (name, emoji) VALUES
('UK',    '🇬🇧'),
('US',    '🇺🇸'),
('CA',    '🇨🇦'),
('UK/US', '🇬🇧 🇺🇸'),
('SE',    '🇸🇪'),
('AU',    '🇦🇺'),
('JM',    '🇯🇲'),
('IE',    '🇮🇪'),
('BE',    '🇧🇪'),
('FR',    '🇫🇷'),
('DE',    '🇩🇪'),
('IS',    '🇮🇸');
ALTER TABLE songs ADD COLUMN country_id INTEGER NOT NULL DEFAULT 1 REFERENCES countries(id) ON DELETE RESTRICT;
ALTER TABLE songs DROP COLUMN country;

-- 8 up Links table refactor
DROP TABLE IF EXISTS countries;  -- originally missed this from the '7' migration
ALTER TABLE links RENAME COLUMN identifier TO embed_identifier;
ALTER TABLE links RENAME COLUMN class TO embed_class;
ALTER TABLE links ADD COLUMN embed_url TEXT NOT NULL DEFAULT '';
ALTER TABLE links ADD COLUMN embed_description TEXT NOT NULL DEFAULT '';
ALTER TABLE links RENAME COLUMN "priority" TO list_priority;
ALTER TABLE links ADD COLUMN list_url TEXT NOT NULL DEFAULT '';
ALTER TABLE links ADD COLUMN list_description TEXT NOT NULL DEFAULT '';
ALTER TABLE links RENAME COLUMN css TO list_css;

UPDATE links SET embed_url = url, embed_description = description WHERE list_priority = 0;
UPDATE links SET list_url = url, list_description = description WHERE list_priority <> 0;
ALTER TABLE links DROP COLUMN "url";
ALTER TABLE links DROP COLUMN title;
ALTER TABLE links DROP COLUMN extras;
ALTER TABLE links DROP COLUMN description;

-- Recreate index without unique constraint
DROP INDEX IF EXISTS links_song_id_identifier_idx;
CREATE INDEX links_song_id_identifier_idx ON links USING BTREE(song_id, embed_identifier);

-- 8 down
DROP INDEX IF EXISTS links_song_id_identifier_idx;
CREATE UNIQUE INDEX links_song_id_identifier_idx ON links USING BTREE(song_id, embed_identifier);

ALTER TABLE links ADD COLUMN description TEXT DEFAULT '';
ALTER TABLE links ADD COLUMN "extras" TEXT DEFAULT NULL;
ALTER TABLE links ADD COLUMN "title" TEXT NOT NULL DEFAULT '';
ALTER TABLE links ADD COLUMN "url" TEXT NOT NULL DEFAULT '';

UPDATE links SET url = embed_url, description = embed_description WHERE list_priority = 0;
UPDATE links SET url = list_url, description = list_description WHERE list_priority <> 0;

ALTER TABLE links RENAME COLUMN list_css TO css;
ALTER TABLE links DROP COLUMN list_description;
ALTER TABLE links DROP COLUMN list_url;
ALTER TABLE links RENAME COLUMN list_priority TO "priority";
ALTER TABLE links DROP COLUMN embed_description;
ALTER TABLE links DROP COLUMN embed_url;
ALTER TABLE links RENAME COLUMN embed_class TO class;
ALTER TABLE links RENAME COLUMN embed_identifier TO identifier;

-- 9 up : list_css is default NULL
ALTER TABLE links ALTER COLUMN list_css DROP NOT NULL;
UPDATE links SET list_css = 'songs-to-the-siren' WHERE list_css = 'default';

-- 9 down : list_css is default 'null'
UPDATE links SET list_css = 'default' WHERE list_css = 'songs-to-the-siren';
ALTER TABLE links ALTER COLUMN list_css SET NOT NULL;

