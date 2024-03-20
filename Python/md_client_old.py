from datetime import datetime, timedelta
from re import split
import json
import requests
from urllib import request, parse
from configparser import ConfigParser
import argparse
# import pathlib
from win32 import win32clipboard
# import shutil
import os

# Get configuration data from requests.config_parser file
config_file = "md_client.config"
config_parser = ConfigParser()
config_parser.read(config_file, 'utf-8')

URL_AUTH = config_parser.get('URLs', 'url_auth')
URL_STORAGE = config_parser.get('URLs', 'url_storage')
URL_CATALOG = config_parser.get('URLs', 'url_catalog')
URL_PROJECTS = config_parser.get('URLs', 'url_projects')
URL_USERS = config_parser.get('URLs', 'url_users')
URL_CHAT = config_parser.get('URLs', 'url_chat')
CATALOG_ASSET_KEY = "asset_mesh"

login = config_parser.get('Authorization', 'login')
password = config_parser.get('Authorization', 'password')
try:
    auth_data = {'login': login,
                'password': password,
                'fingerprint': 'fingerprint'}
except:
    auth_data = None

separ = "%"
separ2 = '$'
STATES = ["None", "In_Work", "Check", "Done"]

def check_token_time(token_time_limit):
    ''' Return True if difference between current time and token's time limit more than one hour '''

    diff_time = timedelta(days=0, hours=1)  # Set one hour limit
    l_date_time = split('T|\+', token_time_limit)
    date_time = l_date_time[0] + ' ' + l_date_time[1]
    date_lim = datetime.strptime(date_time, '%Y-%m-%d %H:%M:%S')
    date_td = datetime.now()
    delta_time = timedelta(days=(date_lim.day - date_td.day),
                           hours=(date_lim.hour - date_td.hour))
    if delta_time > diff_time:
        return True  # Use old token
    else:
        return False  # Get a new token


def get_auth_token(url, data):
    ''' Return access token for authorization or None '''

    try:
        post_data = (parse.urlencode(data)).encode("utf-8")
        response = request.Request(url=url, data=post_data, method="POST")
        auth_response = request.urlopen(response)
        status_code = auth_response.code
        if status_code == 200:
            auth_response_data = json.loads(auth_response.read())
            access_token = str(auth_response_data['access_token'])
            time_limit = str(auth_response_data['expired_at'])
            config_parser.set(
                'Authorization', 'access_token', str(access_token))
            config_parser.set('Authorization', 'time_limit', time_limit)
            with open(config_file, 'w') as file:
                config_parser.write(file)
            return access_token
    except:
        return ''


def create_arg_parser():
    ''' Return the 'ArgumentParser' class object '''

    arg_parser = argparse.ArgumentParser()
    arg_parser.add_argument('command', nargs='?', default='')
    arg_parser.add_argument('params', nargs='?', default='')

    return arg_parser


def read_data_from_json(file_name):

    with open(file_name, 'r', encoding='utf-8') as js:
        return json.load(js)


def write_data_to_json(file_name, data):
    ''' Write json data to file '''

    data = json.dumps(data)
    data = json.loads(str(data))
    with open(file_name, 'w', encoding='utf-8') as file:
        json.dump(data, file, indent=4, ensure_ascii=False,
                  separators=(',', ': '))


def get_data(url, token):
    ''' Returns the json object '''
    ''' [200, "Message", json data object] '''

    response_data = []
    headers = {'Accept': 'application/json',
               'Authorization': ('Bearer ' + token)}
    req = request.Request(url=url, headers=headers, method="GET")
    response = request.urlopen(req)
    code = response.code

    if code == 200:
        response_data.append(str(code))
        response_data.append('Успешно! Соединение установлено.')
        response_data.append(json.loads(response.read()))
    elif code == 401:
        response_data.append(str(code))
        response_data.append('Проблемы с авторизацией.')
        response_data.append(None)
    else:
        response_data.append('400')
        response_data.append('Что-то пошло не так.')
        response_data.append(None)

    return response_data


