INSERT INTO content ("name", author_id, title, markdown, html, updated_at) VALUES ('about', 1, 'About page title', 'The about page', '<p>The about page</p>', NOW());

INSERT INTO countries ("name", emoji) VALUES ('UK', '&#x1F1EC;&#x1F1E7;');
INSERT INTO countries ("name", emoji) VALUES ('US', '&#x1F1FA;&#x1F1F8;');
INSERT INTO countries ("name", emoji) VALUES ('CA', '&#x1F1E8;&#x1F1E6;');

INSERT INTO songs (artist,title,album,"image",country_id,summary_markdown,summary_html,full_markdown,full_html,author_id,created_at,updated_at,released_at,published_at) VALUES
('The Dears', 'Lost in the Plot', 'No Cities Left',  'lost-in-the-plot', 3,
'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
Ut enim ad minim veniam.',
'<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p><p>Ut enim ad minim veniam</p>',
'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.

Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.

Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
'<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p><p>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p><p>Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>',
1, NOW(), NULL, '2003', NOW());

INSERT INTO songs (artist,title,album,"image",country_id,summary_markdown,summary_html,full_markdown,full_html,author_id,created_at,updated_at,released_at,published_at) VALUES
('Flowered Up', 'It''s On', 'A Life with Brian, 1991', 'its-on', 1,
'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
Ut enim ad minim veniam. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
'<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p><p>Ut enim ad minim veniam</p><p>Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>',
'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.

Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.

Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
'<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p><p>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p><p>Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>',
1, NOW(), NULL, '1990 (single)', NOW());

INSERT INTO songs (artist,title,album,"image",country_id,summary_markdown,summary_html,full_markdown,full_html,author_id,created_at,updated_at,released_at,published_at) VALUES
('Throwing Muses', 'Fish', 'Lonely Is An Eyesore (various artists)', 'lonely-is-an-eyesore', 2,
'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
Ut enim ad minim veniam.',
'<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p><p>Ut enim ad minim veniam</p>',
'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.

Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.

Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
'<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p><p>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p><p>Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>',
1, NOW(), NULL, 'June 1987', NOW());

INSERT INTO songs (artist,title,album,"image",country_id,summary_markdown,summary_html,full_markdown,full_html,author_id,created_at,updated_at,released_at,published_at) VALUES
('The Heart Throbs', 'Tiny Feet', 'Jubilee Twist', 'jubilee-twist', 1,
'Nulla porttitor massa id neque aliquam vestibulum morbi. Curabitur vitae nunc sed velit.',
'<p>Nulla porttitor massa id neque aliquam vestibulum morbi. Curabitur vitae nunc sed velit.</p>',
'Nulla porttitor massa id neque aliquam vestibulum morbi. Curabitur vitae nunc sed velit. Sit amet nisl suscipit adipiscing bibendum est ultricies. Eu scelerisque felis imperdiet proin fermentum leo vel. Adipiscing tristique risus nec feugiat in fermentum posuere urna nec. Aliquet risus feugiat in ante. Purus sit amet luctus venenatis. Tincidunt nunc pulvinar sapien et ligula ullamcorper malesuada proin. Phasellus egestas tellus rutrum tellus pellentesque. Sed pulvinar proin gravida hendrerit lectus a. Libero justo laoreet sit amet cursus sit amet dictum sit. Condimentum id venenatis a condimentum vitae sapien pellentesque.

Arcu vitae elementum curabitur vitae nunc sed velit dignissim. Ultrices sagittis orci a scelerisque purus. Ipsum dolor sit amet consectetur. Nibh mauris cursus mattis molestie. Diam vel quam elementum pulvinar etiam non quam lacus. Quam adipiscing vitae proin sagittis nisl. Turpis cursus in hac habitasse platea dictumst quisque sagittis purus. Tristique et egestas quis ipsum suspendisse ultrices gravida dictum. Et tortor at risus viverra adipiscing at in. Mauris a diam maecenas sed enim ut sem. Amet volutpat consequat mauris nunc. Ultricies leo integer malesuada nunc vel risus commodo. Ultricies tristique nulla aliquet enim tortor at auctor urna nunc. Vel risus commodo viverra maecenas accumsan lacus vel facilisis volutpat. Eu turpis egestas pretium aenean pharetra magna ac.',
'<p>Nulla porttitor massa id neque aliquam vestibulum morbi. Curabitur vitae nunc sed velit. Sit amet nisl suscipit adipiscing bibendum est ultricies. Eu scelerisque felis imperdiet proin fermentum leo vel. Adipiscing tristique risus nec feugiat in fermentum posuere urna nec. Aliquet risus feugiat in ante. Purus sit amet luctus venenatis. Tincidunt nunc pulvinar sapien et ligula ullamcorper malesuada proin. Phasellus egestas tellus rutrum tellus pellentesque. Sed pulvinar proin gravida hendrerit lectus a. Libero justo laoreet sit amet cursus sit amet dictum sit. Condimentum id venenatis a condimentum vitae sapien pellentesque.</p><p>Arcu vitae elementum curabitur vitae nunc sed velit dignissim. Ultrices sagittis orci a scelerisque purus. Ipsum dolor sit amet consectetur. Nibh mauris cursus mattis molestie. Diam vel quam elementum pulvinar etiam non quam lacus. Quam adipiscing vitae proin sagittis nisl. Turpis cursus in hac habitasse platea dictumst quisque sagittis purus. Tristique et egestas quis ipsum suspendisse ultrices gravida dictum. Et tortor at risus viverra adipiscing at in. Mauris a diam maecenas sed enim ut sem. Amet volutpat consequat mauris nunc. Ultricies leo integer malesuada nunc vel risus commodo. Ultricies tristique nulla aliquet enim tortor at auctor urna nunc. Vel risus commodo viverra maecenas accumsan lacus vel facilisis volutpat. Eu turpis egestas pretium aenean pharetra magna ac.</p>',
1, NOW(), NULL, 'Summer 1992', NOW());

