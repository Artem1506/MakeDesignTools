import json
from urllib import request, parse
from configparser import ConfigParser
import os

# Get configuration data from requests.config file
config_file = "requests.config"
parser = ConfigParser()
parser.read(config_file, 'utf-16')

URL_AUTH = parser.get('URLs','URL_AUTH')
URL_STORAGE = parser.get('URLs','URL_STORAGE')
URL_CATALOG = parser.get('URLs','URL_CATALOG')
URL_PROJECTS = parser.get('URLs','URL_PROJECTS')

target_catalog_id = parser.get('Variables','target_catalog_id')
url_target_object = URL_CATALOG + '/' + target_catalog_id
login = parser.get('Authorization','login')
password = parser.get('Authorization','password')
auth_data = {'login':login, 'password':password, 'fingerprint':'fingerprint'}

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
        
def upload_files():
    os.startfile('upload.exe')
    
def put_update(url, token, data):
    ''' Update data properties '''
    headers = {'Accept':'application/json', 'Authorization':('Bearer ' + token), 'Content-Type':'application/x-www-form-urlencoded'}
    post_data = (parse.urlencode(data)).encode("utf-8")
    req = request.Request(url=url, headers=headers, data=post_data, method="PUT")
    with request.urlopen(req) as f:
        pass

# Get access token       
access_token = get_auth_token(URL_AUTH, auth_data)

# data = {'style':'Классика'}
# put_update(url_target_object, access_token, data)

