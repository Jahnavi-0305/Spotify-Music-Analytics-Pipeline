import pandas as pd
import snowflake.connector
from snowflake.connector.pandas_tools import write_pandas
import ast

# Snowflake connection details
conn = snowflake.connector.connect(
    user='JAHNAVIK',
    password='snowflakePASSWORD123@',
    account='HKNNOIH-RL66483',  
    warehouse='COMPUTE_WH',
    database='SPOTIFY_PROJECT',
    schema='PUBLIC'  
)

cursor = conn.cursor()
cursor.execute("SELECT CURRENT_DATABASE(), CURRENT_SCHEMA(), CURRENT_WAREHOUSE()")
print(cursor.fetchone())
cursor.execute("SHOW TABLES IN SCHEMA PUBLIC")
tables = cursor.fetchall()
cursor.close()
print(tables)



artist_data_frame = pd.read_csv('Data/data_by_artist.csv')
tracks_data_frame = pd.read_csv('Data/data_w_genres.csv')


def transform(data_frame):
    transformed_data = data_frame[data_frame['genres'].apply(lambda x: len(ast.literal_eval(x)) > 0)]
    return transformed_data

cleaned_tracks_data = transform(tracks_data_frame)
    
def load_to_snowflake(data_frame, table_name, conn):
    # For artists dataframe
    if 'mode' in data_frame.columns or 'count' in data_frame.columns:
        data_frame = data_frame.rename(columns={'mode': 'MODE_COUNT', 'count': 'TRACK_COUNT'})
    
    data_frame.columns = [col.upper() for col in data_frame.columns]
        
    success, nchunks, nrows, _ = write_pandas(conn, data_frame, table_name)
    if success:
        print(f"Loaded {nrows} rows into table '{table_name}'")
    else:
        print(f"Failed to load data into '{table_name}'")

# Load both datasets
load_to_snowflake(artist_data_frame, "ARTIST_TABLE", conn)
load_to_snowflake(cleaned_tracks_data, "TRACKS_TABLE", conn)



