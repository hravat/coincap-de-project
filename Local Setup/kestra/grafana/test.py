import os
import psycopg2
import json
import pycountry

# Database connection parameters
db_host = "postgres_db"
db_port = "5432"  # usually 5432 for PostgreSQL
db_name = "coincap_dwh"
db_user = "coincap_user"
db_password = "coincap_password"

# Define the path inside the Docker container where you want to save the JSON file
docker_path = '/app/geojson/filename.json'


def get_country_by_currency(currency_code):
    return currency_to_country.get(currency_code, "Unknown")

# SQL query


currency_to_country = {
    "EUR": ["Austria", "Belgium", "Cyprus", "Estonia", "Finland", "France", "Germany", "Greece", "Ireland", 
            "Italy", "Latvia", "Lithuania", "Luxembourg", "Malta", "Netherlands", "Portugal", "Slovakia", 
            "Slovenia", "Spain"],
    "JPY": ["Japan"],
    "GBP": ["United Kingdom"],
    "AUD": ["Australia"],
    "CAD": ["Canada"],
    "CHF": ["Switzerland"],
    "CNY": ["China"],
    "SEK": ["Sweden"],
    "NZD": ["New Zealand"],
    "MXN": ["Mexico"],
    "SGD": ["Singapore"],
    "INR": ["India"],
    "BRL": ["Brazil"],
    "RUB": ["Russia"],
    "ZAR": ["South Africa"],
    "KRW": ["South Korea"],
    "HKD": ["Hong Kong"],
    "TRY": ["Turkey"],
    "NOK": ["Norway"],
    "KES": ["Kenya"],
    "NGN": ["Nigeria"],
    "PHP": ["Philippines"],
    "THB": ["Thailand"],
    "VND": ["Vietnam"],
    "IDR": ["Indonesia"],
    "LKR": ["Sri Lanka"],
    "PLN": ["Poland"],
    "HUF": ["Hungary"],
    "DKK": ["Denmark"],
    "CZK": ["Czech Republic"],
    "MYR": ["Malaysia"],
    "KWD": ["Kuwait"],
    "BHD": ["Bahrain"],
    "OMR": ["Oman"],
    "QAR": ["Qatar"],
    "SAR": ["Saudi Arabia"],
    "EGP": ["Egypt"],
    "BDT": ["Bangladesh"],
    "ZMW": ["Zambia"],
    "GHS": ["Ghana"],
    "PKR": ["Pakistan"],
    "SYP": ["Syria"],
    "LBP": ["Lebanon"],
    "MGA": ["Madagascar"],
    "UZS": ["Uzbekistan"],
    "IRR": ["Iran"],
    "UGX": ["Uganda"],
    "TZS": ["Tanzania"],
    "MNT": ["Mongolia"],
    "BIF": ["Burundi"],
    "KHR": ["Cambodia"],
    "GNF": ["Guinea"],
    "MMK": ["Myanmar"],
    "COP": ["Colombia"],
    "CDF": ["Congo"],
    "SLL": ["Sierra Leone"],
    "RWF": ["Rwanda"],
    "IQD": ["Iraq"],
    "AOA": ["Angola"],
    "ARS": ["Argentina"],
    "MWK": ["Malawi"],
    "CLP": ["Chile"],
    "KPW": ["North Korea"],
    "SOS": ["Somalia"],
    "KMF": ["Comoros"],
    "SDG": ["Sudan"],
    "CRC": ["Costa Rica"],
    "XOF": ["West African Countries"],
    "KZT": ["Kazakhstan"],
    "XAF": ["Central Africa"],
    "ZWL": ["Zimbabwe"],
    "AMD": ["Armenia"],
    "YER": ["Yemen"],
    "GYD": ["Guyana"],
    "LRD": ["Liberia"],
    "JMD": ["Jamaica"],
    "DJF": ["Djibouti"],
    "NPR": ["Nepal"],
    "ISK": ["Iceland"],
    "DZD": ["Algeria"],
    "ETB": ["Ethiopia"],
    "SSP": ["South Sudan"],
    "VUV": ["Vanuatu"],
    "HTG": ["Haiti"],
    "RSD": ["Serbia"],
    "XPF": ["Pacific Franc Zone"],
    "CVE": ["Cape Verde"],
    "KGS": ["Kyrgyzstan"],
    "BTN": ["Bhutan"],
    "GMD": ["Gambia"],
    "AFN": ["Afghanistan"],
    "DOP": ["Dominican Republic"],
    "MZN": ["Mozambique"],
    "VES": ["Venezuela"],
    "MKD": ["Macedonia"],
    "MUR": ["Mauritius"],
    "UYU": ["Uruguay"],
    "UAH": ["Ukraine"],
    "MRU": ["Mauritania"],
    "NIO": ["Nicaragua"],
    "SRD": ["Suriname"],
    "TWD": ["Taiwan"],
    "CUP": ["Cuba"],
    "HNL": ["Honduras"],
    "STN": ["São Tomé and Príncipe"],
    "MDL": ["Moldova"],
    "NAD": ["Namibia"],
    "LSL": ["Lesotho"],
    "SZL": ["Swaziland"],
    "MVR": ["Maldives"],
    "ERN": ["Eritrea"],
    "SCR": ["Seychelles"],
    "BWP": ["Botswana"],
    "TJS": ["Tajikistan"],
    "MAD": ["Morocco"],
    "SVC": ["El Salvador"],
    "SBD": ["Solomon Islands"],
    "MOP": ["Macau"],
    "GTQ": ["Guatemala"],
    "CNH": ["China"],
    "HRK": ["Croatia"],
    "BOB": ["Bolivia"],
    "TTD": ["Trinidad and Tobago"],
    "LYD": ["Libya"],
    "RON": ["Romania"],
    "PGK": ["Papua New Guinea"],
    "PEN": ["Peru"],
    "AED": ["United Arab Emirates"],
    "ILS": ["Israel"],
    "TMT": ["Turkmenistan"],
    "BYN": ["Belarus"],
    "TND": ["Tunisia"],
    "WST": ["Samoa"],
    "GEL": ["Georgia"],
    "XCD": ["Eastern Caribbean Dollar"],
    "FJD": ["Fiji"],
    "BZD": ["Belize"],
    "BBD": ["Barbados"],
    "BAM": ["Bosnia and Herzegovina"],
    "BGN": ["Bulgaria"],
    "AWG": ["Aruba"],
    "ANG": ["Netherlands Antilles"],
    "AZN": ["Azerbaijan"],
    "BND": ["Brunei"],
    "USD": ["United States of America"],
    "CUC": ["Cuba"],
    "BMD": ["Bermuda"],
    "PAB": ["Panama"],
    "KYD": ["Cayman Islands"],
    "GIP": ["Gibraltar"],
    "GGP": ["Guernsey"],
    "JEP": ["Jersey"],
    "IMP": ["Isle of Man"],
    "FKP": ["Falkland Islands"],
    "SHP": ["Saint Helena"],
    "XDR": ["International Monetary Fund"],
    "JOD": ["Jordan"],
    "XAG": ["Silver"],
    "CLF": ["Chile"],
    "XPD": ["Palladium"],
    "XPT": ["Platinum"],
    "XAU": ["Gold"]
}
query = """
WITH ranked_data AS (
    SELECT 
        dcr.*,
        fcr.*,
        ROW_NUMBER() OVER (
            PARTITION BY dcr.currency_sr_key 
            ORDER BY fcr.event_timestamp DESC
        ) AS rn
    FROM coincap_prod.dim_currency_rate dcr   
    INNER JOIN coincap_prod.fact_currency_rate fcr 
        ON dcr.currency_sr_key = fcr.currency_sr_key 
    WHERE dcr.currency_type = 'fiat'
)
SELECT UPPER(ranked_data.currency_symbol ) as "Currency Symbol",
       case 
       	when ranked_data.currenncy_rate_in_usd = 0 then NULL
       	else 1/ranked_data.currenncy_rate_in_usd
       end  "Currency Rate"
FROM ranked_data 
WHERE rn = 1
order by ranked_data.currenncy_rate_in_usd NULLS FIRST;
"""

