from configparser import ConfigParser

config_file = "requests.config"
parser = ConfigParser()
parser.read(config_file, 'utf-16')
catalog_name = parser.get('Variables','catalog_name')
print(catalog_name)