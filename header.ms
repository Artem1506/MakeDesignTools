
-- Расположение локальной базы MD
global MD_LIB_DIR = ""
global MAX_UI_BG_COLOR = ""
global PY_BUILTINS = Python.Import "builtins"

-- Основные директории
MAIN_DIR = pathConfig.removePathLeaf (getThisScriptFilename())
MD_LIB_TRASH_DIR = pathConfig.appendPath MD_LIB_DIR "trash"
ICONS_DIR = pathConfig.appendPath MAIN_DIR "icons"
HTTP_CLIENT_DIR = pathConfig.appendPath MAIN_DIR "http_client"
DATA_DIR = pathConfig.appendPath MAIN_DIR "data"

-- HTTP - клиент
HTTP_CLIENT = pathConfig.appendPath HTTP_CLIENT_DIR "md_requests.exe"
HTTP_CLIENT_CONFIG_FILE = pathConfig.appendPath HTTP_CLIENT_DIR "md_requests.config"

-- Файл конфигурации MDT
MDT_CONFIG_FILE = pathConfig.appendPath MAIN_DIR "mdt.config"

-- Файлы для хранения данных
MD_USERS_DATA_FILE = pathConfig.appendPath DATA_DIR "md_users_data.json"
MD_CATALOG_DATA_FILE = pathConfig.appendPath DATA_DIR "md_catalog_data.json"
MD_PROJECTS_DATA_FILE = pathConfig.appendPath DATA_DIR "md_projects_data.json"
MD_LIB_COMMON_DATA_FILE = pathConfig.appendPath MD_LIB_DIR "common_data.json"

-- Файлы иконок
ICON_NO_PRVIEW_FILE = pathConfig.appendPath ICONS_DIR "mdt_no_preview.png"
ICON_MDT_FILE = pathConfig.appendPath ICONS_DIR "mdt_48.png"

-- Инфо
author = "Зайцев Павел"
version = "1.0.0"
docs_file = pathConfig.appendPath MAIN_DIR "mdt_help.pdf"

-- Списки
STATES = #("None", "In_Work", "Check", "Done")
MD_CATEGS = #(#("Каталог объектов", "Проекты"), #("Catalog", "Projects"))
MAIN_LIST_COLUMNS_1 = #("Article", "State", "Group", "Trans", "User")
ADD_LIST_COLUMNS_1 = #("Parts", "Material", "D", "M", "N", "ARD")
MAIN_LIST_COLUMNS_2 = #("Task ID")
ADD_LIST_COLUMNS_2 = #("Furniture Solutions")
TASK_PARAMS_LIST = #("New Valid Only", "New Invalid Only", "Completed", "Deleted")
PIVOT_POS_X = #("Back", "Center", "Front")
PIVOT_POS_Y = #("Left", "Center", "Right")
PIVOT_POS_Z = #("Bottom", "Center", "Top")

-- Интерфейс
global MAX_CLRX_CONFIG_FILE = getIniSetting (getMAXIniFile()) "CuiConfiguration" "ColorFileName"
MAIN_RLT_WIDTH = 240
MAIN_RLT_HEIGHT = 800
CTRL_WIDTH_1 = MAIN_RLT_WIDTH - 12
CTRL_WIDTH_2 = (MAIN_RLT_WIDTH - 12)/2 - 2
CTRL_HEIGHT_1 = 22
CTRL_HEIGHT_2 = 32
PREVIEW_SIZE = MAIN_RLT_WIDTH - 12
SAVED_PREVIEW_SIZE = 384
V_MARGIN = -2
EMPTY_TEXT = "-----"
DN_CLR_DEFAULT = (dotNetClass "System.Drawing.Color").FromArgb 255 0 0 0
DN_CLR_DONE = (dotNetClass "System.Drawing.Color").FromArgb 255 0 128 0
DN_CLR_INWORK = (dotNetClass "System.Drawing.Color").FromArgb 255 0 0 255
DN_CLR_BAD = (dotNetClass "System.Drawing.Color").FromArgb 255 205 92 92
DN_CLR_TEMP = (dotNetClass "System.Drawing.Color").FromArgb 255 119 136 153
DN_CLR_X = (dotNetClass "system.Drawing.color").FromArgb 255 200 50 50
DN_CLR_OK = (dotNetClass "system.Drawing.color").FromArgb 255 10 130 10
dn_max_ui_bg_color = undefined
progress_dlg_title = ""
mdt_temp_layer = "_mdt_temp_"

-- Версия макса при экспорте в fbx
MAX_VERSION = 2018

-- Разделители для задания параметров запуска утилиты "md_requests.exe"
SEPAR_1 = "%"
SEPAR_2 = "$"

-- Роллауты
dlg_configure
dlg_check_tasks
dlg_pivot_params
dlg_load_work
dlg_validation
dlg_progress

global rlt_make_design
rlt_settings
rlt_info_catalog
rlt_info_projects
rlt_tasks
rlt_tools_catalog
rlt_tools_projects
rlt_about

-- Базовые структуры
MD_Log
MD_Tooltips
MD_Data
MD_UI
MD_BBox