def get_catalog_tree(save_file, token):
    ''' Returns a data tree for whole catalog '''
    ''' It takes some time '''

    data_out = []
    response = get_data(URL_CATALOG, token)

    if response[0] == '200':
        response_data = response[2]['catalog']['children']
        for i in range(len(response_data)):
            categ = {'article': response_data[i]['article'],
                     'name': response_data[i]['name'],
                     'children': []}
            data_out.append(categ)
            response_2 = get_data(URL_CATALOG + '/' +
                                  response_data[i]['article'], token)
            if response_2[0] == '200':
                response_data_sub = response_2[2]['catalog']['children']
                for k in range(len(response_data_sub)):
                    categ_sub = {
                        'article': response_data_sub[k]['article'],
                        'name': response_data_sub[k]['name'],
                        'children': []}
                    data_out[i]['children'].append(categ_sub)
                    response_3 = get_data(
                        URL_CATALOG + '/' + categ_sub['article'], token)
                    if response_3[0] == '200':
                        response_data_sub_sub = response_3[2]['catalog']['children']
                        for j in range(len(response_data_sub_sub)):
                            categ_sub_sub = {
                                'article': response_data_sub_sub[j]['article'],
                                'name': response_data_sub_sub[j]['name'],
                                'children': []}
                            data_out[i]['children'][k]['children'].append(
                                categ_sub_sub)

    write_data_to_json(save_file, data_out)
    set_clipboard_text(response[0]+separ+response[1])

    return data_out


def get_projects_tree(save_file, token):
    ''' Returns a data tree for whole projects '''
    ''' It takes some time '''

    data_out = []
    response_data = get_data(URL_PROJECTS, token)

    if response_data[0] == '200':
        for item in response_data[2]['items']:
            dict = {}
            dict['article'] = item['article']
            dict['name'] = item['name']
            dict['preview'] = item['preview']
            dict['plan_source'] = item['plan']['source']
            dict['plan_preview'] = item['plan']['preview']
            dict['plan_name'] = item['plan']['name']
            dict['items'] = []
            data_out.append(dict)

    write_data_to_json(save_file, data_out)
    set_clipboard_text(response_data[0]+separ+response_data[1])

    return data_out

def get_users_tree(save_file, token):
    data_out = []
    response_data = get_data(URL_USERS, token)

    if response_data[0] == '200':
        for item in response_data[2]:
            dict = {}
            dict['title'] = item['title']
            dict['user_id'] = item['user_id']
            dict['image'] = item['image']
            
            data_out.append(dict)

    write_data_to_json(save_file, data_out)
    set_clipboard_text(response_data[0]+separ+response_data[1])

    return data_out
    
def convert_string_to_max_format(text):
    new_text = text.replace("'", "\"")
    new_text = new_text.replace("[", "#(")
    new_text = new_text.replace("]", ")")

    return new_text


