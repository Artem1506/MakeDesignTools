# check_connection          Return: Message // Args: None
# test_request              Return: Message // Args: None
# get_catalog_tree          Return: catalog data json file (json) // Args: save_file_path
# get_projects_tree         Return: projects data json file (json) // Args: save_file_path
# get_users_tree            Return: users data json file (json) // Args: save_file_path
# get_catalog_branch_ids    Return: [valid_tasks_articles, invalid_tasks_articles, done_tasks_articles]  //  Args: section_article%index // Example: ( 01-01-001%2 )
# get_project_catalog       Return: List of all items in project's catalog (json), Task list for work (json), List of valid items for download (json) // Args: project_article%save_dir_path
# download_tasks            Return: Message // Args: categ_article%local_lib_catalog_dir%item_articles_list // Example: ('06-02-013%D:\MakeDesignLib\Catalog%06-02-013-001,06-02-013-005,06-02-013-010')
# upload_content            Return: Message // Args: category%item_article%file_path ( categories: "Catalog", "Project" ) // Example: ( Catalog%01-01-001-001%mesh_file=d:/Lib/Catalog/01-01-001/01-01-001-001/01-01-001-001.fbx )
# erase_content             Return: Message // Erase content fields. // Args: category%item_articles ( Catalog%01-01-001-001,02-02-002-002,... )
# send_message              Return: Message // Send messages for users. // Args: user_ids%messages ( 25,14%Message$Message )
# download_items_content    Return: Content files // Args: download_mode%item_articles%SaveDir // download_modes: 0-Skip, 1-Overwrite // (0%01-06-001-003,05-06-004-010,...%D:/MakeDesignLib/Catalog)

from datetime import datetime, timedelta
from re import split
import json
import requests
from urllib import request, parse
import argparse
from win32 import win32clipboard
import os
import winreg
import socket

# import ctypes

URL_AUTH = "https://stanzza-api.aicrobotics.ru/api/auth/login"
URL_STORAGE = "https://stanzza-api.aicrobotics.ru/api/storage/upload"
URL_CATALOG = "https://stanzza-api.aicrobotics.ru/api/v1/catalog"
URL_PROJECTS = "https://stanzza-api.aicrobotics.ru/api/projects"
URL_PROJECTS_CATALOG = "https://stanzza-api.aicrobotics.ru/api/projects/catalog"
URL_CHAT = "https://stanzza-api.aicrobotics.ru/api/chat"
URL_USERS = "https://stanzza-api.aicrobotics.ru/api/chat/users"
URL_ME = "https://stanzza-api.aicrobotics.ru/api/profile/me"
SEPAR = '%'
SEPAR1 = ','
SEPAR2 = '$'
STATES = ['None', 'In_Work', 'Check', 'Done']
TASK_FILE_NAME = 'task_data.json'
CATALOG_ASSET_PREV_KEY = 'asset_preview'
CATALOG_ASSET_MESH_KEY = 'asset_mesh'
CATALOG_ASSET_TEXS_KEY = 'asset_textures'
CATALOG_ASSET_DATA_KEY = 'asset_data'
CATALOG_ASSET_STATE_KEY = 'asset_state'
STATES = ['None', 'In_work', 'Check', 'Done']

md_var_path = winreg.OpenKeyEx(winreg.HKEY_CURRENT_USER, 'Environment')
login = (winreg.QueryValueEx(md_var_path, 'MD_USER_LOGIN'))[0]
password = (winreg.QueryValueEx(md_var_path, 'MD_USER_PASS'))[0]
auth_data = None

try:
    auth_data = {'login': login,
                'password': password,
                'fingerprint': 'fingerprint'}
except:
    pass

def check_connection():
    ip = socket.gethostbyname(socket.gethostname())
    if ip == "127.0.0.1":
        return False
    else:
        return True
    
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
            return str(auth_response_data['access_token'])
    except:
        return None

def create_arg_parser():
    ''' Return the 'ArgumentParser' class object '''

    arg_parser = argparse.ArgumentParser()
    
    # arg_parser.add_argument('command', nargs='?', default='download_tasks')
    # arg_parser.add_argument('params', nargs='?', default='06-01-002%D:\MakeDesignLib\Catalog%06-01-002-002')
    
    # arg_parser.add_argument('command', nargs='?', default='get_catalog_branch_ids')
    # arg_parser.add_argument('params', nargs='?', default='06-02-009%1')
    
    arg_parser.add_argument('command', nargs='?', default='')
    arg_parser.add_argument('params', nargs='?', default='')

    return arg_parser

def read_data_from_json(file_name):
    ''' Read json data file '''
    
    with open(file_name, 'r', encoding='utf-8') as js:
        return json.load(js)

def write_data_to_json(file_name, data):
    ''' Write json data to file '''
    dir = os.path.dirname(file_name)
    if not os.path.exists(dir):
        os.makedirs(dir)
    data = json.dumps(data)
    data = json.loads(str(data))
    with open(file_name, 'w', encoding='utf-8') as file:
        json.dump(data, file, indent=4, ensure_ascii=False,
                  separators=(',', ': '))
        
