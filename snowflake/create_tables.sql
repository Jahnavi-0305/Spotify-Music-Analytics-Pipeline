-- Database and table creation
CREATE DATABASE spotify_project;

USE DATABASE spotify_project;

-- Table: tracks
CREATE OR REPLACE TABLE tracks (
    genre STRING,
    artists STRING,
    acousticness FLOAT,
    danceability FLOAT,
    duration_ms INT,
    energy FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    tempo FLOAT,
    valence FLOAT,
    popularity FLOAT,
    key INT,
    mode INT,
    track_count INT
);

-- Table: artists
CREATE OR REPLACE TABLE artists (
    mode INT,
    track_count INT,
    acousticness FLOAT,
    artist_name STRING,
    danceability FLOAT,
    duration_ms INT,
    energy FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    tempo FLOAT,
    valence FLOAT,
    popularity INT,
    key INT
);
