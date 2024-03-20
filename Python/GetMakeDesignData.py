import json
from urllib import request, parse

# URLs
URL_AUTH = 'https://stanzza-api.aicrobotics.ru/api/auth/login'
URL_CATALOG = 'https://stanzza-api.aicrobotics.ru/api/v1/catalog'
URL_PROJECTS = 'https://stanzza-api.aicrobotics.ru/api/projects'

auth_data = {'login':'zaitsev-pavel@stanzza.ru', 'password':'zaitsev-pavel2021', 'fingerprint':'finger'}
catalog_json_file = 'd:/Scripts/StanzzaTools/Data/md_catalog.json'
projects_json_file = 'd:/Scripts/StanzzaTools/Data/md_projects.json'

def get_auth_token(url, data):
    ''' Return token for authorization '''
    post_data = (parse.urlencode(data)).encode("utf-8")
    response = request.Request(url=url, data=post_data, method="POST")
    auth_response = request.urlopen(response)
    auth_response_data = json.loads(auth_response.read())
    access_token = str(auth_response_data['access_token'])
    return access_token

def get_response_data(url, token):
    ''' Returns json object '''
    headers = {'Accept':'application/json', 'Authorization':('Bearer ' + token)}
    req = request.Request(url=url, headers=headers, method="GET")
    response = request.urlopen(req)
    response_data = json.loads(response.read())
    return response_data

def write_data_to_file(data, filename):
    ''' Write json data to file '''
    data = json.dumps(data)
    data = json.loads(str(data))
    with open(filename, 'w', encoding = 'utf-8') as file:
        json.dump(data, file, indent = 4, ensure_ascii = False, separators = (',', ': '))

# Get access token       
access_token = get_auth_token(URL_AUTH, auth_data)

# Get 'Furniture Catalog' data
catalog_response_data = get_response_data((URL_CATALOG + '/' + '06-01-001'), access_token)

# Get 'My Projects' data
projects_response_data = get_response_data(URL_PROJECTS, access_token)

# Write json data to file
write_data_to_file(catalog_response_data, catalog_json_file)
write_data_to_file(projects_response_data, projects_json_file)