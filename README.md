# Index Price Calculator RShiny Application

## Overview

This RShiny application(https://kapilnaik.shinyapps.io/Index_Price_Calculator/) allows users to select and import a dataset(Sample_Data.csv can be used for testing the app), calculate the index price based on specific rules, and display the results as a table and chart. Users can also download the calculated index prices as a CSV file.
Application link:- https://kapilnaik.shinyapps.io/Index_Price_Calculator/
Data to be used for testing:- Sample_Data.csv

### Features
- **File Import:** Users can upload a CSV file containing raw deal data.
- **Index Price Calculation:** The application calculates two indices (COAL2 and COAL4) based on the Volume Weighted Average Price (VWAP) of the relevant deals.
- **Data Display:** The results are displayed in a table and plotted as a time series chart.
- **CSV Download:** Users can download the calculated index prices as a CSV file.

## How to Use

1. **Launch the Application:**
   - Run the `app.R` file in an R environment with RShiny installed.

2. **Import Data:**
   - Click the "Choose CSV File" button to upload your dataset. The CSV file should include columns like `DealDate`, `DeliveryDate`, `DeliveryLocation`, `Price`, and `Volume`.

3. **View Results:**
   - The calculated index prices will be displayed in a table in main panel. A chart visualizing the indices over time will also be displayed.

4. **Download CSV:**
   - To download the calculated index prices, click the "Download CSV" button. This will save the data to your local machine as a CSV file.

## Index Price Calculation Rules

1. **Delivery Period:**
   - Only include deals if the delivery period begins within 180 days of the deal date.

2. **Volume Weighted Average Price (VWAP):**
   - The indices are calculated as the VWAP of all relevant deals.

3. **COAL2 Index:**
   - Includes deals delivered into Northwest Europe, specifically to locations in ARA, AMS, ROT, or ANT.

4. **COAL4 Index:**
   - Includes deals delivered from South Africa.