INSERT INTO songs (artist,title,album,"image",country_id,summary_markdown,summary_html,full_markdown,full_html,author_id,created_at,updated_at,released_at,published_at) VALUES
('Pixies', 'Planet of Sound', 'Trompe le Monde', 'planet-of-sound', 2,
'I met this guy in a rover',
'<p>I met this guy in a rover</p>',
'I met this guy in a rover. He said it''s one more over',
'<p>I met this guy in a rover. He said it''s one more over</p>',
1, NOW(), NULL, '28th May 1991 (single), 23rd September 1991 (LP)', NOW());

INSERT INTO songs (artist,title,album,"image",country_id,summary_markdown,summary_html,full_markdown,full_html,author_id,created_at,updated_at,released_at,published_at) VALUES
('This Mortal Coil', 'Song to the Siren', 'It''ll End in Tears', 'song-to-the-siren', 1,
'I met this guy in a rover...',
'<p>I met this guy in a rover...</p>',
'I met this guy in a rover. He said it''s one song over',
'<p>I met this guy in a rover. He said it''s one song over</p>',
1, NOW(), NULL, 'September 1983 (single), October 1984 (LP)', NOW());

INSERT INTO tags (name) VALUES ('1990s');                    -- 1
INSERT INTO tags (name) VALUES ('1980s');                    -- 2
INSERT INTO tags (name) VALUES ('Indie');                    -- 3
INSERT INTO tags (name) VALUES ('Guitar');                   -- 4
INSERT INTO tags (name) VALUES ('Keys');                     -- 5
INSERT INTO tags (name) VALUES ('Male vox');                 -- 6
INSERT INTO tags (name) VALUES ('Female vox');               -- 7
INSERT INTO tags (name) VALUES ('Band');                     -- 8
INSERT INTO tags (name) VALUES ('British');                  -- 9
INSERT INTO tags (name) VALUES ('American');                 -- 10
INSERT INTO tags (name) VALUES ('4AD');                      -- 11
INSERT INTO tags (name) VALUES ('Kristin Hersh');            -- 12
INSERT INTO tags (name) VALUES ('Tanya Donelly');            -- 13
INSERT INTO tags (name) VALUES ('One Little Indian');        -- 14
INSERT INTO tags (name) VALUES ('Instrumental');             -- 15
INSERT INTO tags (name) VALUES ('Mostly-instrumental');      -- 16
INSERT INTO tags (name) VALUES ('Sample-based');             -- 17
INSERT INTO tags (name) VALUES ('Solo artist');              -- 18
INSERT INTO tags (name) VALUES ('DJ');                       -- 19
INSERT INTO tags (name) VALUES ('Producer');                 -- 20
INSERT INTO tags (name) VALUES ('Elektra');                  -- 21

