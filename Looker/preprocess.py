import pandas as pd

# Load CSV with ; as delimiter
df = pd.read_csv('ny_house_cleaned.csv', delimiter=';')

# Process or save
df.to_csv('processed_file.csv', index=False)