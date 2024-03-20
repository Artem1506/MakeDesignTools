import unreal
import os
import json
from pathlib import Path
# Список имён папок для исключения
excluded_names = [
	'Developers',
	'Collections',
	'Blueprints',
	'LUTs',
	'Maps',
	'Materials',
	'Textures',
	'FoliageTypes',
	'BaseContent',
	'Sound'
	]

included_names = [
	'Meshes'
	]

# Путь к системной папке MyDocuments
#my_documens_folder = os.path.expanduser(' \\Documents')

# self_path = os.path.dirname(os.path.dirname(__file__))
self_path = os.path.dirname(os.path.dirname(os.path.dirname(__file__)))
print(self_path)
data_path = self_path + '\\Data\\'
# Путь к общей директории StanzzaToolsDataFiles
#save_data_directory = my_documens_folder + '\\StanzzaToolsData\\'

# Путь файла json
#paths_data_file = save_data_directory + 'exp_paths.json'
paths_data_file = data_path + 'paths.json'

# Путь к папке Content текущего проекта UE
content_dir = unreal.Paths().project_content_dir()

# Фиксит разделители в путях
def FixSeparators(path, separ):
	path = path.replace(os.sep, separ)
	return path

# Возвращает список всех
def GetSubfolder(path):
	folders = [f[0] for f in list(os.walk(path)) if f[0] != path]
	# for i in range(len(folders)):
	# 	s = folders[i]
	# 	new_str = s.replace(os.sep, '/')
	# 	folders[i] = new_str
	return folders

# Исключает все папки, чьи имена имеются в списке excluded_names
def ExcludeFolder(path, ex):
	excl_dir = 0
	dir_base_name = os.path.basename(path)
	for i in ex:
		if i == dir_base_name:
			excl_dir = 1
	return excl_dir

# Преобразует абсолютные пути в относительные пути UE
def ConvertPath(path):
	new_path = ""
	split_path = path.split('/')
	m = 0
	for i in split_path:
		if i == 'Content' and m == 0:
			new_path += "/Game"
			m = 1
		elif i != 'Content' and m > 0:
			new_path += ('/' + i)
	return new_path

# Получает список всех папок в Content списка исключений
def GetContentFolders(path, filter_names_list = []):
	folders = []
	for i in filter_names_list:
		folders = [f.path for f in os.scandir(path) if f.is_dir() and (ExcludeFolder(f, filter_names_list)) == 0]
	for i in range(len(folders)):
		s = folders[i]
		new_str = s.replace(os.sep, '/')
		n = os.path.basename(new_str)
		if (ExcludeFolder(n, filter_names_list)) == 0:
			folders[i] = new_str
	for i in range(len(folders)):
		new_path = ConvertPath(folders[i])
		folders[i] = new_path
	return folders

# Получить список всех подпапок в BaseContent с учётом списка включений
# def GetBasicContentFolders(path, filter_names_list = []):
# 	basic_content_folders = []
# 	folders = GetSubfolder(path)
# 	for f in folders:
# 		f_name = os.path.basename(f)
# 		if (ExcludeFolder(f_name, filter_names_list)) != 0:
# 			basic_content_folders.append(FixSeparators(ConvertPath(f), '/'))
# 	return basic_content_folders

# Получить список всех подпапок в BaseContent с учётом списка включений
def GetBasicContentFolders(path):
	basic_content_folders = []
	folders = GetSubfolder(path)
	for f in folders:
		f_name = os.path.basename(f)
		basic_content_folders.append(FixSeparators(ConvertPath(f), '/'))
	return basic_content_folders

# Записывает данные в json файл
def WriteDataFile(data, filename):
	data = json.dumps(data)
	data = json.loads(str(data))
	with open(filename, 'w', encoding = 'utf-8') as file:
		json.dump(data, file, indent = 4)

def main():
	# Словарь, содержащий данные для загрузки в json формат
	data = {}

	with open(paths_data_file) as jf:
		data = json.load(jf)
	
	# dict_content_dirs['UnrealContentFolders'] = GetContentFolders(content_dir, excluded_names)
	data['ue_exist_projects_folders'] = GetContentFolders(content_dir, excluded_names)

	# dict_content_dirs['ue_basic_content_path'] = GetBasicContentFolders(content_dir + 'BaseContent', included_names)
	data['ue_basic_content_path'] = GetBasicContentFolders(content_dir + 'BaseContent')

	# Записываем данные в файл
	WriteDataFile(data, paths_data_file)
	unreal.log('Done! Data updating is finished.')

if __name__ == "__main__":
    main()