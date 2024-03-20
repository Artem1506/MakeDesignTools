import requests
import json
# import configparser

# URLs
URL_AUTH = 'https://stanzza-api.aicrobotics.ru/api/auth/login'
URL_PROJECTS = 'https://stanzza-api.aicrobotics.ru/api/projects'
URL_CATALOG = 'https://stanzza-api.aicrobotics.ru/api/v1/catalog/06-01-001'

# json_file_name = input("Введите имя: ")
json_file = 'd:/Scripts/StanzzaTools/Data/ass.json'

# Get token for authorizationas
data = {'login':'zaitsev-pavel@stanzza.ru', 'password':'zaitsev-pavel2021', 'fingerprint':'test'}
auth_response = requests.post(URL_AUTH, data=data)
auth_response_data = json.loads(auth_response.text)
access_token = str(auth_response_data['access_token'])

# Headers
headers = {'Accept':'application/json', 'Authorization':('Bearer ' + access_token)}

# Get 'My Projects' data
projects_response_data = (requests.get(URL_PROJECTS, headers=headers)).json()

# Get 'Furniture Catalog' data
catalog_response_data = (requests.get(URL_CATALOG, headers=headers)).json()

def WriteDataFile(data, filename):
    data = json.dumps(data)
    data = json.loads(str(data))
    with open(filename, 'w', encoding = 'utf-8') as file:
        json.dump(data, file, indent = 4, ensure_ascii = False, separators = (',', ': '))
        
WriteDataFile(catalog_response_data, json_file)

# print(access_token)
# print(projects_response_data)
# print(catalog_response_data)