def get_catalog_branch_ids(article, token):
    ''' Return a list of task articles as a string '''
    ''' or an error message '''

    good_data = []
    bad_data = []
    comp_data = []
    url_branch = URL_CATALOG + '/' + article
    response_data = get_data(url_branch, token)
    data = ""

    if response_data[0] == '200':
        for item in response_data[2]['catalog']['children']:
            date_time = (split(' ', item['date_create']))[1]
            # Validation task
            # Good or bad
            if item['photo'] != None and item['size'] != None:
                url_mats_branch = URL_CATALOG + '/' + item['article']
                response_mats_data = get_data(url_mats_branch, token)
                if response_mats_data[0] == '200':
                    children = response_mats_data[2]['catalog']['children']
                    if children != []:
                        mats_valid = 0
                        for mat in children:
                            if mat['name_part_object'] != None and mat['Photo_Texts'] != None and mat['finishing_components'] != None:
                                mats_valid += 1
                        if mats_valid == len(children):
                            # Good task
                            good_data.append(
                                item['article'] + separ2 + date_time + separ2 + "Готово для загрузки." + separ2 + item['userId'])
                            if item['asset_preview'] != None and item['asset_mesh'] != None and item['asset_textures'] != None and item['asset_data'] != None:
                                # Completed task
                                comp_data.append(
                                    item['article'] + separ2 + date_time + separ2 + "Готово для загрузки." + separ2 + item['userId'])
                        # Bad task
                        else:
                            bad_data.append(item['article'] + separ2 + date_time + separ2 +
                                            "В материалах отделки некорректно заполнены некоторые поля (Название части объекта, Фото/Текструры или Материал)." + separ2 + item['userId'])
                    # Bad task
                    else:
                        bad_data.append(
                            item['article'] + separ2 + date_time + separ2 + "Не заданы материалы отделки." + separ2 + item['userId'])
            # Bad task
            else:
                bad_data.append(item['article'] + separ2 + date_time + separ2 +
                                "Отсутствует фото референса или не проставлены размеры." + separ2 + item['userId'])

        good_data_str = str(convert_string_to_max_format(str(good_data)))
        bad_data_str = str(convert_string_to_max_format(str(bad_data)))
        comp_data_str = str(convert_string_to_max_format(str(comp_data)))
        # msg = f'Доступных для скачивания заданий: {len(good_data)}'
        msg = str(len(good_data))

        data = [
            (response_data[0] + separ + msg + separ + good_data_str),
            (response_data[0] + separ + msg + separ + bad_data_str),
            (response_data[0] + separ + msg + separ + comp_data_str)
        ]
    else:
        data = response_data[0]+separ+response_data[1]

    return data


def get_whole_catalog_branch(article, token):
    ''' "Return a data tree for the article" '''

    data_out = []
    url_branch = URL_CATALOG + '/' + article
    response_data = get_data(url_branch, token)

    if response_data[0] == '200':
        for item in response_data[2]['catalog']['children']:
            dict = {
                'article': item['article'],
                'date_create': item['date_create'],
                'object': item['object'],
                'asset_preview': item['asset_preview'],
                'asset_mesh': item['asset_mesh'],
                'asset_textures': item['asset_textures'],
                'asset_data': item['asset_data'],
                'web_site': item['manufacturer_site'],
                'finishing_materials': item['finishing_materials'],
                'state': STATES[0],
                'pivot': [0.0 ,0.0 ,0.0],
                'tags': item['tags'],
                'userId':item['userId'],
                'userName':item['userName'],
                'size': [0.0 ,0.0 ,0.0],
                'size_trans': None
            }
            if item['photo'] != None:
                dict['ref_photo'] = item['photo']['preview']
                dict['ref_photo_name'] = item['photo']['name']

            try:
                w = str(item['size']['size_width']).replace(',', '.')
                d = str(item['size']['size_depth']).replace(',', '.')
                h = str(item['size']['size_height']).replace(',', '.')
                dict['size'] = [float(w), float(d), float(h)]
            except:
                pass
            
            # Обеденные столы
            try:
                if item['kind'] == "раскладной":
                    w = str(item['dimensions_during_transformation']['size_trans_width']).replace(',', '.')
                    d = str(item['dimensions_during_transformation']['size_trans_depth']).replace(',', '.')
                    h = str(item['dimensions_during_transformation']['size_trans_height']).replace(',', '.')
                    dict['size_trans'] = [float(w), float(d), float(h)]
            except:
                pass
            
            url_mats_branch = URL_CATALOG + '/' + item['article']
            response_mats_data = get_data(url_mats_branch, token)

            if response_mats_data[0] == '200':
                children = response_mats_data[2]['catalog']['children']
                mats = []
                for item in children:
                    mats_dict = {
                        'article': item['article'],
                        'name_part_object': item['name_part_object'],
                        'finishing_components': item['finishing_components']
                    }
                    if item['Photo_Texts'] != None:
                        mats_dict['ref_photo'] = item['Photo_Texts']['preview']
                        mats_dict['ref_photo_name'] = item['Photo_Texts']['name']
                    mats.append(mats_dict)
                dict['finishing_materials'] = mats
                data_out.append(dict)

    return data_out


