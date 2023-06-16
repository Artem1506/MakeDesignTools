
-- Расположение локальной базы MD
global MD_LIB_DIR = ""
global MAX_UI_BG_COLOR = ""
global PY_BUILTINS = Python.Import "builtins"
global data = PY_BUILTINS.dict()
global data_file = ""

-- Основные директории
MAIN_DIR = pathConfig.removePathLeaf (getThisScriptFilename())
MD_LIB_TRASH_DIR = ""
HTTP_CLIENT_DIR = pathConfig.appendPath MAIN_DIR "md_client"
DATA_DIR = pathConfig.appendPath MAIN_DIR "data"
SOURCE_DIR = pathConfig.appendPath MAIN_DIR "source"
SOURCE_ICONS_DIR = pathConfig.appendPath SOURCE_DIR "category_icons"

-- HTTP - клиент
HTTP_CLIENT_NAME = "md_client"
HTTP_CLIENT = pathConfig.appendPath HTTP_CLIENT_DIR (HTTP_CLIENT_NAME + ".exe")
HTTP_CLIENT_CONFIG_FILE = pathConfig.appendPath HTTP_CLIENT_DIR (HTTP_CLIENT_NAME + ".config")

-- Файл конфигурации MDT
MDT_CONFIG_FILE = pathConfig.appendPath MAIN_DIR "mdt.config"

-- Файлы для хранения данных
MD_USERS_DATA_FILE = pathConfig.appendPath DATA_DIR "md_users_data.json"
MD_CATALOG_DATA_FILE = pathConfig.appendPath DATA_DIR "md_catalog_data.json"
MD_PROJECTS_DATA_FILE = pathConfig.appendPath DATA_DIR "md_projects_data.json"
MD_LIB_DATA_FILE = ""
COMMON_DATA_FILE_NAME = "lib_data.json"
TASK_FILE_NAME = "data.json"
SAVED_FILE_NAME = "Saving"
TASK_MAT_NAME = "Material.mat"
TASK_ICON_NAME = "Icon.max"
ICON_TEMPLATE_FILE = pathConfig.appendPath SOURCE_DIR "_icon_template_.max"

-- Файлы иконок
ICON_NO_PRVIEW_FILE = pathConfig.appendPath SOURCE_DIR "mdt_no_preview.png"
ICON_MDT_FILE = pathConfig.appendPath SOURCE_DIR "mdt_48.png"

-- Инфо
author = "Зайцев Павел"
version = "1.0.0"
DOCS_FILE = pathConfig.appendPath MAIN_DIR "mdt_help.pdf"

-- Списки
STATES = #("None", "In_Work", "Check", "Done")
MD_CATEGS = #(#("Каталог объектов", "Проекты"), #("Catalog", "Projects"))
TASK_INNER_DIRS = #("Task", "InWork", "InWork/Saved")
MAIN_LIST_COLUMNS_1 = #("Article", "State", "Group", "Trans", "User")
ADD_LIST_COLUMNS_1 = #("Parts", "Material", "Textures")
MAIN_LIST_COLUMNS_2 = #("Task ID")
ADD_LIST_COLUMNS_2 = #("Furniture Solutions")
SAVED_WORKS_LIST_COLUMNS = #("File Name", "Save Date")
TASK_PARAMS_LIST = #("New", "Incorrect", "Completed", "Deleted")
PIVOT_POS_X = #("Back", "Center", "Front")
PIVOT_POS_Y = #("Left", "Center", "Right")
PIVOT_POS_Z = #("Bottom", "Center", "Top")
TEXTURES_SIFFIXES = #("_D.tga", "_M.tga", "_N.tga", "_ARD.tga", "_E.tga", "_SSS.tga", "_ICON.tga")
HELPER_OBJECTS = #("_bbox_", "_arrow_", "_pivot_", "_icon_")
SELECTION_SET_NAMES = #("Left_side", "Right_side", "Front_side", "Back_side")
CLR_PALETTE_1 = #(
    color 87 53 255,
    color 255 53 53,
    color 150 255 53,
    color 52 200 255,
    color 255 25 171,
    color 255 170 53,
    color 78 255 53,
    color 172 53 255,
    color 53 114 255,
    color 255 170 53,
    color 255 114 53,
    color 53 255 194)

ICON_THICKNESS = 0.4 -- Толщина декали в см
MAX_TEX_SIZE = 4096

-- Интерфейс
global MAX_CLRX_CONFIG_FILE = getIniSetting (getMAXIniFile()) "CuiConfiguration" "ColorFileName"
MAIN_RLT_WIDTH = 240
MAIN_RLT_HEIGHT = 800
CTRL_WIDTH_0 = MAIN_RLT_WIDTH - 24
CTRL_WIDTH_1 = MAIN_RLT_WIDTH - 12
CTRL_WIDTH_2 = (MAIN_RLT_WIDTH - 12)/2 - 2
CTRL_WIDTH_02 = (MAIN_RLT_WIDTH - 24)/2 - 2
CTRL_HEIGHT_1 = 22
CTRL_HEIGHT_2 = 32
PREVIEW_SIZE = MAIN_RLT_WIDTH - 12
SAVED_PREVIEW_SIZE = 384
CTRL_MANIP_SIZE = 29
V_MARGIN = -2
EMPTY_TEXT = "-----"
DN_CLR_DEFAULT = DN_Lib.dnColor 0 0 0 255
DN_CLR_DONE = DN_Lib.dnColor 0 128 0 255
DN_CLR_INWORK = DN_Lib.dnColor 10 50 150 255
DN_CLR_BAD = DN_Lib.dnColor 205 92 92 255
DN_CLR_TEMP = DN_Lib.dnColor 119 136 153 255
DN_CLR_X = DN_Lib.dnColor 200 50 50 255
DN_CLR_OK = DN_Lib.dnColor 10 130 10 255
DN_CLR_TRANSP = DN_Lib.dnColor 0 0 0 255
DN_CLR_BG = DN_Lib.dnColor  30 30 30 255
DN_FNT_GRP = DN_Lib.Font 3 8.62 2
CLR_LINK = color 100 190 255
CLR_BBOX_MAIN = color 60 150 255
CLR_BBOX_ADD = color 255 100 50
CLR_BBOX_PIVOT = color 14 255 2
DEFAULT_LAYER = LayerManager.getLayer 0
DN_MAX_UI_CLR = undefined
mdt_temp_layer = "_mdt_temp_"
icon_temp_layer = "_icon_template_"
TRANS_POSTFIX = "_trans"
ICON_POSTFIX = "_icon"

-- Версия макса при экспорте в fbx
MAX_VERSION = 2018

-- Разделители для задания параметров запуска утилиты "md_client.exe"
SEPAR_1 = "%"
SEPAR_2 = "$"

-- Диалоги
dlg_configure
dlg_check_tasks
dlg_pivot_params
dlg_load_work
dlg_export
dlg_request
dlg_load_textures

-- Роллауты
global rlt_make_design
rlt_settings
rlt_info_catalog
rlt_info_projects
rlt_tasks
rlt_general_catalog
rlt_general_projects
rlt_tools_catalog
rlt_about

-- Базовые структуры
MD_Log
Client_Log
MD_Tooltips
MD_Data
MD_UI
MD_BBox
MD_Callbacks
MD_Client
MD_Icon

global CheckExistTaskLayer
InitExistTextures
FullUpdate
cur_view_tm = undefined
cur_view_type = undefined