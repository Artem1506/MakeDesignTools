import requests
import json
from configparser import ConfigParser

# Get configuration data from requests.config file
config_file = "requests.config"
parser = ConfigParser()
parser.read(config_file, 'utf-16')

URL_AUTH = parser.get('URLs','URL_AUTH')
URL_STORAGE = parser.get('URLs','URL_STORAGE')
URL_CATALOG = parser.get('URLs','URL_CATALOG')
URL_PROJECTS = parser.get('URLs','URL_PROJECTS')

target_catalog_id = parser.get('Variables','target_catalog_id')
uploded_file = parser.get('Variables','uploded_file')
url_target_object = URL_CATALOG + '/' + target_catalog_id
login = parser.get('Authorization','login')
password = parser.get('Authorization','password')

# Get token for authorization
data = {'login':login, 'password':password, 'fingerprint':'fingerprint'}
auth_response = requests.post(URL_AUTH, data=data)
auth_response_data = json.loads(auth_response.text)
access_token = str(auth_response_data['access_token'])

# Upload headers
headers = {'Accept':'application/json', 'Authorization':('Bearer ' + access_token)}

# Upload data
files = {'file': open(uploded_file, 'rb')}

# Upload file
upload_respose_data = (requests.post(URL_STORAGE, headers=headers, files=files)).json()
uploaded_file_id = str(upload_respose_data['id'])
# uploaded_file_url = str(upload_respose_data['url'])
# uploaded_file_name = str(upload_respose_data['original_name'])

# Update headers
update_headers = {'Accept':'application/json', 'Authorization':('Bearer ' + access_token), 'Content-Type':'application/x-www-form-urlencoded'}

# Update data for 'asset_ue4' key
data = {'asset_ue4':uploaded_file_id}

# Update 'asset_ue4' key
update_data = (requests.put(url_target_object, headers=update_headers, data=data)).json()

# uploded_files = parser.get('Variables','uploded_files')
# uploded_files_list = list(uploded_files.split(", "))
# print(len(uploded_files_list))