def parse_request_string(req_str):
    ''' String exaple : asset_preview=D:/Catalog/06-02-013-002_PREV.png, asset_mesh=D:/Catalog/06-02-013-002.fbx, ... 
        Return : {'asset_preview': 'D:/Catalog/06-02-013-002_PREV.png', 'asset_textures[]'=['D:/Catalog/T_06-02-013-002-01_D.tga', 'T_06-02-013-002-01_N.tga', ...] ...}
    '''
    str_list = req_str.split(',')
    result_dict = {}
    meshes_list = []
    textures_list = []
    
    for i in str_list:
        split_str = i.split('=')
        key = split_str[0]
        val = split_str[1]
        
        if key == CATALOG_ASSET_MESH_KEY:
            meshes_list.append(val)
            key += '[]'
            result_dict[key] = meshes_list
        elif key == CATALOG_ASSET_TEXS_KEY:
            textures_list.append(val)
            key += '[]'
            result_dict[key] = textures_list
        else:
            result_dict[key] = val
        
    return result_dict

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
        response_data.append('Успешно!')
        response_data.append(json.loads(response.read()))
    elif code == 401:
        response_data.append(str(code))
        response_data.append('Проблемы с авторизацией.')
        response_data.append(None)
    else:
        response_data.append('400')
        response_data.append('Что-то пошло не так :(')
        response_data.append(None)

    return response_data

def get_catalog_tree_old(save_file, token):
    ''' Returns a data tree for whole catalog '''
    ''' It takes some time '''

    response = get_data(URL_CATALOG, token)
    msg = ''
    data_out = []
    
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
        msg = response[1]+' Данные о каталоге объектов загружены.'
        write_data_to_json(save_file, data_out)
    else:
        msg = 'Не удалось загрузить данные о каталоге объектов.'
    
    set_clipboard_text(response[0]+SEPAR+msg)

    return data_out

def get_catalog_tree(save_file, token):
    msg = ''
    data_out = []
    response = get_data(URL_CATALOG, token)
    count = 0

    
    if response[0] == '200':
        response_data = response[2]['catalog']['children']
        
        for i in range(len(response_data)):

            response_2 = get_data(URL_CATALOG + '/' + response_data[i]['article'], token)
            
            if response_2[0] == '200':
                response_data_sub = response_2[2]['catalog']['children']
                
                for k in range(len(response_data_sub)):
                    response_3 = get_data(URL_CATALOG + '/' + response_data_sub[k]['article'], token)
                    
                    if response_3[0] == '200':
                        response_data_sub_sub = response_3[2]['catalog']['children']
                        
                        for j in range(len(response_data_sub_sub)):
                            count += 1
                            categ = {'Name':str(count),
                                    'Category':response_data[i]['name'] + ' [' + response_data_sub[k]['name'] +']',
                                    'SubCategory':response_data_sub_sub[j]['name'],
                                    'Article':response_data_sub_sub[j]['article']}
                            data_out.append(categ)
        msg = f'{response[1]} Данные о каталоге объектов загружены.'
        write_data_to_json(save_file, data_out)    
    else:
        msg = 'Не удалось загрузить данные о каталоге объектов.'  
    set_clipboard_text(response[0]+SEPAR+msg)   
            
def get_projects_tree(save_file, token):
    ''' Returns a data tree for whole projects '''
    ''' It takes some time '''

    response_data = get_data(URL_PROJECTS, token)
    msg = ''
    data_out = []
    
    if response_data[0] == '200':
        for item in response_data[2]['items']:
            dict = {}
            dict['name'] = item['name']
            dict['article'] = item['article']
            # dict['preview'] = item['preview']
            # dict['plan_source'] = item['plan']['source']
            # dict['plan_preview'] = item['plan']['preview']
            # dict['plan_name'] = item['plan']['name']
            # dict['items'] = []
            data_out.append(dict)
        msg = response_data[1]+' Данные о проектах загружены.'
        write_data_to_json(save_file, data_out)
    else:
        msg = 'Не удалось загрузить данные о проектах.'
    set_clipboard_text(response_data[0]+SEPAR+msg)
    
def is_valid_content_data (item, category='objects'):
    ''' Checking for uploaded content data in the "UE Asset" fields '''
    ''' categories : 'objects, finish_mats' '''
    ''' item example : response_data[2]['catalog']['children'][0] '''
    
    if category == 'objects':
        if item['asset_preview'] != None and item['asset_mesh'] != [] and item['asset_textures'] != [] and item['asset_data'] != None:
            return True
        else:
            return False
    elif category == 'finish_mats':
        if item['asset_preview'] != None and item['asset_textures'] != [] and item['asset_data'] != None:
            return True
        else:
            return False
    else:
        return False