INSERT INTO song_tags (song_id, tag_id) VALUES (1, 2);
INSERT INTO song_tags (song_id, tag_id) VALUES (1, 3);
INSERT INTO song_tags (song_id, tag_id) VALUES (1, 4);
INSERT INTO song_tags (song_id, tag_id) VALUES (1, 7);
INSERT INTO song_tags (song_id, tag_id) VALUES (1, 8);
INSERT INTO song_tags (song_id, tag_id) VALUES (1, 10);
INSERT INTO song_tags (song_id, tag_id) VALUES (1, 11);
INSERT INTO song_tags (song_id, tag_id) VALUES (1, 12);
INSERT INTO song_tags (song_id, tag_id) VALUES (1, 13);

INSERT INTO song_tags (song_id, tag_id) VALUES (2, 1);
INSERT INTO song_tags (song_id, tag_id) VALUES (2, 3);
INSERT INTO song_tags (song_id, tag_id) VALUES (2, 4);
INSERT INTO song_tags (song_id, tag_id) VALUES (2, 5);
INSERT INTO song_tags (song_id, tag_id) VALUES (2, 7);
INSERT INTO song_tags (song_id, tag_id) VALUES (2, 8);
INSERT INTO song_tags (song_id, tag_id) VALUES (2, 9);
INSERT INTO song_tags (song_id, tag_id) VALUES (2, 14);

INSERT INTO song_tags (song_id, tag_id) VALUES (3, 1);
INSERT INTO song_tags (song_id, tag_id) VALUES (3, 3);
INSERT INTO song_tags (song_id, tag_id) VALUES (3, 4);
INSERT INTO song_tags (song_id, tag_id) VALUES (3, 6);
INSERT INTO song_tags (song_id, tag_id) VALUES (3, 10);
INSERT INTO song_tags (song_id, tag_id) VALUES (3, 11);

-- A non-admin user. The admin user (1) should be created outside this file
INSERT INTO users ("name",email,password_hash,"admin",registered_at,confirmed_at,password_at) 
VALUES
('hoagy', 'hoagy@ytfc.com', '$2a$13$DxMrrkG0.HdQ9L8itYNW9udfr0OBWiDqm0Fb76.PbMra7/qqTvbiO', false, NOW(), NOW(), NOW()),
('jelie', 'jelie@ytfc.com', '$2a$13$DxMrrkG0.HdQ9L8itYNW9udfr0OBWiDqm0Fb76.PbMra7/qqTvbiO', false, NOW(), NOW(), NOW());


INSERT INTO comments (song_id, author_id, parent_id, comment_bbcode, comment_html, created_at, approved_at)
VALUES
(1, 2, NULL, 'Best band ever', '<p>Best band ever</p>', NOW(), NOW()),
(1, 3, 1, 'Yeah. Best. Band. [i]Ever[/i]', '<p>Yeah. Best. Band. <i>Ever</i></p>', NOW(), NOW());

INSERT INTO comments (song_id, author_id, parent_id, comment_bbcode, comment_html, created_at, approved_at)
VALUES
(2, 2, NULL, 'Best British band ever', '<p>Best British band ever</p>', NOW(), NOW()),
(2, 3,    3, 'Apart from New Order', '<p>Apart from New Order</p>', NOW(), NULL),
(2, 2, NULL, '2nd thread c5', '<p>2nd thread c5</p>', NOW(), NOW()),
(2, 1, NULL, '3rd thread c6', '<p>3rd thread c6</p>', NOW(), NOW()),
(2, 2,    5, 'reply to c5 = c7', '<p>reply to c5 = c7</p>', NOW(), NOW());

INSERT INTO links (song_id, identifier, "class", "url", description, extras, priority)
VALUES
(6, 'official_youtube', 'YouTube', 'https://www.youtube-nocookie.com/embed/HFWKJ2FUiAQ', 'Official video', '16by9', 10);
