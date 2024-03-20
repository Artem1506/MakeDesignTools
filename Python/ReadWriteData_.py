import json

cur_data_file = "c:\\Users\\FD-11\\Downloads\\response.json"
with open(cur_data_file, 'r', encoding='utf-8') as js:
    data = json.load(js)
    
def WriteDataFile(data, filename):
    data = json.dumps(data)
    data = json.loads(str(data))
    with open(filename, 'w', encoding = 'utf-8') as file:
        json.dump(data, file, indent = 4, ensure_ascii = False, separators = (',', ': '))
WriteDataFile(data, cur_data_file)