def is_valid_task_data (item):
    ''' Checking that the fields for a task are filled in correctly '''
    
    val = 0
    bad_msg = 'Ошибка в позиции ' + item['article'] + ' (' + item['object'] +') :'
    base_category = item['article'].split('-')[0]
    
    if item['photo'] != []:
        val += 1
    else:
        bad_msg += 'Отсутствует фото референса. '
        
    if item['manufacturer_site'] != None:
        val += 1
    else:
        bad_msg += 'Не указан сайт производителя. '
        
    if base_category == '06' and item['size_width'] != None:
        val += 1
    elif base_category == '06' and item['size_width'] == None:
        bad_msg += 'Не указан ширина. '
        
    if base_category == '06' and item['size_depth'] != None:
        val += 1
    elif base_category == '06' and item['size_depth'] == None:
        bad_msg += 'Не указана глубина. '
        
    if base_category == '06' and item['size_height'] != None:
        val += 1
    elif base_category == '06' and item['size_height'] == None:
        bad_msg += 'Не указана высота. '
        
    if base_category == '06' and val == 5:
        return [True, ""]
    elif base_category != '06' and val == 2:
        return [True, ""]
    else:
        return [False, bad_msg]
    
def get_project_catalog(project_article, save_file, token):
    ''' Returns list of all catalog object articles into project'''
    
    url = f'{URL_PROJECTS_CATALOG}/{project_article}'
    msg = ''
    data_out = []
    valid_articles_data = []
    valid_tasks_data = []
    in_valid_tasks_data = []
    project_article = (os.path.basename(save_file)).split('_')[0]
    valid_articles_file = f'{os.path.dirname(save_file)}/{project_article}_articles.json'
    tasks_file = f'{os.path.dirname(save_file)}/{project_article}_tasks.json'
    
    name_count = 0
    msg = 'Не удалось загрузить данные.'
    set_clipboard_text('')
    response_data = get_data(url, token)
    
    if response_data[0] == '200':
        total_count = response_data[2]['catalog']['count']
        if total_count > 0:
            for item in response_data[2]['catalog']['children']:
                item_count = item['count']
                if item_count > 0:
                    item_article = item['article']
                    url2 = f'{url}/{item_article}'
                    response_data2 = get_data(url2, token)
                    
                    if response_data2[0] == '200':
                        total_count2 = response_data2[2]['catalog']['count']
                        if total_count2 > 0:
                            for item2 in response_data2[2]['catalog']['children']:
                                item_count2 = item2['count']
                                if item_count2 > 0:
                                    item2_article = item2['article']
                                    url3 = f'{url}/{item2_article}'
                                    response_data3 = get_data(url3, token)
                                    
                                    if response_data3[0] == '200':
                                        total_count3 = response_data3[2]['catalog']['count']
                                        if total_count3 > 0:
                                            for item3 in response_data3[2]['catalog']['children']:
                                                item_count3 = item3['count']
                                                if item_count3 > 0:
                                                    item3_article = item3['article']
                                                    url4 = f'{url}/{item3_article}'
                                                    response_data4 = get_data(url4, token)
                                                    if response_data4[0] == '200':
                                                        name_count += 1
                                                        valid_count = 0
                                                        in_valid_count = 0
                                                        valid_tasks_count = 0
                                                        in_valid_tasks_count = 0
                                                        
                                                        dict = {}
                                                        dict['Name'] = str(name_count)
                                                        dict['Category'] = (item['name'] + ' [' + item2['name'] + ']')
                                                        dict['SubCategory'] = item3['name']
                                                        dict['Article'] = item3['article']
                                                        dict['ValidContentCount'] = 0
                                                        dict['InValidContentCount'] = 0
                                                        dict['ValidTasksCount'] = 0
                                                        dict['InValidTasksCount'] = 0
                                                        dict['ValidContentArticles'] = []
                                                        dict['InValidContentArticles'] = []
                                                        dict['ValidTasksArticles'] = []
                                                        dict['InValidTasksArticles'] = []
                                                        
                                                        tasks_data = {}
                                                        tasks_data['ValidTasksArticles'] = []
                                                        tasks_data['InValidTasksArticles'] = []
                                                        valid_arr = []
                                                        iv_valid_arr = []
                                                        valid_tasks_arr = []
                                                        in_valid_tasks_arr = []
                                                        
                                                        for item4 in response_data4[2]['catalog']['children']:
                                                            # Текущая категория = материалы отделки?
                                                            categ = ''
                                                            if item['article'] == '01' and item['article'] == '02' and item['article'] == '03':
                                                                categ = 'finish_mats'
                                                            else:
                                                                categ = 'objects'
                                                                
                                                            if (is_valid_content_data (item4, category=categ)):
                                                                valid_count += 1
                                                                valid_arr.append(item4['article'])
                                                                dict['ValidContentArticles'] = valid_arr
                                                                valid_articles_data.append(item4)
                                                            else:
                                                                in_valid_count += 1
                                                                iv_valid_arr.append(item4['article'])
                                                                dict['InValidContentArticles'] = iv_valid_arr
                                                            
                                                            validation_result = is_valid_task_data (item4)  
                                                            if (validation_result[0]):
                                                                valid_tasks_count += 1
                                                                valid_tasks_arr.append(item4['article'])
                                                                dict['ValidTasksArticles'] = valid_tasks_arr
                                                                # valid_tasks_data.append(task_item_data)
                                                                valid_tasks_data.append(item4['article'])
                                                            else:
                                                                in_valid_tasks_count += 1
                                                                in_valid_tasks_arr.append(item4['article'])
                                                                dict['InValidTasksArticles'] = in_valid_tasks_arr
                                                                item_dict = {}
                                                                item_dict['article'] = item4['article']
                                                                item_dict['bad_message'] = validation_result[1]
                                                                in_valid_tasks_data.append(item_dict)
                                                            
                                                        dict['ValidContentCount'] = valid_count
                                                        dict['InValidContentCount'] = in_valid_count
                                                        dict['ValidTasksCount'] = valid_tasks_count
                                                        dict['InValidTasksCount'] = in_valid_tasks_count
                                                        tasks_data['ValidTasksArticles'] = valid_tasks_data
                                                        tasks_data['InValidTasksArticles'] = in_valid_tasks_data
                                                        
                                                        data_out.append(dict)
        if name_count != 0:
            msg = response_data[1]+' Данные об объектах проекта загружены.'
            write_data_to_json(save_file, data_out)
            write_data_to_json(valid_articles_file, valid_articles_data)
            write_data_to_json(tasks_file, tasks_data)
        else:
            msg = 'В каталоге проекта нет ни одной позиции.'
    else:
        msg = 'Не удалось загрузить данные.'
    set_clipboard_text(response_data[0]+SEPAR+msg)
    
