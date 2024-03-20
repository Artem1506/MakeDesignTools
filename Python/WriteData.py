import json
import pymxs

rt = pymxs.runtime
def WriteDataFile(data, filename):
    data = json.dumps(data)
    data = json.loads(str(data))
    with open(filename, 'w', encoding = 'utf-8') as file:
        json.dump(data, file, indent = 4, ensure_ascii = False, separators = (',', ': '))
WriteDataFile(rt.data, rt.cur_data_file)
