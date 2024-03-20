import requests
import os
# from win32 import win32clipboard
# from subprocess import Popen, PIPE

data_url = 'https://stanzza-api.aicrobotics.ru/storage/upload/yn6/yn6QO6Z31lxiU9D9MmFVmJJTWtFXXKv452hZgceO.png'
save_path = 'd:/ass/save'
    
def download_data(data_url, save_path, file_name):

    os.makedirs(save_path, exist_ok=True)
    save_file = os.path.join(save_path, file_name)
    response = requests.get(data_url)
    with open(save_file, "wb") as f:
        f.write(response.content)
    if os.path.exists(save_file):  
        return True
    else:
        return False
    
input_1 = "42".replace(',', '.')

input_1 = float(input_1)

print(input_1)   
# print(download_data(data_url, save_path, "изображение_2023-01-13_134817290.png"))

# def  get_clipboard_text():
#     win32clipboard.OpenClipboard()
#     data = win32clipboard.GetClipboardData()
#     win32clipboard.CloseClipboard()
    
#     return data

# ass = get_clipboard_text().split('%')
# print(ass)

# print(download_data(data_url, ass[1], "изображение_2023-01-13_134817290.png"))