def get_users_tree(save_file, token):
    
    response_data = get_data(URL_USERS, token)
    msg = ''
    data_out = []
    count = 0
    
    if response_data[0] == '200':
        for item in response_data[2]:
            count += 1
            dict = {}
            dict['Name'] = (str(count))
            dict['title'] = item['title']
            dict['user_id'] = item['user_id']
            dict['image'] = item['image']
            
            data_out.append(dict)
        msg = response_data[1]+' Данные о пользователях загружены.'
        write_data_to_json(save_file, data_out)
    else:
        msg = 'Не удалось загрузить данные о пользователях.'
    set_clipboard_text(response_data[0]+SEPAR+msg)
    
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
    url_branch = URL_PROJECTS_CATALOG + '/' + article
    response_data = get_data(url_branch, token)
    data = ""
    size_exist = False
    
    if response_data[0] == '200':
        for item in response_data[2]['catalog']['children']:
            date_time = (split(' ', item['date_create']))[1]
            obj_type_valid = False
            try:
                if item['size_width'] != None:
                    size_exist = True
            except:
                pass
            
            # Validate item
            validation_result = is_valid_task_data (item)  
            if (validation_result[0]):
                pass
            else:
                bad_data.append(item['article'] + SEPAR2 + date_time + SEPAR2 + validation_result[1] + SEPAR2 + item['userId'])
                
            # if item['photo'] != None and size_exist:
            if len(list(item['photo'])) > 0 and size_exist and item['photo']:
                url_mats_branch = URL_CATALOG + '/' + item['article']
                response_mats_data = get_data(url_mats_branch, token)
                if response_mats_data[0] == '200':
                    mats = response_mats_data[2]['catalog']['children']
                    
                    # Object type validation
                    # Type 1 (Simple. No finishing materials)
                    if (item['Suppliers_article'] != "0" or item['Suppliers_article'] != None) and item['tags'] == [] and mats == []:
                        obj_type_valid = True
                    # Type 2 (With tag. No finishing materials)
                    elif (item['Suppliers_article'] != "0" or item['Suppliers_article'] != None) and item['tags'] != [] and mats == []:
                        for t in item['tags']:
                            tag_parse = t.split('_')
                            if len(tag_parse) == 2 and tag_parse[0] == 'group':
                                obj_type_valid = True
                                break
                    # Type 3 (No basic price. With finishing materials)
                    elif (item['Suppliers_article'] == "0" or item['Suppliers_article'] == None) and item['tags'] == [] and mats != []:
                        mats_valid = 0
                        for mat in mats:
                            # if mat['name_part_object'] != None and mat['article_object'] != None and mat['name_material_finish'] != None and mat['Photo_Texts'] != [] and mat['finishing_components'] != None and mat['link'] != None and mat['unit_price'] != None:
                            if mat['article_object'] != None and mat['link'] != None and mat['Photo_Texts'] != []:
                                mats_valid += 1
                        if mats_valid == len(mats):
                            obj_type_valid = True
                        else:
                            # Bad task
                            bad_data.append(item['article'] + SEPAR2 + date_time + SEPAR2 +
                            "В материалах отделки некорректно заполнены некоторые поля ('Артикул материала', 'Фото/Текструры', 'Ссылка на материал' или 'Материал')." + SEPAR2 + item['userId'])
                    else:
                        # Bad task
                        bad_data.append(
                            item['article'] + SEPAR2 + date_time + SEPAR2 + "Позиция не соответствует ни одному из возможных типов объектов." + SEPAR2 + item['userId'])
                    
                    if obj_type_valid:
                        # Good task
                        good_data.append(item['article'] + SEPAR2 + date_time + SEPAR2 + "Готово для загрузки." + SEPAR2 + item['userId'])
                            # if item['asset_preview'] != None and item['asset_mesh'] != [] and item['asset_textures'] != [] and item['asset_data'] != None:
                        if item['asset_preview'] != None and item['asset_mesh'] != [] and item['asset_data'] != None and item['asset_state']['value'] == 'Check':
                            # Completed task
                            comp_data.append(item['article'] + SEPAR2 + date_time + SEPAR2 + "Готово для загрузки." + SEPAR2 + item['userId'])
            else:
                bad_data.append(item['article'] + SEPAR2 + date_time + SEPAR2 +
                "Отсутствует фото референса или не проставлены размеры." + SEPAR2 + item['userId'])

        good_data_str = str(convert_string_to_max_format(str(good_data)))
        bad_data_str = str(convert_string_to_max_format(str(bad_data)))
        comp_data_str = str(convert_string_to_max_format(str(comp_data)))
        # msg = f'Доступных для скачивания заданий: {len(good_data)}'
        msg = str(len(good_data))

        data = [
            (response_data[0] + SEPAR + msg + SEPAR + good_data_str),
            (response_data[0] + SEPAR + msg + SEPAR + bad_data_str),
            (response_data[0] + SEPAR + msg + SEPAR + comp_data_str)
        ]
    else:
        data = response_data[0]+SEPAR+response_data[1]

    return data


