from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
import os

default_args = {
    'owner': 'jahnavi',
    'start_date': datetime(2024, 5, 27),
    'retries': 1,
}

dag = DAG(
    dag_id='spotify_etl_pipeline',
    default_args=default_args,
    schedule_interval=None,
    catchup=False
)

def run_load():
    os.system("python etl/load_to_snowflake.py")

load_task = PythonOperator(
    task_id='load_to_snowflake',
    python_callable=run_load,
    dag=dag,
)