# Currency to Country mapping (example for a few currencies)


# Connect to the database
try:
    conn = psycopg2.connect(
        host=db_host,
        port=db_port,
        dbname=db_name,
        user=db_user,
        password=db_password
    )
    cursor = conn.cursor()

    # Execute the SQL query
    cursor.execute(query)

    # Fetch all rows
    rows = cursor.fetchall()

    # Prepare the data to be written to the JSON file
    currency_data = []
    for row in rows:
        currency_symbol = row[0]
        currency_rate = row[1]
        
        # Get country name based on the currency symbol (using the dictionary)
        country_list = get_country_by_currency(currency_symbol)
        
        for country in country_list:
            if currency_rate is None:
                currency_rate = -99
            else:
                currency_rate = float(currency_rate)        


            # Append data as a dictionary
            currency_data.append({
                "Currency Symbol": currency_symbol,
                "Currency Rate": currency_rate,
                "Country": country
            })

    # Ensure the directory exists
    os.makedirs(os.path.dirname(docker_path), exist_ok=True)

    # Write the data to a JSON file
    with open(docker_path, 'w') as f:
        json.dump(currency_data, f, indent=4)

    print(f"JSON file created at {docker_path}")


    # Load the GeoJSON file
    with open('/app/geojson/countries.geojson', 'r', encoding='utf-8') as f:
        geojson_data = json.load(f)

    # Load the currency data JSON file
    with open('/app/geojson/filename.json', 'r', encoding='utf-8') as f:
        currency_data = json.load(f)

    # Create a dictionary from the currency data for easy lookup
    currency_dict = {
        item['Country']: {
            'Currency Symbol': item['Currency Symbol'],
            'Currency Rate': item['Currency Rate']
        }
        for item in currency_data
    }

    # Add currency information to each feature in the GeoJSON
    for feature in geojson_data['features']:
        country_name = feature['properties']['name']
        
        
        if country_name in currency_dict:
            feature['properties']['Currency Symbol'] = currency_dict[country_name]['Currency Symbol']
            feature['properties']['Currency Rate'] = currency_dict[country_name]['Currency Rate']

    # Write the updated GeoJSON back to a new file
    with open('/app/geojson/updated_countries.geojson', 'w', encoding='utf-8') as f:
        json.dump(geojson_data, f, indent=4)



except Exception as e:
    print(f"Error: {e}")

finally:
    # Close the database connection
    if conn:
        cursor.close()
        conn.close()


