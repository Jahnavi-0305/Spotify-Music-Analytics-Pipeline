-- 1. Top 5 Most Popular Genres (FAANG-style aggregation)
SELECT genre, ROUND(AVG(popularity), 2) AS avg_popularity
FROM tracks
GROUP BY genre
ORDER BY avg_popularity DESC
LIMIT 5;

-- 2. Genre with Highest Average Danceability
SELECT genre, AVG(danceability) AS avg_danceability
FROM tracks
GROUP BY genre
ORDER BY avg_danceability DESC
LIMIT 1;

-- 3. Average Loudness and Energy by Genre
SELECT genre, AVG(loudness) AS avg_loudness, AVG(energy) AS avg_energy
FROM tracks
GROUP BY genre;

-- 4. Artists with More Than 10 Tracks and Their Average Track Popularity
SELECT artists, COUNT(*) AS num_tracks, AVG(popularity) AS avg_popularity
FROM tracks
GROUP BY artists
HAVING COUNT(*) > 10
ORDER BY avg_popularity DESC;

-- 5. Top 3 Most Energetic Tracks per Genre (FAANG-style windowing)
SELECT *
FROM (
    SELECT *, RANK() OVER (PARTITION BY genre ORDER BY energy DESC) AS energy_rank
    FROM tracks
) ranked
WHERE energy_rank <= 3;

-- 6. Tracks in Top 10% Danceability
SELECT *
FROM tracks
WHERE danceability > (
    SELECT PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY danceability)
    FROM tracks
);

-- 7. Correlation Between Tempo and Popularity
SELECT CORR(tempo, popularity) AS tempo_popularity_correlation
FROM tracks;

-- 8. Count of Tracks by Popularity Band
SELECT 
  CASE 
    WHEN popularity < 40 THEN 'Low'
    WHEN popularity BETWEEN 40 AND 70 THEN 'Medium'
    ELSE 'High'
  END AS popularity_category,
  COUNT(*) AS track_count
FROM tracks
GROUP BY popularity_category;

-- 9. Genre with Most High-Energy & High-Danceability Tracks
SELECT genre, COUNT(*) AS num_tracks
FROM tracks
WHERE energy > 0.8 AND danceability > 0.7
GROUP BY genre
ORDER BY num_tracks DESC
LIMIT 1;

-- 10. Average Valence and Loudness by Musical Key
SELECT key, AVG(valence) AS avg_valence, AVG(loudness) AS avg_loudness
FROM tracks
GROUP BY key
ORDER BY key;

-- 11. Top 10 Artists by Combined Loudness + Energy
SELECT artist_name, loudness + energy AS combined_score
FROM artists
ORDER BY combined_score DESC
LIMIT 10;

-- 12. Artists with >15 Tracks and Highest Acousticness
SELECT artist_name, track_count, acousticness
FROM artists
WHERE track_count > 15
ORDER BY acousticness DESC
LIMIT 10;

-- 13. Compare Artist Popularity vs Avg Track Popularity
SELECT 
    a.artist_name,
    AVG(t.popularity) AS avg_track_popularity,
    a.popularity AS artist_popularity,
    (AVG(t.popularity) - a.popularity) AS popularity_diff
FROM tracks t
JOIN artists a ON t.artists = a.artist_name
GROUP BY a.artist_name, a.popularity
ORDER BY popularity_diff DESC;

-- 14. Artists with Most Variance in Energy (Interview-style stddev)
SELECT artists, COUNT(*) AS num_tracks, STDDEV(energy) AS energy_stddev
FROM tracks
GROUP BY artists
HAVING COUNT(*) > 5
ORDER BY energy_stddev DESC
LIMIT 10;

-- 15. Mood Clustering Based on Valence and Energy
SELECT artist_name,
       CASE
           WHEN valence > 0.6 AND energy > 0.6 THEN 'Happy Energetic'
           WHEN valence > 0.6 AND energy <= 0.6 THEN 'Happy Calm'
           WHEN valence <= 0.6 AND energy > 0.6 THEN 'Moody Intense'
           ELSE 'Sad Calm'
       END AS mood_cluster,
       COUNT(*) AS num_tracks
FROM artists
GROUP BY artist_name, mood_cluster
ORDER BY num_tracks DESC;

-- 16. Most Common Musical Keys in Popular Tracks (>70 Popularity)
SELECT key, COUNT(*) AS num_tracks
FROM tracks
WHERE popularity > 70
GROUP BY key
ORDER BY num_tracks DESC;

-- 17. Most “Underrated” Artists (high avg track popularity, low artist popularity)
SELECT 
    a.artist_name,
    AVG(t.popularity) AS avg_track_popularity,
    a.popularity AS artist_popularity,
    (AVG(t.popularity) - a.popularity) AS popularity_gap
FROM tracks t
JOIN artists a ON t.artists = a.artist_name
GROUP BY a.artist_name, a.popularity
HAVING popularity_gap > 10
ORDER BY popularity_gap DESC;

-- 18. Distribution of Tracks per Genre
SELECT genre, COUNT(*) AS total_tracks
FROM tracks
GROUP BY genre
ORDER BY total_tracks DESC;

-- 19. Top Artists by Loudness in Tracks Dataset
SELECT artists, AVG(loudness) AS avg_loudness
FROM tracks
GROUP BY artists
ORDER BY avg_loudness DESC
LIMIT 10;

-- 20. Track Tempo Deviation from Genre Average (for anomaly detection)
WITH genre_avg AS (
    SELECT genre, AVG(tempo) AS avg_genre_tempo
    FROM tracks
    GROUP BY genre
)
SELECT t.genre, t.artists, t.tempo, g.avg_genre_tempo, 
       (t.tempo - g.avg_genre_tempo) AS tempo_deviation
FROM tracks t
JOIN genre_avg g ON t.genre = g.genre
ORDER BY ABS(t.tempo - g.avg_genre_tempo) DESC
LIMIT 20;
