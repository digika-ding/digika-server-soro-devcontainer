CREATE ROLE admin WITH LOGIN PASSWORD 'mySecret160418';
CREATE DATABASE digi_user;
CREATE DATABASE digi_player_1;
CREATE DATABASE digi_player_2;
GRANT ALL PRIVILEGES ON DATABASE digi_user TO admin;
GRANT ALL PRIVILEGES ON DATABASE digi_player_1 TO admin;
GRANT ALL PRIVILEGES ON DATABASE digi_player_2 TO admin;