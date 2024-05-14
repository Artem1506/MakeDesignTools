
-- Расположение локальной базы MD
global MD_LIB_DIR = ""
global MD_CURRENT_PROJECT = ""
global MAX_UI_BG_COLOR = color 0 0 0
global PY_BUILTINS = Python.Import "builtins"
global data = PY_BUILTINS.dict()
global data_file = ""
MD_USERS_DATA_FILE = ""
MD_CATALOG_DATA_FILE = ""
MD_PROJECTS_DATA_FILE = ""
MD_DATA_DIR = ""
RESOURCES_DIR = ""
DECALS_DIR = ""
LIB_TRASH_DIR = ""

-- Основные директории
MAIN_DIR = pathConfig.removePathLeaf (getThisScriptFilename())
HTTP_CLIENT_DIR = pathConfig.appendPath MAIN_DIR "md_client"
DATA_DIR_NAME = "Data"
RESOURCES_DIR_NAME = "Resources"
DECALS_DIR_NAME = "Decals"
RESOURCES_DIR = pathConfig.appendPath MAIN_DIR "Resources"
DECALS_DIR = pathConfig.appendPath RESOURCES_DIR "Decals"

-- HTTP - клиент
HTTP_CLIENT_NAME = "md_client"
HTTP_CLIENT = pathConfig.appendPath HTTP_CLIENT_DIR (HTTP_CLIENT_NAME + ".exe")
HTTP_CLIENT_CONFIG_FILE = pathConfig.appendPath HTTP_CLIENT_DIR (HTTP_CLIENT_NAME + ".config")

-- Файл конфигурации MDT
MDT_CONFIG_FILE = pathConfig.appendPath MAIN_DIR "mdt.config"

-- Файлы для хранения данных
USERS_DATA_FILE_NAME = "md_users_data.json"
CATALOG_DATA_FILE_NAME = "_catalog_data.json"
PROJECTS_DATA_FILE_NAME = "md_projects_data.json"
MD_LIB_DATA_FILE = ""
TRASH_DIR_NAME = "Trash"
COMMON_DATA_FILE_NAME = "lib_data.json"
TASK_FILE_NAME = "task_data.json"
SAVED_FILE_NAME = "Saving"
TASK_MAT_NAME = "Material.mat"
TASK_ICON_NAME = "Decal.max"
ICON_TEMPLATE_FILE = pathConfig.appendPath RESOURCES_DIR "_decal_template_.max"

-- Файлы иконок
ICON_NO_PRVIEW_FILE = pathConfig.appendPath RESOURCES_DIR "mdt_no_preview.png"
ICON_MDT_FILE = pathConfig.appendPath RESOURCES_DIR "mdt_48.png"

-- Инфо
author = "Zaitsev Pavel"
version = "2.0"
-- DOCS_FILE = pathConfig.appendPath MAIN_DIR "mdt_help.pdf"
DOCS_FILE = "https://docs.google.com/document/d/14-jr4cs0WKgLgi4kcZE9rmL9bZ2LGde-TA1OQyfQ1Cs/edit#heading=h.ahx5rkfl52u"

-- Списки
STATES = #("None", "In_Work", "Check", "Done")
MD_CATEGS = #(#("Каталог объектов", "Проекты"), #("Catalog", "Projects"))
TASK_INNER_DIRS = #("Task", "InWork", "InWork/Saved")
MAIN_LIST_COLUMNS_1 = #("Article", "State", "Materials", "Group", "Trans", "Manager", "Content Maker")
ADD_LIST_COLUMNS_1 = #("Mat. Index", "Texture Count")
MAIN_LIST_COLUMNS_2 = #("Task ID")
ADD_LIST_COLUMNS_2 = #("Furniture Solutions")
SAVED_WORKS_LIST_COLUMNS = #("File Name", "Save Date")
TASK_PARAMS_LIST = #("Valid Tasks", "Invalid Tasks", "Completed Tasks")
PIVOT_POS_X = #("Back", "Center", "Front")
PIVOT_POS_Y = #("Left", "Center", "Right")
PIVOT_POS_Z = #("Bottom", "Center", "Top")
TEXTURES_SIFFIXES = #("_D.tga", "_M.tga", "_N.tga", "_SRM.tga", "_E.tga", "_SSS.tga", "_DECAL.tga", "_DP.tga")
HELPER_OBJECTS = #("_bbox_", "_arrow_", "_pivot_", "_decal_")
SELECTION_SET_NAMES = #("Left_side", "Right_side", "Front_side", "Back_side")
PACK_TEXTS_TYPES = #("SRM", "AORM")
CLR_PALETTE_1 = #(
    color 90 120 255,
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
MAIN_RLT_WIDTH = 240
MAIN_RLT_HEIGHT = 760
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
DN_CLR_INWORK = DN_Lib.dnColor 40 80 200 255
DN_CLR_BAD = DN_Lib.dnColor 205 92 92 255
DN_CLR_TEMP = DN_Lib.dnColor 119 136 153 255
DN_CLR_X = DN_Lib.dnColor 200 50 50 255
DN_CLR_OK = DN_Lib.dnColor 10 130 10 255
DN_CLR_TRANSP = DN_Lib.dnColor 0 0 0 255
DN_CLR_BG = DN_Lib.dnColor  30 30 30 255
DN_FNT_GRP = DN_Lib.Font 3 8.62 3
DN_CLR_COLUMN_BG = DN_Lib.dnColor 100 100 100 255
CLR_LINK = color 100 190 255
CLR_BBOX_MAIN = color 60 150 255
CLR_BBOX_ADD = color 255 100 50
CLR_BBOX_PIVOT = color 14 255 2
DEFAULT_LAYER = LayerManager.getLayer 0
DN_MAX_UI_CLR = undefined
mdt_temp_layer = "_mdt_temp_"
icon_temp_layer = "_decal_template_"
TRANS_POSTFIX = "_trans"
ICON_POSTFIX = "_decal"

-- Версия макса при экспорте в fbx
MAX_VERSION = 2018

-- http-клиента
URL_AUTH = "https://stanzza-api.aicrobotics.ru/api/auth/login"
URL_STORAGE = "https://stanzza-api.aicrobotics.ru/api/storage/upload"
URL_CATALOG = "https://stanzza-api.aicrobotics.ru/api/v1/catalog"
URL_PROJECTS = "https://stanzza-api.aicrobotics.ru/api/projects"
URL_CHAT = "https://stanzza-api.aicrobotics.ru/api/chat"
URL_USERS = "https://stanzza-api.aicrobotics.ru/api/chat/users"
SEPAR = "%"
SEPAR1 = ","
SEPAR2 = "$"

-- Диалоги
dlg_configure
dlg_check_tasks
dlg_pivot_params
dlg_load_work
dlg_export
dlg_request
dlg_edit_material

-- Роллауты
global rlt_mdt_content_maker
rlt_settings
rlt_catalog_info
rlt_catalog_tasks
rlt_catalog_general
rlt_catalog_tools
rlt_about

-- Базовые структуры
MD_Log
Client_Log
UI_Tooltips_Full
UI_Tooltips_Empty
MD_Tooltips
MD_Data
MD_UI
MD_BBox
MD_Callbacks
MD_Client
MD_Icon

global CheckExistTaskLayer
-- InitExistTextures
cur_view_tm = undefined
cur_view_type = undefined