'''
def get_whole_catalog_branch(article, token):
    ''' "Return a data tree for the article" '''
    
    data_out = []
    url_branch = URL_CATALOG + '/' + article
    response_data = get_data(url_branch, token)
    
    if response_data[0] == '200':
        for item in response_data[2]['catalog']['children']:
            dict = {
                'article':item['article'],
                'date_create':item['date_create'],
                'object':item['object'],
                'preview':item['preview'],
                'asset_ue4':item['asset_ue4'],
                'web_site':item['manufacturer_site'],
                'finishing_materials':item['finishing_materials'],
                'state':None,
                'tags':item['tags'],
                # 'ref_photo':item['photo'],
                # 'ref_photo_name':item['photo']['name'],
                # 'size':item['size']
            }
            # print(item['photo']['preview'])
            if item['photo'] != None:
                dict['ref_photo'] = item['photo']['preview']
                dict['ref_photo_name'] = item['photo']['name']
                
            if item['size'] != None:
                dict['size'] = item['size']
                
            url_mats_branch = URL_CATALOG + '/' + item['article']
            response_mats_data = get_data(url_mats_branch, token)
            
            if response_data[0] == '200':
                children = response_mats_data[2]['catalog']['children']
                mats = []
                for item in children:
                    mats_dict = {
                        'article':item['article'],
                        'name_part_object':item['name_part_object'],
                        'finishing_components':item['finishing_components'],
                        # 'ref_photo':item['Photo_Texts']['preview'],
                        # 'ref_photo_name':item['Photo_Texts']['name']
                    }
                    if item['Photo_Texts'] != None:
                        mats_dict['ref_photo'] = item['Photo_Texts']['preview']
                        mats_dict['ref_photo_name'] = item['Photo_Texts']['name']
                    mats.append(mats_dict)
                dict['finishing_materials'] = mats
                data_out.append(dict)
        
    return data_out
'''


def write_response(status_code):
    ''' Write down the response status code to the 'requests_config.ini' file '''

    config_parser.set('Response', 'status_code', str(status_code))
    with open(config_file, 'w', encoding='utf-8') as file:
        config_parser.write(file)


def get_clipboard_text():
    win32clipboard.OpenClipboard()
    data = win32clipboard.GetClipboardData()
    win32clipboard.CloseClipboard()

    return data


def set_clipboard_text(text):
    win32clipboard.OpenClipboard()
    win32clipboard.EmptyClipboard()
    win32clipboard.SetClipboardText(text, win32clipboard.CF_UNICODETEXT)
    win32clipboard.CloseClipboard()


def download_data(data_url, save_path, save_file_name):
    os.makedirs(save_path, exist_ok=True)
    save_file = os.path.join(save_path, save_file_name)
    try:
        response = requests.get(data_url)
        with open(save_file, "wb") as f:
            f.write(response.content)
        if os.path.exists(save_file):
            return True
        else:
            return False
    except Exception:
        return False

# def upload_files(url, key, uploded_file, token):
#     headers = {'Accept':'application/json', 'Authorization':('Bearer '+ token)}
#     files = {'file': open(uploded_file, 'rb')}
#     upload_respose_data = (requests.post(URL_STORAGE, headers=headers, files=files)).json()
#     uploaded_file_id = str(upload_respose_data['id'])
#     update_headers = {'Accept':'application/json', 'Authorization':('Bearer ' + token), 'Content-Type':'application/x-www-form-urlencoded'}
#     data = {key:uploaded_file_id}
#     update_respose_data = (requests.put(url, headers=update_headers, data=data)).json()
#     if update_respose_data["success"]==True:
#         return True
#     else:
#         return False


