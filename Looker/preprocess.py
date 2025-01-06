import pandas as pd
import string


def csv_load():
    # Load CSV with ; as delimiter
    df = pd.read_csv('ny_house_cleaned.csv', delimiter=';')

    # Process or save
    df.to_csv('processed_file.csv', index=False)

def process_csv():
    df_w = pd.read_csv('processed_file.csv')

    #a = df_w['LOCALITY'].unique()

    b = df_w[df_w['LOCALITY'].str.contains('New York', na=False)]

    df_w.loc[df_w['LOCALITY'].str.contains('New', na=False), 'LOCALITY'] = 'New York'

    df_w.loc[df_w['LOCALITY'].str.contains('Bronx', na=False), 'LOCALITY'] = 'Bronx County'

    df_w.loc[df_w['LOCALITY'].str.contains('Queens', na=False), 'LOCALITY'] = 'Queens County'

    df_w.loc[df_w['LOCALITY'].str.contains('United States', na=False), 'LOCALITY'] = 'Indefined'

    df_w.to_csv('file_unique_values.csv', index=False)

process_csv()