(
    units.DisplayType = #metric
    units.systemType = #centimeters
    units.MetricType = #centimeters

    clearListener()

    if ::rlt_make_design_tools == undefined OR ::rlt_make_design_tools.IsDisplayed == false then
    (
struct DotNetLib
(
	Pixel = (DotNetClass "System.Drawing.GraphicsUnit").Pixel ,
	ControlMousePos = (DotNetClass "System.Windows.Forms.Control").MousePosition ,
	Clipboard = DotNetClass "System.Windows.Forms.Clipboard" ,
	Keys = DotNetClass "System.Windows.Forms.Keys" ,
	Screen = (DotNetClass "System.Windows.Forms.Screen").PrimaryScreen ,
	ScreenWidth = Screen.Bounds.Width ,
	ScreenHeight = Screen.Bounds.Height ,
	MouseButtonLeft = (DotNetClass "System.Windows.Forms.MouseButtons").Left ,
	MouseButtonRight = (DotNetClass "System.Windows.Forms.MouseButtons").Right ,
	MouseButtonMiddle = (DotNetClass "System.Windows.Forms.MouseButtons").Middle ,
	MouseButtonNone = (DotNetClass "System.Windows.Forms.MouseButtons").None ,
	Flat = (DotNetClass "System.Windows.Forms.FlatStyle").Flat ,
	Popup = (DotNetClass "System.Windows.Forms.FlatStyle").Popup ,
	Standard = (DotNetClass "System.Windows.Forms.FlatStyle").Standard ,
	System = (DotNetClass "System.Windows.Forms.FlatStyle").System ,
	Fixed3D = (DotNetClass "System.Windows.Forms.BorderStyle").Fixed3D ,
	FixedSingle = (DotNetClass "System.Windows.Forms.BorderStyle").FixedSingle ,
	BorderNone = (DotNetClass "System.Windows.Forms.BorderStyle").None ,
	FormFixed3D = (DotNetClass "System.Windows.Forms.FormBorderStyle").Fixed3D ,
	FormFixedDialog = (DotNetClass "System.Windows.Forms.FormBorderStyle").FixedDialog ,
	FormFixedSingle = (DotNetClass "System.Windows.Forms.FormBorderStyle").FixedSingle ,
	FormFixedToolWindow = (DotNetClass "System.Windows.Forms.FormBorderStyle").FixedToolWindow ,
	FormNone = (DotNetClass "System.Windows.Forms.FormBorderStyle").None ,
	FormSizable = (DotNetClass "System.Windows.Forms.FormBorderStyle").Sizable ,
	FormSizableToolWindow = (DotNetClass "System.Windows.Forms.FormBorderStyle").SizableToolWindow ,
	GrowAndShrink = (DotNetClass "System.Windows.Forms.AutoSizeMode").GrowAndShrink ,
	GrowOnly = (DotNetClass "System.Windows.Forms.AutoSizeMode").GrowOnly ,
	BottomUp = (DotNetClass "System.Windows.Forms.FlowDirection").BottomUp ,
	LeftToRight = (DotNetClass "System.Windows.Forms.FlowDirection").LeftToRight ,
	RightToLeft = (DotNetClass "System.Windows.Forms.FlowDirection").RightToLeft ,
	TopDown = (DotNetClass "System.Windows.Forms.FlowDirection").TopDown ,
	Center = (DotNetClass "System.Windows.Forms.ImageLayout").Center ,
	None = (DotNetClass "System.Windows.Forms.ImageLayout").None ,
	Stretch = (DotNetClass "System.Windows.Forms.ImageLayout").Stretch ,
	Tile = (DotNetClass "System.Windows.Forms.ImageLayout").Tile ,
	BottomCenter = (DotNetClass "System.Drawing.ContentAlignment").BottomCenter ,
	BottomLeft = (DotNetClass "System.Drawing.ContentAlignment").BottomLeft ,
	BottomRight = (DotNetClass "System.Drawing.ContentAlignment").BottomRight ,
	MiddleCenter = (DotNetClass "System.Drawing.ContentAlignment").MiddleCenter ,
	MiddleLeft = (DotNetClass "System.Drawing.ContentAlignment").MiddleLeft ,
	MiddleRight = (DotNetClass "System.Drawing.ContentAlignment").MiddleRight ,
	TopCenter = (DotNetClass "System.Drawing.ContentAlignment").TopCenter ,
	TopLeft = (DotNetClass "System.Drawing.ContentAlignment").TopLeft ,
	TopRight = (DotNetClass "System.Drawing.ContentAlignment").TopRight ,
	Horizontal = (DotNetClass "System.Windows.Forms.Orientation").Horizontal ,
	Vertical = (DotNetClass "System.Windows.Forms.Orientation").Vertical ,
	MousePosition = (DotNetClass "System.Windows.Forms.Control").MousePosition ,
	Transp = (DotNetClass "System.Drawing.Color").Transparent,	
	fn Image bitmap_file = (DotNetClass "System.Drawing.Image").FromFile bitmap_file ,
	Cursor = DotNetClass "System.Windows.Forms.Cursor",
	fn dnColor r g b a = (DotNetClass "System.Drawing.Color").FromArgb a r g b ,
	fn Pad a b c d = DotNetObject "System.Windows.Forms.Padding" a b c d ,
	fn Pos x y = (DotNetObject "System.Drawing.Point" x y) ,
	fn Size w h = (DotNetObject "System.Drawing.Size" w h) ,
	fn Rect x y w h = (DotNetObject "System.Drawing.Rectangle" x y w h) ,
	fn Font family size style = 
	(
		fname
		fstyle
		case family of
		(
			0: (fname = "Microsoft Sans Serif")
			1: (fname = "Verdana")
			2: (fname = "Tahoma")
			3: (fname = "Arial")
			4: (fname = "Courier New")
			5: (fname = "Consolas")
			6: (fname = "Century Gothic")
			7: (fname = "Segoe UI Symbol")
			8: (fname = "Times New Roman")
		)
		case style of
		(
			1: (fstyle = (dotNetClass "System.Drawing.FontStyle").Regular)
			2: (fstyle = (dotNetClass "System.Drawing.FontStyle").Italic)
			3: (fstyle = (dotNetClass "System.Drawing.FontStyle").Bold)
		)
		dotNetObject "System.Drawing.Font" fname size fstyle
	) ,
	fn Bmap w h bitmap_file =
	(
		img = (DotNetClass "System.Drawing.Image").FromFile bitmap_file 
		dn_bitmap = DotNetObject "System.Drawing.Bitmap" w h
		graphic = (DotNetClass "System.Drawing.Graphics").FromImage dn_bitmap
		graphic.InterpolationMode = graphic.InterpolationMode.HighQualityBicubic
		graphic.PixelOffsetMode = graphic.PixelOffsetMode.highQuality
		graphic.DrawImage img 0 0 w h
		img.Dispose()
		dn_bitmap	
	) ,
	fn ResizeBmap new_w new_h dn_bitmap quality:1 =
	(
		new_bitmap = DotNetObject "System.Drawing.Bitmap" new_w new_h
		graphic = (DotNetClass "System.Drawing.Graphics").FromImage new_bitmap
		case quality of
		(
			0:
			(
				graphic.InterpolationMode = graphic.InterpolationMode.NearestNeighbor
				graphic.PixelOffsetMode = graphic.PixelOffsetMode.HighSpeed					
			)
			1:
			(
				graphic.InterpolationMode = graphic.InterpolationMode.HighQualityBicubic
				graphic.PixelOffsetMode = graphic.PixelOffsetMode.highQuality				
			)
		)
		graphic.DrawImage dn_bitmap 0 0 new_w new_h
		new_bitmap	
	) ,
	fn IconMaker w h bitmap_file icon_num =
	(
		img = (DotNetClass "System.Drawing.Image").FromFile bitmap_file
		bmp_icon = DotNetObject "System.Drawing.Bitmap" w h
		graphic = (DotNetClass "System.Drawing.Graphics").FromImage bmp_icon
		graphic.DrawImage img (Rect 0 0 img.Width img.Height) (Rect (w * icon_num) 0 img.Width img.Height) Pixel
		img.Dispose()
		bmp_icon
	) ,
	fn FillRectangle w h fill_color =
	(
		dn_bitmap = DotNetObject "System.Drawing.Bitmap" w h
		graphic = (DotNetClass "System.Drawing.Graphics").FromImage dn_bitmap
		fill_brush = dotnetobject "System.Drawing.SolidBrush" fill_color
		fill_rect = Rect 0 0 w h
		graphic.FillRectangle fill_brush fill_rect
		dn_bitmap
	) ,
	fn newForm n:"" w:200 h:200 bc:(Color 0 0 0 255) fc:(Color 220 220 220 255) =
	(
		ctrl = DotNetObject "System.Windows.Forms.Form"
		ctrl.Name = n
		ctrl.Margin = ctrl.Padding = Pad 0 0 0 0
		ctrl.Width = w
		ctrl.Height = h
		ctrl.BackColor = bc
		ctrl.ForeColor = bc
		ctrl.AllowTransparency = true
		ctrl.Topmost = false
		ctrl.ShowInTaskbar = false
		ctrl.StartPosition = (DotNetClass "System.Windows.Forms.FormStartPosition").CenterScreen
		ctrl
	) ,	
	fn newUserControl n:"" w:200 h:200 bc:(Color 0 0 0 255) fc:(Color 180 180 180 255) =
	(
		ctrl = DotNetObject "System.Windows.Forms.UserControl" 
		ctrl.Name = n
		ctrl.Margin = ctrl.Padding = Pad 0 0 0 0
		ctrl.Width = w
		ctrl.Height = h
		ctrl.BackColor = bc
		ctrl.ForeColor = bc
		ctrl
	) ,
	fn newPictureBox n:"" w:200 h:200 bc:(Color 0 0 0 255) fc:(Color 180 180 180 255) =
	(
		ctrl = DotNetObject "System.Windows.Forms.PictureBox"
		ctrl.Name = n
		ctrl.Margin = ctrl.Padding = Pad 0 0 0 0
		ctrl.Width = w
		ctrl.Height = h
		ctrl.BackColor = bc
		ctrl.ForeColor = bc
		ctrl
	) ,
	fn newFlowLayoutPanel n:"" w:200 h:200 bc:(Color 0 0 0 255) fc:(Color 180 180 180 255) =
	(
		ctrl = DotNetObject "System.Windows.Forms.FlowLayoutPanel"
		ctrl.Name = n
		ctrl.Margin = ctrl.Padding = Pad 0 0 0 0
		ctrl.Width = w
		ctrl.Height = h
		ctrl.BackColor = bc
		ctrl.ForeColor = bc
		ctrl
	) ,
	fn newSplitContainer n:"" w:200 h:200 bc:(Color 0 0 0 255) fc:(Color 180 180 180 255) =
	(
		ctrl = DotNetObject "System.Windows.Forms.SplitContainer"
		ctrl.Name = n
		ctrl.Margin = ctrl.Padding = Pad 0 0 0 0
		ctrl.Width = w
		ctrl.Height = h
		ctrl.BackColor = bc
		ctrl.ForeColor = bc
		ctrl
	) ,
	fn newLabel n:"" w:200 h:200 bc:(Color 0 0 0 255) fc:(Color 180 180 180 255) txt:"" =
	(
		ctrl = DotNetObject "System.Windows.Forms.Label"
		ctrl.Name = n
		ctrl.Margin = ctrl.Padding = Pad 0 0 0 0
		ctrl.Width = w
		ctrl.Height = h
		ctrl.BackColor = bc
		ctrl.ForeColor = fc
		ctrl.Text = txt
		ctrl.TextAlign = MiddleCenter
		ctrl.Font = Font 3 8 1
		ctrl
	)
)
DN_Lib = DotNetLib()
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
MAIN_DIR = pathConfig.removePathLeaf (getThisScriptFilename())
HTTP_CLIENT_DIR = pathConfig.appendPath MAIN_DIR "md_client"
DATA_DIR_NAME = "Data"
RESOURCES_DIR_NAME = "Resources"
DECALS_DIR_NAME = "Decals"
RESOURCES_DIR = pathConfig.appendPath MAIN_DIR "Resources"
DECALS_DIR = pathConfig.appendPath RESOURCES_DIR "Decals"
HTTP_CLIENT_NAME = "md_client"
HTTP_CLIENT = pathConfig.appendPath HTTP_CLIENT_DIR (HTTP_CLIENT_NAME + ".exe")
HTTP_CLIENT_CONFIG_FILE = pathConfig.appendPath HTTP_CLIENT_DIR (HTTP_CLIENT_NAME + ".config")
MDT_CONFIG_FILE = pathConfig.appendPath MAIN_DIR "mdt.config"
USERS_DATA_FILE_NAME = "md_users_data.json"
CATALOG_DATA_FILE_NAME = "_catalog_data.json"
PROJECTS_DATA_FILE_NAME = "md_projects_data.json"
MD_LIB_DATA_FILE = ""
TRASH_DIR_NAME = "Trash"
COMMON_DATA_FILE_NAME = "lib_data.json"
TASK_FILE_NAME = "task_data.json"
SAVED_FILE_NAME = "Saving"
TASK_MAT_NAME = "Material.mat"
TASK_ICON_NAME = "Icon.max"
ICON_TEMPLATE_FILE = pathConfig.appendPath RESOURCES_DIR "_icon_template_.max"
ICON_NO_PRVIEW_FILE = pathConfig.appendPath RESOURCES_DIR "mdt_no_preview.png"
ICON_MDT_FILE = pathConfig.appendPath RESOURCES_DIR "mdt_48.png"
author = "Zaitsev Pavel"
version = "2.0"
DOCS_FILE = "https://docs.google.com/document/d/14-jr4cs0WKgLgi4kcZE9rmL9bZ2LGde-TA1OQyfQ1Cs/edit#heading=h.ahx5rkfl52u"
STATES = #("None", "In_Work", "Check", "Done")
MD_CATEGS = #(#("Каталог объектов", "Проекты"), #("Catalog", "Projects"))
TASK_INNER_DIRS = #("Task", "InWork", "InWork/Saved")
MAIN_LIST_COLUMNS_1 = #("Article", "State", "Group", "Trans", "User")
ADD_LIST_COLUMNS_1 = #("Parts", "Material", "Textures")
MAIN_LIST_COLUMNS_2 = #("Task ID")
ADD_LIST_COLUMNS_2 = #("Furniture Solutions")
SAVED_WORKS_LIST_COLUMNS = #("File Name", "Save Date")
TASK_PARAMS_LIST = #("New Valid Tasks", "Incorrect Tasks", "Completed Tasks")
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
MAX_VERSION = 2018
URL_AUTH = "https://stanzza-api.aicrobotics.ru/api/auth/login"
URL_STORAGE = "https://stanzza-api.aicrobotics.ru/api/storage/upload"
URL_CATALOG = "https://stanzza-api.aicrobotics.ru/api/v1/catalog"
URL_PROJECTS = "https://stanzza-api.aicrobotics.ru/api/projects"
URL_CHAT = "https://stanzza-api.aicrobotics.ru/api/chat"
URL_USERS = "https://stanzza-api.aicrobotics.ru/api/chat/users"
SEPAR = "%"
SEPAR1 = ","
SEPAR2 = "$"
dlg_configure
dlg_check_tasks
dlg_pivot_params
dlg_load_work
dlg_export
dlg_request
dlg_load_textures
global rlt_make_design_tools
rlt_settings
rlt_catalog_info
rlt_projects_info
rlt_catalog_tasks
rlt_projects_tasks
rlt_catalog_general
rlt_projects_general
rlt_catalog_tools
rlt_about
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
InitExistTextures
cur_view_tm = undefined
cur_view_type = undefined
fn GetINISettings roll ini_file_path ini_tag onlyRollState:false include_list:#() exclude_list:#() =
(
	if onlyRollState == false then
	(
		controls = #()
		if include_list.count != 0 then (controls = include_list)
		else if exclude_list.count != 0 then (controls = for ctrl in roll.controls where (findItem include_list ctrl == 0) collect ctrl)
		else controls = roll.controls
		for ctrl in controls where ((classof ctrl) != GroupStartControl and (classof ctrl) != GroupEndControl and ctrl.name != "author") do
		(
			case (classof ctrl) of
			(
				colorpickerControl:(ctrl.color = execute (getINISetting ini_file_path ini_tag (ctrl.name + "_color")))
				CheckBoxControl:(ctrl.checked = execute (getINISetting ini_file_path ini_tag (ctrl.name + "_checked")))
				CheckButtonControl:(ctrl.checked = execute (getINISetting ini_file_path ini_tag (ctrl.name + "_checked")))
				SpinnerControl:(ctrl.value = execute (getINISetting ini_file_path ini_tag (ctrl.name + "_value")))
				ComboBoxControl:(ctrl.selection = execute (getINISetting ini_file_path ini_tag (ctrl.name + "_selection")))
				listboxControl:(ctrl.selection = execute (getINISetting ini_file_path ini_tag (ctrl.name + "_selection")))
				RadioControl:(ctrl.state = execute (getINISetting ini_file_path ini_tag (ctrl.name + "_state")))
				EdittextControl:(ctrl.text = getINISetting ini_file_path ini_tag (ctrl.name + "_text"))
				LabelControl:(ctrl.text = getINISetting ini_file_path ini_tag (ctrl.name + "_text"))
				SubRollout:(ctrl.pos = getINISetting ini_file_path ini_tag (ctrl.name + "_text"))
				dotNetControl:(
					if ctrl.SelectedItems.Count != 0 then
					ctrl.SelectedItems.Item[0].Index = execute (getINISetting ini_file_path ini_tag (ctrl.name + "_selection"))
				)
			)
			ctrl.enabled = execute (getINISetting ini_file_path ini_tag (ctrl.name + "_enabled"))
		)
	)
	roll.open = execute (getINISetting ini_file_path roll.name "opened")
)
fn SetINISettings roll ini_file_path ini_tag onlyRollState:false include_list:#() exclude_list:#() =
(
    setIniForceUTF16Default False
	if onlyRollState == false then
	(
		controls = #()
		if include_list.count != 0 then (controls = include_list)
		else if exclude_list.count != 0 then (controls = for ctrl in roll.controls where (findItem include_list ctrl == 0) collect ctrl)
		else controls = roll.controls
		for ctrl in controls do
		(
			case (classof ctrl) of
			(
				colorpickerControl:(setINISetting ini_file_path ini_tag (ctrl.name + "_color") (ctrl.color as string))
				CheckBoxControl:(setINISetting ini_file_path ini_tag (ctrl.name + "_checked") (ctrl.checked as string))
				CheckButtonControl:(setINISetting ini_file_path ini_tag (ctrl.name + "_checked") (ctrl.checked as string))
				SpinnerControl:(setINISetting ini_file_path ini_tag (ctrl.name + "_value") (ctrl.value as string))
				ComboBoxControl:(setINISetting ini_file_path ini_tag (ctrl.name + "_selection") (ctrl.selection as string))
				listboxControl:(setINISetting ini_file_path ini_tag (ctrl.name + "_selection") (ctrl.selection as string))
				RadioControl:(setINISetting ini_file_path ini_tag (ctrl.name + "_state") (ctrl.state as string))
				EdittextControl:(setINISetting ini_file_path ini_tag (ctrl.name + "_text") ctrl.text)
				LabelControl:(setINISetting ini_file_path ini_tag (ctrl.name + "_text") ctrl.text)
				SubRollout:(setINISetting ini_file_path ini_tag (ctrl.name + "_text") (ctrl.pos as string))
				dotNetControl:(
					if ctrl.SelectedItems.Count != 0 then
					setINISetting ini_file_path ini_tag (ctrl.name + "_selection") (ctrl.SelectedItems.Item[0].Index as string)
				)
			)
			setINISetting ini_file_path ini_tag (ctrl.name + "_enabled") (ctrl.enabled as string)
		)
	)
	setINISetting ini_file_path roll.name "opened" (roll.open as string)
)
fn ReadDataFile data_file =
(
    ::data_file = data_file
    ::data = undefined
    local py_code = ""
    py_code += "import json" + "\n"
    py_code += "import pymxs" + "\n"
    py_code += "rt = pymxs.runtime" + "\n"
    py_code += "with open(rt.data_file, 'r', encoding='utf-8') as f:" + "\n"
    py_code += "    rt.data = json.load(f)"
    try (python.Execute py_code)
    catch ()
)
fn WriteDataFile data_file =
(
    ::data_file = data_file
    local py_code = ""
    py_code += "import json" + "\n"
    py_code += "import pymxs" + "\n"
    py_code += "rt = pymxs.runtime" + "\n"
    py_code += "def WriteDataFile(data, filename):" + "\n"
    py_code += "\t" + "data = json.dumps(data)" + "\n"
    py_code += "\t" + "data = json.loads(str(data))" + "\n"
    py_code += "\t" + "with open(filename, 'w', encoding = 'utf-8') as f:" + "\n"
    py_code += "\t\t" + "json.dump(data, f, indent = 4, ensure_ascii = False, separators = (',', ': '))" + "\n"
    py_code += "WriteDataFile(rt.data, rt.data_file)"
    try (python.Execute py_code)
	catch ()
)
fn hex_to_rgb hex_value =
(
	local hex = trimLeft (hex_value as string) "#"
	local rgb_arr = for k = 0 to 2 collect (bit.hexasint (substring hex (1 + 2*k) 2))
    
	return (color rgb_arr[3] rgb_arr[2] rgb_arr[1])
)
fn get_max_ui_bg_color =
(
	MAX_UI_BG_COLOR = color 0 0 0
	global MAX_CLRX_CONFIG_FILE = getIniSetting (getMAXIniFile()) "CuiConfiguration" "ColorFileName"
	if MAX_CLRX_CONFIG_FILE != "" then
	(
		py_code = "import pymxs" + "\n"
		py_code += "import xml.etree.ElementTree as ET" + "\n"
		py_code += "rt = pymxs.runtime" + "\n"
		py_code += "tree = ET.parse(rt.MAX_CLRX_CONFIG_FILE)" + "\n"
		py_code += "root = tree.getroot()" + "\n"
		py_code += "for item in root.iter('color'):" + "\n"
		py_code += "\t" + "item_attr_list = list(item.attrib.values())" + "\n"
		py_code += "\t" + "if item_attr_list[2] == 'Background Odd':" + "\n"
		py_code += "\t\t" + "rt.MAX_UI_BG_COLOR = item_attr_list[1]"
		python.Execute py_code
		MAX_UI_BG_COLOR = hex_to_rgb MAX_UI_BG_COLOR		
	)
	MAX_UI_BG_COLOR
)
fn SetUserEnvVar var val =
(
    ::var = var
    ::val = val
    ::result = ""
    py_code = "import pymxs" + "\n"
    py_code += "import winreg" + "\n"
	py_code += "rt = pymxs.runtime" + "\n"
	py_code += "key = winreg.CreateKey(winreg.HKEY_CURRENT_USER, \"Environment\")" + "\n"
	py_code += "winreg.SetValueEx(key, rt.var, 1, winreg.REG_SZ, rt.val)" + "\n"
	py_code += "if key:" + "\n"
	py_code += "\t" + "winreg.CloseKey(key)" + "\n"
	py_code += "\t" + "rt.result = rt.val" + "\n"
	py_code += "else:" + "\n"
	py_code += "\t" + "rt.result = \"\"" + "\n"
	python.Execute py_code
    return result
)
fn GetUserEnvVar var =
(
    ::var = var
    ::result = ""
    py_code = "import pymxs" + "\n"
	py_code += "import winreg" + "\n"
    py_code += "rt = pymxs.runtime" + "\n"
	py_code += "md_var_path = winreg.OpenKeyEx(winreg.HKEY_CURRENT_USER, \"Environment\")" + "\n"
	py_code += "rt.result = (winreg.QueryValueEx(md_var_path, rt.var))[0]" + "\n"
	python.Execute py_code
    return result
)
fn GetTimeStamp format:#all seconds:true =
(
	::time_stamp = ""
	py_code = ""
	py_code += "import pymxs" + "\n"
	py_code += "from datetime import datetime" + "\n"
	py_code += "rt = pymxs.runtime" + "\n"
	py_code += "now = datetime.now()" + "\n"
	case format of
	(
		#all:(
			case seconds of
			(
				true:(py_code += "rt.time_stamp = now.strftime(\"%d/%m/%Y %H:%M:%S\")")
				false:(py_code += "rt.time_stamp = now.strftime(\"%d/%m/%Y %H:%M\")")
			)
		)
		#time:(
			case seconds of
			(
				true:(py_code += "rt.time_stamp = now.strftime(\"%H:%M:%S\")")
				false:(py_code += "rt.time_stamp = now.strftime(\"%H:%M\")")
			)
		)
		#date:(py_code += "rt.time_stamp = now.strftime(\"%d/%m/%Y\")")
	)
	python.Execute py_code
	return time_stamp
)
fn ConvertValueToSystemUnits input_units val = 
(
	local factor = case units.systemType of
	(
		#Millimeters: 1.0
		#Centimeters: 0.1
		#Meters: 0.001
		#Kilometers: 0.000001
	)
	local shift = case input_units of
	(
		#mm: 1.0
		#cm: 10.0
		#m: 100.0
		#km: 100000.0
	)
	return (val*factor*shift)
)
fn ConvertSysUnitsToCentimeters val = 
(
	local factor = case units.systemType of
	(
		#inches:2.54
		#Millimeters: 0.1
		#Centimeters: 1.0
		#Meters: 100.0
		#Kilometers: 100000.0
	)
	return (val*factor)
)
fn ConvertCentimeterToSysUnits val = 
(
	local factor = case units.systemType of
	(
		#inches:2.54
		#Millimeters: 0.1
		#Centimeters: 1.0
		#Meters: 100.0
		#Kilometers: 100000.0
	)
	return (val/factor)
)
fn GetAllLayerNodes layer_name =
(
	local layer = LayerManager.getLayerFromName layer_name
	local nodes = #()
	if layer != undefined then
	(
		local num_sub_layers = layer.getNumChildren()
		
		layer.nodes &nodes
		if num_sub_layers != 0 then
		(
			for i = 1 to num_sub_layers do
			(
				local sl = layer.getChild i
				local arr = #()
				sl.nodes &arr
				join nodes arr
			)		
		)
	)
	nodes
)
fn DeleteAllSubLayers layer_name =
(
	local layer = LayerManager.getLayerFromName layer_name
	local num_sub_layers = layer.getNumChildren()
	local sub_layers = #()
	if num_sub_layers != 0 then
	(
		for i = 1 to num_sub_layers do
		(
			local sl = layer.getChild i
			append sub_layers sl
		)
		for sl in sub_layers do (LayerManager.deleteLayerByName sl.name)
	)
)
fn CreatePreviewFromImageFile img_file max_size fill_bg:true bg_color:DN_CLR_BG type:#max =
(
	local clipboard = dotnetclass "Clipboard"
	local img
	local source_size = #()
	local target_size = #()
	local fill_brush
	if classof img_file == BitMap then
	(
		setclipboardBitmap img_file
		img = clipboard.GetImage()
	)
	else if classof img_file == String then
	(
		img = (DotNetClass "System.Drawing.Image").FromFile img_file
	)
	source_size = #(img.width, img.height)
    aspect = ((amin source_size) as float)/((amax source_size) as float)
	if aspect == 1.0 then 
	(
		target_size[1] = max_size
		target_size[2] = max_size
	)
	else
	(
		target_size[findItem source_size (amax source_size)] = max_size
		target_size[findItem source_size (amin source_size)] = (max_size * aspect) as integer
	)
    bm_target = DotNetObject "System.Drawing.Bitmap" max_size max_size
    graphic = (DotNetClass "System.Drawing.Graphics").FromImage bm_target
    graphic.CompositingQuality = graphic.CompositingQuality.HighSpeed
    graphic.InterpolationMode = graphic.InterpolationMode.Default
    graphic.PixelOffsetMode = graphic.PixelOffsetMode.None
	if fill_bg == true then
	(
		fill_brush = dotnetobject "System.Drawing.SolidBrush" DN_CLR_BG
		graphic.FillRectangle fill_brush 0 0 max_size max_size
	)
	else
	(
		fill_brush = dotnetobject "System.Drawing.SolidBrush" DN_CLR_TRANSP
		graphic.FillRectangle fill_brush 0 0 max_size max_size
	)
    graphic.DrawImage img ((max_size - target_size[1])/2) ((max_size - target_size[2])/2) target_size[1] target_size[2]
    img.Dispose()
    clipboard.SetImage bm_target
	if type == #dotnet then bm = bm_target
	else bm = getclipboardBitmap()
	free source_size
	free target_size
    bm
)
fn save_nodes nodes max_file_path reset_trans:false = 
(
	local cur_sel_state = (selection as array)
	clearSelection()
	try(max_ver = (maxversion())[8] - 3)catch()
	saveNodes nodes max_file_path saveAsVersion:max_ver quiet:true
	select cur_sel_state
)
fn ViewportSnapshot save_file size auto_frame:true =
(
    local grab_bm
    if auto_frame then
    (
        local cur_tm = viewport.getTM()
        local cur_layout = viewport.getLayout()
        local active_view_num = viewport.activeViewport 
        local cur_view = viewport.getType()
        local show_edges = viewport.GetShowEdgeFaces()
        local rend_level = viewport.GetRenderLevel()
        local view_is_max = not (viewport.NumViews > 1)
        local bg_is_solid = viewport.IsSolidBackgroundColorMode()
        local tm = (matrix3 [0,0,1] [1,0,0] [0,1,0] [0.0,0.0,0.0])
    
        DisableSceneRedraw()
        if view_is_max == false then max tool maximize
        viewport.setType #view_persp_user
        viewport.SetShowEdgeFaces true
        viewport.SetRenderLevel #smoothhighlights
        viewport.EnableSolidBackgroundColorMode true
        viewport.setTM tm
        max tool zoomextents
        viewport.zoom 1.1
        
        enableSceneRedraw()
        completeredraw()
        DisableSceneRedraw()
        grab_bm = gw.getViewportDib gammaCorrect:false
        if view_is_max == false then max tool maximize
        viewport.setType cur_view
        viewport.SetShowEdgeFaces show_edges
        viewport.SetRenderLevel rend_level
    
        viewport.setTM cur_tm
        enableSceneRedraw()
        completeredraw()
    )
    else grab_bm = gw.getViewportDib gammaCorrect:false
    jpeg.setQuality 85
    local new_bm = CreatePreviewFromImageFile grab_bm size fill_bg:true
    new_bm.filename = save_file
	save new_bm gamma:1.0
	gc()
)
fn DeleteAllEmptyLayers =
(
	try
	(	
		_total_layers = layerManager.count - 1
		_layercount = #()
		_layercount = for i = 1 to _total_layers collect i
		_revlayers = #()
		for i in _layercount.count to 1 by -1 do append _revlayers _layercount[i]
		for j in _revlayers do
		(
			_getlayer = layerManager.getlayer j
			LayerManager.deleteLayerByName _getlayer.name
		)
	)
	catch()
)
fn GetMaterialIDList obj =
(
	local mat_ids = #()
	if classof obj == Editable_Poly then
	(
		for f = 1 to obj.numfaces do 
		appendifunique mat_ids (polyop.getFaceMatID obj f)		
	)
	else if classof obj == Editable_Mesh then
	(
		for f = 1 to obj.numfaces do 
		appendifunique mat_ids (getFaceMatID obj f)	
	)
	mat_ids
)
fn GetNumUVChannels obj = 
(
	local count = 0
	if classof obj == Editable_Poly then
	(
		for i in 1 to polyOp.getNumMaps obj do
		if polyOp.getMapSupport obj i then count += 1
	)
	else
	(
		if classof obj == editable_mesh then
		(
			for i in 1 to meshOp.getNumMaps obj do
			if meshOp.getMapSupport obj i then count += 1
		)
	)
	return count
)
fn Triangulate obj =
(
	local ttp_mod = Turn_to_Poly limitPolySize:on maxPolySize:3
	addModifier obj ttp_mod
)
fn SetFBXSettings =
(
	FbxExporterSetParam "SmoothingGroups" true
	FbxExporterSetParam "ConvertUnit" "cm"
	FbxExporterSetParam "TangentSpaceExport" true
)
fn ExportToFBX objs fbx_file_path =
(
    local sel_arr = #()
    local obj = undefined
    local copies = #()
    for n in objs do
    (
        append sel_arr n.isSelected
        obj = copy n
        append copies obj
        Triangulate obj
        obj.name = n.name
		ResetXForm obj
		collapseStack obj
		obj.transform = matrix3 1
    )
    clearSelection()
    select copies
    SetFBXSettings()
    exportFile fbx_file_path #noPrompt selectedOnly:true using:fbxexp
    for i = 1 to sel_arr.count do
    (
        objs[i].isSelected = sel_arr[i]
    )
    delete copies
	gc()
)
fn SaveSelectedObjects nodes max_file_path = 
(
    local cur_sel_state = (selection as array)
    clearSelection()
    try(max_ver = (maxversion())[8] - 3)catch()
    saveNodes nodes max_file_path saveAsVersion:max_ver quiet:true
    select cur_sel_state
)
fn SetMatID obj id =
(
	if classof obj == Editable_Poly then
	(
		local sel_faces = polyop.getFaceSelection obj
		polyop.setFaceMatID obj sel_faces id
	)
	else if classof obj == Editable_Mesh then
	(
		local sel_faces = getFaceSelection obj
		try(for i in sel_faces do setFaceMatID obj i id; update obj)catch()
	)
)
fn WithoutRedraw foo params:#() =
(
	try
	(
		disableSceneRedraw()
		if params.count == 0 then foo()
		else
		(
			local cmd = foo as string
			cmd = trimRight cmd "()"
			
			for prm in params do
			(
				cmd += " "
				cmd += prm as string
			)
			execute cmd
		)
		
		enableSceneRedraw()
		completeRedraw()			
	)
	catch(
		enableSceneRedraw()
		completeRedraw()
	)
)
fn MoveVertsInNamedSet obj set_name offset = 
(
	for i in (obj.Verts[set_name] as BitArray) do
	(
		cur_pos = polyop.getvert obj i
		polyop.setvert obj i (cur_pos + offset)
	)
)
struct LogSys
(
	source = "",
	fn Info msg_text = (format "%_INFO: % | %\n" source (GetTimeStamp()) msg_text),
	fn Warning msg_text = (format "%_WARNING: % | %\n" source (GetTimeStamp()) msg_text),
	fn Error msg_text = (format "%_ERROR: % | %\n" source (GetTimeStamp()) msg_text)
)
struct UI_Tooltips
(
	settings_01_a = "ON - Показать габариты объекта. (Только если задание находится в состоянии \"In_Work\")",
	settings_01_b = "Цвет габаритного контейнера основного меша.",
	settings_01_c = "Цвет габаритного контейнера доп. меша.",
	settings_01_d = "Сбросить цвета абаритного контейнера до дефолтных значений.",
	settings_02 = "ON - При экспорте объекта его пивот автоматически выравняется с пивотом габаритного контейнера.\nOFF - Будет использовано текущее положение пивота.",
	settings_03 = "Каждый раз при сохранении промежуточного этапа работы создаётся превью.\nON - Автоматически будет подобран ракурс так, чтобы охватить все объекты на сцене.\nOFF - Будет использован текущий ракурс.",
	settings_04 = "Максимальное количество сохранений промежуточных этапов работы.\nПри достижении этого числа, ранее сохранённые файлы будут удаляться по мере добавления новых.",
	settings_05 = "При наличии ранее сохранённых рабочих файлов в текущем задании, будет автоматически загружен последний из них.",
	settings_06 = "Показать иконку для выбранной в данный момент категории.\nИконка - это объект, на основе которого при экспорте задания автоматически создаётся файл с изображением.\nЭто изображение необходимо для схематичного отображение объекта в UnrealEngine",
	tasks_01 = "Проверить наличие доступных заданий.",
	tasks_02_a = "Загрузить отмеченные задания и сохранить в локальную базу.",
	tasks_02_b = "Автоматическая разослать сообщения об ошибках.\nСообщения будут оправлены адресно для каждого отмеченного задания.",
	tasks_02_c = "Сделать бэкап отмеченных заданий.",
	tasks_02_d = "Восстановить удалённые задания.",
	tasks_02_e = "Обновить отмеченные задания в случае их изменений на удалённом сервере.",
	tasks_03_a = "Очистить текущий список заданий.",
	tasks_03_b = "Удалить отмеченные задания. При этом, если задание уже было в работе и имеются сохранённые этапы работы, то оно будет помещено в собственную корзину локальной базы. В дальнейшем это задание можно будет либо восстановить, либо полностью удалить.",
	tasks_04_a = "Взять выбранное задание в работу. При этом будет создан рабочий слой и все выбранные в данный момент обекты будут добавлены в него.",
	tasks_04_b = "Обновить состояние текущей работы.",
	tasks_05 = "Прекратить работу над текущем заданием. При этом ранее сохранённая работа останется, изменится лишь её состояние.",
	tasks_06 = "Назначить Material ID на выделенные полигоны, соответствующий порядковому номеру, выбранного в данный момент, элемента в списке материалов",
	tasks_07 = "Назначить текстуры на выбранный материал.",
	tools_cat_01 = "Добавить выделенные объекты в рабочий слой.",
	tools_cat_02 = "Установить опорную точку габаритного контейнера. Если в свитке \"Settings\" параметр \"Auto Pivot\" = ON, то при экспорте опорная точка объекта будет автоматически установлена в положение опорной точки габаритного контейнера.",
	tools_cat_03 = "Назначить материал. (Материал создаётся автоматически, при создании рабочего задания.)",
	tools_cat_04 = "Режим редактирования иконки.",
	tools_cat_05 = "Сохранить текущее состояние работы. Будут сохранены только те объекты, которые находятся на рабочем слое.",
	tools_cat_06_a = "Загрузить последнее сохранение.",
	tools_cat_06_b = "Открыть диалоговое окно со списком ранее сделанных сохранений.",
	tools_cat_07_a = "Указать выделенный в данный момент объект в качеств основного.\nОбъект будет переименован в соответствии с артикулом задания.",
	tools_cat_07_b = "Указать выделенный в данный момент объект в качестве дополнительного. Необходимо только если активное задание имеет значение в поле \"Trans\".\nОбъект будет переименован в соответствии с артикулом задания.",
	tools_cat_08 = "Переключиться между основным и дополнительным объектами.",
	tools_cat_09 = "Интерактивная проверка готовности задания.",
	tools_cat_10 = "Проверка задания и экспорт в локальную базу.",
	tools_cat_11_a = "Позать все объекты на сцене.",
	tools_cat_11_b = "Позать только объекты относящиеся к текущему заданию.",
	chk_01 = "Запросить список новых корректно составленных заданий.\nТакие задания имеют все необходимые данные и их можно брать в работу.",
	chk_02 = "Запросить список новых НЕкорректно составленных заданий.\nТакие задания нельзя брать в работу и загружать в локальную базу, но можно разослать составителям сообщения об ошибках.",
	chk_03 = "Запросить список ранее сделанных заданий.\nИх можно загрузить в локальную базу в случае если данные были потеряны или если эти задания выполнял другой пользватель.\nПри необходимости можно возобновить работу над заданиями после того как администратор изменит их состояние на \"None\".",
	chk_04 = "Запросить список ранее удалённых заданий, хранящихся в корзине локальной базы.",
	val_exp_01 = "На рабочем слое должен быть только один объект (Main Mesh), за исключением тех случаев, когда задание имеет значение в поле Trans. В таких случаях на слое должен так же располагаться дополнительный объект (Additional Mesh), представляющий основной объект в трансформированном виде.",
	val_exp_02 = "Тип геометрии должен быть Editable Poly или Editable Mesh.",
	val_exp_03 = "Габаритные размеры объекта(ов) должны соответствовать указанным в задании. Так же он должен располагаться так, чтобы не выходить за границы вспомогательного габаритного контейнера.",
	val_exp_04 = "На объект(ы) должен быть назначен корректный материал. Материал создаётся автоматически при создании рабочего состояния и назначается на объект(ы) при указании его в качестве основного или вспомагательного меша.",
	val_exp_05 = "Количество Material ID должно соответствовать количеству элементов в списке матералов.",
	val_exp_06 = "Объект(ы) должны иметь минимум два канала UV развёртки."
)
struct TaskMaterial
(
	Article = undefined,
	PartName = undefined,
	Material = undefined,
    RefFile = undefined,
	texture_d = undefined,
	texture_m = undefined,
	texture_n = undefined,
	texture_ard = undefined,
	textures = #(texture_d, texture_m, texture_n, texture_ard),
	RefBitmap = undefined,
	WebSite = undefined
)
struct Task
(
	File = undefined,
	Article = undefined,
	DateCreate = undefined,
	Object = undefined,
	WebSite = undefined,
	Materials = #(),
	Material = undefined,
	MatLib = undefined,
	State = STATES[1],
	Pivot = undefined,
	Group = undefined,
	UserId = undefined,
	UserName = undefined,
    RefFile = undefined,
	Size = undefined,
	SizeTrans = undefined,
	IconSize = #(),
	Icon = undefined,
	Layer = undefined,
	Mesh = undefined,
	AddMesh = undefined,
	ActiveMesh = 1,
	SavedWorks = #(),
	SavedWorksPreviews = #(),
	RefBitmap = undefined,
	MatLibFile = undefined,
	Valid = False,
	InWorkDir = undefined,
	GroupDir = undefined,
	fn CreateMaterial =
	(
        local mat = Multimaterial name:Article
        local MatLib = materialLibrary()
		local m_name = ""
		mat.materialList.count = Materials.count
		for i = 1 to Materials.count do
		(
			local val = true
			m_name = "Material_" + (formattedPrint i format:#02d)
			mat.materialList[i] = Standardmaterial()
			mat.materialList[i].Diffuse = CLR_PALETTE_1[i]
			mat.materialList[i].Name = m_name
			mat.names[i] = Materials[i].PartName
		)
		Material = mat
        append MatLib mat
		if not DoesDirectoryExist InWorkDir do MakeDir InWorkDir
        saveTempMaterialLibrary MatLib MatLibFile
	),
	fn LoadMaterial =
	(
		try
		(
			MatLib = loadTempMaterialLibrary MatLibFile
			Material = MatLib[1]
		)
		catch()
	),
	fn LoadWork saved_file quiet_mode:true =
	(
		local cur_sel_objs = (selection as array)
		local merged_objs = undefined
		local load_result = false
		MD_Callbacks.Destruct()
		clearSelection()
		MD_Data.WorkLayerNodes = GetAllLayerNodes MD_Data.WorkLayer.Name
		MD_Data.WorkLayer.current = true
		
		if MD_Data.WorkLayerNodes.count != 0 and quiet_mode == false then
		(
			if (queryBox "Очистить рабочий слой перед загрузкой?" title:"Внимание!" icon:#question) then
			(
				delete MD_Data.WorkLayerNodes
				gc()
			)
		)
		mergeMAXFile saved_file #mergeDups #useSceneMtlDups #neverReparent
		merged_objs = getLastMergedNodes()
		if merged_objs.count != 0 then
		(
			for obj in merged_objs do
			(
				if MD_Data.InWorkTask != undefined then
				(
					if MD_Data.InWorkTask.Group == undefined then 
					(
						if obj.name == MD_Data.InWorkTask.Article then
						(
							MD_Data.InWorkTask.Mesh = obj
							MD_Data.AssignMaterial obj
						)
						if obj.name == (MD_Data.InWorkTask.Article + TRANS_POSTFIX) then
						(
							MD_Data.InWorkTask.AddMesh = obj
							MD_Data.AssignMaterial obj
						)						
					)else(
						if obj.name == MD_Data.InWorkTask.Group then
						(
							MD_Data.InWorkTask.Mesh = obj
							MD_Data.AssignMaterial obj
						)
						if obj.name == (MD_Data.InWorkTask.Group + TRANS_POSTFIX) then
						(
							MD_Data.InWorkTask.AddMesh = obj
							MD_Data.AssignMaterial obj
						)	
					)
				)
			)
			load_result = true		
		)
		else try (select cur_sel_objs) catch()
		
		completeRedraw()
		return load_result
	),
	fn SaveWork =
	(
		MD_Data.WorkLayerNodes = GetAllLayerNodes MD_Data.WorkLayer.Name
		local save = true
		local file_path
		local prev_file
		local save_dir
		
		if MD_Data.WorkLayerNodes.count != 0 then
		(
			if ((objects.count - MD_Data.TempLayerNodes.count) > MD_Data.WorkLayerNodes.count) then
			(
				msg = "Будут сохранены только объекты находящиеся на рабочем слое!"
				messageBox msg title:"Warning!" icon:#warning
			)
				local index
		
				if MD_Data.InWorkTask.SavedWorks.count == 0 then
					index = formattedPrint 1 format:#02d
				else
				(
					if MD_Data.InWorkTask.SavedWorks.count >= MD_UI.SettingsRoll.spn_save_count.value then
					(
						local last_file = MD_Data.InWorkTask.SavedWorks[MD_Data.InWorkTask.SavedWorks.count]
						local last_file_index = (filterString (getFilenameFile last_file) "_")[2] as integer
						local first_max_file = MD_Data.InWorkTask.SavedWorks[1]
						local first_prev_file = (trimRight MD_Data.InWorkTask.SavedWorks[1] ".max") + ".jpg"
		
						index = formattedPrint (last_file_index + 1) format:#02d
		
						deleteFile first_max_file
						deleteFile first_prev_file
					)
					else
					(
						local max_index = 0
		
						for f in MD_Data.InWorkTask.SavedWorks do
						(
							local f_index = (filterString (getFilenameFile f) "_")[2] as integer
							if f_index > max_index then max_index = f_index
						)
		
						index = formattedPrint (max_index + 1) format:#02d
					)
				)
				local file_name = (SAVED_FILE_NAME + "_" + index)
				local task_file = MD_Data.InWorkTask.File
				local task_dir = pathConfig.removePathLeaf (pathConfig.removePathLeaf task_file)
				if Group == undefined then save_dir = pathConfig.appendPath task_dir TASK_INNER_DIRS[3]
				else save_dir = MD_Data.InWorkTask.GroupDir
				if not doesDirectoryExist save_dir then MakeDir save_dir
				
				file_path = (pathconfig.appendpath save_dir (file_name + ".max"))
				save_nodes MD_Data.WorkLayerNodes file_path
				prev_file = (pathconfig.appendpath save_dir (file_name + ".jpg"))
				try ViewportSnapshot prev_file SAVED_PREVIEW_SIZE auto_frame:MD_UI.SettingsRoll.ckbx_auto_prev.checked catch()
				MD_Data.InWorkTask.SavedWorks = GetFiles (save_dir + "/*.max")
				sort MD_Data.InWorkTask.SavedWorks
				DisplayTempPrompt "Работа была сохранена." 5000
				MD_Log.Info ("Работа была сохранена  [" + file_name + "]")
		)
		else
		(
			messageBox "Рабочий слой не содержит объектов!" title:"Сообщение"
		)
	),
	fn Update =
	(
		if MD_Data.ActiveTask != undefined then
		(
			ReadDataFile File
			data["state"] = State
			WriteDataFile File
			local task_file_dir = getFilenamePath File
			TaskDir = pathConfig.removePathLeaf task_file_dir
			for mat in this.Materials do
			(
				for t = 1 to mat.textures.count do
				(
					local tex_file = (pathConfig.appendPath TaskDir ("T_" + mat.Article + TEXTURES_SIFFIXES[t]))
					if doesFileExist tex_file then (mat.textures[t] = tex_file)
					else mat.textures[t] = undefined
				)
			)
			this.LoadMaterial()
		)
	),
	fn Init = (
        if (File != undefined and DoesFileExist File) then
        (
            ReadDataFile File
            if data != undefined then
            (
				local task_file_dir = getFilenamePath File
				TaskDir = pathConfig.removePathLeaf task_file_dir
				InWorkDir = pathConfig.appendPath (pathConfig.removePathLeaf task_file_dir) TASK_INNER_DIRS[2]
				saved_dir = pathConfig.appendPath (pathConfig.removePathLeaf task_file_dir) TASK_INNER_DIRS[3]
				try Group = data["tags"][1] catch()
				if Group != undefined then 
				(
					GroupDir = pathConfig.removePathLeaf task_file_dir
					GroupDir = pathConfig.removePathLeaf GroupDir
					GroupDir = pathConfig.appendPath GroupDir Group
				)
				MatLibFile = (pathConfig.appendPath InWorkDir TASK_MAT_NAME)
				local ref_file_name = data["ref_photo_name"]
				local ref_file_type = getFilenameType ref_file_name
				local task_dir_files = GetFiles (task_file_dir + "/*.*")
				local mat_ref_files = #()
				
				for f in task_dir_files do
				(
					if (FindString f data["article"]) != undefined then
					(
						if getFilenameFile f == data["article"] and getFilenameType f == ref_file_type 
						then RefFile = f
						else append mat_ref_files f
					)
				)
				sort mat_ref_files
                Article = data["article"]
				DateCreate = data["date_create"]
				Object = data["object"]
                Website = data["web_site"]
				for i = 1 to data["finishing_materials"].count do
				(
					local mat = TaskMaterial()
					try mat.Article = data["finishing_materials"][i]["article"] catch()
					try mat.PartName = data["finishing_materials"][i]["name_part_object"] catch()
					try mat.Material = data["finishing_materials"][i]["finishing_components"] catch()
					try mat.RefFile = mat_ref_files[i] catch()
					try (mat.RefBitmap = CreatePreviewFromImageFile mat_ref_files[i] PREVIEW_SIZE)
					catch (mat.RefBitmap = CreatePreviewFromImageFile ICON_NO_PRVIEW_FILE PREVIEW_SIZE type:#dotnet)
					try (mat.WebSite = data["finishing_materials"][i]["web_site"]) catch()
					for t = 1 to mat.textures.count do
					(
						local tex_file = (pathConfig.appendPath TaskDir ("T_" + mat.Article + TEXTURES_SIFFIXES[t]))
						if doesFileExist tex_file then (mat.textures[t] = tex_file)
					)
					append Materials mat
				)
				State = data["state"]
				Pivot = #(
					ConvertCentimeterToSysUnits data["pivot"][1],
					ConvertCentimeterToSysUnits data["pivot"][2],
					ConvertCentimeterToSysUnits data["pivot"][3]
				)
				
				UserId = data["userId"]
                UserName = data["userName"]
                Size = #(
					ConvertCentimeterToSysUnits data["size"][1],
					ConvertCentimeterToSysUnits data["size"][2],
					ConvertCentimeterToSysUnits data["size"][3]
				)
				IconSize = #(
					ConvertCentimeterToSysUnits data["size"][1], 
					ConvertCentimeterToSysUnits data["size"][2]
				)
                try SizeTrans = #(
					ConvertCentimeterToSysUnits data["size_trans"][1], 
					ConvertCentimeterToSysUnits data["size_trans"][2], 
					ConvertCentimeterToSysUnits data["size_trans"][3]
				) 
				catch()
				if Group == undefined then
				(
					if pathConfig.doesFileExist saved_dir then
					(
						SavedWorks = GetFiles (saved_dir + "/*.max")
						sort SavedWorks
					)					
				)
				else
				(
					if pathConfig.doesFileExist GroupDir then
					(
						SavedWorks = GetFiles (GroupDir + "/*.max")
						sort SavedWorks
					)	
				)
				try (RefBitmap = CreatePreviewFromImageFile RefFile PREVIEW_SIZE)
				catch(RefBitmap = CreatePreviewFromImageFile ICON_NO_PRVIEW_FILE PREVIEW_SIZE type:#dotnet)
				if not DoesFileExist MatLibFile then CreateMaterial()
				else LoadMaterial()
            )
        )
	),
	on create do Init()
)
struct TaskIcon
(
	icon = undefined,
	fn New =
	(
		mergeMAXFile ICON_TEMPLATE_FILE #deleteOldDups #useSceneMtlDups #neverReparent
		this.icon = (getLastMergedNodes())[1]
		this.icon.IsHidden = false
		setTransformLockFlags this.icon #all
		max modify mode
		modPanel.setCurrentObject this.icon.BaseObject node:this.icon
		enableShowEndRes true
	),
	fn Create icon_file =
	(
		mergeMAXFile icon_file #deleteOldDups #useSceneMtlDups #neverReparent
		this.icon = (getLastMergedNodes())[1]
		this.icon.IsHidden = true
		setTransformLockFlags this.icon #all
	),
	fn FitSizeToBBox bbox =
	(
		local offset_d = undefined
		local offset_w = undefined
		if bbox != undefined then
		(
			offset_d = (bbox.max.x - bbox.min.x)/2 - (this.icon.max.x - this.icon.min.x)/2
			offset_w = (bbox.max.y - bbox.min.y)/2 - (this.icon.max.y - this.icon.min.y)/2					
		)
		if (bbox.max.x - bbox.min.x) != 0.0 and (bbox.max.y - bbox.min.y) != 0.0 then
		(
			MoveVertsInNamedSet this.icon "Left_side" [0.0, -offset_w, 0.0]
			MoveVertsInNamedSet this.icon "Right_side" [0.0, offset_w, 0.0]
			MoveVertsInNamedSet this.icon "Back_side" [-offset_d, 0.0, 0.0]
			MoveVertsInNamedSet this.icon "Front_side" [offset_d, 0.0, 0.0]			
		)
		CompleteRedraw()		
	),
	fn SetNamedSelSet set_name =
	(
		if classOf this.icon == Editable_Poly and subobjectLevel == 1 then
		(
			this.icon.Verts[set_name] = polyop.getVertSelection this.icon
		)
	),
	fn IconRender obj frame_size:2048 out_file:undefined frame_is_quad:false =
	(
		cur_view_tm = viewport.GetTM()
		cur_view_type = viewport.getType()
		cur_obj_state = obj.IsHidden
		if classof renderers.current != Default_Scanline_Renderer then
		renderers.current = RendererClass.classes[1]()
		useEnvironmentMap = off
		backgroundColor = color 0 0 0
		ambientColor = color 0 0 0
		lightTintColor = color 255 255 255
		Targa.setColorDepth 16
		Targa.setCompressed true
		Targa.setAlphaSplit false
		local layer_states = #()
		local obj_cur_layer = obj.layer
		local targ_dist = ConvertCentimeterToSysUnits 100
		local obj_w = (obj.max.y - obj.min.y)
		local obj_d = (obj.max.x - obj.min.x)
		local fov = (atan ((ConvertSysUnitsToCentimeters obj_w/2.0)/targ_dist)) * 2.0
		local main_camera = undefined
		for i = 0 to LayerManager.count - 1 do
		(
			lr = LayerManager.getLayer i
			append layer_states lr.ishidden
			lr.ishidden = true
		)
		obj.IsHidden = false
		obj.Layer.on = true
		if frame_is_quad then
		(
			renderWidth = frame_size
			renderHeight = frame_size
		)else(
			local aspect = obj_w / obj_d
			if aspect >= 1.0 then
			(
				renderWidth = frame_size
				renderHeight = (ceil ((frame_size as float)/aspect)) as integer
			)else(
				renderWidth = (ceil ((frame_size as float)*aspect)) as integer
				renderHeight = frame_size
			)		
		)
		main_camera = Freecamera orthoProjection:true targetDistance:targ_dist fov:fov
		main_camera.transform = matrix3 [0, 1, 0] [-1, 0, 0] [0, 0, 1] [0, 0, targ_dist]
		max vpt camera
		
		if out_file != undefined then
		(
			vfb = render outputfile:out_file vfb:true
			close vfb
		)else(
			render vfb:true
		)
		for i = 0 to LayerManager.count - 1 do
		(
			lr = LayerManager.getLayer i
			append layer_states lr.ishidden
			lr.ishidden = layer_states[i + 1]
		)
		
		delete main_camera
		free layer_states
		viewport.SetType cur_view_type
		viewport.SetTM cur_view_tm
		obj.IsHidden = cur_obj_state
		completeRedraw()
	),
	fn Destruct =
	(
		delete this.icon
		this.icon = undefined
		gc()
	),
	fn SetIcon icon_file =
    (
        try MD_Callbacks.Destruct() catch()
        try this.Destruct() catch()
        this.Create icon_file
        completeRedraw()
    ),
	fn SetEditIconMode state =
	(
		case state of
		(
			true:(
				MD_Callbacks.Destruct()
				cur_view_tm = viewport.GetTM()
				cur_view_type = viewport.getType()
				max vpt iso user
				viewport.SetTM (matrix3 [0,-1,0] [1,0,0] [0,0,1] [0.0, 0.0, ConvertCentimeterToSysUnits -100.0])
				for i = 0 to LayerManager.count - 1 do
				(
					lr = LayerManager.getLayer i
					if lr != MD_BBox.Layer then lr.ishidden = true
				)
				MD_BBox.Layer.on = false
				MD_BBox.Layer.lock = false
				MD_BBox.Layer.ishidden = false
				MD_BBox.Layer.current = true
				MD_BBox.bb.isHidden = false
				MD_BBox.bb.length = ConvertCentimeterToSysUnits 100.0
				MD_BBox.bb.width = ConvertCentimeterToSysUnits 100.0
				MD_BBox.bb.height = 0.0
				arrow_offset = ConvertCentimeterToSysUnits 10.0
				arrow_rad = ConvertCentimeterToSysUnits 20.0
				MD_BBox.arrow.radius = arrow_rad
				MD_BBox.arrow.pos.x = (MD_BBox.bb.width/2.0 + arrow_rad/2.0 + arrow_offset)
				MD_BBox.bb.wireColor = CLR_BBOX_PIVOT
				MD_BBox.arrow.wireColor = CLR_BBOX_PIVOT
				completeRedraw()
				for ctrl in MD_UI.SettingsRoll.Controls do ctrl.enabled = false
				for ctrl in MD_UI.TasksCatalogRoll.Controls do ctrl.enabled = false
				for ctrl in MD_UI.GeneralCatalogRoll.Controls do ctrl.enabled = false
			)
			false:(
				viewport.SetType cur_view_type
				viewport.SetTM cur_view_tm
				try MD_BBox.Update() catch()
				MD_BBox.bb.wireColor = CLR_BBOX_MAIN
				MD_BBox.arrow.wireColor = CLR_BBOX_MAIN
				completeRedraw()
				
				if MD_Data.InWorkTask != undefined and MD_Data.ActiveTask != undefined and MD_Data.ActiveTask.Article == MD_Data.InWorkTask.Article then
				MD_Data.ShowLayers mode:#work_only else MD_Data.ShowLayers mode:#scene_only
				for ctrl in MD_UI.SettingsRoll.Controls do ctrl.enabled = true
				for ctrl in MD_UI.TasksCatalogRoll.Controls do ctrl.enabled = true
				MD_UI.UpdateCatalogTasksRlt()
				MD_UI.UpdateCatalogGeneralRlt()
			)
		)
	)
)
struct GlobalData
(
	Categories = #(),
	SubCategories = #(),
	WorkLayer = undefined,
	TempArticlesList = #(),
	InvalidTasks = #(),
	CompletedTasks = #(),
	DeletedTasks = #(),
	Tasks = #(), -- Задания для выбранной в данный момент подкатегории
	SortTasks = #(), -- Отсортированные задания для выбранной в данный момент подкатегории
	main_categs = #(), -- #("01-01 - Пол - Плитка", ...)
	main_categ_ids = #(), -- #(#("01-01-001", ...), ...)
	sub_categs = #(), -- #(#("001 - Керамическая плитка", "002 - Керамогранит", "003 - Мозаика", "004 - Неолит"), ... )
	sub_categ_lib_dirs = #(), -- #(#("D:\MakeDesignLib\Catalog\06-02-013", ...), ...) Пути к категориям в локальной базе
	ActiveCategory = undefined, --> [int] Активная категория
	ActiveSubCategory = undefined, --> [int] Активная подкатегория
	ActiveTask = undefined, --> [Task] Выбранное на текущий момент задание в списке MD_UI.CatalogListMain
	ActiveTaskIndex = undefined, --> [int] Порядковый номер активного задания в списке MD_UI.CatalogListMain
	ActiveTaskAddIndex = undefined, --> [int] Порядковый номер в списке MD_UI.CatalogListAdd
	active_catalog_dir = undefined, --> [str] "01-01-001"
	active_catalog_article = undefined, --> [str] "01-01-001"
	ActiveList = 1, --> [int] Активный список
	InWorkTask = undefined, --> [task] Задание, находящееся в данный момент в рабочем состоянии
	InWorkTaskFile = undefined, --> [str] Задание, находящееся в данный момент в рабочем состоянии
	CheckedTasks = #(), -- Отмеченные задания в списке MD_UI.CatalogListMain
	WorkLayerNodes = #(),
	TempLayerNodes = #(),
	ActiveCategoryIcon = TaskIcon(),
	edit_icon_mode = false,
	proj_main_categs = #(),
	proj_main_categ_ids = #(),
	proj_sub_categs = #(),
	proj_sub_categ_ids = #(),
	VisibleLayers = false,
	LoadState = false, -- Был ли загружен rlt_catalog_tasks
	ProjectsRollLoadState = false, -- Был ли загружен rlt_projects_tasks
	Users = #(),
	fn AssignMatID obj =
	(
		try(
			if subobjectLevel == 4 or subobjectLevel == 5 then
			(
				SetMatID obj ActiveTaskAddIndex
				CompleteRedraw()
			)
		)catch()
	),
	fn AssignMaterial obj =
	(
		try(
			subobjectLevel = 0
			obj.Material = MD_Data.ActiveTask.Material
			CompleteRedraw()
		)catch()
	),
	fn Validation =
	(
		try WorkLayerNodes = GetAllLayerNodes WorkLayer.Name catch()
		local obj, th, bb, sub_mats_count, mat_ids, uv_count
		sub_mats_count = 0
		local mat_ids = uv_count = #()
		local val = true
		local msg = ""
		local valids = #("X", "X", "X", "X", "X", "X", "X")
		local objs = #(InWorkTask.Mesh, InWorkTask.AddMesh)
		if InWorkTask.SizeTrans == undefined then
		(
			if WorkLayerNodes.count == 1 and InWorkTask.Mesh != undefined and InWorkTask.AddMesh == undefined then
			(
				valids[1] = "OK"
				obj = WorkLayerNodes[1]
			)
		)else if WorkLayerNodes.count == 2 and InWorkTask.Mesh != undefined and InWorkTask.AddMesh != undefined then
		(
			valids[1] = "OK"
			obj = objs[MD_Data.InWorkTask.ActiveMesh]
		)
		else (msg = "Слой задания содержит более одного объекта.")
		
		if obj != undefined and not (isdeleted obj) then
		(
			if superClassOf obj == GeometryClass then
			(
				valids[2] = "OK"
				
				threshold = ConvertSysUnitsToCentimeters 0.25
				
				if ((distance MD_BBox.bb.min obj.min) < threshold) and ((distance MD_BBox.bb.max obj.max) < threshold) then 
				(
					valids[3] = "OK"
					
				)else (msg = "Расположение или размеры объекта не соответствуют габаритному контейнеру.")
				if this.ActiveTask.material != undefined then
				(
					sub_mats_count = 0
					try(sub_mats_count = this.ActiveTask.material.count)catch()
					if (InWorkTask.Group == undefined and this.ActiveTask.material.name == this.ActiveTask.Article and sub_mats_count == this.ActiveTask.Materials.count) or \
					(InWorkTask.Group == this.ActiveTask.Group and this.ActiveTask.Material.name == this.ActiveTask.Article and sub_mats_count == this.ActiveTask.Materials.count) then
					(
						valids[4] = "OK"
						mat_ids = GetMaterialIDList obj
						if mat_ids.count >= this.ActiveTask.Materials.count then
						(
							valids[5] = "OK"
						)else (msg = "Количество material IDs объекта не соответствует заданию.")
					)else (msg = "На объект назначен некорректный материал.")
				)else (msg = "На объект не назначен материал.")
				uv_count = GetNumUVChannels obj
				if uv_count >= 1 then
				(
					valids[6] = "OK"                                    
				)else(msg = "Объект должен содержать хотя бы один UV канал.")
				
				if this.ActiveCategoryIcon.Icon != undefined then
				(
					valids[7] = "OK"                                    
				)else(msg = "Для данной категории необходима иконка.")
			)else (msg = "Объект должен иметь тип Geometry.")
		)
		for v in valids where v == "X" do (val = false; exit)
		try(
			for i = 2 to MD_UI.Dialogs.Export.controls.count by 2 do
			(
				v = valids[i/2]
				MD_UI.Dialogs.Export.controls[i].text = v
				if v == "OK" then MD_UI.Dialogs.Export.controls[i].ForeColor = DN_CLR_OK
				else MD_UI.Dialogs.Export.controls[i].ForeColor = DN_CLR_X
			)                
		)catch()
		ActiveTask.Valid = val
		return #(val, msg, valids, obj)
	),
	fn AttachObjectsToWorkState =
	(
		try (
			for obj in objects do
			(
				if obj.name == ActiveTask.Article then
				(
					MD_Data.SetMesh obj
					WorkLayer.addNode obj
				)
				if obj.name == (ActiveTask.Article + TRANS_POSTFIX) then
				(
					MD_Data.SetAddMesh obj
					WorkLayer.addNode obj
					obj.Ishidden = true
				)
			)
		)catch()
	),
    fn ShowLayers mode:#work_only =
    (
		try(MD_BBox.Layer.lock = true)catch()
		try(
			case mode of
			(
				#scene_only:(
					for i = 0 to LayerManager.count - 1 do
					(
						lr = LayerManager.getLayer i
						if lr != WorkLayer and lr != MD_BBox.Layer then
						(
							lr.on = true
							DEFAULT_LAYER.current = true						
						)
						else lr.on = false
					)
				)
				#work_only:(
					for i = 0 to LayerManager.count - 1 do
					(
						lr = LayerManager.getLayer i
						if lr != WorkLayer and lr != MD_BBox.Layer then
						lr.on = false
						else 
						(
							if lr == MD_BBox.Layer then 
							(
								if MD_UI.SettingsRoll.ckbx_show_bb.checked or MD_UI.SettingsRoll.ckbx_show_icon.checked or \
								(MD_UI.SettingsRoll.ckbx_show_bb.checked and MD_UI.SettingsRoll.ckbx_show_icon.checked) then
								lr.on = true
							)
							else
							(
								lr.on = true
								lr.current = true								
							)
						)
					)
				)
				#all:(
					for i = 0 to LayerManager.count - 1 do
					(
						lr = LayerManager.getLayer i
						lr.on = true
					)
				)
				#none:(
					for i = 0 to LayerManager.count - 1 do
					(
						lr = LayerManager.getLayer i
						lr.on = false
					)
				)
			)			
		)catch()
		completeRedraw()
    ),
	fn CreateWorkLayer =
	(
		try (
			if InWorkTask.Group == undefined then
			(
				LayerManager.newLayerFromName InWorkTask.Article
				WorkLayer = LayerManager.getLayerFromName InWorkTask.Article
			)
			else(
				LayerManager.newLayerFromName InWorkTask.Group
				WorkLayer = LayerManager.getLayerFromName InWorkTask.Group
			)
			WorkLayer.on
			WorkLayer.current = true
		)catch()
	),
	fn AttachSelectedToWorkLayer =
	(
		try (
			for obj in selection do WorkLayer.addnode obj
			WorkLayer.on
			WorkLayer.current = true
			this.WorkLayerNodes = GetAllLayerNodes MD_Data.WorkLayer.Name
			select cur_selection
		)catch()
	),
	fn DeleteWorkLayer =
	(
		try (
			local nodes
			local name_case = InWorkTask.Article
			if InWorkTask.Group != undefined then name_case = InWorkTask.Group
			nodes = GetAllLayerNodes name_case
			Delete nodes
			DeleteAllSubLayers name_case
			LayerManager.deleteLayerByName name_case
			InWorkTask = undefined
			WorkLayer = undefined
			gc()
			CompleteRedraw()
		)
		catch()
	),
	fn ExitWorkState =
	(
		try MD_Callbacks.Destruct() catch()
		for t in MD_Data.Tasks do
		(
			t.State = STATES[1]
			t.ActiveMesh = 1
		)
        DeleteWorkLayer()
        InWorkTask = undefined
		try (
			ReadDataFile MD_LIB_DATA_FILE
			data["in_work_task"] = undefined
			WriteDataFile MD_LIB_DATA_FILE
		)
		catch (MD_Log.Error "[ExitWorkState] Не удалось сохранить данные в файл.")
		try (
			ReadDataFile InWorkTaskFile
			data["state"] = STATES[1]
			WriteDataFile InWorkTaskFile
		)
		catch ()
		if ActiveTask != InWorkTask then DeleteWorkLayer()
		MD_Data.active_catalog_article = (MD_Data.main_categ_ids[MD_Data.ActiveCategory][MD_Data.ActiveSubCategory])
		try (
			local icon_file = pathConfig.appendPath DECALS_DIR (MD_Data.active_catalog_article + (ICON_POSTFIX + ".max"))
			MD_Data.ActiveCategoryIcon.SetIcon icon_file
		) catch()
	),
	fn CreateWorkState =
	(
		try MD_Callbacks.Destruct() catch()
		try this.ExitWorkState() catch()
        ActiveTask.State = STATES[2]
        ActiveTask.ActiveMesh = 1
        InWorkTask = ActiveTask
		InWorkTaskFile = ActiveTask.File
		try ClearTrashLayers() catch()
		CreateWorkLayer()
		AttachSelectedToWorkLayer()
		try AttachObjectsToWorkState() catch()
		try (
			ReadDataFile MD_LIB_DATA_FILE
			data["in_work_task"] = substituteString InWorkTask.File "\\" "/"
			WriteDataFile MD_LIB_DATA_FILE
		)
		catch ()
        
		ActiveTask.Update()
        
		local work_tasks = #()
		if this.ActiveTask.Group != undefined then
		(
			work_tasks = for t in this.Tasks where t.Group == this.ActiveTask.Group collect t
		)
		else work_tasks = #(this.ActiveTask)
		for t in work_tasks do
		(
			MakeDir t.InWorkDir
			if DoesFileExist (pathConfig.appendPath t.InWorkDir TASK_MAT_NAME) then
			(
				t.LoadMaterial()
				
			)else t.CreateMaterial()			
		)
		local icon_file = pathconfig.appendpath MD_Data.InWorkTask.InWorkDir TASK_ICON_NAME
		if (DoesFileExist icon_file) then 
		(
			MD_Data.ActiveCategoryIcon.SetIcon icon_file
		)
	),
		
		
	fn ClearTrashLayers =
	(
		local split_str = undefined
		for i = 0 to LayerManager.count - 1 do
		(
			lr = LayerManager.getLayer i
			if lr != this.WorkLayer then
			(
				split_str = filterString lr.name "-"
				if split_str.count == 4 then (try LayerManager.deleteLayerByName lr.name catch())					
			)
		)
	),
	fn UpdateWorkState =
	(
		try
		(
			MD_Callbacks.Destruct()
			this.InWorkTask.State = STATES[2]
			this.InWorkTask.ActiveMesh = 1
			this.InWorkTask = this.ActiveTask
			this.InWorkTaskFile = this.InWorkTask.File
			this.CreateWorkLayer()
			try (
				ReadDataFile MD_LIB_DATA_FILE
				data["in_work_task"] = substituteString InWorkTaskFile "\\" "/"
				WriteDataFile MD_LIB_DATA_FILE
			)
			catch ()
			MD_BBox.Init()
			try MD_BBox.Update() catch()
			MD_UI.UpdateCatalogTasksRlt()
			local icon_file = pathconfig.appendpath this.InWorkTask.InWorkDir TASK_ICON_NAME
			
			if (DoesFileExist icon_file) then 
			(
				this.ActiveCategoryIcon.SetIcon icon_file
			)else(
				try (
					this.active_catalog_article = (this.main_categ_ids[this.ActiveCategory][this.ActiveSubCategory])
					icon_file = pathConfig.appendPath DECALS_DIR (this.active_catalog_article + (ICON_POSTFIX + ".max"))
					this.ActiveCategoryIcon.SetIcon icon_file
				)catch(this.ActiveCategoryIcon.Icon = undefined)
			)	
		)
		catch()
	),
	fn GetTasksInActiveCategory =
	(
		Tasks = #()
		local activ_dir = sub_categ_lib_dirs[ActiveCategory][ActiveSubCategory]
		local tasks_dirs = GetDirectories (activ_dir + "\\*")
		for dir in tasks_dirs do
		(
			local f = trimRight (filenameFromPath dir) "\\"
			if (filterstring f "-").count >= 4 then
			(
				local task_file = pathConfig.AppendPath dir TASK_INNER_DIRS[1]
				task_file = pathConfig.AppendPath task_file TASK_FILE_NAME
				if (doesFileExist task_file) then
				(
					task_file = substituteString task_file "\\" "/"
					append Tasks (Task File:task_file)
				)
			)
		)
	),
	/*
	fn GetTasksInActiveCategory =
	(
		Tasks = #()
		local activ_dir = sub_categ_lib_dirs[ActiveCategory][ActiveSubCategory]
		local tasks_dirs = GetDirectories (activ_dir + "\\*")
		for dir in tasks_dirs do
		(
			local f = trimRight (filenameFromPath dir) "\\"
			if (filterstring f "-").count >= 4 then
			(
				local task_file = pathConfig.AppendPath dir TASK_INNER_DIRS[1]
				task_file = pathConfig.AppendPath task_file TASK_FILE_NAME
				task_file = substituteString task_file "\\" "/"
				append Tasks (Task File:task_file)
			)
		)
	),
	*/
	fn SetMesh obj =
	(
		if (SuperClassOf obj == GeometryClass) and MD_Data.InWorkTask != undefined then
		(
			if this.InWorkTask.Mesh == obj then
			(
				this.InWorkTask.Mesh.Material = undefined
				this.InWorkTask.Mesh.Name = uniqueName "Object"
				this.InWorkTask.Mesh = undefined
				this.ActiveTask.ActiveMesh = 1
			)
			else
			(
				local mesh_name = ""
				this.WorkLayerNodes = GetAllLayerNodes this.WorkLayer.Name
				if this.InWorkTask.Group == undefined then 
				(
					mesh_name = this.InWorkTask.Article
				)
				else 
				(
					mesh_name = this.InWorkTask.Group
				)
				for task_obj in this.WorkLayerNodes where task_obj.name == mesh_name do
				(
					task_obj.Material = undefined
					task_obj.Name = uniqueName "Object"
				)
				obj.IsHidden = false
				this.InWorkTask.Mesh = obj
				this.InWorkTask.Mesh.Name = mesh_name
				this.ActiveTask.ActiveMesh = 1
				this.InWorkTask.Mesh.Material = this.InWorkTask.Material
			)	
			if this.InWorkTask.Mesh == this.InWorkTask.AddMesh then
			this.InWorkTask.AddMesh = undefined
			select obj
			CompleteRedraw()
		)
	),
	fn SetAddMesh obj =
	(
		if (SuperClassOf obj == GeometryClass) and MD_Data.InWorkTask != undefined then
		(
			if this.InWorkTask.AddMesh == obj then
			(
				this.InWorkTask.AddMesh.Material = undefined
				obj.Material = undefined
				this.InWorkTask.AddMesh.Name = uniqueName "Object"
				this.InWorkTask.AddMesh = undefined
				obj.IsHidden = False
				this.ActiveTask.ActiveMesh = 1
			)
			else
			(
				local mesh_name = ""
				this.WorkLayerNodes = GetAllLayerNodes this.WorkLayer.Name
				if this.InWorkTask.Group == undefined then 
				(
					mesh_name = this.InWorkTask.Article
				)
				else 
				(
					mesh_name = this.InWorkTask.Group
				)
				for task_obj in this.WorkLayerNodes where task_obj.name == (mesh_name + TRANS_POSTFIX) do
				(
					task_obj.Material = undefined
					task_obj.Name = uniqueName "Object"
				)
				
				for task_obj in this.WorkLayerNodes do task_obj.IsHidden = True
				this.InWorkTask.AddMesh = obj
				this.InWorkTask.AddMesh.Name = mesh_name + TRANS_POSTFIX
				obj.IsHidden = False
				this.ActiveTask.AddMesh.Material = this.InWorkTask.Material
				this.ActiveTask.ActiveMesh = 2
			)
			if this.InWorkTask.AddMesh == this.InWorkTask.Mesh then
			this.InWorkTask.Mesh = undefined
			select obj
			CompleteRedraw()
		)
	),
	fn ExportTask =
	(
		local valid_result = validation()
		local objs = #()
		local cur_obj_names = #()
		if valid_result[1] then
		(
			MD_Callbacks.Destruct()
			if InWorkTask.SizeTrans == undefined then (objs = #(InWorkTask.Mesh); cur_obj_names = #(InWorkTask.Mesh.Name))
			else (objs = #(InWorkTask.Mesh, InWorkTask.AddMesh); cur_obj_names = #(InWorkTask.Mesh.Name, InWorkTask.AddMesh.Name))
			local main_dir = pathConfig.removePathLeaf (getFilenamePath ActiveTask.File)
			local save_fbx_path = pathConfig.appendPath main_dir (ActiveTask.Article + ".fbx")
			local save_max_path = pathConfig.appendPath main_dir (ActiveTask.Article + ".max")
			for obj in objs do 
			(
				if MD_UI.SettingsRoll.ckbx_auto_pivot.checked then 
				(
					obj.pivot.x = MD_BBox.pivot_pos[1]
					obj.pivot.y = MD_BBox.pivot_pos[2]
					obj.pivot.z = MD_BBox.pivot_pos[3]
				)				
			)
			with redraw off 
			(
				if InWorkTask.Group != undefined then
				(
					objs[1].name = ActiveTask.Article
					try objs[2].name = (ActiveTask.Article + TRANS_POSTFIX) catch()
				)
				try(
					SaveSelectedObjects objs save_max_path
				)catch(MD_Log.Error "Не удалось сохранить текущее состояние сцены!")
				try(
					ExportToFBX objs save_fbx_path
				)catch(MD_Log.Error "Не удалось экспортировать задание!")
				if InWorkTask.Group != undefined then
				(
					objs[1].name = cur_obj_names[1]
					try objs[2].name = cur_obj_names[2] catch()
				)
			)
			for obj in objs do 
			(
				obj.pos = MD_BBox.pp.pos
			)
			ReadDataFile this.ActiveTask.File
			data["icon_size"] = #(
				ICON_THICKNESS,
				ConvertSysUnitsToCentimeters this.InWorkTask.Size[1],
				ConvertSysUnitsToCentimeters this.InWorkTask.Size[2]
			)
			WriteDataFile this.ActiveTask.File
			ReadDataFile MD_LIB_DATA_FILE
			local dict = PY_BUILTINS.dict()
			if data["to_import"] == undefined then data["to_import"] = dict
			else dict = data["to_import"]
			dict[this.ActiveTask.Article] = substituteString (pathConfig.removePathLeaf this.ActiveTask.InWorkDir) "\\" "/"
			data["to_import"] = dict
			WriteDataFile MD_LIB_DATA_FILE
			CompleteRedraw()
		)
	),
	fn ClearWorkLayer =
	(
		try (
			this.WorkLayerNodes = GetAllLayerNodes this.WorkLayer.Name
			if MD_Data.InWorkTask != undefined and WorkLayerNodes.count != 0 then
			(
				if (queryBox "Все объекты, находящиеся на рабочем слое, будут удалены.\nСохранить работу перед удалением?" title:"Внимание!" icon:#question) then
				InWorkTask.SaveWork()
			)
			delete WorkLayerNodes
			gc()
		) catch()
	),
	fn Update =
	(
		case ActiveSection of
		(
			1:(
				ActiveTaskAddIndex = undefined
				TempArticlesList = #()
				try (GetTasksInActiveCategory()) catch()
				if Tasks.count != 0 then
				(
					try
					(
						if ActiveTaskIndex == undefined then
						ActiveTask = Tasks[1]
						else ActiveTask = Tasks[ActiveTaskIndex]
					)catch()
					if ActiveTask != undefined then
					(
						case ActiveTask.State of
						(
							(STATES[1]):()
							(STATES[2]):(CreateWorkState())
							(STATES[3]):()
							(STATES[4]):()
						)
					)						
				)
				else 
				(
					ActiveTask = undefined
					ActiveTaskIndex = undefined
				)
			)
			2:(
			)
		)
	),
	fn DeleteEmptyTask task trash:true =
	(
		local task_dir = pathConfig.appendPath sub_categ_lib_dirs[ActiveCategory][ActiveSubCategory] task.Article
		local done_files = getFiles (task_dir + "/*.*")
		local result = false
		if (doesFileExist task.File) == true then
		(
			if trash then
			(
				if done_files.count != 0 or task.SavedWorks.count != 0 then
				(
					if not (doesDirectoryExist LIB_TRASH_DIR) then
					(
						make_dir_cmd = "mkdir -p " + LIB_TRASH_DIR
						HiddenDOSCommand make_dir_cmd donotwait:true
		
						add_hide_attrib_cmd = "attrib +h " + LIB_TRASH_DIR
						HiddenDOSCommand add_hide_attrib_cmd donotwait:true 
					)
					local trash_dirs = getDirectories (LIB_TRASH_DIR + "/*.*")
					local task_in_trash_dir = (pathConfig.appendPath LIB_TRASH_DIR task.Article)
					local exists = #()
					for dir in trash_dirs do
					(
						f = findString dir task.Article
						if f != undefined then 
						append exists dir
					)
					if exists.count != 0 then
					(
						copy_name = task.Article + "_" + ((formattedPrint (exists.count + 1) format:"01d") as string)
						task_in_trash_dir = (pathConfig.appendPath LIB_TRASH_DIR copy_name)
					)
		
					dosCommand ("xcopy " + task_dir + " " + task_in_trash_dir + " /S /E /I /Y /R /C")
				)					
			)
		)
		if task.State == STATES[2] then this.ExitWorkState()
		dosCommand ("rmdir " + task_dir + " /S /Q")
		if not doesDirectoryExist task_dir then result = true
		result
	),
	fn FullUpdate =
	(
		try MD_UI.Sort = false catch()
		try this.ActiveList = 1 catch()
		try this.ActiveTask = this.Tasks[this.ActiveTaskIndex] catch()
		try MD_UI.FillMainList() catch()
		try MD_UI.FillAddList() catch()
		try MD_UI.UpdateCatalogTasksRlt() catch()
		try MD_UI.UpdateCatalogInfoRlt() catch()
		try MD_UI.UpdateCatalogGeneralRlt() catch()
		try MD_UI.UpdateCatalogToolsRlt() catch()
		try MD_BBox.Update() catch()
		try if this.InWorkTask.file != undefined and this.WorkLayer == undefined then this.CreateWorkLayer() catch()
		try this.SwitchWorkLayer catch()
		if this.ActiveTaskIndex == undefined then try MD_UI.CatalogListMain.Items.Item[0].selected = true catch()
		try this.active_catalog_article = (this.main_categ_ids[this.ActiveCategory][this.ActiveSubCategory]) catch()
	),
	fn Init = (
		
		Tasks = #()
		sub_categs = #()
		main_categ_id = #()
		sub_categ_lib_dirs = #()
		main_categs = #()
		try (
			MD_LIB_DIR = GetUserEnvVar "MD_LIB_DIR"
			MD_CURRENT_PROJECT = GetUserEnvVar "MD_CURRENT_PROJECT"
			LIB_TRASH_DIR = pathConfig.appendPath MD_LIB_DIR TRASH_DIR_NAME
			MD_CATALOG_DATA_FILE = pathConfig.appendPath MD_LIB_DIR MD_CATEGS[2][2]
			MD_CATALOG_DATA_FILE = pathConfig.appendPath MD_CATALOG_DATA_FILE MD_CURRENT_PROJECT
			MD_CATALOG_DATA_FILE = pathConfig.appendPath MD_CATALOG_DATA_FILE (MD_CURRENT_PROJECT + CATALOG_DATA_FILE_NAME)
			MD_DATA_DIR = pathConfig.appendPath MD_LIB_DIR DATA_DIR_NAME
			if not doesDirectoryExist MD_DATA_DIR then makeDir MD_DATA_DIR
			MD_USERS_DATA_FILE = pathConfig.appendPath MD_DATA_DIR USERS_DATA_FILE_NAME
			MD_PROJECTS_DATA_FILE = pathConfig.appendPath MD_DATA_DIR PROJECTS_DATA_FILE_NAME
			MD_LIB_DATA_FILE = pathConfig.appendPath MD_DATA_DIR COMMON_DATA_FILE_NAME
		)
		catch (MD_Log.Error "Не указан путь к локальной базе MakeDesign.")
		if DoesFileExist MD_LIB_DATA_FILE then
		(
			ReadDataFile MD_LIB_DATA_FILE
			InWorkTaskFile = data["in_work_task"]
			if InWorkTaskFile != undefined then InWorkTask = Task file:InWorkTaskFile
		)
		else 
		(
			data = PY_BUILTINS.dict()
			data["in_work_task"] = undefined
			WriteDataFile MD_LIB_DATA_FILE
		)
		if DoesDirectoryExist MD_LIB_DIR then
		(
			if DoesFileExist MD_CATALOG_DATA_FILE then
			(
				ReadDataFile MD_CATALOG_DATA_FILE
				local arr_names = #()
				local arr_ids = #()
				local arr_tasks = #()
				local local_catalog_dir = pathConfig.AppendPath MD_LIB_DIR MD_CATEGS[2][1]
				for i in data as array do 
				(
					local parse_article = filterString i["Article"] "-"
					local categ_article_part = parse_article[1] + "-" + parse_article[2]
					local sub_categ_article_part = parse_article[3]
					local sub_categ_option = sub_categ_article_part + " - " + i["SubCategory"]
					local sub_categ_dir = pathConfig.AppendPath local_catalog_dir i["Article"]
					locaL categ_option = categ_article_part + " - " + i["Category"]
					local categ_arr_index = findItem main_categs categ_option
					if categ_arr_index == 0 then
					(
						append main_categs categ_option
						append main_categ_ids #(i["Article"])
						append sub_categs #(sub_categ_option)
						append sub_categ_lib_dirs #(sub_categ_dir)
					)
					else if categ_arr_index > 0 then
					(
						append main_categ_ids[categ_arr_index] i["Article"]
						append sub_categs[categ_arr_index] sub_categ_option
						append sub_categ_lib_dirs[categ_arr_index] sub_categ_dir
					)
				)
			)
			else MD_Log.Error "Отсутствуют данные о каталоге объектов."
			
			if DoesFileExist MD_USERS_DATA_FILE then
			(
				local titles = #()
				local us_ids = #()
				ReadDataFile MD_USERS_DATA_FILE
				for i in data as array do 
				(
					append titles i["title"]
					append us_ids i["user_id"]
				)
				append users titles
				append users us_ids				
			)
			else MD_Log.Error "Отсутствуют данные о пользователях."
		)
		
	)
)
struct UI_Dialogs
(
	Configure = dlg_configure,
	CheckTasks = dlg_check_tasks,
	PivotParams = dlg_pivot_params,
	LoadWork = dlg_load_work,
	Export = dlg_export,
	Request = dlg_request,
	LoadTextures = dlg_load_textures,
	fn UpdatePreview =
	(
		try (
			local item_index = LoadWork.lv_files.SelectedItems.Item[0].Index + 1
			LoadWork.img_prew.Image = MD_Data.ActiveTask.SavedWorksPreviews[item_index]
		) catch()
	),
	fn DeleteSavedFiles =
	(
		local indexes = #()
		if (queryBox "Действительно удалить отмеченные файлы?" title:"Внимание!" icon:#warning) then
		(
			for i = 0 to LoadWork.lv_files.Items.count - 1 do
			(
				if LoadWork.lv_files.Items.Item[i].Checked == true then
				(
					local index = LoadWork.lv_files.Items.Item[i].Index + 1
					max_file = MD_Data.ActiveTask.SavedWorks[index]
					prev_file = (trimRight max_file ".max") + ".jpg"
					
					deleteFile max_file
					deleteFile prev_file
					append indexes index
				)
			)
			for i = indexes.count to 1 by -1 do
			(
				deleteItem MD_Data.ActiveTask.SavedWorks indexes[i]
				deleteItem MD_Data.ActiveTask.SavedWorksPreviews indexes[i]
			)
		)
	),
	fn InitLoadWork =
	(
		LoadWork.lv_files.Columns.Clear()
		LoadWork.lv_files.BorderStyle = DN_Lib.BorderNone
		LoadWork.lv_files.gridLines = true
		LoadWork.lv_files.View = (dotNetClass "System.Windows.Forms.View").Details
		LoadWork.lv_files.fullRowSelect = true
		LoadWork.lv_files.MultiSelect = false
		LoadWork.lv_files.HideSelection = false
		LoadWork.lv_files.HoverSelection  = false
		LoadWork.lv_files.CheckBoxes = true
		LoadWork.lv_files.Columns.add SAVED_WORKS_LIST_COLUMNS[1] 110
		LoadWork.lv_files.Columns.add SAVED_WORKS_LIST_COLUMNS[2] 110
		
		local items = #()
		local date_time = time_part = date_time = ""
		local prev_file
		MD_Data.ActiveTask.SavedWorksPreviews = #()
		for i = 1 to MD_Data.ActiveTask.SavedWorks.count do
		(
			li = dotNetObject "System.Windows.Forms.ListViewItem" (getFilenameFile MD_Data.ActiveTask.SavedWorks[i])
			li.ForeColor = DN_CLR_DEFAULT
			prev_file = (trimRight MD_Data.ActiveTask.SavedWorks[i] ".max") + ".jpg"
			try(
				prev_bm = CreatePreviewFromImageFile prev_file SAVED_PREVIEW_SIZE type:#dotnet
			)catch(
				prev_bm = CreatePreviewFromImageFile ICON_NO_PRVIEW_FILE SAVED_PREVIEW_SIZE type:#dotnet
			)
			append MD_Data.ActiveTask.SavedWorksPreviews prev_bm
			date_time = filterString (getFileCreateDate MD_Data.ActiveTask.SavedWorks[i]) " "
			time_part = filterString date_time[2] ":"
			date_time = date_time[1] + "  " + time_part[1] + ":" + time_part[2]
			li.SubItems.add date_time
			append items li
		)
		LoadWork.lv_files.Items.Clear()
		LoadWork.lv_files.Items.AddRange items
		LoadWork.lv_files.Update()
		try LoadWork.lv_files.Items.Item[0].selected = true catch()
		LoadWork.img_prew.backColor = DN_CLR_BG
		LoadWork.img_prew.Margin = LoadWork.img_prew.Padding = DN_Lib.Pad 0 0 0 0
		LoadWork.img_prew.SizeMode = LoadWork.img_prew.SizeMode.CenterImage
		try LoadWork.img_prew.Image = MD_Data.ActiveTask.SavedWorksPreviews[1] catch()
		LoadWork.lv_files.focus()
	)
)
struct UI
(
	MainRoll = rlt_make_design_tools,
	SettingsRoll = rlt_settings,
	AboutRoll = rlt_about,
	Dialogs = UI_Dialogs(),
	TasksCatalogRoll = rlt_catalog_tasks,
	InfoCatalogRoll = rlt_catalog_info,
	ToolsCatalogRoll = rlt_catalog_tools,
	GeneralCatalogRoll = rlt_catalog_general,
	Categories = rlt_catalog_tasks.lst_basic_catalog,
	SubCategories = rlt_catalog_tasks.lst_sub_catalog,
	CatalogListMain = rlt_catalog_tasks.lv_main,
	CatalogListAdd = rlt_catalog_tasks.lv_add,
	InfoCatalogPreview = rlt_catalog_info.img_prev,
	InfoCatalogWeb = rlt_catalog_info.hpl_site,
	InfoCatalogSize = rlt_catalog_info.lbl_size_txt,
	TasksProjectsRoll = rlt_projects_tasks,
	InfoProjectsRoll = rlt_projects_info,
	GeneralProjectsRoll = rlt_projects_general,
	ProjectsListMain = rlt_projects_tasks.lv_main,
	ProjectsListAdd = rlt_projects_tasks.lv_add,
	EMPTY_PREVIEW = undefined,
	LabelSizeText = "",
	LabelAddSizeText = "",
	Sort = False,
	fn SetListViewParams list_view CheckBoxes:true= (
		list_view.BorderStyle = list_view.BorderStyle.None
		list_view.gridLines = true
		list_view.View = (dotNetClass "System.Windows.Forms.View").Details
		list_view.fullRowSelect = true
		list_view.MultiSelect = false
		list_view.HideSelection = false
		list_view.HoverSelection  = false
		list_view.CheckBoxes = CheckBoxes
	),
	fn AddListViewColumns list_view columns widths:#() = (
		for i = 1 to columns.count do
		try(list_view.Columns.add columns[i] widths[i])
		catch(list_view.Columns.add columns[i])
	),
	fn InitCatalogLists = 
	(
		CatalogListMain.Columns.Clear()
		CatalogListAdd.Columns.Clear()
		SetListViewParams CatalogListMain
		SetListViewParams CatalogListAdd CheckBoxes:false
		AddListViewColumns CatalogListMain MAIN_LIST_COLUMNS_1 widths:#(110, 60, 60, 60, 120)
		AddListViewColumns CatalogListAdd ADD_LIST_COLUMNS_1 widths:#(70, 100, 55)
		setFocus CatalogListMain
	),
	fn InitProjectsLists = 
	(
		ProjectsListMain.Columns.Clear()
		ProjectsListAdd.Columns.Clear()
		SetListViewParams ProjectsListMain
		SetListViewParams ProjectsListAdd CheckBoxes:false
		AddListViewColumns ProjectsListMain MAIN_LIST_COLUMNS_2 widths:#(206)
		AddListViewColumns ProjectsListAdd ADD_LIST_COLUMNS_2 widths:#(206)
		setFocus ProjectsListMain
	),
	fn FillMainList =
	(
		case MD_Data.ActiveSection of
		(	/*
			1:(
				local task_list = #()
				local main_items = #()
				local item_index = 0
				local cur_sel = undefined
				if CatalogListMain.SelectedItems.Count != 0 then cur_sel = CatalogListMain.SelectedItems.Item[0].Index
				
				for task in MD_Data.Tasks do
				(
					dn_list_item = dotNetObject "System.Windows.Forms.ListViewItem" task.Article
					dn_list_item.Checked = false
					dn_list_item.ForeColor = DN_CLR_DEFAULT
					if (MD_Data.ActiveTask != undefined and task.State == STATES[2]) or \
					(MD_Data.ActiveTask != undefined and task.State == STATES[1] and MD_Data.InWorkTask != undefined and task.Group != undefined and task.Group == MD_Data.InWorkTask.Group) then 
					(
						dn_list_item.ForeColor = DN_CLR_INWORK
						dn_list_item.Font = DN_FNT_GRP
						dn_list_item.SubItems.add STATES[2]
						if task.Article == MD_Data.ActiveTask.Article then
						(
							MD_Data.InWorkTask = task
							MD_Data.CreateWorkLayer()							
						)
					)
					else dn_list_item.SubItems.add ""
					if task.Group != undefined then dn_list_item.SubItems.add task.Group
					else dn_list_item.SubItems.add ""
					if task.SizeTrans != undefined then dn_list_item.SubItems.add "•" -- alt+0149
					else dn_list_item.SubItems.add ""
					if task.UserName != undefined then dn_list_item.SubItems.add task.UserName
					else dn_list_item.SubItems.add ""
					
					if cur_sel == item_index then dn_list_item.Selected = true
					append main_items dn_list_item
					item_index += 1
					try dn_list_item.tag = item_index catch()
				)
				CatalogListMain.Items.Clear()
				CatalogListMain.Items.AddRange main_items
				CatalogListMain.Update()
				main_items = #()
				free main_items
				task_list = #()
				free task_list
			)
			*/
			1:(
				
				local task_list = #()
				local main_items = #()
				local item_index = 0
				local cur_sel = undefined
				if CatalogListMain.SelectedItems.Count != 0 then cur_sel = CatalogListMain.SelectedItems.Item[0].Index
				
				for task in MD_Data.Tasks do
				(
					dn_list_item = dotNetObject "System.Windows.Forms.ListViewItem" task.Article
					dn_list_item.Checked = false
					dn_list_item.ForeColor = DN_CLR_DEFAULT
					if (MD_Data.ActiveTask != undefined and task.State == STATES[2]) or \
					(MD_Data.ActiveTask != undefined and task.State == STATES[1] and MD_Data.InWorkTask != undefined and task.Group != undefined and task.Group == MD_Data.InWorkTask.Group) then 
					(
						dn_list_item.ForeColor = DN_CLR_INWORK
						dn_list_item.Font = DN_FNT_GRP
						dn_list_item.SubItems.add STATES[2]
						if task.Article == MD_Data.ActiveTask.Article then
						(
							MD_Data.InWorkTask = task
							MD_Data.CreateWorkLayer()							
						)
					)
					else dn_list_item.SubItems.add ""
					if task.Group != undefined then dn_list_item.SubItems.add task.Group
					else dn_list_item.SubItems.add ""
					if task.SizeTrans != undefined then dn_list_item.SubItems.add "•" -- alt+0149
					else dn_list_item.SubItems.add ""
					if task.UserName != undefined then dn_list_item.SubItems.add task.UserName
					else dn_list_item.SubItems.add ""
					
					if cur_sel == item_index then dn_list_item.Selected = true
					append main_items dn_list_item
					item_index += 1
					try dn_list_item.tag = item_index catch()
				)
				CatalogListMain.Items.Clear()
				CatalogListMain.Items.AddRange main_items
				CatalogListMain.Update()
				main_items = #()
				free main_items
				task_list = #()
				free task_list
			)
			2:(
				Categories.Items = MD_Data.proj_main_categs
				SubCategories.Items = MD_Data.proj_sub_categs
				try SubCategories.Items = MD_Data.proj_sub_categs[Categories.Selection] catch()
				CatalogListMain.Items.Clear()
				CatalogListMain.Update()
			)
		)
	),
	fn FillCategoriesLists =
	(
		Categories.Items = MD_Data.main_categs
		try SubCategories.Items = MD_Data.sub_categs[Categories.Selection]
		catch(SubCategories.Items = #())
		
	),
	fn UpdateCatalogGeneralRlt =
	(
		try
		(
			GeneralCatalogRoll.btn_main_mesh.text = "Main Mesh"
			GeneralCatalogRoll.btn_add_mesh.text = "Additional Mesh"
			GeneralCatalogRoll.btn_vis_switch.text = "Show Scene Objects"
			for ctrl in GeneralCatalogRoll.Controls do ctrl.enabled = false
			for ctrl in GeneralProjectsRoll.Controls do ctrl.enabled = false
			local objs = #()
			if (MD_Data.ActiveTask != undefined and MD_Data.WorkLayer != undefined and MD_Data.ActiveTask.State == STATES[2]) or \
			(MD_Data.ActiveTask != undefined and MD_Data.ActiveTask.Group != undefined and MD_Data.InWorkTask != undefined and MD_Data.ActiveTask.Group == MD_Data.InWorkTask.Group) then
			(
				GeneralCatalogRoll.btn_vis_switch.enabled = true
				MD_Data.WorkLayerNodes = GetAllLayerNodes MD_Data.WorkLayer.Name
				objs = for obj in (objects as array) where (findItem MD_Data.TempLayerNodes obj == 0) collect obj
				GeneralCatalogRoll.btn_set_pivot.enabled = true
				if MD_Data.ActiveCategoryIcon.Icon != undefined then
				GeneralCatalogRoll.btn_edit_icon.enabled = true
				if MD_Data.InWorkTask.Mesh != undefined and not MD_Data.InWorkTask.Mesh.IsDeleted then
				(
					GeneralCatalogRoll.btn_main_mesh.text = "  Main Mesh •"
					if MD_Data.InWorkTask.ActiveMesh == 1 and selection.count == 1 and selection[1] == MD_Data.InWorkTask.Mesh then GeneralCatalogRoll.btn_assign_mat.enabled = true
					try GeneralCatalogRoll.btn_main_mesh.tooltip = ("Текущий объект: " + MD_Data.InWorkTask.Mesh.Name + "\nДля удаления статуса главного объекта необходимо повторно нажать на кнопку.") catch()
				)
				else
				(
					GeneralCatalogRoll.btn_main_mesh.text = "Main Mesh"
					if SettingsRoll.ckbx_tooltips.Checked == true then
					GeneralCatalogRoll.btn_main_mesh.tooltip = MD_Tooltips.tools_cat_07_a
				)
				if MD_Data.InWorkTask.SizeTrans != undefined then 
				(
					GeneralCatalogRoll.btn_mesh_switch.enabled = true
					if MD_Data.InWorkTask.ActiveMesh == 2 then
					GeneralCatalogRoll.btn_mesh_switch.text = "<< Switch To Main Mesh"	
					else GeneralCatalogRoll.btn_mesh_switch.text = ">> Switch To Additional Mesh"
					if (selection.count == 1 and \
						SuperClassOf selection[1] == GeometryClass and \
						findItem MD_Data.WorkLayerNodes selection[1] != 0) then
					(
						if MD_Data.InWorkTask.ActiveMesh == 2 then
						(
							GeneralCatalogRoll.btn_mesh_switch.text = "<< Switch To Main Mesh"
							GeneralCatalogRoll.btn_add_mesh.enabled = true		
						)
						else
						(
							GeneralCatalogRoll.btn_mesh_switch.text = ">> Switch To Additional Mesh"
							GeneralCatalogRoll.btn_main_mesh.enabled = true
							if MD_Data.InWorkTask.AddMesh == undefined or MD_Data.InWorkTask.AddMesh.IsDeleted then
							GeneralCatalogRoll.btn_add_mesh.enabled = true
						)
					)
					if MD_Data.InWorkTask.AddMesh != undefined and not MD_Data.InWorkTask.AddMesh.IsDeleted then
					(
						GeneralCatalogRoll.btn_add_mesh.text = "  Additional Mesh •"
						if MD_Data.InWorkTask.ActiveMesh == 2 and selection.count == 1 and selection[1] == MD_Data.InWorkTask.AddMesh then GeneralCatalogRoll.btn_assign_mat.enabled = true
						try GeneralCatalogRoll.btn_add_mesh.tooltip = ("Текущий объект: " + MD_Data.InWorkTask.AddMesh.Name + "\nДля удаления статуса дополнительного объекта необходимо повторно нажать на кнопку.") catch()
					)
					else(
						GeneralCatalogRoll.btn_add_mesh.text = "Additional Mesh"
						if SettingsRoll.ckbx_tooltips.Checked == true then
						GeneralCatalogRoll.btn_add_mesh.tooltip = MD_Tooltips.tools_cat_07_b
					)
				)
				else
				(
					MD_Data.InWorkTask.ActiveMesh = 1
					if (selection.count == 1 and \
						SuperClassOf selection[1] == GeometryClass and \
						findItem MD_Data.WorkLayerNodes selection[1] != 0) then
					(
						GeneralCatalogRoll.btn_main_mesh.enabled = true
						if MD_Data.InWorkTask.Mesh == 1 and selection[1] == MD_Data.InWorkTask.Mesh then GeneralCatalogRoll.btn_assign_mat.enabled = true
					)
				)
				
				if (MD_Data.WorkLayer != undefined and MD_Data.WorkLayerNodes.count != 0) then
				(
					GeneralCatalogRoll.btn_save_work.enabled = true
					GeneralCatalogRoll.btn_export.enabled = true
				)
				if objs.count != MD_Data.WorkLayerNodes.count and objs.count != 0 then 
				(
					local obj_outside = false
					for obj in selection where obj.layer != MD_Data.WorkLayer do (obj_outside = true; exit)
					if obj_outside then
					local obj_outside = false
					for obj in selection where obj.layer != MD_Data.WorkLayer do (obj_outside = true; exit)
					if obj_outside then
					GeneralCatalogRoll.btn_attach_to_task.enabled = true
				)
				if MD_Data.InWorkTask.SavedWorks.count != 0 then
				(
					GeneralCatalogRoll.btn_load_work.enabled = true
					GeneralCatalogRoll.btn_work_list.enabled = true
				)
			)
			free MD_Data.WorkLayerNodes
			free objs
		)catch()
	),
	fn UpdateCatalogToolsRlt = 
	(
		if TasksCatalogRoll.lst_sub_catalog.selection != 0 then
		ToolsCatalogRoll.btn_create_icon.enabled = true
	),
	fn FillAddList =
	(
		case MD_Data.ActiveSection of
		(
			1:(
				local add_items = #()
				local tex_count = 0
				try
				(
					for mat in MD_Data.ActiveTask.Materials do
					(
						dn_list_item = dotNetObject "System.Windows.Forms.ListViewItem" mat.PartName
						dn_list_item.ForeColor = DN_CLR_DEFAULT
						dn_list_item.SubItems.add mat.material
						tex_count = 0
						
						for t in mat.textures where t != undefined do tex_count += 1
						if tex_count != 0 then dn_list_item.SubItems.add (tex_count as string)
						append add_items dn_list_item
					)					
				)
				catch()
				CatalogListAdd.Items.Clear()
				CatalogListAdd.Items.AddRange add_items
				CatalogListAdd.Update()
				add_items = #()
				free add_items
			)
			2:(
				CatalogListAdd.Items.Clear()
				CatalogListAdd.Update()
			)
		)
	),
	fn UpdateCatalogInfoRlt =
	(
		case MD_Data.ActiveList of
		(
			1:(
				InfoCatalogRoll.title = "Info"
				if MD_Data.ActiveTask != undefined then
				(
					try (
						if MD_Data.ActiveTask.RefBitmap != undefined then
						InfoCatalogPreview.bitmap = MD_Data.ActiveTask.RefBitmap
					) 
					catch()
					
					try (
						InfoCatalogWeb.text = ""
						InfoCatalogWeb.text = substring MD_Data.ActiveTask.Website 1 30
						InfoCatalogWeb.address = MD_Data.ActiveTask.Website
						
					) catch()
					try (
						LabelSizeText = ""
						LabelSizeText += ("W: " + (MD_Data.ActiveTask.Size[1] as float) as string + "    ")
						LabelSizeText += ("D: " + (MD_Data.ActiveTask.Size[2] as float) as string + "    ")
						LabelSizeText += ("H: " + (MD_Data.ActiveTask.Size[3] as float) as string)
						
					) catch()
					try (
						LabelAddSizeText = ""
						LabelAddSizeText += ("W: " + (MD_Data.ActiveTask.SizeTrans[1] as float) as string + "    ")
						LabelAddSizeText += ("D: " + (MD_Data.ActiveTask.SizeTrans[2] as float) as string + "    ")
						LabelAddSizeText += ("H: " + (MD_Data.ActiveTask.SizeTrans[3] as float) as string)
					) catch()
					InfoCatalogRoll.lbl_size.visible = true
					InfoCatalogRoll.lbl_size_txt.visible = true
					InfoCatalogRoll.lbl_site.visible = true
					InfoCatalogRoll.hpl_site.visible = true
					InfoCatalogRoll.hpl_site.text = ""
					try (InfoCatalogRoll.hpl_site.address = MD_Data.ActiveTask.WebSite) catch()
					case MD_Data.ActiveTask.ActiveMesh of
					(
						1:(
							InfoCatalogRoll.lbl_size_txt.text = LabelSizeText
						)
						2:(
							InfoCatalogRoll.lbl_size_txt.text = LabelAddSizeText
						)
					)
					try (InfoCatalogRoll.hpl_site.text = MD_Data.ActiveTask.WebSite) catch()
					try InfoCatalogRoll.title = MD_Data.ActiveTask.Article catch()
					try InfoCatalogRoll.height = 280 catch()				
				)
			)
			2:(
				InfoCatalogPreview.bitmap = MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].RefBitmap
				InfoCatalogRoll.title = MD_Data.ActiveTask.Article + "  [" + MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].PartName + "]"
				InfoCatalogRoll.height = 280
			)
		)
	),
	fn UpdateCatalogTasksRlt =
	(
		TasksCatalogRoll.btn_get.enabled = false
		TasksCatalogRoll.btn_clear.enabled = false
		TasksCatalogRoll.btn_assign_mat_id.enabled = false	
		TasksCatalogRoll.btn_assign_texts.enabled = false
		if MD_Data.ActiveTask == undefined then
		(
			for ctrl in TasksCatalogRoll.Controls do ctrl.enabled = false
			for ctrl in InfoCatalogRoll.Controls do ctrl.enabled = false
			for ctrl in GeneralCatalogRoll.Controls do ctrl.enabled = false
			for ctrl in GeneralProjectsRoll.Controls do ctrl.enabled = false
			TasksCatalogRoll.btn_work_state.text = "Set Work State"
			InfoCatalogPreview.bitmap = EMPTY_PREVIEW
			InfoCatalogWeb.text = ""
			InfoCatalogWeb.address = ""
			InfoCatalogSize.text = ""
			TasksCatalogRoll.lst_basic_catalog.enabled = true
			TasksCatalogRoll.lst_sub_catalog.enabled = true
			CatalogListMain.enabled = true
			CatalogListAdd.enabled = true
		)
		else
		(
			TasksCatalogRoll.btn_work_state.enabled = true
			if (MD_Data.InWorkTask != undefined and MD_Data.ActiveTask.Article != MD_Data.InWorkTask.Article and MD_Data.ActiveTask.Group == undefined) or \
			(MD_Data.InWorkTask == undefined and (MD_Data.ActiveTask.Group == undefined or MD_Data.ActiveTask.Group != undefined)) or \
			(MD_Data.InWorkTask != undefined and MD_Data.ActiveTask != MD_Data.InWorkTask and MD_Data.ActiveTask.Group != MD_Data.InWorkTask.Group) then
			(
				TasksCatalogRoll.btn_work_state.text = "Set Work State"
				TasksCatalogRoll.btn_exit_work_state.enabled = false
				for ctrl in GeneralCatalogRoll.Controls do ctrl.enabled = false
				for ctrl in GeneralProjectsRoll.Controls do ctrl.enabled = false
			)
			else if (MD_Data.InWorkTask != undefined and MD_Data.ActiveTask.Article == MD_Data.InWorkTask.Article and MD_Data.ActiveTask.Group == undefined) or \
			
			(MD_Data.InWorkTask != undefined and MD_Data.ActiveTask.Article == MD_Data.InWorkTask.Article and MD_Data.ActiveTask.Group == MD_Data.InWorkTask.Group) then
			(
				TasksCatalogRoll.btn_work_state.text = "Update Work State"
				TasksCatalogRoll.btn_work_state.enabled = true
				TasksCatalogRoll.btn_exit_work_state.enabled = true
				TasksCatalogRoll.btn_get.enabled = false
				TasksCatalogRoll.btn_clear.enabled = false
				TasksCatalogRoll.btn_get.text = "Get"
				TasksCatalogRoll.btn_clear.text = "Clear"
				if SettingsRoll.ckbx_tooltips.Checked == true then
				TasksCatalogRoll.btn_get.tooltip = MD_Tooltips.tasks_02_a
				if SettingsRoll.ckbx_tooltips.Checked == true then
				TasksCatalogRoll.btn_clear.tooltip = MD_Tooltips.tasks_03_a
				
				if MD_Data.ActiveList == 2 then
				(
					TasksCatalogRoll.btn_assign_texts.enabled = true
					if subobjectLevel == 4 or subobjectLevel == 5 then TasksCatalogRoll.btn_assign_mat_id.enabled = true			
					else if subobjectLevel == 0 or subobjectLevel == undefined then TasksCatalogRoll.btn_assign_mat_id.enabled = false
				)
			)
			else if (MD_Data.InWorkTask != undefined and MD_Data.ActiveTask.Article != MD_Data.InWorkTask.Article and MD_Data.ActiveTask.Group == MD_Data.InWorkTask.Group) then
			(
				TasksCatalogRoll.btn_work_state.text = "Set Work State"
				TasksCatalogRoll.btn_work_state.enabled = true
				TasksCatalogRoll.btn_exit_work_state.enabled = true
			)
			for ctrl in InfoCatalogRoll.Controls do ctrl.enabled = true
			
			try (CatalogListMain.Items.Item[MD_Data.ActiveTaskIndex - 1].Selected = True) catch()
		)
		if MD_Data.TempArticlesList.count != 0 then
		(
			TasksCatalogRoll.btn_work_state.enabled = false
			TasksCatalogRoll.btn_exit_work_state.enabled = false
			for ctrl in GeneralCatalogRoll.Controls do ctrl.enabled = false
			for ctrl in GeneralProjectsRoll.Controls do ctrl.enabled = false
			case MD_Client.ActiveCheckParam of
			(
				1:(
					TasksCatalogRoll.btn_get.text = "Get"
					if SettingsRoll.ckbx_tooltips.Checked == true then
					TasksCatalogRoll.btn_get.tooltip = MD_Tooltips.tasks_02_a
				)
				2:(
					TasksCatalogRoll.btn_get.text = "Send"
					if SettingsRoll.ckbx_tooltips.Checked == true then
					TasksCatalogRoll.btn_get.tooltip = MD_Tooltips.tasks_02_b
				)
				3:(
					TasksCatalogRoll.btn_get.text = "Backup"
					if SettingsRoll.ckbx_tooltips.Checked == true then
					TasksCatalogRoll.btn_get.tooltip = MD_Tooltips.tasks_02_c
				)
				4:
				(
					TasksCatalogRoll.btn_get.text = "Restore"
					if SettingsRoll.ckbx_tooltips.Checked == true then
					TasksCatalogRoll.btn_get.tooltip = MD_Tooltips.tasks_02_d
				)
			)
			TasksCatalogRoll.btn_clear.text = "Clear"
			if SettingsRoll.ckbx_tooltips.Checked == true then
			TasksCatalogRoll.btn_clear.tooltip = MD_Tooltips.tasks_03_a
		)
		else
		(
			TasksCatalogRoll.btn_get.text = "Update"
			if SettingsRoll.ckbx_tooltips.Checked == true then
			TasksCatalogRoll.btn_get.tooltip = MD_Tooltips.tasks_02_e
			TasksCatalogRoll.btn_clear.text = "Delete"
			if SettingsRoll.ckbx_tooltips.Checked == true then
			TasksCatalogRoll.btn_clear.tooltip = MD_Tooltips.tasks_03_b
		)
		if MD_Data.CheckedTasks.Count > 0 then
		(
			TasksCatalogRoll.btn_get.enabled = true
			TasksCatalogRoll.btn_clear.enabled = true
			TasksCatalogRoll.btn_work_state.enabled = false
			TasksCatalogRoll.btn_exit_work_state.enabled = false
		)
		if SubCategories.Items.Count != 0 then
		(
			TasksCatalogRoll.lst_basic_catalog.enabled = true
			TasksCatalogRoll.lst_sub_catalog.enabled = true
			TasksCatalogRoll.btn_check.enabled = true
		)
		try
		(
			InfoCatalogWeb.text = ""
			InfoCatalogWeb.text = substring MD_Data.ActiveTask.Website 1 30
		)
		catch()
	),
	fn FillTempData =
	(
		local main_items = #()
		for i in MD_Data.TempArticlesList do
		(
			dn_list_item = dotNetObject "System.Windows.Forms.ListViewItem" i
			dn_list_item.checked = true
			case MD_Client.ActiveCheckParam of
			(
				1:(dn_list_item.ForeColor = DN_CLR_TEMP)
				2:(dn_list_item.ForeColor = DN_CLR_BAD)
				3:(dn_list_item.ForeColor = DN_CLR_DONE)
				4:(dn_list_item.ForeColor = DN_CLR_TEMP)
			)
			
			append main_items dn_list_item
		)
		CatalogListMain.Items.Clear()
		CatalogListMain.Items.AddRange main_items
		CatalogListMain.Update()
		CatalogListAdd.Items.Clear()
		CatalogListAdd.Update()
	),
	fn SwitchRollouts = (
		try MD_Callbacks.Destruct() catch()
		removeSubRollout MainRoll.sub_rlt GeneralProjectsRoll
		removeSubRollout MainRoll.sub_rlt InfoProjectsRoll
		removeSubRollout MainRoll.sub_rlt TasksProjectsRoll
		AddSubRollout MainRoll.sub_rlt TasksCatalogRoll rolledUp:false
		AddSubRollout MainRoll.sub_rlt InfoCatalogRoll rolledUp:true
		try AddSubRollout MainRoll.sub_rlt ToolsCatalogRoll rolledUp:true catch()
		AddSubRollout MainRoll.sub_rlt GeneralCatalogRoll rolledUp:true
		MD_Data.FullUpdate()
				
        AddSubRollout MainRoll.sub_rlt AboutRoll rolledUp:True
		
		MainRoll.sub_rlt.height = (MAIN_RLT_HEIGHT - 28)
		MainRoll.sub_rlt.pos = [2, 4]
		updateRolloutLayout TasksCatalogRoll forceUpdate:true
	),
	fn Close = (
		try(cui.UnRegisterDialogBar ::rlt_make_design_tools)catch()
		try(destroyDialog ::rlt_make_design_tools)catch()
	),
	fn SetColorScheme =
	(
		local color_theme = colorMan.getColorTheme()
		if color_theme == #light then
		(
			DN_CLR_X = (dotNetClass "system.Drawing.color").FromArgb 255 200 50 50
			DN_CLR_OK = (dotNetClass "system.Drawing.color").FromArgb 255 10 130 10
			DN_MAX_UI_CLR = (dotNetClass "system.Drawing.color").FromArgb 255 214 214 214
		)
		else if color_theme == #dark then
		(
			DN_CLR_X = (dotNetClass "system.Drawing.color").FromArgb 255 255 90 50
			DN_CLR_OK = (dotNetClass "system.Drawing.color").FromArgb 255 55 200 55
			DN_MAX_UI_CLR = (dotNetClass "system.Drawing.color").FromArgb 255 68 68 68
		)
	),
	fn Init = (
		local exist_categ_index = undefined
		local exist_sub_categ_index = undefined
		Close()
		SetColorScheme()
		createdialog MainRoll width:(MAIN_RLT_WIDTH + 8) height:(MAIN_RLT_HEIGHT - 20) autoLayoutOnResize:true scrollBar:#on lockHeight:false
		AddSubRollout MainRoll.sub_rlt SettingsRoll rolledUp:true
		AddSubRollout MainRoll.sub_rlt TasksCatalogRoll rolledUp:true
		AddSubRollout MainRoll.sub_rlt InfoCatalogRoll rolledUp:true
		try AddSubRollout MainRoll.sub_rlt ToolsCatalogRoll rolledUp:true catch()
		AddSubRollout MainRoll.sub_rlt GeneralCatalogRoll rolledUp:true
		AddSubRollout MainRoll.sub_rlt TasksProjectsRoll rolledUp:true
		AddSubRollout MainRoll.sub_rlt InfoProjectsRoll rolledUp:true
		AddSubRollout MainRoll.sub_rlt GeneralProjectsRoll rolledUp:true
		AddSubRollout MainRoll.sub_rlt AboutRoll rolledUp:true
        try(
            GetINISettings SettingsRoll MDT_CONFIG_FILE SettingsRoll.name
            GetINISettings TasksCatalogRoll MDT_CONFIG_FILE TasksCatalogRoll.name include_list:#(TasksCatalogRoll.lst_basic_catalog, TasksCatalogRoll.lst_sub_catalog)
            GetINISettings InfoCatalogRoll MDT_CONFIG_FILE InfoCatalogRoll.name onlyRollState:true
            try GetINISettings ToolsCatalogRoll MDT_CONFIG_FILE ToolsCatalogRoll.name onlyRollState:true catch()
            GetINISettings GeneralCatalogRoll MDT_CONFIG_FILE GeneralCatalogRoll.name onlyRollState:true
        )catch ()
		if MD_Data.main_categs.count != 0 then
		(
			exist_categ_index = execute (GetINISetting MDT_CONFIG_FILE TasksCatalogRoll.Name "lst_basic_catalog_selection")
			if classOf exist_categ_index != Integer then exist_categ_index = 1
		)
		if MD_Data.sub_categs.count != 0 then
		(
			exist_sub_categ_index = execute (GetINISetting MDT_CONFIG_FILE TasksCatalogRoll.Name "lst_sub_catalog_selection")
			if classOf exist_sub_categ_index != Integer then exist_sub_categ_index = 1
		)
			exist_task_index = execute (GetINISetting MDT_CONFIG_FILE TasksCatalogRoll.Name (CatalogListMain.name + "_selection"))
			if classOf exist_task_index == Integer then
			(
				exist_task_index += 1
				MD_Data.ActiveTaskIndex = exist_task_index
				MD_Data.ActiveTask = MD_Data.Tasks[exist_task_index]				
			)
		try (
			if exist_categ_index > 0 then Categories.Selection = MD_Data.ActiveCategory = exist_categ_index
			else if exist_categ_index == 0 and MD_Data.main_categs.count != 0 then Categories.Selection = MD_Data.ActiveCategory = 1
			
			if exist_sub_categ_index > 0 then SubCategories.Selection = MD_Data.ActiveSubCategory = exist_sub_categ_index
			else if exist_sub_categ_index == 0 and MD_Data.sub_categs.count != 0 then SubCategories.Selection = MD_Data.ActiveSubCategory = 1
		)
		catch()
		try(
			EMPTY_PREVIEW = CreatePreviewFromImageFile ICON_NO_PRVIEW_FILE PREVIEW_SIZE
			InfoCatalogPreview.bitmap = EMPTY_PREVIEW
		)
		catch (MD_Log.Error "Не удалось загрузить изображение \"NO PREVIEW\".")
		if SettingsRoll.ckbx_tooltips.Checked == false then
		(
			for ctrl in SettingsRoll.Controls do try(ctrl.tooltip = "")catch()
			for ctrl in TasksCatalogRoll.Controls do try(ctrl.tooltip = "")catch()
			for ctrl in InfoCatalogRoll.Controls do try(ctrl.tooltip = "")catch()
			try (for ctrl in ToolsCatalogRoll.Controls do try(ctrl.tooltip = "")catch()) catch()
			for ctrl in GeneralCatalogRoll.Controls do try(ctrl.tooltip = "")catch()
			for ctrl in GeneralProjectsRoll.Controls do try(ctrl.tooltip = "")catch()
		)
		SettingsRoll.ckbx_tooltips.tooltip = "Требуется перезагрузка."
		MD_Data.Update()
		
		InitCatalogLists()
		FillCategoriesLists()
		FillMainList()
		FillAddList()
		InitProjectsLists()
		SwitchRollouts()
		MD_Data.LoadState = true
		MD_Data.ProjectsRollLoadState = true
		UpdateCatalogInfoRlt()
	),
	on create do Init()
)
struct BoundingBox
(
	Layer = undefined,
	bbox_size = [0, 0, 0],
	pivot_pos = [0, 0, 0],
	bb = undefined,
	arrow = undefined,
	pp = undefined,
	clr_main = MD_UI.SettingsRoll.clr_bb_main.color,
	clr_add = MD_UI.SettingsRoll.clr_bb_add.color,
	arrow_offset = ConvertCentimeterToSysUnits 10.0,
	arrow_rad = ConvertCentimeterToSysUnits 20.0,
	fn Remove =
	(
		try(delete (execute ("$" + HELPER_OBJECTS[1] + "*")))catch()
		try(delete (execute ("$" + HELPER_OBJECTS[2] + "*")))catch()
		try(delete (execute ("$" + HELPER_OBJECTS[3] + "*")))catch()
		try(delete (execute ("$" + HELPER_OBJECTS[4] + "*")))catch()
		try(LayerManager.deleteLayerByName mdt_temp_layer)catch()
		gc()
	),
	fn CreateBBox =
	(
		this.bb = Box name:HELPER_OBJECTS[1] length:0.0 width:0.0 height:0.0 isSelected:off
		this.arrow = Ngon name:HELPER_OBJECTS[2] radius:0.0 cornerRadius:0 nsides:3 circular:off scribe:1 pos:[0, 0, 0] isSelected:off
		this.pp = Point name:HELPER_OBJECTS[3] isSelected:off
		cur_sel = selection
		setTransformLockFlags this.bb #all
		setTransformLockFlags this.arrow #all
		setTransformLockFlags this.pp #all
		this.bb.boxmode = on
		this.bb.showFrozenInGray = this.arrow.showFrozenInGray = off
		this.bb.isFrozen = this.arrow.isFrozen = on
		this.bb.isSelected = this.arrow.isSelected = off
		this.bb.renderable = this.arrow.renderable = off
		this.bb.wireColor = this.arrow.wireColor = clr_main
		this.arrow.render_renderable = false
		this.arrow.render_useViewportSettings = false
		this.arrow.render_displayRenderMesh = false
		this.pp.centermarker = on
		this.pp.Box = off
		this.pp.cross = off
		this.pp.axistripod = off
		this.pp.drawontop = on
		this.pp.showFrozenInGray = off
		this.pp.isFrozen = on
		this.pp.wireColor = CLR_BBOX_PIVOT
		this.pp.ishidden = on
		this.Layer.addnode bb
		this.Layer.addnode arrow
		this.Layer.addnode pp
		select cur_sel
		snapMode.toFrozen = true
		completeRedraw()
		MD_Data.TempLayerNodes = GetAllLayerNodes this.Layer.Name
	),
	fn CreateLayer =
	(
		LayerManager.newLayerFromName mdt_temp_layer
		this.Layer = LayerManager.getLayerFromName mdt_temp_layer
		Layer.on = false
		Layer.lock = on
		Layer.ishidden = MD_UI.SettingsRoll.ckbx_show_bb.checked
	),
	fn WritePivotData task:MD_Data.InWorkTask =
	(
		if task != undefined then
		(
			ReadDataFile task.File
			data["pivot"] = #(
				ConvertSysUnitsToCentimeters pivot_pos[1], 
				ConvertSysUnitsToCentimeters pivot_pos[2], 
				ConvertSysUnitsToCentimeters pivot_pos[3]
			)
			WriteDataFile task.File
		)
	),
	fn ReadPivotData =
	(
		if MD_Data.ActiveTask != undefined then
		(
			ReadDataFile MD_Data.ActiveTask.File
			pivot_pos = [ConvertCentimeterToSysUnits data["pivot"][1], \
			ConvertCentimeterToSysUnits data["pivot"][2], \
			ConvertCentimeterToSysUnits data["pivot"][3]]
		)
	),
	fn SetPivotPos =
	(
		try(
			bb_x = [bb.min.x, bb.center.x, bb.max.x]
			bb_y = [bb.min.y, bb.center.y, bb.max.y]
			bb_z = [bb.min.z, bb.center.z, bb.max.z]
			pivot_pos = [bb_x[MD_UI.Dialogs.PivotParams.lst_x.selection], \
			bb_y[MD_UI.Dialogs.PivotParams.lst_y.selection], \
			bb_z[MD_UI.Dialogs.PivotParams.lst_z.selection]]
			
			this.pp.pos = [pivot_pos[1], pivot_pos[2], pivot_pos[3]]
		)catch()
		completeRedraw()
	),
	fn ResetPivot =
	(
		try(
			pivot_pos = [0.0, 0.0, 0.0]
			this.pp.pos = [pivot_pos[1], pivot_pos[2], pivot_pos[3]]
			WritePivotData()
		)catch()
		completeRedraw()
	),
	fn Update =
	(
		case MD_Data.ActiveSection of
		(
			1:(
				local arrow_offset = ConvertCentimeterToSysUnits 10.0
				
				try ReadPivotData() catch()
				try this.pp.pos = [pivot_pos[1], pivot_pos[2], pivot_pos[3]] 
				catch(
					Remove()
					CreateLayer()
					CreateBBox()
				)
				arrow_rad = 0.0
				bbox_size = [0, 0, 0]
				this.bb.isHidden = true
				this.arrow.isHidden = true
				this.pp.isHidden = true
				this.bb.wireColor = clr_main
				this.arrow.wireColor = clr_main
				if MD_Data.InWorkTask != undefined then
				(
					case MD_Data.InWorkTask.ActiveMesh of
					(
						1:(
							bb_w = MD_Data.InWorkTask.Size[1]
							bb_d = MD_Data.InWorkTask.Size[2]
							bb_h = MD_Data.InWorkTask.Size[3]
							bbox_size = [bb_w, bb_d, bb_h]
							this.bb.wireColor = clr_main
							this.arrow.wireColor = clr_main
						)
						2:(
							bt_w = MD_Data.InWorkTask.SizeTrans[1]
							bt_d = MD_Data.InWorkTask.SizeTrans[2]
							bt_h = MD_Data.InWorkTask.SizeTrans[3]
							bbox_size = [bt_w, bt_d, bt_h]
							this.bb.wireColor = clr_add
							this.arrow.wireColor = clr_add
						)
					)
					arrow_rad = ConvertCentimeterToSysUnits 10.0
					
					if MD_Data.InWorkTask != undefined and MD_Data.ActiveTask != undefined and MD_Data.InWorkTask.Article == MD_Data.ActiveTask.Article then
					(
						if MD_UI.SettingsRoll.ckbx_show_bb.checked and MD_UI.SettingsRoll.ckbx_show_icon.checked then
						(
							this.bb.isHidden = false
							this.arrow.isHidden = false
							this.pp.isHidden = not MD_UI.SettingsRoll.ckbx_auto_pivot.checked
							try MD_Data.ActiveCategoryIcon.icon.isHidden = false catch()
						)
						else if MD_UI.SettingsRoll.ckbx_show_bb.checked and not MD_UI.SettingsRoll.ckbx_show_icon.checked then
						(
							this.bb.isHidden = false
							this.arrow.isHidden = false
							this.pp.isHidden = not MD_UI.SettingsRoll.ckbx_auto_pivot.checked
							try MD_Data.ActiveCategoryIcon.icon.isHidden = true catch()
						)
						else if not MD_UI.SettingsRoll.ckbx_show_bb.checked and MD_UI.SettingsRoll.ckbx_show_icon.checked then
						(
							this.bb.isHidden = true
							this.arrow.isHidden = true
							this.pp.isHidden = not MD_UI.SettingsRoll.ckbx_auto_pivot.checked
							try MD_Data.ActiveCategoryIcon.icon.isHidden = false catch()
						)	
						else if not MD_UI.SettingsRoll.ckbx_show_bb.checked and not MD_UI.SettingsRoll.ckbx_show_icon.checked then
						(
							this.bb.isHidden = true
							this.arrow.isHidden = true
							try MD_Data.ActiveCategoryIcon.icon.isHidden = true catch()
						)					
					)
				)
				this.bb.length = bbox_size[1]
				this.bb.width = bbox_size[2]
				this.bb.height = bbox_size[3]
				this.arrow.radius = arrow_rad
				this.arrow.pos.x = (this.bb.width/2.0 + arrow_rad/2.0 + arrow_offset)
				try (MD_Data.ActiveCategoryIcon.FitSizeToBBox this.bb) catch()
			)
			2:(
			)
		)
		completeRedraw()
	),
	fn ChangeColor =
	(
		clr_main = MD_UI.SettingsRoll.clr_bb_main.color
		clr_add = MD_UI.SettingsRoll.clr_bb_add.color
		case MD_Data.ActiveTask.ActiveMesh of
		(
			1:(
				this.bb.wireColor = clr_main
				this.arrow.wireColor = clr_main
			)
			2:(
				this.bb.wireColor = clr_add
				this.arrow.wireColor = clr_add
			)
		)
		completeRedraw()
	),
	fn Init =
	(
		this.Remove()
		this.CreateLayer()
		this.CreateBBox()
	),
	on create do Init()
)
struct Callback
(
	ToolsUIUpdate = undefined,
	fn UpdateUI ev nd = 
	(
		MD_UI.UpdateCatalogGeneralRlt()
		MD_UI.UpdateCatalogTasksRlt()
		if not MD_UI.SettingsRoll.ckbx_show_icon.checked then
		(
			try MD_Data.ActiveCategoryIcon.Icon.IsHidden = not MD_UI.SettingsRoll.ckbx_show_icon.checked catch()
			try MD_Data.WorkLayer.on = on catch()
			completeRedraw()			
		)
	),
	fn UpdateUI2 ev nd = 
	(
		MD_UI.UpdateCatalogGeneralRlt()
		MD_UI.UpdateCatalogTasksRlt()
	),
	fn AddObject = 
	(
		try (
			local obj = callbacks.notificationParam()
			if obj.Layer != MD_Data.WorkLayer then
			(
				obj.Material = undefined
				if (findString obj.Name MD_Data.WorkLayer.Name) != undefined then 
				(
					obj.Name = uniqueName "Object"
					obj.IsHidden = False
				)
			)
			if obj != MD_Data.ActiveTask.Mesh and obj != MD_Data.ActiveTask.AddMesh then
			(
				obj.Name = uniqueName "Object"
				obj.Material = undefined
			)
		)catch()
		MD_UI.UpdateCatalogGeneralRlt()
	),
	fn DeleteObject = 
	(
		try (
			local obj = callbacks.notificationParam()
			if MD_Data.InWorkTask != undefined then
			(
				if obj == MD_Data.InWorkTask.Mesh then MD_Data.InWorkTask.Mesh = undefined
				if obj == MD_Data.InWorkTask.AddMesh then MD_Data.InWorkTask.AddMesh = undefined
			)
			
		)catch()
		try (if obj == MD_Data.ActiveCategoryIcon.Icon then MD_Data.ActiveCategoryIcon.Icon = undefined) catch()
		MD_UI.UpdateCatalogGeneralRlt()
	),
	fn LayerChange = 
	(
		try (
			local params = callbacks.notificationParam()
			local obj = params[1]
			local old_layer = params[2]
			local new_layer = params[3]
			if obj.Layer == MD_BBox.Layer then
			(
				with redraw off
				(
					DEFAULT_LAYER.addNode obj
					DEFAULT_LAYER.Current = true					
				)
			)
			if new_layer != MD_Data.WorkLayer then
			(
				if obj == MD_Data.InWorkTask.Mesh then 
				(
					MD_Data.InWorkTask.Mesh = undefined
					obj.Name = uniqueName "Object"
				)
				if obj == MD_Data.InWorkTask.AddMesh then 
				(
					MD_Data.InWorkTask.AddMesh = undefined
					obj.Name = uniqueName "Object"
				)
				if obj.Material == MD_Data.InWorkTask.Material then obj.Material = undefined
			)
			completeRedraw()
		)catch()
		MD_UI.UpdateCatalogGeneralRlt()
	),
	fn CheckExistTaskLayer =
	(
		if (callbacks.notificationParam()).name == MD_Data.ActiveTask.Article then
		(
			if MD_Data.ActiveTask != undefined then
			(
				MD_Data.ActiveTask.State = STATES[1]
				MD_Data.ActiveTask.ActiveMesh = 1
				MD_Data.InWorkTask = undefined
				MD_Data.WorkLayer = undefined
				MD_Data.ActiveTask.Update()
				
				MD_Data.FullUpdate()
			)
		)
	),
		
	fn UpdateState =
	(
		try(
			if MD_Data.ActiveTask == MD_Data.InWorkTask then
			(
				MD_Data.Update()
				MD_Data.FullUpdate()
			)	
		) catch()
	),
	fn MatChange ev nd =
	(
		try (
		)catch()
	),
	fn Add =
	(
		callbacks.addScript #layerDeleted CheckExistTaskLayer id:#md_callbacks
		callbacks.addScript #filePostOpen UpdateState id:#md_callbacks
		callbacks.addScript #nodeCloned AddObject id:#md_callbacks
		callbacks.addScript #sceneNodeAdded AddObject id:#md_callbacks
		callbacks.addScript #nodeCreated AddObject id:#md_callbacks
		callbacks.addScript #nodePreDelete DeleteObject id:#md_callbacks
		callbacks.addScript #nodeLayerChanged LayerChange id:#md_callbacks
		ToolsUIUpdate = NodeEventCallback mouseUp:false delay:250 \
		materialOtherEvent:MatChange \
		selectionChanged: UpdateUI \
		subobjectSelectionChanged:UpdateUI2
	),
	fn Destruct =
	(
		callbacks.removeScripts id:#md_callbacks
		ToolsUIUpdate = undefined
		gc light:true
	)
)
struct HTTPClient
(
	ResponseStatus,
	ResponseMessage,
	ResponseData,
	ActiveCheckParam = 1,
	RequestDialogTitle,
	RequestDialogShow = True,
	fn GetResposeArticlesList =
	(
		local resp_articles = #()
		for rd in this.ResponseData do 
		(
			local resp = FilterString rd SEPAR2
			append resp_articles resp[1]
		)
		return resp_articles
	),
	fn GetResposeArticlesListWithFilter =
	(
		local filter_articles = #()
		local categ_lib_dirs = GetDirectories (MD_Data.sub_categ_lib_dirs[MD_Data.ActiveCategory][MD_Data.ActiveSubCategory] + "/*")
		local exist_articles = #()
		for dir in categ_lib_dirs do 
		(
		   local categ = pathConfig.stripPathToLeaf (trimRight dir "\\/")
		   append exist_articles categ
		)
		for rd in this.ResponseData do 
		(
			local resp = FilterString rd SEPAR2
			local f = findItem exist_articles resp[1]
			
			if f == 0 then (append filter_articles resp[1])
			else 
			(
				local exist_task_file = pathConfig.AppendPath categ_lib_dirs[f] TASK_INNER_DIRS[1]
				exist_task_file = pathConfig.AppendPath exist_task_file TASK_FILE_NAME
				if doesFileExist exist_task_file then
				(
					ReadDataFile exist_task_file
					local date = FilterString data["date_create"] " "
					if date[2] != resp[2] then append filter_articles resp[1]               
				)
			)
		)
		return filter_articles
	),
    fn Request request args:"" title:"" show_dialog:True =
    (
		this.ResponseStatus = undefined
		this.ResponseMessage = undefined
		this.ResponseData = undefined
		if DoesFileExist HTTP_CLIENT then
		(
			this.RequestDialogShow = show_dialog
			this.RequestDialogTitle = title
			shellLaunch HTTP_CLIENT (request + " " + args)
			CreateDialog MD_UI.Dialogs.Request modal:true
		)
		else 
		(
			this.ResponseMessage = "Не удалось обнаружить http-клиент."
			Client_Log.Error this.ResponseMessage
		)
    )
)
rollout dlg_check_tasks "Check Available Tasks" width:250 height:180
(
    radiobuttons 'rbtn_check_vars' labels:TASK_PARAMS_LIST default:1 columns:1 offsets:#([0, 24], [0, 30], [0, 36])\
        tooltip:#(MD_Tooltips.chk_01, MD_Tooltips.chk_02, MD_Tooltips.chk_03)
    groupBox 'grp_01' " Parameters: " width:(dlg_check_tasks.width - 20) height:100 align:#center offset:[0, -86]
    button 'btn_check' "Check" width:(dlg_check_tasks.width - 20) height:CTRL_HEIGHT_2 align:#center offset:[0, 2]
    
    on dlg_check_tasks open do 
    (
        MD_Client.ActiveCheckParam = rbtn_check_vars.state
    )
    on dlg_check_tasks close do 
    (
  
    )
    on rbtn_check_vars changed arg do
    (
        MD_Client.ActiveCheckParam = arg
    )
    on btn_check pressed do
    (
        DestroyDialog dlg_check_tasks
        try(DestroyDialog MD_UI.Dialogs.Request)catch()
        MD_Data.active_catalog_article = (MD_Data.main_categ_ids[MD_Data.ActiveCategory][MD_Data.ActiveSubCategory])
        local clr
        local args = ""
        case rbtn_check_vars.state of
        (
            1:(args = MD_Data.active_catalog_article + SEPAR + "1"; clr = DN_CLR_TEMP)
            2:(args = MD_Data.active_catalog_article + SEPAR + "2"; clr = DN_CLR_BAD)
            3:(args = MD_Data.active_catalog_article + SEPAR + "3"; clr = DN_CLR_DONE)
        )
        MD_Client.Request "get_catalog_branch_ids" args:args title:"Available Tasks Checkings" 
        msg = "Доступно заданий: " + (MD_Data.TempArticlesList.count as string) + " из " + MD_Client.ResponseMessage
        Client_Log.Info msg
        if MD_Data.TempArticlesList.count == 0 then 
        (
            MD_Data.FullUpdate()
        )
    )
)
rollout dlg_configure "Configure User Data" width:400 height:210
(
    local login, password
    local result_sum = 0
    local cur_md_lib
    Label 'lbl_6' "Local Database Dir: " width:92 offset:[8, 14] align:#left across:3
    editText 'etxt_local_dir' "" width:198 height:20 offset:[-20, 12] align:#left
    Button 'btn_md_lib_dir' "Browse" width:64 height:CTRL_HEIGHT_1 offset:[0, 11] align:#right
    Label 'lbl_8' "MD Login:" width:48 offset:[55, 2] align:#left across:2
    editText 'etxt_log' "" width:268 height:20 offset:[-2, 0] align:#right multiLine:false
    Label 'lbl_9' "MD Password:" width:68 offset:[33, 2] align:#left across:2
    editText 'etxt_pass' "" width:268 height:20 offset:[-2, 0] align:#right multiLine:false
    Label 'lbl_10' "Project Article:" width:70 offset:[30, 2] align:#left across:2
    editText 'etxt_proj_article' "" width:268 height:20 offset:[-2, 0] align:#right multiLine:false
    groupBox 'gbx_1' "" width:388 height:116 pos:[6, 2] align:#left
    button 'btn_confirm' "Confirm User Data" width:192 height:CTRL_HEIGHT_1 offset:[-7, 0] align:#left enabled:true across:2
    button 'btn_test' "Test Connection" width:192 height:CTRL_HEIGHT_1 offset:[7, 0] align:#right enabled:true
    button 'btn_get_data' "Get MakeDesign Data" width:388 height:CTRL_HEIGHT_2 offset:[0, -2] align:#center enabled:true
    Label 'lbl_info' "" width:388 offset:[-4, 2] align:#left across:3
    Label 'lbl_connect' "" width:388 offset:[168, 2] align:#left
    on dlg_configure open do
    (
        try(
            dialog_pos = execute (GetINISetting MDT_CONFIG_FILE dlg_configure.name "pos")
            SetDialogPos dlg_configure dialog_pos
        )catch()
        etxt_local_dir.text = MD_LIB_DIR
        etxt_local_dir.tooltip = MD_LIB_DIR
        etxt_proj_article.text = MD_CURRENT_PROJECT
        try(
            login = GetUserEnvVar "MD_USER_LOGIN"
            etxt_log.text = login
        )catch()
        try(
            password = GetUserEnvVar "MD_USER_PASS"
            etxt_pass.text = password
        )catch()
        cur_md_lib = etxt_local_dir.text
        
        if etxt_log.text != "" and etxt_pass.text != "" then
        btn_test.enabled = true
    )
    on dlg_configure close do
    (
        SetINISetting MDT_CONFIG_FILE dlg_configure.name "pos" ((GetDialogPos dlg_configure) as string)
        SetUserEnvVar "MD_USER_LOGIN" etxt_log.text
        SetUserEnvVar "MD_USER_PASS" etxt_pass.text
    )
    on btn_md_lib_dir pressed do
    (
        local dir = getSavePath caption:"Set MakeDesign data folder..." initialDir:MD_LIB_DIR
        
        if (dir == undefined) then etxt_local_dir.text = "" else 
        (
            SetUserEnvVar "MD_LIB_DIR" dir
            etxt_local_dir.text = dir
        )
                
    )
    on etxt_log entered arg do
    (
        if etxt_log.text != "" and etxt_pass.text != "" then
        btn_test.enabled = true
        else btn_test.enabled = false
        updateRolloutLayout dlg_configure forceUpdate:true
        SetUserEnvVar "MD_USER_LOGIN" etxt_log.text
    )
    on etxt_pass entered arg do
    (
        if etxt_log.text != "" and etxt_pass.text != "" then
        btn_test.enabled = true
        else btn_test.enabled = false
        updateRolloutLayout dlg_configure forceUpdate:true
        SetUserEnvVar "MD_USER_PASS" etxt_pass.text
    )
    on etxt_local_dir entered arg do
    (
        SetUserEnvVar "MD_LIB_DIR" etxt_local_dir.text
    )
    on etxt_proj_article entered arg do
    (
        SetUserEnvVar "MD_CURRENT_PROJECT" etxt_proj_article.text
    )
    on btn_confirm pressed do 
    (
        SetUserEnvVar "MD_LIB_DIR" etxt_local_dir.text
        SetUserEnvVar "MD_USER_LOGIN" etxt_log.text
        SetUserEnvVar "MD_USER_PASS" etxt_pass.text
        SetUserEnvVar "MD_CURRENT_PROJECT" etxt_proj_article.text
        MD_Data.Init()
        lbl_info.text = "Ok"
    )
    on btn_test pressed do
    (
        MD_Client.Request "check_connection" show_dialog:false title:"Check Internet Connection"
        
        if MD_Client.ResponseStatus == "200" then 
        (
            if etxt_log.text != "" and etxt_pass.text != "" then
            Client_Log.Info MD_Client.ResponseMessage
            MD_Client.Request "test_request" title:"Authorization Test"
        
            if MD_Client.ResponseStatus == "200" then 
            (
                lbl_info.text = "INFO: " + MD_Client.ResponseMessage
                Client_Log.Info MD_Client.ResponseMessage
                btn_get_data.enabled = true
            )
            else 
            (
                lbl_info.text = "ERROR: " + MD_Client.ResponseMessage
                Client_Log.Error MD_Client.ResponseMessage
            )
        )
        else(
            lbl_info.text = "ERROR: " + MD_Client.ResponseMessage
            Client_Log.Error MD_Client.ResponseMessage
            btn_get_data.enabled = false
        )
    )
    on btn_get_data pressed do 
    (
        lbl_connect.text = ""
        MD_Client.Request "get_users_tree" args:("\"" + MD_USERS_DATA_FILE + "\"") title:"Get Users Data"
        if MD_Client.ResponseStatus == "200" then 
        (
            Client_Log.Info MD_Client.ResponseMessage
            lbl_info.text = "INFO: " + MD_Client.ResponseMessage
            result_sum += 1
        )
        else
        (
            Client_Log.Error MD_Client.ResponseMessage
            lbl_info.text = "ERROR: " + MD_Client.ResponseMessage
        )
        MD_Client.Request "get_projects_tree" args:("\"" + MD_PROJECTS_DATA_FILE + "\"") title:"Get Projects Data"
        if MD_Client.ResponseStatus == "200" then 
        (
            Client_Log.Info MD_Client.ResponseMessage
            lbl_info.text = "INFO: " + MD_Client.ResponseMessage
            result_sum += 1
        )
        else
        (
            Client_Log.Error MD_Client.ResponseMessage
            lbl_info.text = "ERROR: " + MD_Client.ResponseMessage
        )
        MD_Client.Request "get_project_catalog" args:("\"" + MD_CURRENT_PROJECT + SEPAR + MD_CATALOG_DATA_FILE + "\"") title:("Get "+ MD_CURRENT_PROJECT + " Catalog Data")
        if MD_Client.ResponseStatus == "200" then 
        (
            Client_Log.Info MD_Client.ResponseMessage
            lbl_info.text = "INFO: " + MD_Client.ResponseMessage
            result_sum += 1
        )
        else
        (
            Client_Log.Error MD_Client.ResponseMessage
            lbl_info.text = "ERROR: " + MD_Client.ResponseMessage
        )
        if result_sum == 3 then 
        (
            destroyDialog dlg_configure
            
            MD_Data.CheckedTasks = #()
            MD_Callbacks.Destruct()
            MD_Data.Init()
            try (MD_UI.Categories.selection = 1) catch()
            try MD_Data.ActiveCategory = 1 catch()
            try MD_Data.ActiveSubCategory = 1 catch()
            try MD_UI.lst_sub_catalog.Items = MD_Data.sub_categs[MD_Data.ActiveCategory] catch()
            try MD_UI.lst_sub_catalog.selection = 1 catch()
            MD_Data.CheckedTasks = #()
            MD_Data.ActiveList = 1
            MD_Data.ActiveTaskAddIndex = undefined
            MD_Data.FullUpdate()
            MD_UI.FillCategoriesLists()
            try MD_BBox.Update() catch()
            try (MD_UI.SubCategories.selection = 1) catch()
            MD_UI.UpdateCatalogTasksRlt()
            if MD_Data.ActiveTask == MD_Data.InWorkTask then MD_Data.ShowLayers mode:#work_only
            else MD_Data.ShowLayers mode:#scene_only
        )
        else if result_sum > 0 then
        (
            msg = "Не удалось загрузить некоторые данные."
            lbl_info.text = "WARNING: " + msg
            Client_Log.Warning msg
        ) 
        else
        (
            msg = "Данные не были загружены."
            lbl_info.text = "ERROR: " + msg
            Client_Log.Error msg
        )
    )
)
rollout dlg_pivot_params "Pivot Settings"
(
    label 'lbl_x' "X" width:20 height:20 align:#left offset:[46, 8] across:3
    label 'lbl_y' "Y" width:20 height:20 align:#center offset:[6, 8]
    label 'lbl_z' "Z" width:20 height:20 align:#right offset:[-36, 8]
    dropdownlist 'lst_x' "" items:PIVOT_POS_X width:100 height:20 align:#left offset:[0, -6] selection:2 across:3
    dropdownlist 'lst_y' "" items:PIVOT_POS_Y width:100 height:20 align:#center offset:[0, -6] selection:2
    dropdownlist 'lst_z' "" items:PIVOT_POS_Z width:100 height:20 align:#right offset:[0, -6] selection:1
    
    button 'btn_ok' "OK" width:100 height:24 align:#center offset:[0, 4]
    on dlg_pivot_params close do
    (
        if MD_Data.ActiveTask.Group == undefined then MD_BBox.WritePivotData()
        else 
        (
            for t in MD_Data.Tasks where t.Group == MD_Data.ActiveTask.Group do MD_BBox.WritePivotData task:t
        )
    )
    on btn_ok pressed do
    (
        destroyDialog MD_UI.Dialogs.PivotParams
    )
    on lst_x selected arg do MD_BBox.SetPivotPos()
    on lst_y selected arg do MD_BBox.SetPivotPos()
    on lst_z selected arg do MD_BBox.SetPivotPos()
)
rollout dlg_load_work "Saved Works"
(
   dotNetControl 'lv_files' "System.Windows.Forms.ListView" width:220 align:#left offset:[-4, 2] across:2
   dotNetControl 'img_prew' "System.Windows.Forms.PictureBox" width:SAVED_PREVIEW_SIZE height:SAVED_PREVIEW_SIZE align:#left offset:[-78, 2] across:2
   button 'btn_load' "Load" width:111 height:CTRL_HEIGHT_2 align:#left offset:[-6, -37] acreoss:2 enabled:true
   button 'btn_delete' "Delete" width:111 height:CTRL_HEIGHT_2 align:#left offset:[107, -37] enabled:false
   fn UpdateTitle = (dlg_load_work.title = "Saved Works [" + (lv_files.Items.Count as string) + "]")
   on dlg_load_work open do
   (
      MD_UI.Dialogs.InitLoadWork()
      lv_files.Items.Item[0].Selected = true
      lv_files.height = 346
      UpdateTitle()
      try(
         dialog_pos = execute (GetINISetting MDT_CONFIG_FILE dlg_load_work.name "pos")
         SetDialogPos dlg_load_work dialog_pos
      )catch()
   )
   on dlg_load_work close do
   (
      MD_UI.UpdateCatalogGeneralRlt()
      SetINISetting MDT_CONFIG_FILE dlg_load_work.name "pos" ((GetDialogPos dlg_load_work) as string)
   )
   on lv_files Click self arg do
   (
      MD_UI.Dialogs.UpdatePreview()
   )
   on btn_load pressed do
   (
      try(
         local load_result = MD_Data.InWorkTask.LoadWork \
         MD_Data.InWorkTask.SavedWorks[lv_files.SelectedItems.Item[0].Index + 1] quiet_mode:false
         
         if load_result then destroyDialog dlg_load_work
      )catch()
   )
   on lv_files ItemChecked self args do 
   (
      lv_files.update()
       if keyboard.controlPressed == true then
       (
           for i = 0 to self.Items.count-1 do self.Items.Item[i].Checked = true
       )
       else if keyboard.altPressed == true then
       (
           for i = 0 to self.Items.count-1 do self.Items.Item[i].Checked = false
       )
       if self.CheckedItems.Count > 0 then
       btn_delete.enabled = true
       else btn_delete.enabled = false
   )
   on btn_delete pressed do
   (
      MD_UI.Dialogs.DeleteSavedFiles()
      MD_UI.Dialogs.InitLoadWork()
      if MD_Data.ActiveTask.SavedWorks.Count == 0 then
      (
         destroyDialog dlg_load_work
         MD_UI.UpdateCatalogGeneralRlt()
      )
      UpdateTitle()
   )
)
rollout dlg_export "Validation And Export" width:210  height:230
(
    label 'lbl_one_mesh' "1 - Objects Count" width:160 align:#left offset:[8, 24] across:2 tooltip:MD_Tooltips.val_exp_01
        dotnetcontrol 'lbl_one_mesh_txt' "System.Windows.Forms.Label" text:"X" width:24 offset:[-4, 24] align:#right
    label 'lbl_epoly' "2 - Object(s) Type" width:160 align:#left offset:[8, 2] across:2 tooltip:MD_Tooltips.val_exp_02
        dotnetcontrol 'lbl_epoly_txt' "System.Windows.Forms.Label" text:"X" width:24 align:#right offset:[-4, 2]
    label 'lbl_bounds' "3 - Bounds And Position" width:160 align:#left offset:[8, 2] across:2 tooltip:MD_Tooltips.val_exp_03
        dotnetcontrol 'lbl_bounds_txt' "System.Windows.Forms.Label" text:"X" width:24 align:#right offset:[-4, 2]
    label 'lbl_cor_mat' "4 - Material" width:160 align:#left offset:[8, 2] across:2 tooltip:MD_Tooltips.val_exp_04
        dotnetcontrol 'lbl_cor_mat_txt' "System.Windows.Forms.Label" text:"X" width:24 align:#right offset:[-4, 2]
    label 'lbl_mat_id' "5 - Material IDs Count" width:190 align:#left offset:[8, 2] across:2 tooltip:MD_Tooltips.val_exp_05
        dotnetcontrol 'lbl_mat_id_txt' "System.Windows.Forms.Label" text:"X" width:24 align:#right offset:[-4, 2]
    label 'lbl_uvs' "6 - UVs" width:160 align:#left offset:[8, 2] across:2 tooltip:MD_Tooltips.val_exp_06
        dotnetcontrol 'lbl_uvs_txt' "System.Windows.Forms.Label" text:"X" width:24 align:#right offset:[-4, 2]
    label 'lbl_icon' "7 - Icon" width:160 align:#left offset:[8, 2] across:2 tooltip:MD_Tooltips.val_exp_06
        dotnetcontrol 'lbl_icon_txt' "System.Windows.Forms.Label" text:"X" width:24 align:#right offset:[-4, 2]
    groupBox 'grp_01' " Validation " width:(dlg_export.width - 20) height:174 align:#center offset:[0, -166]
    button 'btn_export' "EXPORT" width:(dlg_export.width - 20) height:CTRL_HEIGHT_2 align:#center offset:[0, 0] enabled:false
    timer 'clock' "Clock" interval:250
    
    on clock tick do
    (
        local val_result = MD_Data.validation()
		if val_result[1] then btn_export.enabled = true
		else btn_export.enabled = false
    )
    on dlg_export open do
    (
        for i = 2 to 14 by 2 do
        (
            dlg_export.controls[i].BackColor = DN_MAX_UI_CLR
            dlg_export.controls[i].ForeColor = DN_CLR_X
            dlg_export.controls[i].font = DN_LIB.Font 5 10 3 
            dlg_export.controls[i].TextAlign = DN_LIB.MiddleCenter      
        )
        try(
            dialog_pos = execute (GetINISetting MDT_CONFIG_FILE dlg_export.name "pos")
            SetDialogPos dlg_export dialog_pos
        )catch()
        MD_Callbacks.Add()
    )
    on dlg_export close do
    (
        SetINISetting MDT_CONFIG_FILE dlg_export.name "pos" ((GetDialogPos dlg_export) as string)
    )
    on btn_export pressed do
    (
        destroyDialog dlg_export
        if MD_Data.InWorkTask.Group == undefined then MD_Data.ExportTask()
        else(
            local cur_active_task = MD_Data.ActiveTask
            for t in MD_Data.Tasks where t.group == MD_Data.InWorkTask.Group do
            (
                MD_Data.ActiveTask = t
                MD_Data.ExportTask()
            )
            
            MD_Data.ActiveTask = cur_active_task
        )
        if MD_Data.ActiveCategoryIcon.Icon != undefined then
        (
            local frame_size = MAX_TEX_SIZE / 16
            local max_size = amax #(MD_Data.InWorkTask.Size[1], MD_Data.InWorkTask.Size[2])
            local icon_out_file = "T_" + MD_Data.InWorkTask.Article + TEXTURES_SIFFIXES[7]
            if max_size >= (ConvertCentimeterToSysUnits 200.0) then frame_size = MAX_TEX_SIZE / 2
            else if max_size >= (ConvertCentimeterToSysUnits 100.0) then frame_size = MAX_TEX_SIZE / 4
            else if max_size >= (ConvertCentimeterToSysUnits 50.0) then frame_size = MAX_TEX_SIZE / 8
            icon_out_file = pathconfig.appendpath (pathconfig.removePathLeaf MD_Data.InWorkTask.InWorkDir) icon_out_file
            try (
                MD_Data.ActiveCategoryIcon.IconRender MD_Data.ActiveCategoryIcon.Icon frame_size:frame_size out_file:icon_out_file
            )catch()            
        )
    )
)
rollout dlg_request MD_Client.RequestDialogTitle width:350 height:100
(
    local dots = "."
    local index = 1
    local process = dotNetObject "System.Diagnostics.Process"
    local resp = #()
    local proc
    label 'lbl_01' "In Progress " align:#left offset:[30, 37] across:2
    label 'lbl_02' "." align:#left offset:[-70, 37]
    timer clock "Clock" interval:250
    on dlg_request open do
    (
        MD_Data.TempArticlesList = #()
		process.StartInfo.RedirectStandardOutput = true
		process.StartInfo.RedirectStandardError = true
        MD_Client.ResponseData = #()
        if MD_Client.RequestDialogShow == false then 
        (
            dlg_request.visible = false
            dlg_request.height = 0
            dlg_request.height = 0
        )
        else
        (
            dlg_request.visible = true
            dlg_request.height = 350
            dlg_request.height = 100
        )
    )
    on clock tick do
    (
		proc = process.GetProcessesByName(HTTP_CLIENT_NAME)
        if proc.count == 0 then 
        (
            try resp = (FilterString (getclipboardText()) SEPAR) catch()
            
            try MD_Client.ResponseStatus = resp[1] catch()
            try MD_Client.ResponseMessage = resp[2] catch()
            try MD_Client.ResponseData = (execute resp[3]) catch()
            try MD_Data.TempArticlesList = MD_Client.GetResposeArticlesList() catch()
            destroyDialog dlg_request
        )
        if (mod index 5) == 0 then (index = 1; dots = ".") else (index += 1; dots += ".")
        lbl_02.text = dots
    )
    on dlg_request close do
    (
        if MD_Data.TempArticlesList.count != 0 then
        (
            MD_UI.FillTempData()
            MD_Data.ActiveTask = undefined
            MD_UI.UpdateCatalogTasksRlt()
            MD_UI.UpdateCatalogInfoRlt()
            MD_UI.UpdateCatalogGeneralRlt()
            try MD_BBox.Update() catch()
            if MD_Data.ActiveTask != undefined and MD_Data.InWorkTask != undefined and MD_Data.ActiveTask.Article == MD_Data.InWorkTask.Article then 
            MD_Data.ShowLayers mode:#work_only
            else MD_Data.ShowLayers mode:#scene_only            
        )
    )
)
rollout dlg_load_textures "" width:320 height:270
(
    groupBox 'grp_01' " Textures: " width:(dlg_load_textures.width - 20) height:188 align:#left offset:[-3, 2]
    label 'lbl_01' "Diffuse:" width:70 height:18 align:#left offset:[8, -166] across:3
	button 'btn_d' EMPTY_TEXT width:(dlg_load_textures.width - 108) height:CTRL_HEIGHT_1 align:#center offset:[12, -170]
        checkbox 'ckbx_d' "" width:20 offset:[-3, -166] align:#right checked:false enabled:false
    label 'lbl_02' "Metallic:" width:70 height:18 align:#left offset:[7, 4] across:3
	button 'btn_m' EMPTY_TEXT width:(dlg_load_textures.width - 108) height:CTRL_HEIGHT_1 align:#center offset:[12, 0]
        checkbox 'ckbx_m' "" width:20 offset:[-3, 4] align:#right checked:false enabled:false
    label 'lbl_03' "Normal:" width:70 height:18 align:#left offset:[9, 4] across:3
	button 'btn_n' EMPTY_TEXT width:(dlg_load_textures.width - 108) height:CTRL_HEIGHT_1 align:#center offset:[12, 0]
        checkbox 'ckbx_n' "" width:20 offset:[-3, 4] align:#right checked:false enabled:false
    label 'lbl_04' "ARD:" width:70 height:18 align:#left offset:[20, 4] across:3
	button 'btn_ard' EMPTY_TEXT width:(dlg_load_textures.width - 108) height:CTRL_HEIGHT_1 align:#center offset:[12, 0]
        checkbox 'ckbx_ard' "" width:20 offset:[-3, 4] align:#right checked:false enabled:false
    label 'lbl_05' "Emission:" width:70 height:18 align:#left offset:[1, 4] across:3
	button 'btn_e' EMPTY_TEXT width:(dlg_load_textures.width - 108) height:CTRL_HEIGHT_1 align:#center offset:[12, 0]
        checkbox 'ckbx_e' "" width:20 offset:[-3, 4] align:#right checked:false enabled:false
    label 'lbl_06' "SSS:" width:70 height:18 align:#left offset:[22, 4] across:3
	button 'btn_sss' EMPTY_TEXT width:(dlg_load_textures.width - 108) height:CTRL_HEIGHT_1 align:#center offset:[12, 0]
        checkbox 'ckbx_sss' "" width:20 offset:[-3, 4] align:#right checked:false enabled:false
	button 'btn_auto_load' "Package Load" width:((dlg_load_textures.width - 23)/2) height:CTRL_HEIGHT_1 align:#center offset:[-2, 10] across:2
    button 'btn_delete' "Delete" width:((dlg_load_textures.width - 23)/2) height:CTRL_HEIGHT_1 align:#center offset:[2, 10] enabled:false
	button 'btn_load' "Add Textures To Material" width:(dlg_load_textures.width - 20) height:CTRL_HEIGHT_2 align:#center offset:[0, -2] enabled:false
    
    local controls_arr = #(#(btn_d, ckbx_d), #(btn_m, ckbx_m), #(btn_n, ckbx_n), #(btn_ard, ckbx_ard), #(btn_e, ckbx_e), #(btn_sss, ckbx_sss))
    local textures = #(undefined, undefined, undefined, undefined, undefined, undefined)
    local source_files = #(undefined, undefined, undefined, undefined, undefined, undefined)
    fn ChangeMaterial =
    (
        if textures[1] != undefined then 
        (
            bm = Bitmaptexture fileName:textures[1]
            MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex].diffuseMap = bm
            bm.reload()
        )
        else MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex].diffuseMap = undefined
        if textures[2] != undefined then 
        (
            bm = Bitmaptexture fileName:textures[2]
            MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex].specularMap = bm
            bm.reload()
        )
        else MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex].specularMap = undefined
        if textures[3] != undefined then 
        (
            bm = Bitmaptexture fileName:textures[3]
            MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex].bumpMap = bm
            bm.reload()
        )
        else MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex].bumpMap = undefined
        if textures[4] != undefined then 
        (
            bm = Bitmaptexture fileName:textures[4]
            MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex].glossinessMap = bm
            bm.reload()
        )
        else MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex].glossinessMap = undefined
        if textures[5] != undefined then 
        (
            bm = Bitmaptexture fileName:textures[5]
            MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex].selfillumMap = bm
            MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex].selfillumMapEnable = off
            bm.reload()
        )
        else MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex].selfillumMap = undefined
        if textures[6] != undefined then 
        (
            bm = Bitmaptexture fileName:textures[6]
            MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex].opacityMap = bm
            MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex].opacityMapEnable = off
            bm.reload()
        )
        else MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex].opacityMap = undefined
        MD_Data.ActiveTask.MatLib[1] = MD_Data.ActiveTask.Material
        saveTempMaterialLibrary MD_Data.ActiveTask.MatLib MD_Data.ActiveTask.MatLibFile
        MD_Data.ActiveTask.MatLib = loadTempMaterialLibrary MD_Data.ActiveTask.MatLibFile
        MD_Data.ActiveTask.Material = MD_Data.ActiveTask.MatLib[1]
        UpdateSceneMaterialLib()
        actionMan.executeAction 0 "63545"
        if MD_Data.InWorkTask != undefined then
        (
            if MD_Data.InWorkTask.Group == undefined then MD_Data.WorkLayerNodes = GetAllLayerNodes MD_Data.InWorkTask.Article
            else MD_Data.WorkLayerNodes = GetAllLayerNodes MD_Data.InWorkTask.Group
            for obj in MD_Data.WorkLayerNodes do
            (
                try(
                    if obj == MD_Data.InWorkTask.Mesh or obj == MD_Data.InWorkTask.AddMesh then
                    MD_Data.AssignMaterial obj
                )catch()
            )
        )
    )
    fn GetCheckedItems =
    (
        local checked_items = #()
        for i = 1 to controls_arr.count where controls_arr[i][2].checked == true do append checked_items controls_arr[i][2]
        return checked_items
    )
    fn InitExistTextures =
    (
        if MD_Data.ActiveTaskAddIndex == undefined then dlg_load_textures.title = ("Load Textures")
        else 
        (
            dlg_load_textures.title = ("Load Textures " + "[" + MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].Material + "]")
            btn_delete.enabled = false
            btn_load.enabled = false
            for i = 1 to controls_arr.count do
            (
                local task_dir = pathConfig.removePathLeaf (getFilenamePath MD_Data.ActiveTask.File)
                local text_name = "T_" + MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].Article + TEXTURES_SIFFIXES[i]
                local lib_tex_file = (pathConfig.appendPath task_dir text_name)
                if DoesFileExist lib_tex_file then
                (
                    controls_arr[i][1].text = text_name
                    controls_arr[i][2].checked = false
                    controls_arr[i][2].enabled = true
                    textures[i] = lib_tex_file
                    btn_delete.enabled = false
                    btn_load.enabled = false
                )
                else
                (
                    controls_arr[i][1].text = EMPTY_TEXT
                    controls_arr[i][2].checked = false
                    controls_arr[i][2].enabled = false
                    textures[i] = undefined
                )
            )
        )
        SetFocus dlg_load_textures 
    )
    fn OpenFile btn lbl def_text =
    (
        local file = getOpenFileName caption:"Set Texture File ..." types:"Targa (*.tga)|*.tga|"
        local task_dir = pathConfig.removePathLeaf (getFilenamePath MD_Data.ActiveTask.File)
        local suffix = ""
        local text_name = ""
        btn_delete.enabled = false
        btn_load.enabled = false
        
        if file != undefined then 
        (
            case def_text of
            (
                "Diffuse":(suffix = TEXTURES_SIFFIXES[1]; textures[1] = (pathConfig.appendPath task_dir ("T_" + MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].Article + suffix)); source_files[1] = file)
                "Metallic":(suffix = TEXTURES_SIFFIXES[2]; textures[2] = (pathConfig.appendPath task_dir ("T_" + MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].Article + suffix)); source_files[2] = file)
                "Normal":(suffix = TEXTURES_SIFFIXES[3]; textures[3] = (pathConfig.appendPath task_dir ("T_" + MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].Article + suffix)); source_files[3] = file)
                "ARD":(suffix = TEXTURES_SIFFIXES[4]; textures[4] = (pathConfig.appendPath task_dir ("T_" + MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].Article + suffix)); source_files[4] = file)
                "Emissive":(suffix = TEXTURES_SIFFIXES[5]; textures[5] = (pathConfig.appendPath task_dir ("T_" + MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].Article + suffix)); source_files[5] = file)
                "SSS":(suffix = TEXTURES_SIFFIXES[6]; textures[6] = (pathConfig.appendPath task_dir ("T_" + MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].Article + suffix)); source_files[6] = file)
            )
            text_name = "T_" + MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].Article + suffix
            btn.text = text_name
            lbl.checked = true
            lbl.enabled = true
            btn_delete.enabled = true
            btn_load.enabled = true
        )
    )
    fn CopyTextsToLib = 
    (
        local task_dir = pathConfig.removePathLeaf (getFilenamePath MD_Data.ActiveTask.File)
        for i = 1 to controls_arr.count where controls_arr[i][2].checked do
        (
            try (dosCommand ("copy " + source_files[i] + " " + textures[i] + " /Y /Z"))catch()                
        )
    )
	on dlg_load_textures open do
    (
        try(
            dialog_pos = execute (GetINISetting MDT_CONFIG_FILE dlg_load_textures.name "pos")
            SetDialogPos dlg_load_textures dialog_pos
        )catch()
        MD_Callbacks.Add()
        InitExistTextures()
    )
    on dlg_load_textures close do
    (
        SetINISetting MDT_CONFIG_FILE dlg_load_textures.name "pos" ((GetDialogPos dlg_load_textures) as string)
    )
    on ckbx_d changed arg do (
        if (GetCheckedItems()).count == 0 
        then (btn_delete.enabled = false; btn_load.enabled = false)
        else (btn_delete.enabled = true; btn_load.enabled = true)
    )
    on ckbx_m changed arg do (
        if (GetCheckedItems()).count == 0 
        then (btn_delete.enabled = false; btn_load.enabled = false)
        else (btn_delete.enabled = true; btn_load.enabled = true)
    )
    on ckbx_n changed arg do (
        if (GetCheckedItems()).count == 0 
        then (btn_delete.enabled = false; btn_load.enabled = false)
        else (btn_delete.enabled = true; btn_load.enabled = true)
    )
    on ckbx_ard changed arg do (
        if (GetCheckedItems()).count == 0 
        then (btn_delete.enabled = false; btn_load.enabled = false)
        else (btn_delete.enabled = true; btn_load.enabled = true)
    )
    on ckbx_e changed arg do (
        if (GetCheckedItems()).count == 0 
        then (btn_delete.enabled = false; btn_load.enabled = false)
        else (btn_delete.enabled = true; btn_load.enabled = true)
    )
    on ckbx_sss changed arg do (
        if (GetCheckedItems()).count == 0 
        then (btn_delete.enabled = false; btn_load.enabled = false)
        else (btn_delete.enabled = true; btn_load.enabled = true)
    )
    on btn_d pressed do OpenFile btn_d ckbx_d "Diffuse"
    on btn_m pressed do OpenFile btn_m ckbx_m "Metallic"
    on btn_n pressed do OpenFile btn_n ckbx_n "Normal"
    on btn_ard pressed do OpenFile btn_ard ckbx_ard "ARD"
    on btn_e pressed do OpenFile btn_e ckbx_e "Emissive"
    on btn_sss pressed do OpenFile btn_sss ckbx_sss "SSS"
    on btn_load pressed do
    (
        CopyTextsToLib()
        ChangeMaterial()
        MD_Data.ActiveTask.Update()
        MD_UI.FillAddList()
        CompleteRedraw()
    )
    on btn_delete pressed do
    (
        if (queryBox "Действительно удалить отмеченные текстуры из локальной базы?" title:"Внимание!" icon:#question) then
        (
            for i = 1 to controls_arr.count do
            (
                if controls_arr[i][2].checked then 
                (
                    dosCommand ("del + " + textures[i] + " /F")
                )
            )
            InitExistTextures()
            ChangeMaterial()
            MD_Data.ActiveTask.Update()
            MD_UI.FillAddList()
            CompleteRedraw()
        )
    )
)
rollout rlt_settings "Settings"
(
    button 'btn_paths' "Configure User Data" width:CTRL_WIDTH_1 height:CTRL_HEIGHT_1 align:#center offset:[1, V_MARGIN]
    button 'btn_fbx_sets' "FBX Settings" width:CTRL_WIDTH_1 height:CTRL_HEIGHT_1 align:#center offset:[1, V_MARGIN]
    checkbox 'ckbx_show_bb' "Show Bounding Box" width:120 offset:[0, 0] align:#left checked:true across:4 tooltip:MD_Tooltips.settings_01_a
    colorpicker 'clr_bb_main' fieldWidth:36 color:CLR_BBOX_MAIN height:16 align:#center offset:[62, 0] modal:false tooltip:MD_Tooltips.settings_01_b
    colorpicker 'clr_bb_add' fieldWidth:36 color:CLR_BBOX_ADD height:16 align:#center offset:[48, 0] modal:false tooltip:MD_Tooltips.settings_01_c
    button 'btn_clr_reset' "R" width:17 height:16 align:#right offset:[10, 0] tooltip:MD_Tooltips.settings_01_d
    checkbox 'ckbx_show_icon' "Show Icon" width:120 offset:[0, V_MARGIN] align:#left checked:false tooltip:MD_Tooltips.settings_06
    checkbox 'ckbx_auto_pivot' "Auto Pivot" width:150 offset:[0, 0] align:#left checked:true tooltip:MD_Tooltips.settings_02
    checkbox 'ckbx_auto_prev' "Auto Preview" width:150 offset:[0, 0] align:#rigth checked:true tooltip:MD_Tooltips.settings_03
    spinner 'spn_save_count' "Max Saving Count: " width:90 offset:[2, 1] range:[0, 100, 10] type:#integer fieldwidth:50 align:#left tooltip:MD_Tooltips.settings_04
    checkbox 'ckbx_load_last' "Auto Load Last Saving" width:150 offset:[0, 0] align:#left checked:false tooltip:MD_Tooltips.settings_05
    checkbox 'ckbx_tooltips' "Tooltips" width:150 offset:[0, 0] align:#left checked:false
    on rlt_settings open do
    (
      
    )
    on rlt_settings close do 
    (
    
    )
    on btn_paths pressed do
    (
		try(destroyDialog MD_UI.Dialogs.Configure)catch()
        CreateDialog MD_UI.Dialogs.Configure style:#(#style_sysmenu, #style_titlebar) modal:true
    )
    on btn_fbx_sets pressed do OpenFbxSetting()
    
    on ckbx_show_bb changed arg do 
    (
        try MD_BBox.Update() catch()
    )
    on ckbx_show_icon changed arg do 
    (               
        try MD_BBox.Update() catch()
    )
    on ckbx_auto_pivot changed arg do 
    (
        try MD_BBox.Update() catch()
    )
    on ckbx_tooltips changed arg do 
    ( 
    )
    on clr_bb_main changed arg do try MD_BBox.ChangeColor() catch()
    on clr_bb_add changed arg do try MD_BBox.ChangeColor() catch()
    on btn_clr_reset pressed do 
    (
        clr_bb_main.color = CLR_BBOX_MAIN
        clr_bb_add.color = CLR_BBOX_ADD
        try MD_BBox.ChangeColor() catch()
    )
)
rollout rlt_catalog_info "Info"
(
    label 'lbl_site' "Website:" width:50 offset:[-3, V_MARGIN] align:#left across:2
    hyperLink 'hpl_site' "" address:"" width:166 offset:[-50, V_MARGIN] align:#left visitedColor:(color 110 180 255) Color:(color 110 180 255) hoverColor:(color 120 190 255) enabled:false
    label 'lbl_size' "Size:" width:50 offset:[17, 0] align:#left across:2
    label 'lbl_size_txt' "" width:165 offset:[-50, 0] align:#left
    imgTag 'img_prev' "" offset:[1, 2] bitmap:undefined width:CTRL_WIDTH_1 height:CTRL_WIDTH_1 align:#center style:#bmp_center
    on rlt_catalog_info open do
    (
    )
    on img_prev lbuttondblclk point_click args do 
    (
        case MD_Data.ActiveList of
		(
			1:(HiddenDOSCommand MD_Data.ActiveTask.RefFile donotwait:true)
			2:(HiddenDOSCommand MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].RefFile donotwait:true)
        )
    )
)
rollout rlt_projects_info "Info"
(
    label 'lbl_size_txt' "Привет!" width:165 offset:[-50, 0] align:#left
)
rollout rlt_catalog_tasks "Catalog"
(
    dropdownlist 'lst_basic_catalog' "" items:#() width:CTRL_WIDTH_1 height:50 offset:[0, V_MARGIN] align:#center selection:1 enabled:true
    dropdownlist 'lst_sub_catalog' "" items:#() width:CTRL_WIDTH_1 height:50 offset:[1, V_MARGIN] align:#center selection:1 enabled:true
    button 'btn_check' "Check tasks" width:(CTRL_WIDTH_1/2 - 3) height:CTRL_HEIGHT_1 align:#center offset:[11, V_MARGIN] across:3 enabled:false tooltip:MD_Tooltips.tasks_01
    button 'btn_get' "Get" width:(CTRL_WIDTH_1/4 - 2) height:CTRL_HEIGHT_1 align:#center offset:[29, V_MARGIN] enabled:false tooltip:MD_Tooltips.tasks_02_a
    button 'btn_clear' "Clear" width:(CTRL_WIDTH_1/4 - 2) height:CTRL_HEIGHT_1 align:#center offset:[19, V_MARGIN] enabled:false tooltip:MD_Tooltips.tasks_03_a
    dotNetControl 'lv_main' "System.Windows.Forms.ListView" width:(CTRL_WIDTH_1) height:176 align:#center offset:[1, 0] enabled:true
    button 'btn_work_state' "Set Work State" width:CTRL_WIDTH_2 height:CTRL_HEIGHT_1 align:#center offset:[-5, 0] across:2 enabled:false tooltip:MD_Tooltips.tasks_04_a
    button 'btn_exit_work_state' "Exit Work State" width:CTRL_WIDTH_2 height:CTRL_HEIGHT_1 align:#center offset:[7, 0] enabled:false tooltip:MD_Tooltips.tasks_05
    
    dotNetControl 'lv_add' "System.Windows.Forms.ListView" width:(CTRL_WIDTH_1) height:110 align:#center offset:[1, 0] enabled:true
    button 'btn_assign_mat_id' "Set Material ID" width:CTRL_WIDTH_2 height:CTRL_HEIGHT_1 align:#center offset:[-5, 0] across:2 enabled:false tooltip:MD_Tooltips.tasks_06
    button 'btn_assign_texts' "Assign Textures" width:CTRL_WIDTH_2 height:CTRL_HEIGHT_1 align:#center offset:[7, 0] enabled:false tooltip:MD_Tooltips.tasks_07
    
    on rlt_catalog_tasks open do
    (
        lv_main.Name = "lv_main"
        if MD_Data.LoadState then
        (
            try lst_basic_catalog.Items = MD_Data.main_categs catch()
            try lst_sub_catalog.Items = MD_Data.sub_categs[MD_Data.ActiveCategory] catch()
            try lst_basic_catalog.selection = MD_Data.ActiveCategory catch()
            try lst_sub_catalog.selection = MD_Data.ActiveSubCategory catch()
            try MD_UI.InitCatalogLists() catch()
            try lv_main.Items.Item[MD_Data.ActiveTaskIndex - 1].selected = true catch()
            
            try MD_Data.active_catalog_article = (MD_Data.main_categ_ids[MD_Data.ActiveCategory][MD_Data.ActiveSubCategory]) catch()
            try (
                icon_file = pathConfig.appendPath DECALS_DIR (MD_Data.active_catalog_article + (ICON_POSTFIX + ".max"))
                MD_Data.ActiveCategoryIcon.SetIcon icon_file
            )catch(MD_Data.ActiveCategoryIcon.Icon = undefined)
        )
        if MD_Data.ActiveTask == MD_Data.InWorkTask then MD_Data.ShowLayers mode:#work_only
        else MD_Data.ShowLayers mode:#scene_only
    )
    
    on rlt_catalog_tasks close do
    (
  
    )
/*
    on lst_sections selected arg do 
    (
        if MD_Data.ActiveSection != arg then
        (
            MD_Data.ShowLayers mode:#none
            MD_Data.CheckedTasks = #()
            try MD_Callbacks.Destruct() catch()
            MD_Data.ActiveSection = arg
            MD_Data.ActiveList = 1
            MD_Data.ActiveTaskAddIndex = undefined
            MD_Data.Update()
            MD_UI.SwitchRollouts()
            MD_UI.FillCategoriesLists()
            MD_Data.FullUpdate()
            try MD_BBox.Update() catch()
    
            if MD_Data.ActiveTask == MD_Data.InWorkTask then MD_Data.ShowLayers mode:#work_only
            else MD_Data.ShowLayers mode:#scene_only
        )
        try (destroyDialog MD_UI.Dialogs.LoadTextures) catch()
    )
*/
    on lst_basic_catalog selected arg do
    (
        if MD_Data.ActiveCategory != arg then
        (
            MD_Data.ShowLayers mode:#none
            MD_Data.CheckedTasks = #()
            try MD_Callbacks.Destruct() catch()
            MD_Data.ActiveCategory = arg
            try lst_sub_catalog.Items = MD_Data.sub_categs[MD_Data.ActiveCategory] catch()
            try lst_sub_catalog.selection = 1 catch()
            MD_Data.ActiveSubCategory = lst_sub_catalog.selection
            MD_Data.ActiveList = 1
            MD_Data.ActiveTaskAddIndex = undefined
            MD_Data.Update()
            MD_Data.FullUpdate()
            try MD_BBox.Update() catch()
            if MD_Data.ActiveTask == MD_Data.InWorkTask then MD_Data.ShowLayers mode:#work_only
            else MD_Data.ShowLayers mode:#scene_only
            try (
                MD_Data.active_catalog_article = (MD_Data.main_categ_ids[MD_Data.ActiveCategory][MD_Data.ActiveSubCategory])
			    local icon_file = pathConfig.appendPath DECALS_DIR (MD_Data.active_catalog_article + (ICON_POSTFIX + ".max"))
			    MD_Data.ActiveCategoryIcon.SetIcon icon_file
            ) catch()
        )
        try (destroyDialog MD_UI.Dialogs.LoadTextures) catch()
    )
    on lst_sub_catalog selected arg do
    (
        if MD_Data.ActiveSubCategory != arg then
        (
            MD_Data.ShowLayers mode:#none
            MD_Data.CheckedTasks = #()
            try MD_Callbacks.Destruct() catch()
            MD_Data.ActiveSubCategory = arg
            MD_Data.ActiveList = 1
            MD_Data.ActiveTaskAddIndex = undefined
            MD_Data.Update()
            MD_Data.FullUpdate()
            try MD_BBox.Update() catch()
            
            if MD_Data.ActiveTask == MD_Data.InWorkTask then MD_Data.ShowLayers mode:#work_only
            else MD_Data.ShowLayers mode:#scene_only
            try (
                MD_Data.active_catalog_article = (MD_Data.main_categ_ids[MD_Data.ActiveCategory][MD_Data.ActiveSubCategory])
                local icon_file = pathConfig.appendPath DECALS_DIR (MD_Data.active_catalog_article + (ICON_POSTFIX + ".max"))
                MD_Data.ActiveCategoryIcon.SetIcon icon_file
            ) catch()
        )
        try (destroyDialog MD_UI.Dialogs.LoadTextures) catch()
        try (
			if MD_Data.ActiveCategoryIcon.Icon != undefined then
			MD_UI.ToolsCatalogRoll.btn_mode.text = "Edit Icon"
			else MD_UI.ToolsCatalogRoll.btn_mode.text = "Create Icon"			
		)catch()
    )
    on lst_sub_catalog rightClick do
    (
    ) 
    
    on btn_check pressed do 
    (
        try(DestroyDialog MD_UI.Dialogs.CheckTasks)catch()
        CreateDialog MD_UI.Dialogs.CheckTasks
    )
    on btn_get pressed do 
    (
        local args = ""
        local msg = ""
        local download_articles = ""
        MD_Data.ShowLayers mode:#none
        case btn_get.text of
        (
            "Send":( 
                local article = ""
                local msg = ""
                local user_id = ""
                local temp_txt = #()
                for i in MD_Data.CheckedTasks do
                (
                    local split = FilterString MD_Client.ResponseData[i] SEPAR2
                    article = split[1]
                    msg = split[3]
                    user_id = split[4]
                    args += user_id + SEPAR2
                    append temp_txt (article + " | " + msg)
                )
                args = trimRight args SEPAR2
                args += SEPAR
                for txt in temp_txt do
                (
                    args += (txt + SEPAR2)
                )
                args = "\"" + (trimRight args SEPAR2) + "\""
                MD_Client.Request "send_message" args:args title:"Sending Messages"
                Client_Log.Info MD_Client.ResponseMessage
            )
            "Update":(
                
                for i in MD_Data.CheckedTasks do
                (
                    download_articles += MD_Data.Tasks[i].Article + SEPAR1
                )
                download_articles = trimRight download_articles SEPAR1
                lib_path = pathConfig.AppendPath MD_LIB_DIR MD_CATEGS[2][1]
                MD_Data.active_catalog_article = (MD_Data.main_categ_ids[MD_Data.ActiveCategory][MD_Data.ActiveSubCategory])
                args = MD_Data.active_catalog_article + SEPAR + lib_path + SEPAR + download_articles
                MD_Client.Request "download_tasks" args:args title:"Updating Tasks"
                msg = "Обновлено заданий: " + MD_Client.ResponseMessage
                Client_Log.Info msg
            )
            "Backup":(
                
                for i in MD_Data.CheckedTasks do
                (
                    download_articles += MD_Data.TempArticlesList[i] + SEPAR1
                )
                download_articles = trimRight download_articles SEPAR1
                lib_path = pathConfig.AppendPath MD_LIB_DIR MD_CATEGS[2][1]
                args = "1" + SEPAR + download_articles + SEPAR + lib_path
                MD_Client.Request "download_items_content" args:args title:"Backup Content"
                msg = "Загружено контента: " + MD_Client.ResponseMessage + " из " + MD_Data.CheckedTasks.count as string
                Client_Log.Info msg
                MD_Data.CheckedTasks = #()          
            )
            default:(
                for i in MD_Data.CheckedTasks do
                (
                    download_articles += MD_Data.TempArticlesList[i] + SEPAR1
                )
                download_articles = trimRight download_articles SEPAR1
                lib_path = pathConfig.AppendPath MD_LIB_DIR MD_CATEGS[2][1]
                args = MD_Data.active_catalog_article + SEPAR + lib_path + SEPAR + download_articles
                MD_Client.Request "download_tasks" args:args title:"Downloading Tasks"
                msg = "Скачано заданий: " + MD_Data.CheckedTasks.count as string
                Client_Log.Info msg
            )
        )
        MD_Data.TempArticlesList = #()
        MD_Data.Update()
        MD_UI.FillMainList()
        MD_UI.FillAddList()
        MD_UI.UpdateCatalogTasksRlt()
        MD_UI.UpdateCatalogInfoRlt()
        MD_UI.UpdateCatalogGeneralRlt()
        try MD_BBox.Update() catch()
        if MD_Data.ActiveTask == MD_Data.InWorkTask then MD_Data.ShowLayers mode:#work_only
        else MD_Data.ShowLayers mode:#scene_only
        MD_Data.FullUpdate()
    )
    
    on btn_clear pressed do 
    (
        MD_Data.ShowLayers mode:#none
        case btn_clear.text of
        (
            "Clear":(
                MD_Data.TempArticlesList = #()
            )
            "Delete":
                (
                    MD_Data.ExitWorkState()
                    MD_Data.InWorkTask = Undefined
                    if keyboard.shiftPressed then
                    (
                        local del_task_dirs = 0
                        for i in MD_Data.CheckedTasks do
                        (
                            del = MD_Data.DeleteEmptyTask MD_Data.Tasks[i] trash:false
                            del_task_dirs += 1
                        )
                        if del_task_dirs > 0 then MD_Log.Info ("Удаленно заданий: " + del_task_dirs as string)
                    )
                    else
                    (
                        if (queryBox "Дейсвительно удалить отмеченные задания?" title:"Внимание!" icon:#warning) then
                        (
                            local del_task_dirs = 0
                            for i in MD_Data.CheckedTasks do
                            (
                                del = MD_Data.DeleteEmptyTask MD_Data.Tasks[i]
                                del_task_dirs += 1
                            )
                            if del_task_dirs > 0 then MD_Log.Info ("Удаленно заданий: " + del_task_dirs as string)
                        )                        
                    )
                )
        )
        MD_Data.CheckedTasks = #()
        MD_Data.Update()
        MD_UI.FillMainList()
        MD_UI.FillAddList()
        try MD_Data.ActiveTask = MD_Data.Tasks[MD_Data.ActiveTaskIndex] catch()
        MD_UI.UpdateCatalogTasksRlt()
        MD_UI.UpdateCatalogInfoRlt()
        MD_UI.UpdateCatalogGeneralRlt()
        try MD_BBox.Update() catch()
        if MD_Data.ActiveTask == MD_Data.InWorkTask then 
        (
            if MD_Data.InWorkTask != undefined then MD_Data.ShowLayers mode:#work_only
            else MD_Data.ShowLayers mode:#none
        )
        else MD_Data.ShowLayers mode:#scene_only
    )
    on lv_main ItemChecked self args do
    (   
        MD_Data.CheckedTasks = for i = 0 to (self.CheckedItems.Count - 1) collect (self.CheckedItems.Item[i].Index + 1)
        if keyboard.controlPressed == true then
        (
            for i = 0 to self.Items.count-1 do self.Items.Item[i].Checked = true
        )
        else if keyboard.altPressed == true then
        (
            for i = 0 to self.Items.count-1 do self.Items.Item[i].Checked = false
        )
        try MD_UI.UpdateCatalogTasksRlt() catch()
    )
    on lv_main ColumnClick self arg do 
    (
        case arg.column of
        (
            0:(
                for i = 0 to self.Items.count-1 do 
                (
                    if self.Items.Item[i].Checked == true then self.Items.Item[i].Checked = false
                    else self.Items.Item[i].Checked = true
                )
                MD_UI.UpdateCatalogGeneralRlt()
            )
            4:(
                local sel_user = undefined
                try sel_user = self.SelectedItems.Item[0].SubItems.Item[4].text catch()
                MD_Data.SortTasks = #()
                free MD_Data.SortTasks
                if NOT MD_UI.Sort and sel_user != undefined then 
                (
                    for i = 0 to self.Items.Count - 1 do
                    (
                        if self.Items.Item[i].SubItems.Item[4].text == sel_user then
                        (
                            append MD_Data.SortTasks MD_Data.Tasks[self.Items.Item[i].Tag]
                        )
                    )
                    MD_UI.Sort = true                    
                )
                else MD_UI.Sort = false
                MD_UI.FillMainList()
                MD_UI.FillAddList()
                try MD_Data.ActiveTask = MD_Data.Tasks[MD_Data.ActiveTaskIndex] catch()
                MD_UI.UpdateCatalogTasksRlt()
                MD_UI.UpdateCatalogInfoRlt()
                MD_UI.UpdateCatalogGeneralRlt()
                try self.Items.Item[self.Items.Item[i].Tag - 1].selected = true catch()
            )
        )
    )
    on lv_main Click self arg do
    (
        MD_Data.ActiveList = 1
        MD_Data.ActiveTaskAddIndex = 0
        subobjectLevel = 0
        if MD_Data.TempArticlesList.count == 0 then
        (
            if (self.SelectedItems.count != 0 and (MD_Data.ActiveTaskIndex != self.SelectedItems.Item[0].Tag)) or self.Items.count == 1 then
            (
                MD_Data.ActiveTaskIndex = self.SelectedItems.Item[0].Tag
				if MD_UI.Sort then MD_Data.ActiveTask = MD_Data.SortTasks[self.SelectedItems.Item[0].Tag]
				else MD_Data.ActiveTask = MD_Data.Tasks[self.SelectedItems.Item[0].Tag]
                MD_Data.ActiveTaskAddIndex = undefined
                if MD_Data.InWorkTask != undefined and MD_Data.ActiveTask.Article == MD_Data.InWorkTask.Article then
                (
                    MD_Data.WorkLayerNodes = GetAllLayerNodes MD_Data.InWorkTask.Article
                    MD_Data.InWorkTask.ActiveMesh = 1
                    for obj in MD_Data.WorkLayerNodes do
                    (
                        if obj.name == MD_Data.InWorkTask.Article then
                        (
                            MD_Data.InWorkTask.Mesh = obj
                        )
                        if obj.name == (MD_Data.InWorkTask.Article + TRANS_POSTFIX) then
                        (
                            MD_Data.InWorkTask.AddMesh = obj
                            MD_Data.InWorkTask.AddMesh.isHidden = true
                        )    
                    )
                    if MD_Data.InWorkTask.Group == MD_Data.ActiveTask.Group then
                    ( 
                        try MD_Data.InWorkTask.Mesh.Material = MD_Data.InWorkTask.Material catch()
                        try MD_Data.InWorkTask.AddMesh.Material = MD_Data.InWorkTask.Material catch()
                        completeRedraw()
                    )
                    try MD_BBox.Update() catch()
                    MD_Data.ShowLayers mode:#work_only
                )
                else 
                (
                    if MD_Data.InWorkTask != undefined and \
                    MD_Data.InWorkTask != undefined and \
                    MD_Data.InWorkTask.Article != undefined and \
                    MD_Data.ActiveTask.Group != undefined and \
                    MD_Data.ActiveTask.Group == MD_Data.InWorkTask.Group then
                    (
                        try MD_BBox.Update() catch()
                        MD_Data.ShowLayers mode:#work_only
                        try MD_Data.InWorkTask.Mesh.Material = MD_Data.ActiveTask.Material catch()
                        try MD_Data.InWorkTask.AddMesh.Material = MD_Data.ActiveTask.Material catch()
                        completeRedraw()
                    )
                    else 
                    (
                        try MD_BBox.Update() catch()
                        try(destroyDialog MD_UI.Dialogs.Export)catch()
                        MD_Data.ShowLayers mode:#scene_only
                    )
                )
                MD_UI.FillAddList()
                try MD_Data.ActiveTask = MD_Data.Tasks[self.SelectedItems.Item[0].Tag] catch()
                MD_UI.UpdateCatalogTasksRlt()
                MD_UI.UpdateCatalogInfoRlt()
                MD_UI.UpdateCatalogGeneralRlt()
            )
        )
        try (destroyDialog MD_UI.Dialogs.LoadTextures) catch()
    )
    on lv_add Click self arg do
    (
        MD_Data.ActiveList = 2
        MD_Data.ActiveTaskIndex = 0
        if (MD_Data.ActiveTaskAddIndex != self.SelectedItems.Item[0].Index + 1) then
        (
            MD_Data.ActiveList = 2
            MD_Data.ActiveTaskAddIndex = self.SelectedItems.Item[0].Index + 1
            MD_UI.UpdateCatalogTasksRlt()
            MD_UI.UpdateCatalogInfoRlt()
            MD_UI.UpdateCatalogGeneralRlt()
        )
        if MD_UI.Dialogs.LoadTextures.Visible then MD_UI.Dialogs.LoadTextures.InitExistTextures()
    )
    on lv_add MouseDoubleClick self arg do
    (
        try(
            subobjectLevel = 4
            $.selectByMaterial (self.SelectedItems.Item[0].Index + 1)
            completeRedraw()
        )catch()
    )
    on btn_work_state pressed do
    ( 
        MD_Data.ShowLayers mode:#none
        case btn_work_state.text of
        (
            "Set Work State":(
                try ClearTrashLayers() catch()
                
                MD_Data.CreateWorkState()
                if MD_Data.InWorkTask != undefined and MD_Data.InWorkTask.SavedWorks.count != 0 then
                (
                    dlg_msg = "Загрузить последнее сохранённое рабочее состояние сцены?\n"
                    dlg_msg += "При этом все объекты на текущем рабоче слое будут удалены!"
                    if MD_UI.SettingsRoll.ckbx_load_last.checked then
                    (
                        if MD_Data.WorkLayerNodes.count != 0 then
                        (
                            if queryBox dlg_msg title:"Сообщение" then 
                            (
                                try MD_Data.ClearWorkLayer() catch()
                            )
                        )
                        MD_Data.InWorkTask.LoadWork \
                        MD_Data.InWorkTask.SavedWorks[MD_Data.InWorkTask.SavedWorks.count] quiet_mode:true
                    )
                )
            )
            "Update Work State":(
                MD_Data.UpdateWorkState()
            )
        )
        MD_Data.FullUpdate()
        try MD_BBox.Update() catch()
        MD_Data.ShowLayers mode:#work_only
    )
    on btn_exit_work_state pressed do
    (
        try MD_Data.WorkLayerNodes = GetAllLayerNodes MD_Data.WorkLayer.Name catch()
        MD_Data.ClearWorkLayer()
        MD_Data.ExitWorkState()
        MD_Data.FullUpdate()
        try MD_BBox.Update() catch()
        MD_Data.ShowLayers mode:#scene_only
    )
    on lv_add ColumnClick s e do
    (
    )
    on btn_assign_mat_id pressed do
    (
        MD_Data.AssignMatID selection[1]
    )
    on btn_assign_texts pressed do
    (
        try (destroyDialog MD_UI.Dialogs.LoadTextures) catch()
        CreateDialog MD_UI.Dialogs.LoadTextures modal:false
    )
)
rollout rlt_projects_tasks "Tasks"
(
    dotNetControl 'lv_main' "System.Windows.Forms.ListView" width:(CTRL_WIDTH_1) height:176 align:#center offset:[1, 0] enabled:true
    dotNetControl 'lv_add' "System.Windows.Forms.ListView" width:(CTRL_WIDTH_1) height:110 align:#center offset:[1, 0] enabled:true
  
    on rlt_projects_tasks open do
    (
        if MD_Data.ProjectsRollLoadState then
        (
            try MD_BBox.Remove() catch()
            try MD_Data.ClearWorkLayer() catch()
            try MD_Data.DeleteWorkLayer() catch()
            try MD_Data.ClearTrashLayers() catch()
            for i = 0 to LayerManager.count - 1 do
            (
                lr = LayerManager.getLayer i
                lr.on = true
            )
            try MD_Callbacks.Destruct() catch()
            MD_UI.InitProjectsLists()
        )
    )
/*
    on lst_sections selected arg do 
    (
        if MD_Data.ActiveSection != arg then
        (
            MD_Data.ActiveSection = arg
            MD_UI.SwitchRollouts()
            try MD_Data.active_catalog_article = (MD_Data.main_categ_ids[MD_Data.ActiveCategory][MD_Data.ActiveSubCategory]) catch()
            try (
                icon_file = pathConfig.appendPath DECALS_DIR (MD_Data.active_catalog_article + (ICON_POSTFIX + ".max"))
                MD_Data.ActiveCategoryIcon.SetIcon icon_file
            )catch(MD_Data.ActiveCategoryIcon.Icon = undefined)
            
            MD_Callbacks.Add()
        )
    )
    */
)
rollout rlt_catalog_tools "Tools"
(
    groupBox 'grp_01' " Transform: " width:(rlt_catalog_tools.width - 8) height:120 align:#center offset:[0, -4]
    button 'btn_up' "▲" width:CTRL_MANIP_SIZE height:CTRL_MANIP_SIZE align:#center offset:[-1, -104]
	button 'btn_left' "◄" width:CTRL_MANIP_SIZE height:CTRL_MANIP_SIZE align:#center offset:[37, -2] across:3
	button 'btn_center' "•" width:CTRL_MANIP_SIZE height:CTRL_MANIP_SIZE align:#center offset:[0, -2]
    button 'btn_right' "►" width:CTRL_MANIP_SIZE height:CTRL_MANIP_SIZE align:#center offset:[-37, -2]
	button 'btn_down' "▼" width:CTRL_MANIP_SIZE height:CTRL_MANIP_SIZE align:#center offset:[-1, -2] 
	groupBox 'grp_02' " Icon: " width:(rlt_catalog_tools.width - 8) height:146 align:#center offset:[0, 4]
	checkbutton 'btn_create_icon' "Create Icon Mode" width:CTRL_WIDTH_0 height:CTRL_HEIGHT_1 align:#center offset:[1, -132] enabled:false
	button 'btn_create_sel_set' "Create Select Set" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[-2, V_MARGIN] across:2 enabled:false
    dropdownlist 'lst_sel_sets' "" items:SELECTION_SET_NAMES width:CTRL_WIDTH_02 height:50 offset:[4, V_MARGIN] align:#center selection:1 enabled:false
	spinner 'spn_w' "Width:" width:CTRL_WIDTH_02 fieldWidth:56 offset:[5, 3] range:[ConvertCentimeterToSysUnits 10.0, ConvertCentimeterToSysUnits 500.0, ConvertCentimeterToSysUnits 100.0] type:#WorldUnits fieldwidth:50 align:#left across:2 enabled:false
	button 'btn_fit' "Fit" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[4, -3] enabled:false
	spinner 'spn_d' "Depth:" width:CTRL_WIDTH_02 fieldWidth:56 offset:[4, -1] range:[ConvertCentimeterToSysUnits 10.0, ConvertCentimeterToSysUnits 500.0, ConvertCentimeterToSysUnits 100.0] type:#WorldUnits fieldwidth:50 align:#left across:2 enabled:false
	button 'btn_render' "Render" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[4, V_MARGIN] enabled:false
	button 'btn_save' "Save As Default Icon" width:CTRL_WIDTH_0 height:CTRL_HEIGHT_1 align:#center offset:[1, V_MARGIN] enabled:false
	local icon_controls = #(btn_create_sel_set, lst_sel_sets, spn_w, btn_fit, spn_d, btn_render, btn_save)
	local icon_layer = undefined
	local layer_nodes = #()
	fn getViewCoordSys =
	(
		local coordSysTM = undefined
		local result = #()
		
		coordSysTM = Inverse(viewport.GetTM())
		coordSysTM.row3 *= -1
		for i = 1 to 3 do
		(
			local val = coordSysTM[i]
			local max_num = 0
			local max_num_index = undefined
			local new_vector = [0, 0, 0]
				
			for k = 1 to 3 where abs val[k] > abs max_num do
			(	
				max_num = val[k]		
				max_num_index = k
			)
			
			new_vector[max_num_index] = floor (max_num + 0.5)
			append result new_vector
		)
		
		return result
	)
	fn ConvertSelectedToVerts obj =
	(
		local verts = BitArray()
		
		if obj != undefined then
		(
			obj = snapshotAsMesh obj
			
			case subobjectLevel of
			(
				undefined:(verts = #{1..(getNumVerts obj)})
				0:(verts = #{1..(getNumVerts obj)})
				1:(verts = getVertSelection obj)
				2:(verts = meshop.getVertsUsingEdge obj (getEdgeSelection obj))
				3:(verts = meshop.getVertsUsingEdge obj (getFaceSelection obj))
				4:(verts = meshop.getVertsUsingFace obj (getFaceSelection obj))
				5:(verts = meshop.getVertsUsingFace obj (getFaceSelection obj))
			)
		)
		return verts
	)
	fn MinOfSelected obj =
	(
		local verts = ConvertSelectedToVerts obj
		local sel_min = undefined
		
		if obj != undefined and verts.count != 0 then
		(
			obj = snapshotAsMesh obj
			local sel_min = meshop.getVert obj (verts as array)[1]
			
			for i in verts do
			(
				vert_pos = meshop.getVert obj i
				if vert_pos.x < sel_min.x then sel_min.x = vert_pos.x
				if vert_pos.y < sel_min.y then sel_min.y = vert_pos.y
				if vert_pos.z < sel_min.z then sel_min.z = vert_pos.z
			)
		)
		
		return sel_min
	)
	fn MaxOfSelected obj =
	(
		local verts = ConvertSelectedToVerts obj
		local sel_max = undefined
		
		if obj != undefined and verts.count != 0 then
		(
			obj = snapshotAsMesh obj
			local sel_max = meshop.getVert obj (verts as array)[1]
			
			for i in verts do
			(
				vert_pos = meshop.getVert obj i
				if vert_pos.x > sel_max.x then sel_max.x = vert_pos.x
				if vert_pos.y > sel_max.y then sel_max.y = vert_pos.y
				if vert_pos.z > sel_max.z then sel_max.z = vert_pos.z
			)
		)
		
		return sel_max
	)
	fn MinByGeom obj =
	(
		local sel_min = undefined
		
		if obj != undefined then
		(
			obj = snapshotAsMesh obj
			local verts_count = getNumVerts obj
			local sel_min = meshop.getVert obj 1
			
			for i = 1 to verts_count do
			(
				vert_pos = meshop.getVert obj i
				if vert_pos.x < sel_min.x then sel_min.x = vert_pos.x
				if vert_pos.y < sel_min.y then sel_min.y = vert_pos.y
				if vert_pos.z < sel_min.z then sel_min.z = vert_pos.z
			)
		)
		
		return sel_min
	)
	fn MaxByGeom obj =
	(
		local sel_max = undefined
		
		if obj != undefined then
		(
			obj = snapshotAsMesh obj
			local verts_count = getNumVerts obj
			local sel_max = meshop.getVert obj 1
			
			for i = 1 to verts_count do
			(
				vert_pos = meshop.getVert obj i
				if vert_pos.x > sel_max.x then sel_max.x = vert_pos.x
				if vert_pos.y > sel_max.y then sel_max.y = vert_pos.y
				if vert_pos.z > sel_max.z then sel_max.z = vert_pos.z
			)
		)
		
		return sel_max
	)
	fn AlignBoundings obj bound_box dir =
	(
		local vcs = getViewCoordSys()
		local move_dist = [0,0,0]
		local val = undefined
		case dir of
		(
			#left:(
				if (vcs[1].x +  vcs[1].y +  vcs[1].z) > 0 then
				(
					if subobjectLevel == 0 or subobjectLevel == undefined then val = (MinByGeom obj) 
					else if subobjectLevel > 0 then val = (MinOfSelected obj)
					move_dist = ((bound_box.min * vcs[1])-(val * vcs[1]))
				)
				else 
				(
					if subobjectLevel == 0 or subobjectLevel == undefined then val = (MaxByGeom obj) else val = (MaxOfSelected obj)
					move_dist = ((((bound_box.max * vcs[1])-(val * vcs[1]))) * -1)
				)
			)
			#right:(
				if (vcs[1].x +  vcs[1].y +  vcs[1].z) > 0 then
				(
					if subobjectLevel == 0 or subobjectLevel == undefined then val = (MaxByGeom obj) else val = (MaxOfSelected obj)
					move_dist = ((bound_box.max * vcs[1])-(val * vcs[1]))	
				)
				else 
				(
					if subobjectLevel == 0 or subobjectLevel == undefined then val = (MinByGeom obj) else val = (MinOfSelected obj)
					move_dist = ((((bound_box.min * vcs[1])-(val * vcs[1]))) * -1)
				)
			)
			#up:(
				if (vcs[2].x +  vcs[2].y +  vcs[2].z) > 0 then
				(
					if subobjectLevel == 0 or subobjectLevel == undefined then val = (MaxByGeom obj) else val = (MaxOfSelected obj)
					move_dist = ((bound_box.max * vcs[2])-(val * vcs[2]))
				)
				else 
				(
					if subobjectLevel == 0 or subobjectLevel == undefined then val = (MinByGeom obj) else val = (MinOfSelected obj)
					move_dist = ((((bound_box.min * vcs[2])-(val * vcs[2]))) * -1)
				)
			)
			#down:(
				if (vcs[2].x +  vcs[2].y +  vcs[2].z) > 0 then
				(
					if subobjectLevel == 0 or subobjectLevel == undefined then val = (MinByGeom obj) else val = (MinOfSelected obj)
					move_dist = ((bound_box.min * vcs[2])-(val * vcs[2]))
				)
				else 
				(
					if subobjectLevel == 0 or subobjectLevel == undefined then val = (MaxByGeom obj) else val = (MaxOfSelected obj)
					move_dist = ((((bound_box.max * vcs[2])-(val * vcs[2]))) * -1)
				)
                CompleteRedraw()
			)
			#center:(
				if subobjectLevel == 0 or subobjectLevel == undefined then val = (((MaxByGeom obj) + (MinByGeom obj))/2) else val = (((MaxOfSelected obj) + (MinOfSelected obj))/2)
				move_dist = bound_box.center - val
			)
			#vcenter:(
				if subobjectLevel == 0 or subobjectLevel == undefined then val = (((MaxByGeom obj) + (MinByGeom obj))/2) else val = (((MaxOfSelected obj) + (MinOfSelected obj))/2)
				if (vcs[2].x +  vcs[2].y +  vcs[2].z) > 0 then
				move_dist = ((bound_box.center * vcs[2])-(val * vcs[2]))
				else move_dist = ((((bound_box.center * vcs[2])-(val * vcs[2]))) * -1)
			)
			#hcenter:(
				if subobjectLevel == 0 or subobjectLevel == undefined then val = (((MaxByGeom obj) + (MinByGeom obj))/2) else val = (((MaxOfSelected obj) + (MinOfSelected obj))/2)
				if (vcs[1].x +  vcs[1].y +  vcs[1].z) > 0 then 
				move_dist = ((bound_box.center * vcs[1])-(val * vcs[1]))
				else move_dist = ((((bound_box.center * vcs[1])-(val * vcs[1]))) * -1)
			)
		)
		case superClassOf obj of
		(
			GeometryClass:(
				if subobjectLevel == 0 or subobjectLevel == undefined then (move obj move_dist)
				case classOf obj of
				(
					Editable_Poly:(
							if subobjectLevel > 0 then (
								if obj.useSoftSel == off then polyop.moveVert obj (ConvertSelectedToVerts obj) move_dist
								else polyop.moveVert obj #all move_dist useSoftSel:true
							)
						)
					Editable_mesh:(
							if subobjectLevel > 0 then (
								if meshop.getSoftSel obj == off then meshop.moveVert obj (ConvertSelectedToVerts obj) move_dist
								else (meshop.moveVert obj #all useSoftSel:true; update obj)
							)
						)
				)				
			)
			Shape:(
				if subobjectLevel == 0 or subobjectLevel == undefined then (move obj move_dist)
			)
		)
	)
    on btn_up pressed do (undo on for obj in selection do (try AlignBoundings obj MD_BBox.bb #up catch(); CompleteRedraw()))
	on btn_down pressed do (undo on for obj in selection do (try AlignBoundings obj MD_BBox.bb #down catch(); CompleteRedraw()))
    on btn_left pressed do (undo on for o in selection do (try AlignBoundings o MD_BBox.bb #left catch(); CompleteRedraw()))
	on btn_right pressed do (undo on for obj in selection do (try AlignBoundings obj MD_BBox.bb #right catch(); CompleteRedraw()))
		
	on btn_up rightclick do (undo on for obj in selection do (try AlignBoundings obj MD_BBox.bb #vcenter catch(); CompleteRedraw()))
	on btn_down rightclick do (undo on for obj in selection do (try AlignBoundings obj MD_BBox.bb #vcenter catch(); CompleteRedraw()))
		
	on btn_left rightclick do (undo on for obj in selection do (try AlignBoundings obj MD_BBox.bb #hcenter catch(); CompleteRedraw()))
	on btn_right rightclick do (undo on for obj in selection do (try AlignBoundings obj MD_BBox.bb #hcenter catch(); CompleteRedraw()))
		
	on btn_center pressed do (undo on for obj in selection do (try AlignBoundings obj MD_BBox.bb #center catch(); CompleteRedraw()))
	on btn_create_icon changed arg do
	(
		case arg of
		(
			true:(
				MD_Data.ActiveCategoryIcon.SetEditIconMode arg
				for ctrl in icon_controls do ctrl.enabled = true
				MD_Data.ActiveCategoryIcon.New()
			)
			false:(
				try MD_Data.ActiveCategoryIcon.Destruct() catch()
				try MD_Data.active_catalog_article = (MD_Data.main_categ_ids[MD_Data.ActiveCategory][MD_Data.ActiveSubCategory]) catch()
				local icon_file = pathConfig.appendPath DECALS_DIR (MD_Data.active_catalog_article + (ICON_POSTFIX + ".max"))
				try MD_Data.ActiveCategoryIcon.Create icon_file catch()
				for ctrl in icon_controls do ctrl.enabled = false
				try MD_Data.ActiveCategoryIcon.SetEditIconMode arg catch()
				spn_w.value = ConvertCentimeterToSysUnits 100.0
				spn_d.value = ConvertCentimeterToSysUnits 100.0
			)
		)
		completeRedraw()
		MD_Data.edit_icon_mode = arg
	)
	on btn_create_sel_set pressed do 
	(
		try MD_Data.ActiveCategoryIcon.SetNamedSelSet lst_sel_sets.items[lst_sel_sets.selection] catch()
	)
	on spn_w changed arg do (MD_BBox.bb.length = arg; completeRedraw())
	on spn_d changed arg do 
	(
		MD_BBox.bb.width = arg
		arrow_offset = ConvertCentimeterToSysUnits 10.0
		arrow_rad = ConvertCentimeterToSysUnits 20.0
		MD_BBox.arrow.radius = arrow_rad
		MD_BBox.arrow.pos.x = (MD_BBox.bb.width/2.0 + arrow_rad/2.0 + arrow_offset)
		completeRedraw()
	)
	on btn_fit pressed do (
		undo on
		MD_Data.ActiveCategoryIcon.Icon.Pivot = MD_Data.ActiveCategoryIcon.Icon.Center
		MD_Data.ActiveCategoryIcon.Icon.Pos = [0, 0, 0]
		try MD_Data.ActiveCategoryIcon.FitSizeToBBox MD_BBox.bb catch()
		completeRedraw()
	)
	on btn_render pressed do (
		try MD_Data.ActiveCategoryIcon.IconRender MD_Data.ActiveCategoryIcon.Icon catch()
	)
	on btn_save pressed do (
		local file_path = (pathconfig.appendpath DECALS_DIR (MD_Data.active_catalog_article + "_icon.max"))
		gc()
		save_nodes MD_Data.ActiveCategoryIcon.Icon file_path
	)
)
rollout rlt_catalog_general "General"
(
    groupBox 'grp_01' " Common: " width:(rlt_catalog_general.width - 8) height:97 align:#center offset:[0, -4]
    button 'btn_vis_switch' "Show Scene Objects" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[-2, -82] across:2 enabled:false tooltip:MD_Tooltips.tools_cat_11_a
    button 'btn_attach_to_task' "Attach Selected" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[4, -82] enabled:false tooltip:MD_Tooltips.tools_cat_01
    button 'btn_set_pivot' "Set Pivot" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[-2, V_MARGIN] across:2 enabled:false tooltip:MD_Tooltips.tools_cat_02
    button 'btn_assign_mat' "Assign Material" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[4, V_MARGIN] enabled:false tooltip:MD_Tooltips.tools_cat_03
	checkbutton 'btn_edit_icon' "Edit Icon Mode" width:CTRL_WIDTH_0 height:CTRL_HEIGHT_1 align:#center offset:[1, V_MARGIN] enabled:false tooltip:MD_Tooltips.tools_cat_04
    groupBox 'grp_02' " Mesh: " width:(rlt_catalog_general.width - 8) height:72 align:#center offset:[0, 4]
    button 'btn_main_mesh' "Main Mesh" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[-2, -57] across:2 enabled:false tooltip:MD_Tooltips.tools_cat_07_a
    button 'btn_add_mesh' "Additional Mesh" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[4, -57] enabled:false tooltip:MD_Tooltips.tools_cat_07_b
    button 'btn_mesh_switch' ">> Switch To Additional Mesh" width:CTRL_WIDTH_0 height:CTRL_HEIGHT_1 align:#center offset:[1, V_MARGIN] enabled:false tooltip:MD_Tooltips.tools_cat_08
    groupBox 'grp_03' " Files: " width:(rlt_catalog_general.width - 8) height:80 align:#center offset:[0, 4]
    button 'btn_save_work' "Save Work" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[16, -67] across:3 enabled:false tooltip:MD_Tooltips.tools_cat_05
    button 'btn_load_work' "Load Last" width:(CTRL_WIDTH_02 - CTRL_HEIGHT_1 - 4) height:CTRL_HEIGHT_1 align:#center offset:[44, -67] enabled:false tooltip:MD_Tooltips.tools_cat_06_a
    button 'btn_work_list' "…" width:CTRL_HEIGHT_1 height:CTRL_HEIGHT_1 align:#center offset:[30, -67] enabled:false tooltip:MD_Tooltips.tools_cat_06_b
    button 'btn_export' "Validation And Export" width:CTRL_WIDTH_0 height:CTRL_HEIGHT_2 align:#center offset:[1, V_MARGIN] enabled:false tooltip:MD_Tooltips.tools_cat_10
    on rlt_catalog_general open do
    (
    )
    
    on rlt_catalog_general close do
    (
    )
    on btn_assign_mat pressed do
    (
        MD_Data.AssignMaterial selection[1]
    )
    on btn_vis_switch pressed do
    (
        MD_Data.CreateWorkLayer()
        case btn_vis_switch.text of
        (
            "Show Scene Objects":(
                MD_Data.ShowLayers mode:#all
                btn_vis_switch.text = "Isolate Task Layer"
                btn_vis_switch.tooltip = MD_Tooltips.tools_cat_11_b
            )
            "Isolate Task Layer":(
                MD_Data.ShowLayers mode:#work_only
                btn_vis_switch.text = "Show Scene Objects"
                btn_vis_switch.tooltip = MD_Tooltips.tools_cat_11_a
            )
        )
    )
    on btn_main_mesh pressed do
    (
        MD_Data.SetMesh selection[1]
        MD_UI.UpdateCatalogGeneralRlt()
        try MD_BBox.Update() catch()
    )
    on btn_add_mesh pressed do
    (
        if MD_Data.InWorkTask != undefined and selection[1] != undefined then 
        (
            if MD_Data.InWorkTask.AddMesh == undefined and MD_Data.InWorkTask.Mesh == selection[1] then
            (
                if (queryBox "Создать дополнительный меш путём копирования основного?" title:"Внимание!" icon:#question) then 
                (
                    MD_Data.SetAddMesh (copy selection[1])
                )
            )
            else MD_Data.SetAddMesh selection[1]
        )
        
        MD_UI.UpdateCatalogGeneralRlt()
        try MD_BBox.Update() catch()
    )
    on btn_mesh_switch pressed do
    (
        clearSelection()
        if MD_Data.InWorkTask != undefined then
        (
            MD_Data.WorkLayerNodes = GetAllLayerNodes MD_Data.WorkLayer.Name
            case MD_Data.InWorkTask.ActiveMesh of
            (
                1:(
                    MD_Data.InWorkTask.ActiveMesh = 2
                    try (for n in MD_Data.WorkLayerNodes do n.IsHidden = true) catch()
                    try MD_Data.InWorkTask.AddMesh.IsHidden = false catch()
                    try select MD_Data.InWorkTask.AddMesh catch()
                )
                2:(
                    MD_Data.InWorkTask.ActiveMesh = 1
                    try (for n in MD_Data.WorkLayerNodes do n.IsHidden = false) catch()
                    try MD_Data.InWorkTask.AddMesh.IsHidden = true catch()
                    try select MD_Data.InWorkTask.Mesh catch()
                )
            )
            MD_UI.UpdateCatalogGeneralRlt()
            try MD_BBox.Update() catch()
            MD_UI.UpdateCatalogInfoRlt()
        )
    )
    on btn_set_pivot pressed do
    (
        try destroyDialog MD_UI.Dialogs.PivotParams catch()
        createDialog MD_UI.Dialogs.PivotParams 340 100 modal:false
        try MD_BBox.Update() catch()
    )
    on btn_set_pivot rightclick do
    (
        MD_BBox.ResetPivot()
        MD_BBox.ResetPivot()
    )
    on btn_save_work pressed do
    (
        MD_Data.InWorkTask.SaveWork()
        MD_UI.UpdateCatalogGeneralRlt()
    )
    on btn_load_work pressed do
    (
        if MD_Data.ActiveTask.Group == undefined then
        (
            MD_Data.CreateWorkLayer()
        )
        MD_Data.InWorkTask.LoadWork \
        MD_Data.InWorkTask.SavedWorks[MD_Data.InWorkTask.SavedWorks.count] quiet_mode:false
        MD_UI.UpdateCatalogGeneralRlt()    
    )
    on btn_work_list pressed do
    (
        try destroyDialog MD_UI.Dialogs.LoadWork catch()
        if MD_Data.ActiveTask.SavedWorks.count != 0 then
        (
           createDialog MD_UI.Dialogs.LoadWork 628 398 modal:true
           MD_UI.UpdateCatalogGeneralRlt()
        )
    )
    on btn_export pressed do
    (
        MD_Callbacks.Add()
        try(destroyDialog MD_UI.Dialogs.Export)catch()
        CreateDialog MD_UI.Dialogs.Export style:#(#style_sysmenu, #style_titlebar)
    )
    on btn_attach_to_task pressed do
    (
        MD_Data.AttachSelectedToWorkLayer()
        MD_Data.ShowLayers mode:#work_only
    )
	on btn_edit_icon changed arg do
	(
		case arg of
		(
			true:(
                MD_Callbacks.Destruct()
				MD_BBox.Layer.on = false
				MD_BBox.Layer.lock = false
				MD_BBox.Layer.ishidden = false
				MD_BBox.Layer.current = true
                for i = 0 to LayerManager.count - 1 do
				(
					lr = LayerManager.getLayer i
					if lr != MD_BBox.Layer then lr.ishidden = true
				)
				for ctrl in MD_UI.SettingsRoll.Controls do ctrl.enabled = false
				for ctrl in MD_UI.TasksCatalogRoll.Controls do ctrl.enabled = false
				for ctrl in MD_UI.GeneralCatalogRoll.Controls do ctrl.enabled = false
                btn_edit_icon.enabled = true
                try MD_Data.ActiveCategoryIcon.Icon.IsHidden = false catch()
                try select MD_Data.ActiveCategoryIcon.Icon catch()
                max modify mode
                subobjectLevel = 1
			)
			false:(
                try MD_BBox.Update() catch()
                try MD_Data.ActiveCategoryIcon.Icon.IsHidden = not MD_UI.SettingsRoll.ckbx_show_icon.checked catch()
				if MD_Data.InWorkTask != undefined and MD_Data.ActiveTask != undefined and MD_Data.ActiveTask.Article == MD_Data.InWorkTask.Article then
				MD_Data.ShowLayers mode:#work_only else MD_Data.ShowLayers mode:#scene_only
				for ctrl in MD_UI.SettingsRoll.Controls do ctrl.enabled = true
				for ctrl in MD_UI.TasksCatalogRoll.Controls do ctrl.enabled = true
				MD_UI.UpdateCatalogTasksRlt()
				MD_UI.UpdateCatalogGeneralRlt()
                
                local file_path = pathconfig.appendpath MD_Data.InWorkTask.InWorkDir TASK_ICON_NAME
                gc()
                save_nodes MD_Data.ActiveCategoryIcon.Icon file_path
                
			)
		)
		completeRedraw()
		MD_Data.edit_icon_mode = arg
	)
)
rollout rlt_projects_general "General"
(
    button 'btn_export' "Export Task" width:CTRL_WIDTH_1 height:CTRL_HEIGHT_2 align:#center offset:[1, V_MARGIN] enabled:true
)
rollout rlt_about "About"
(
    label 'lbl_author' "" align:#center offset:[0, 10]
    label 'lbl_organization' "" align:#center offset:[0, V_MARGIN]
    label 'lbl_version' "" align:#center offset:[0, V_MARGIN]
    hyperLink 'hpl_site' "Documentation" address:docs_file offset:[0, V_MARGIN] align:#center Color:(color 255 110 40) hoverColor:(color 255 130 60) visitedColor:(color 255 110 40)
    button 'btn_update' "Update" width:120 offset:[0, V_MARGIN] align:#center
    label 'lbl_empty' "" align:#center offset:[0, 8]
    on rlt_about open do 
    (
        lbl_author.text = "Author: " + author
        lbl_version.text = "Version: " + version
        lbl_organization.text = "Organization: Faberon Design"
    )
)
rollout rlt_make_design_tools ("MDT_ContentMaker v" + version)
(
    subrollout 'sub_rlt' "" width:(MAIN_RLT_WIDTH + 8) align:#center
    on rlt_make_design_tools open do
    (
        try(
            dialog_pos = execute (getINISetting MDT_CONFIG rlt_make_design_tools.name "pos")
            SetDialogPos rlt_make_design_tools dialog_pos
        )catch()
    )
    on rlt_make_design_tools close do
    (
        try(destroyDialog dlg_configure)catch()
        try(destroyDialog dlg_check_tasks)catch()
        try(destroyDialog dlg_pivot_params)catch()
        try(destroyDialog dlg_load_work)catch()
        try(destroyDialog dlg_export)catch()
        try(destroyDialog dlg_request)catch()
        try(destroyDialog dlg_load_textures)catch()
        MD_Data.FullUpdate()
        SetINISettings MD_UI.SettingsRoll MDT_CONFIG_FILE MD_UI.SettingsRoll.name
        SetINISettings MD_UI.TasksCatalogRoll MDT_CONFIG_FILE MD_UI.TasksCatalogRoll.name include_list:#(MD_UI.TasksCatalogRoll.lst_basic_catalog, MD_UI.TasksCatalogRoll.lst_sub_catalog, MD_UI.TasksCatalogRoll.lv_main)
        try SetINISettings MD_UI.ToolsCatalogRoll MDT_CONFIG_FILE MD_UI.ToolsCatalogRoll.name onlyRollState:true catch()
        SetINISettings MD_UI.GeneralCatalogRoll MDT_CONFIG_FILE MD_UI.GeneralCatalogRoll.name onlyRollState:true
        try MD_Callbacks.Destruct() catch()
        try MD_BBox.Remove() catch()
        try MD_Data.ClearWorkLayer() catch()
        try MD_Data.DeleteWorkLayer() catch()
        try MD_Data.ClearTrashLayers() catch()
        for i = 0 to LayerManager.count - 1 do
        (
            lr = LayerManager.getLayer i
            lr.on = true
        )
    )
)

        clearSelection()
        try MD_Data.ClearTrashLayers() catch()

        MD_Log = LogSys source:"MAKE_DESIGN_TOOLS"
        Client_Log = LogSys source:"HTTP_CLIENT"
        MD_Tooltips = UI_Tooltips()
        MD_Data = GlobalData()
        MD_UI = UI()
        MD_BBox = BoundingBox()
        MD_Callbacks = Callback()
        MD_Client = HTTPClient()



        try(
            login = GetUserEnvVar "MD_USER_LOGIN"
            etxt_log.text = login
        )catch()

        try(
            password = GetUserEnvVar "MD_USER_PASS"
            etxt_pass.text = password
        )catch()

        MD_Callbacks.Destruct()
        MD_Data.Init()
        MD_Data.CheckedTasks = #()
        MD_Data.ActiveList = 1
        MD_Data.ActiveTaskAddIndex = undefined
        MD_Data.Update()
        MD_UI.FillCategoriesLists()
        try MD_BBox.Update() catch()

        MD_Data.ShowLayers mode:#none
        for ctrl in MD_UI.SettingsRoll.Controls do ctrl.enabled = true
        
        try (
			MD_Data.active_catalog_article = (MD_Data.main_categ_ids[MD_Data.ActiveCategory][MD_Data.ActiveSubCategory])
			icon_file = pathConfig.appendPath DECALS_DIR (MD_Data.active_catalog_article + (ICON_POSTFIX + ".max"))
			MD_Data.ActiveCategoryIcon.SetIcon icon_file
		)catch()

		if MD_Data.Tasks.Count != 0 then
		(
            local exist_task_index = undefined

            try (exist_task_index = execute (GetINISetting MDT_CONFIG_FILE MD_UI.TasksCatalogRoll.Name (MD_UI.CatalogListMain.name + "_selection")) + 1) catch()

            if exist_task_index != undefined and exist_task_index > 0 then
            (
                MD_Data.ActiveTaskIndex = exist_task_index
                MD_Data.ActiveTask = MD_Data.Tasks[exist_task_index]
            )
            
            if MD_Data.ActiveTask != undefined and MD_Data.InWorkTask != undefined then
            (
                if MD_Data.ActiveTask.Article == MD_Data.InWorkTask.Article then
                (
                    MD_Data.CreateWorkState()

                    if MD_UI.SettingsRoll.ckbx_load_last.checked then
                    (
                        try(
                            if MD_Data.WorkLayerNodes.count == 0 then
                            (
                                MD_Data.InWorkTask.LoadWork \
                                MD_Data.InWorkTask.SavedWorks[MD_Data.InWorkTask.SavedWorks.count] quiet_mode:true
                                
                            )
                        ) catch()    
                    )

                    MD_UI.UpdateCatalogGeneralRlt()
                    MD_Data.ShowLayers mode:#work_only
                )
            )
		)

        MD_Data.FullUpdate()
        MD_UI.Init()

        try if MD_Data.InWorkTask.file != undefined and MD_Data.WorkLayer == undefined then MD_Data.CreateWorkLayer() catch()

        if MD_Data.ActiveTask != undefined and MD_Data.InWorkTask != undefined and MD_Data.ActiveTask.Article == MD_Data.InWorkTask.Article then 
        MD_Data.ShowLayers mode:#work_only
        else MD_Data.ShowLayers mode:#scene_only


        try MD_Callbacks.Add() catch()

        try (
            if MD_Data.InWorkTask != undefined then
            (
                if MD_Data.InWorkTask.Group != undefined and MD_Data.InWorkTask.Group == MD_Data.ActiveTask.Group then
                MD_Data.ShowLayers mode:#work_only
            )
        )catch()

    )
    else
    (
        try(cui.UnRegisterDialogBar ::rlt_make_design_tools)catch()
        try(destroyDialog ::rlt_make_design_tools)catch()
    )
    
	ok
    
)
