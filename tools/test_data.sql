INSERT INTO users ("name", email, password_hash, "admin", registered_at, confirmed_at, password_at) 
    VALUES ('admin', 'admin@ytfc.com', '$2a$13$PlRNo4VJA0TziKUpct2qfeQmF/uuCmPlWpx/6qLUyUcShX1lNUXTq', true, NOW(), NOW(), NOW());
    
INSERT INTO countries ("name", emoji) VALUES ('UK', '&#x1F1EC;&#x1F1E7;');
INSERT INTO countries ("name", emoji) VALUES ('US', '&#x1F1FA;&#x1F1F8;');
INSERT INTO countries ("name", emoji) VALUES ('CA', '&#x1F1E8;&#x1F1E6;');
