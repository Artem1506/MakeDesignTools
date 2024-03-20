import json
import pymxs

rt = pymxs.runtime
with open(rt.cur_data_file, 'r', encoding='utf-8') as js:
    rt.data = json.load(js)