def get_catalog_branch_ids_old(article, token):
    ''' Return a list of task articles as a string '''
    ''' or an error message '''

    good_data = []
    bad_data = []
    comp_data = []
    url_branch = URL_CATALOG + '/' + article
    response_data = get_data(url_branch, token)
    data = ""
    size_exist = False
    
    if response_data[0] == '200':
        for item in response_data[2]['catalog']['children']:
            date_time = (split(' ', item['date_create']))[1]
            obj_type_valid = False
            try:
                if item['size_width'] != None:
                    size_exist = True
            except:
                pass
            
            # if item['photo'] != None and size_exist:
            if len(list(item['photo'])) > 0 and size_exist and item['photo']:
                url_mats_branch = URL_CATALOG + '/' + item['article']
                response_mats_data = get_data(url_mats_branch, token)
                if response_mats_data[0] == '200':
                    mats = response_mats_data[2]['catalog']['children']
                    
                    # Object type validation
                    if item['Suppliers_article'] != "0" and item['tags'] == [] and mats == []:
                        obj_type_valid = True
                    elif item['Suppliers_article'] != "0" and item['tags'] != [] and mats == []:
                        for t in item['tags']:
                            tag_parse = t.split('_')
                            if len(tag_parse) == 2 and tag_parse[0] == 'group':
                                obj_type_valid = True
                                break
                    elif item['Suppliers_article'] == "0" and item['tags'] == [] and mats != []:
                        mats_valid = 0
                        for mat in mats:
                            # if mat['name_part_object'] != None and mat['article_object'] != None and mat['name_material_finish'] != None and mat['Photo_Texts'] != [] and mat['finishing_components'] != None and mat['link'] != None and mat['unit_price'] != None:
                            if mat['Photo_Texts'] != []:
                                mats_valid += 1
                        if mats_valid == len(mats):
                            obj_type_valid = True
                        else:
                            # Bad task
                            bad_data.append(item['article'] + SEPAR2 + date_time + SEPAR2 +
                            "В материалах отделки некорректно заполнены некоторые поля (Название части объекта, Фото/Текструры, Материал или Цена)." + SEPAR2 + item['userId'])
                    else:
                        # Bad task
                        bad_data.append(
                            item['article'] + SEPAR2 + date_time + SEPAR2 + "Позиция не соответствует ни одному из возможных типов объектов." + SEPAR2 + item['userId'])
                    
                    if obj_type_valid:
                        # Good task
                        good_data.append(item['article'] + SEPAR2 + date_time + SEPAR2 + "Готово для загрузки." + SEPAR2 + item['userId'])
                            # if item['asset_preview'] != None and item['asset_mesh'] != [] and item['asset_textures'] != [] and item['asset_data'] != None:
                        if item['asset_preview'] != None and item['asset_mesh'] != [] and item['asset_data'] != None and item['asset_state']['value'] == 'Check':
                            # Completed task
                            comp_data.append(item['article'] + SEPAR2 + date_time + SEPAR2 + "Готово для загрузки." + SEPAR2 + item['userId'])
            else:
                bad_data.append(item['article'] + SEPAR2 + date_time + SEPAR2 +
                "Отсутствует фото референса или не проставлены размеры." + SEPAR2 + item['userId'])

        good_data_str = str(convert_string_to_max_format(str(good_data)))
        bad_data_str = str(convert_string_to_max_format(str(bad_data)))
        comp_data_str = str(convert_string_to_max_format(str(comp_data)))
        # msg = f'Доступных для скачивания заданий: {len(good_data)}'
        msg = str(len(good_data))

        data = [
            (response_data[0] + SEPAR + msg + SEPAR + good_data_str),
            (response_data[0] + SEPAR + msg + SEPAR + bad_data_str),
            (response_data[0] + SEPAR + msg + SEPAR + comp_data_str)
        ]
    else:
        data = response_data[0]+SEPAR+response_data[1]

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
                'finishing_materials': [],
                'state': item['asset_state']['value'],
                'pivot': [0.0 ,0.0 ,0.0],
                'tags': item['tags'],
                'userId':item['userId'],
                'userName':item['userName'],
                'asset_cm_id':item['asset_cm_id'],
                'asset_cm_name':item['asset_cm_name'],
                'size': [0.0 ,0.0 ,0.0],
                'size_trans': None
            }
            if len(list(item['photo'])) > 0:
                dict['ref_photo'] = item['photo'][0]['preview']
                dict['ref_photo_name'] = item['photo'][0]['name']

            try:
                w = str(item['size_width']).replace(',', '.')
                d = str(item['size_depth']).replace(',', '.')
                h = str(item['size_height']).replace(',', '.')
                dict['size'] = [float(w), float(d), float(h)]
            except:
                pass
            
            # Обеденные столы
            try:
                if item['kind'] == "раскладной":
                    w = str(item['size_trans_width']).replace(',', '.')
                    d = str(item['size_trans_depth']).replace(',', '.')
                    h = str(item['size_trans_height']).replace(',', '.')
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
                        # 'name_part_object': item['name_part_object'],
                        # 'finishing_components': item['finishing_components'],
                        'link': item['link']
                        # 'unit_price': item['unit_price']
                    }
                    try:
                        mats_dict['ref_photo'] = item['Photo_Texts'][0]['preview']
                        mats_dict['ref_photo_name'] = item['Photo_Texts'][0]['name']
                    except:
                        pass
                    mats.append(mats_dict)
                    
                dict['finishing_materials'] = mats
                data_out.append(dict)

    return data_out

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

