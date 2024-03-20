import urllib.request 
import shutil
import os

url = 'https://stanzza-api.aicrobotics.ru/storage/upload/p8l/p8lLU3jUNatrlr5gu5uvmnGK7JkMTSaQNUDurG14.jpg'
direct_local_file = 'd:/ass2.jpg'

downloaded_file = (urllib.request.urlretrieve(url))[0]
path = shutil.copy(downloaded_file, direct_local_file)
os.remove(downloaded_file)
