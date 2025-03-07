import json 


with open('/home/hussain/coincap-de-project/Local Setup/grafana/geojson/countries.geojson', 'r', encoding='utf-8') as f:
    geojson_data = json.load(f)
    
# Load the currency data JSON file
with open('/home/hussain/coincap-de-project/Local Setup/grafana/geojson/filename.json', 'r', encoding='utf-8') as f:
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
    
    if country_name == 'Spain':
        print(currency_dict[country_name])
    
    if country_name in currency_dict:
        feature['properties']['Currency Symbol'] = currency_dict[country_name]['Currency Symbol']
        feature['properties']['Currency Rate'] = currency_dict[country_name]['Currency Rate']
# Write the updated GeoJSON back to a new file
with open('/home/hussain/coincap-de-project/Local Setup/grafana/geojson/countries.geojson', 'w', encoding='utf-8') as f:
    json.dump(geojson_data, f, indent=4)