def upload_file(url, key, uploded_file, token):
    headers = {'Accept': 'application/json', 'Authorization': ('Bearer ' + token)}
    uploaded_file_id = ''
    
    with open(uploded_file, 'rb') as f:
        files = {'file': f}
        upload_respose_data = (requests.post(URL_STORAGE, headers=headers, files=files)).json()
        uploaded_file_id = str(upload_respose_data['id'])
        update_headers = {'Accept': 'application/json', 'Authorization': ('Bearer ' + token), 'Content-Type': 'application/x-www-form-urlencoded'}
        data = {key: uploaded_file_id}
        update_respose_data = (requests.put(url, headers=update_headers, data=data)).json()

        if update_respose_data["success"] == True:
            return True
        else:
            return False

def upload_content(url, data_files, token):
    ''' data_result = {'asset_mesh[]': '1253', 'asset_mesh[]': '3055', ...} '''
    
    upload_headers = {'Accept': 'application/json', 'Authorization': ('Bearer ' + token)}
    update_headers = {'Accept': 'application/json', 'Authorization': ('Bearer ' + token), 'Content-Type': 'application/x-www-form-urlencoded'}
    uploaded_file_id = ''
    data_ids = {}
    meshes_list = []
    textures_list = []
    str_list = data_files.split(SEPAR1)
    
    for i in str_list:
        if i != '':
            split_str = i.split('=')
            key = split_str[0]
            file = split_str[1]
            
            with open(file, 'rb') as f:
                files = {'file': f}
                upload_respose_data = (requests.post(URL_STORAGE, headers=upload_headers, files=files)).json()
                uploaded_file_id = (str(upload_respose_data['id']))
                
                if key == CATALOG_ASSET_MESH_KEY:
                    meshes_list.append(uploaded_file_id)
                    key += '[]'
                    data_ids[key] = meshes_list
                elif key == CATALOG_ASSET_TEXS_KEY:
                    textures_list.append(uploaded_file_id)
                    key += '[]'
                    data_ids[key] = textures_list
                else:
                    data_ids[key] = uploaded_file_id
                
    update_respose = (requests.put(url, headers=update_headers, data=data_ids)).json()

    try:
        if update_respose["success"] == True:
            return True
        else:
            return False
    except:
        return False


def set_content_state (url, state, token):
    ''' Available states: [None, In_work, Check, Done] '''
    
    update_headers = {'Accept': 'application/json', 'Authorization': ('Bearer ' + token), 'Content-Type': 'application/x-www-form-urlencoded'}
    data_state = {CATALOG_ASSET_STATE_KEY:state}
    update_state_resp = (requests.put(url, headers=update_headers, data=data_state)).json()
    
    try:
        if update_state_resp["success"] == True:
            return True
        else:
            return False
    except:
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

    try:
        if respose_data["success"] == True:
            return True
        else:
            return False
    except:
        return False