def upload_files(url, key, uploded_file, token):
    headers = {'Accept': 'application/json',
               'Authorization': ('Bearer ' + token)}
    with open(uploded_file, 'rb') as file:
        files = {'file': file}
        upload_respose_data = (requests.post(
            URL_STORAGE, headers=headers, files=files)).json()
        uploaded_file_id = str(upload_respose_data['id'])
        update_headers = {'Accept': 'application/json', 'Authorization': (
            'Bearer ' + token), 'Content-Type': 'application/x-www-form-urlencoded'}
        data = {key: uploaded_file_id}
        update_respose_data = (requests.put(
            url, headers=update_headers, data=data)).json()
        if update_respose_data["success"] == True:
            return True
        else:
            return False


def put_update(url, data, token):
    ''' Update data properties '''
    ''' data example - {"asset_mesh":""} '''

    headers = {'Accept': 'application/json', 'Authorization': (
        'Bearer ' + token), 'Content-Type': 'application/x-www-form-urlencoded'}
    post_data = (parse.urlencode(data)).encode("utf-8")
    req = request.Request(url=url, headers=headers,
                          data=post_data, method="PUT")
    with request.urlopen(req) as f:
        status_code = f.code
        if status_code == 200:
            return True
        else:
            return False


def send_message(url, text, token):
    headers = {'Accept': 'application/json', 'Authorization': (
        'Bearer ' + token), 'Content-Type': 'application/x-www-form-urlencoded'}
    data = {'text': text}
    respose_data = (requests.post(url, data, headers=headers)).json()
    print (respose_data)
    try:
        if respose_data["success"] == True:
            return True
        else:
            return False
    except:
        return False


