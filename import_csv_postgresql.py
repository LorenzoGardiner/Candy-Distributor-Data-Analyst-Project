import pandas as pd
from sqlalchemy import create_engine

#Load the CSV files into DataFrames
df1 = pd.read_csv('Candy_Sales.csv') 
df2 = pd.read_csv('Candy_Products.csv') 

# Create the connection string to PostgreSQL (insert your username, password, host, port, database)
engine = create_engine('postgresql://postgres:4daData!@localhost:5432/CandyDB')

#DataFrame will create table in PostgreSQL automatically
df1.to_sql('CandySales', engine, if_exists='replace', index=False)
df2.to_sql('CandyProducts', engine, if_exists='replace', index=False)

print("CSV imported successfully!")