if __name__ == "__main__":
    arg_parser = create_arg_parser()
    args = arg_parser.parse_args()
    connection = check_connection()
    # MessageBox = ctypes.windll.user32.MessageBoxW
    # MessageBox(None, 'Hello', 'Window title', 0)
    
    if args.command == 'check_connection':
        if connection:
            set_clipboard_text(f'200{SEPAR}Есть подключение к интернету.')
        else:
            set_clipboard_text(f'400{SEPAR}Отсутствует подключение к интернету.')     
    else:
        if connection:
            # set_clipboard_text('')
            access_token = get_auth_token(URL_AUTH, auth_data)
            if access_token:
                
                if args.command == 'test_request':
                    if access_token:
                        set_clipboard_text(f'200{SEPAR}Успешно! Соединение с базой MakeDesign установлено.')
                    else:
                        set_clipboard_text(f'401{SEPAR}Проблемы с авторизацией.')
                        
                elif args.command == 'get_catalog_tree':
                    access_token = get_auth_token(URL_AUTH, auth_data)
                    if args.params != '':
                        get_catalog_tree(args.params, access_token)
        
                elif args.command == 'get_projects_tree':
                    if args.params != '':
                        get_projects_tree(args.params, access_token)
                        
                elif args.command == 'get_project_catalog':
                    if args.params != '':
                        
                        args_list = args.params.split(SEPAR)
                        if len(args_list) == 2:
                            get_project_catalog(args_list[0], args_list[1], access_token)
                        else:
                            set_clipboard_text(f'400{SEPAR}Неверное кол-во аргументов.')  
                    else:
                        set_clipboard_text(f'400{SEPAR}Неверные аргументы запроса.')
                    
                elif args.command == 'get_users_tree':
                    if args.params != '':
                        get_users_tree(args.params, access_token)
                            
                elif args.command == 'get_catalog_branch_ids':
                    if args.params != '':
                        args_list = args.params.split(SEPAR)
                        data = get_catalog_branch_ids(args_list[0], access_token)
                        if int(args_list[1]) == 1:
                            set_clipboard_text(data[0])
                        elif int(args_list[1]) == 2:
                            set_clipboard_text(data[1])
                        elif int(args_list[1]) == 3:
                            set_clipboard_text(data[2])
                        
                elif args.command == 'download_tasks':
                    if args.params != '':
                        task_download_count = 0
                        args_list = args.params.split(SEPAR)
                        if len(args_list) == 3:
                            articles_list = args_list[2].split(SEPAR1)
                            if len(articles_list) != 0:
                                response_data = get_whole_catalog_branch(args_list[0], access_token)
                                for i in range(len(articles_list)):
                                    for item in response_data:
                                        if item['article'] == articles_list[i]:
                                            save_path = os.path.join(
                                                args_list[1], args_list[0], articles_list[i], 'Task')
                                            save_file_suf = item['ref_photo_name'].split('.')[
                                                1]
                                            save_file_name = item['article'] + \
                                                '.' + save_file_suf
                                            resp = download_data(
                                                item['ref_photo'], save_path, save_file_name)
                                            if resp == True:
                                                json_file = os.path.join(save_path, TASK_FILE_NAME)
                                                if os.path.exists(json_file):
                                                    data = read_data_from_json(json_file)
                                                    # item['state'] = data['state']
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
                                set_clipboard_text(f'{200}{SEPAR}{task_download_count}')
                        
                elif args.command == 'download_items_content':
                    ''' 1%01-06-001-003,05-06-004-010,...%D:/MakeDesignLib/Catalog '''
                    
                    if args.params != '':
                        args_list = args.params.split(SEPAR)
                        
                        if len(args_list) == 3:
                            download_mode = int(args_list[0])
                            articles = args_list[1].split(',')
                            save_dir = args_list[2]
                            download_items_count = 0
                            download_files_count = 0
                            
                            if len(articles) != 0:
                                start_time = datetime.now()
                                for article in articles:
                                    if article != '':
                                        categ_article = article.split('-')
                                        categ_article = categ_article[0]+'-'+categ_article[1]+'-'+categ_article[2]
                                        url = URL_CATALOG + '/' + categ_article
                                        response_data = get_data(url, access_token)
                                        
                                        if response_data[0] == '200':
                                            for item in response_data[2]['catalog']['children']:
                                                if item['article'] == article:
                                                    local_lib_dir = os.path.join(save_dir, categ_article, article)
                                                    
                                                    if (os.path.isdir(local_lib_dir) == False) or (os.path.isdir(local_lib_dir) == True and download_mode == 1):
                                                        if (download_data(item['asset_preview']['preview'], local_lib_dir, item['asset_preview']['name'])):
                                                            download_files_count += 1
                                                        for mesh in item['asset_mesh']:
                                                            if (download_data(mesh['url'], local_lib_dir, mesh['original_name'])):
                                                                download_files_count += 1
                                                        for tex in item['asset_textures']:
                                                            if (download_data(tex['url'], local_lib_dir, tex['original_name'])):
                                                                download_files_count += 1
                                                        if (download_data(item['asset_data'], local_lib_dir, (article + '.json'))):
                                                            download_files_count += 1
                                                        download_items_count += 1
                                        else:
                                            set_clipboard_text(f'{response_data[0]}{SEPAR}')
                                end_time = datetime.now()
                                if download_files_count != 0:
                                    time_result = end_time - start_time
                                else:
                                    time_result = 0         
                                set_clipboard_text(f'200{SEPAR}Загружено элементов: {download_items_count} Загружено всего файлов: {download_files_count} Время загрузки: {time_result}')
                            
                elif args.command == 'upload_content':
                    if args.params != '':
                        args_list = args.params.split(SEPAR)
                        if len(args_list) == 3:
                            resp = False
                            try:
                                article = args_list[1]
                                data_files = args_list[2]
                                msg = ''
                                if args_list[0] == 'Catalog' and article != '' and data_files != '':
                                    url = URL_CATALOG + '/' + article
                                    resp = upload_content(url, data_files, access_token)
                                    if resp:
                                        set_content_state (url, STATES[2], access_token)
                                        set_clipboard_text(f'200{SEPAR}Файлы контента для объекта {article} успешно загружены.')
                                    else:
                                        set_content_state (url, STATES[0], access_token)
                                        set_clipboard_text(f'0{SEPAR}Не все файлы были загружены. Что-то пошло не так :(')
                                elif args_list[0] == 'Projects':
                                    pass
                                else:
                                    msg = str(f'400{SEPAR}Неверный запрос.')
                                    set_clipboard_text(f'200{SEPAR}{msg}')
                            except Exception:
                                set_clipboard_text(f'0{SEPAR}Что-то пошло не так :(')
                        else:
                            set_clipboard_text(f'400{SEPAR}Неверный запрос.')
                    else:
                        set_clipboard_text(f'400{SEPAR}Неверный запрос.')
                        
                elif args.command == 'erase_content':
                    if args.params != '':
                        args_list = args.params.split(SEPAR)
                        if len(args_list) == 2:
                            articles = args_list[1].split(',')
                            erased_count = 0
                            if args_list[0] == 'Catalog' and len(articles) != 0:
                                for i in range(len(articles)):
                                    url = URL_CATALOG + '/' + articles[i]
                                    
                                    try:
                                        data = {CATALOG_ASSET_PREV_KEY:''}
                                        put_update(url, data, access_token)
                                        resp1 = True
                                    except:
                                        resp1 = False
                                        
                                    try:
                                        key = CATALOG_ASSET_MESH_KEY + '[]'
                                        data = {key:''}
                                        put_update(url, data, access_token)
                                        resp2 = True
                                    except:
                                        resp2 = False
                                        
                                    try:
                                        key = CATALOG_ASSET_TEXS_KEY + '[]'
                                        data = {key:''}
                                        put_update(url, data, access_token)
                                        resp3 = True
                                    except:
                                        resp3 = False
                                        
                                    try:   
                                        data = {CATALOG_ASSET_DATA_KEY:''}
                                        put_update(url, data, access_token)
                                        resp4 = True
                                    except:
                                        resp4 = False
                                        
                                    if resp1 and resp2 and resp3 and resp4:
                                        erased_count += 1
                                        set_content_state (url, STATES[0], access_token)
                                        
                                        msg = str(erased_count)
                                        set_clipboard_text(f'200{SEPAR}Поля контента у объекта {articles[i]} успешно очищены.')
                                    else:
                                        set_clipboard_text(f'400{SEPAR}Не все поля очищены.')
                            elif args_list[0] == 'Projects':
                                pass
                            else:
                                msg = str(f'400{SEPAR}Неверный запрос.') 
                                set_clipboard_text(f'200{SEPAR}{msg}')
                    else:
                        set_clipboard_text(f'400{SEPAR}Неверный запрос.')
                        
                elif args.command == 'send_message':
                    if args.params != '':
                        # Accepted arguments:
                        # 'reciver_id + separ2 + reciver_id + separ2... + separ + message + separ2 + message + separ2 ...'

                        rgs_list = args.params
                        txt_arr = rgs_list.split(SEPAR)
                        ids = txt_arr[0].split(SEPAR1)
                        msgs = txt_arr[1].split(SEPAR2)
                        send_num = 0
                        code = 200
                        
                        for i in range(len(ids)):
                            url = URL_CHAT + '/' + ids[i]
                            resp = send_message(url, msgs[i], access_token)
                            if resp: 
                                send_num += 1
                
                        if send_num != len(ids):
                            code = 400
                            
                        set_clipboard_text(f'{code}{SEPAR}Отправлено сообщений: {send_num}')                 
            else:
                set_clipboard_text(f'401{SEPAR}Проблемы с авторизацией.')
        else:
            set_clipboard_text(f'400{SEPAR}Отсутствует подключение к интернету.')
            