if __name__ == "__main__":

    if auth_data != None:
        use_old_token = False
        arg_parser = create_arg_parser()
        args = arg_parser.parse_args()
        access_token = get_auth_token(URL_AUTH, auth_data)
        if access_token != '':
            # try:
            #     token_time_limit = config_parser['Authorization']['time_limit']
            #     use_old_token = check_token_time(token_time_limit)
            # except:
            #     pass

            # if use_old_token:
            #     access_token = config_parser['Authorization']['access_token']
            # else:
            #     access_token = get_auth_token(URL_AUTH, auth_data)
            
            # Commmands
            if args.command == 'test_request':  # Test request
                access_token = get_auth_token(URL_AUTH, auth_data)
                response = get_data(URL_PROJECTS, access_token)
                set_clipboard_text(response[0]+separ+response[1])

            if args.command == 'get_catalog_tree':  # Get object of the catalog json data
                if args.params != '':
                    get_catalog_tree(args.params, access_token)

            if args.command == 'get_projects_tree':  # Get object json data
                if args.params != '':
                    get_projects_tree(args.params, access_token)
                    
            if args.command == 'get_users_tree':  # Get users json data
                if args.params != '':
                    get_users_tree(args.params, access_token)
                    
            if args.command == 'get_catalog_branch_ids':
                if args.params != '':
                    args_list = args.params.split(separ)
                    data = get_catalog_branch_ids(args_list[0], access_token)
                    if int(args_list[1]) == 1:
                        set_clipboard_text(data[0])
                    elif int(args_list[1]) == 2:
                        set_clipboard_text(data[1])
                    elif int(args_list[1]) == 3:
                        set_clipboard_text(data[2])

            if args.command == 'download_tasks':
                if args.params != '':
                    task_total_count = 0
                    task_download_count = 0
                    # try:
                    args_list = args.params.split(separ)
                    response_data = get_whole_catalog_branch(
                        args_list[0], access_token)
                    task_total_count = len(args_list)-2
                    for i in range(2, len(args_list)):
                        for item in response_data:
                            if item['article'] == args_list[i]:
                                save_path = os.path.join(
                                    args_list[1], args_list[0], args_list[i], 'Task')
                                save_file_suf = item['ref_photo_name'].split('.')[
                                    1]
                                save_file_name = item['article'] + \
                                    '.' + save_file_suf
                                resp = download_data(
                                    item['ref_photo'], save_path, save_file_name)
                                if resp == True:
                                    json_file = os.path.join(save_path, 'data.json')
                                    if os.path.exists(json_file):
                                        data = read_data_from_json(json_file)
                                        item['state'] = data['state']
                                        item['pivot'] = data['pivot']
                                    write_data_to_json(json_file, item)
                                mats_count = 0
                                for mat in item['finishing_materials']:
                                    save_file_suf = mat['ref_photo_name'].split('.')[
                                        1]
                                    save_file_name = mat['article'] + \
                                        '.' + save_file_suf
                                    resp_mats = download_data(
                                        mat['ref_photo'], save_path, save_file_name)
                                    if resp_mats == True:
                                        mats_count += 1
                                if mats_count == len(item['finishing_materials']):
                                    task_download_count += 1
                    # msg = f'Скачано заданий: {task_download_count} из {task_total_count}'
                    msg = str(task_download_count)
                    set_clipboard_text(f'{200}{separ}{msg}')
                    # except Exception:
                    #     set_clipboard_text(f'400{separ}Что-то пошло не так.')

            if args.command == 'upload_content':
                if args.params != '':
                    try:
                        args_list = args.params.split(separ)
                        articles = args_list[1].split(',')
                        files = args_list[2].split(',')
                        upload_count = 0
                        if args_list[0] == 'Catalog' and len(articles) != 0:
                            for i in range(len(articles)):
                                url = URL_CATALOG + '/' + articles[i]
                                uploaded_file = files[i]
                                resp = upload_files(
                                    url, CATALOG_ASSET_KEY, uploaded_file, access_token)
                                if resp:
                                    upload_count += 1
                        elif args_list[0] == 'Projects':
                            pass
                        # msg = f'Загружено заданий: {upload_count} из {len(articles)}'
                        msg = str(upload_count)
                        set_clipboard_text('200'+separ+msg)
                    except Exception:
                        set_clipboard_text(f'400{separ}Что-то пошло не так.')

            if args.command == 'erase_content':
                if args.params != '':
                    # try:
                    args_list = args.params.split(separ)
                    articles = args_list[1].split(',')
                    erased_count = 0
                    if args_list[0] == 'Catalog' and len(articles) != 0:
                        for i in range(len(articles)):
                            url = URL_CATALOG + '/' + articles[i]
                            data = {CATALOG_ASSET_KEY: ''}
                            resp = put_update(url, data, access_token)
                            if resp:
                                erased_count += 1
                    elif args_list[0] == 'Projects':
                        pass
                    # msg = f'Удалено заданий: {erased_count} из {len(articles)}'
                    msg = str(erased_count)
                    set_clipboard_text('200'+separ+msg)
                    # except Exception:
                    #     set_clipboard_text('400'+separ+'ERROR: Something went wrong.')

            if args.command == 'send_message':
                if args.params != '':
                    # Accepted arguments:
                    # 'reciver_id + separ2 + reciver_id + separ2... + separ + message + separ2 + message + separ2 ...'

                    rgs_list = args.params
                    txt_arr = rgs_list.split(separ)
                    ids = txt_arr[0].split(separ2)
                    msgs = txt_arr[1].split(separ2)
                    send = 0
                    code = 200
                    
                    for i in range(len(ids)):
                        url = URL_CHAT + '/' + ids[i]
                        resp = send_message(url, msgs[i], access_token)
                        if resp: 
                            send += 1
            
                    if send != len(ids):
                        code = 400
                        
                    set_clipboard_text(f'{code}{separ}{send}')
        else:
            code = 401
            set_clipboard_text(f'{code}')