'''
def upload_file(url, key, uploded_file, token):
    headers = {'Accept':'application/json', 'Authorization':('Bearer '+ token)}
    files = {'file': open(uploded_file, 'rb')}
    upload_respose_data = (requests.post(URL_STORAGE, headers=headers, files=files)).json()
    uploaded_file_id = str(upload_respose_data['id'])
    update_headers = {'Accept':'application/json', 'Authorization':('Bearer ' + token), 'Content-Type':'application/x-www-form-urlencoded'}
    data = {key:uploaded_file_id}
    update_respose_data = (requests.put(url, headers=update_headers, data=data)).json()
    if update_respose_data["success"]==True:
        return True
    else:
        return False
'''            
            
'''   
                elif args.command == 'upload_content':
                    if args.params != '':
                        try:
                            args_list = args.params.split(SEPAR)
                            articles = args_list[1].split(',')
                            files = args_list[2].split(',')
                            upload_count = 0
                            if args_list[0] == 'Catalog' and len(articles) != 0:
                                for i in range(len(articles)):
                                    url = URL_CATALOG + '/' + articles[i]
                                    uploaded_file = files[i]
                                    resp1 = upload_file(url, CATALOG_ASSET_PREV_KEY, uploaded_file, access_token)
                                    # resp2 = upload_file(url, CATALOG_ASSET_MESH_KEY, uploaded_file, access_token)
                                    if resp1:
                                        upload_count += 1
                            elif args_list[0] == 'Projects':
                                pass
                            msg = str(upload_count)
                            set_clipboard_text(f'200{SEPAR}{msg}')
                        except Exception:
                            set_clipboard_text(f'400{SEPAR}Что-то пошло не так.')
'''