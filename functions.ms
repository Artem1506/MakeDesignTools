
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
				CheckBoxControl:(ctrl.checked = execute (getINISetting ini_file_path ini_tag (ctrl.name + "_checked")))
				CheckButtonControl:(ctrl.checked = execute (getINISetting ini_file_path ini_tag (ctrl.name + "_checked")))
				SpinnerControl:(ctrl.value = execute (getINISetting ini_file_path ini_tag (ctrl.name + "_value")))
				ComboBoxControl:(ctrl.selection = execute (getINISetting ini_file_path ini_tag (ctrl.name + "_selection")))
				listboxControl:(ctrl.selection = execute (getINISetting ini_file_path ini_tag (ctrl.name + "_selection")))
				RadioControl:(ctrl.state = execute (getINISetting ini_file_path ini_tag (ctrl.name + "_state")))
				EdittextControl:(ctrl.text = getINISetting ini_file_path ini_tag (ctrl.name + "_text"))
				LabelControl:(ctrl.text = getINISetting ini_file_path ini_tag (ctrl.name + "_text"))
				SubRollout:(ctrl.pos = getINISetting ini_file_path ini_tag (ctrl.name + "_text"))
				dotNetControl:(try ((getINISetting ini_file_path ini_tag (ctrl.name + "_selection"))) catch(print "ass"))
			)
			ctrl.enabled = execute (getINISetting ini_file_path ini_tag (ctrl.name + "_enabled"))
		)
	)
	roll.open = execute (getINISetting ini_file_path roll.name "opened")
)

-- Save the states of the user interface controls in an ini file
fn SetINISettings roll ini_file_path ini_tag onlyRollState:false include_list:#() exclude_list:#() =
(
    setIniForceUTF16Default False

	if onlyRollState == false then
	(
		controls = #()

		if include_list.count != 0 then (controls = include_list)
		else if exclude_list.count != 0 then (controls = for ctrl in roll.controls where (findItem include_list ctrl == 0) collect ctrl)
		else controls = roll.controls
		-- for ctrl in controls where ((classof ctrl) != GroupStartControl and (classof ctrl) != GroupEndControl and ctrl.name != "author") do
		for ctrl in controls do
		(
			case (classof ctrl) of
			(
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
					print ctrl.SelectedItems.Count
					if ctrl.SelectedItems.Count != 0 then
					(setINISetting ini_file_path ini_tag (ctrl.name + "_selection") (ctrl.SelectedItems.Item[0].Index as string))
					print "okkkkk"
				)
			)
			setINISetting ini_file_path ini_tag (ctrl.name + "_enabled") (ctrl.enabled as string)
		)
	)
	setINISetting ini_file_path roll.name "opened" (roll.open as string)
)

fn ReadDataFile data_file =
(
    -- Читает данных из json файла и записывает в глобальную переменную "data"
    --> PyWrapperBase

    ::data_file = data_file
    ::data = undefined

    local py_code = ""
    py_code += "import json" + "\n"
    py_code += "import pymxs" + "\n"
    py_code += "rt = pymxs.runtime" + "\n"
    py_code += "with open(rt.data_file, 'r', encoding='utf-8') as f:" + "\n"
    py_code += "    rt.data = json.load(f)"

    try (python.Execute py_code)
    catch (MD_Log.Error "Не удалось загрузить данные для задания | global data = undefined")
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
	catch (MD_Log.Error "Не удалось записать данные в файл")
)

fn hex_to_rgb hex_value =
(
	local hex = trimLeft (hex_value as string) "#"
	local rgb_arr = for k = 0 to 2 collect (bit.hexasint (substring hex (1 + 2*k) 2))
    
	return (color rgb_arr[3] rgb_arr[2] rgb_arr[1])
)

fn get_max_ui_bg_color =
(
    -- Возвращает цвет интерфейса 3ds max

	py_code = "from pymxs import runtime as rt" + "\n"
	py_code += "import xml.etree.ElementTree as ET" + "\n"
	py_code += "tree = ET.parse(rt.MAX_CLRX_CONFIG_FILE)" + "\n"
	py_code += "root = tree.getroot()" + "\n"
	py_code += "for item in root.iter('color'):" + "\n"
	py_code += "\t" + "item_attr_list = list(item.attrib.values())" + "\n"
	py_code += "\t" + "if item_attr_list[2] == 'Background Odd':" + "\n"
	py_code += "\t\t" + "rt.MAX_UI_BG_COLOR = item_attr_list[1]"

	python.Execute py_code

	MAX_UI_BG_COLOR = hex_to_rgb MAX_UI_BG_COLOR
)

fn SetUserEnvVar var val =
(
    -- Прописывает в сис. реестр (HKEY_CURRENT_USER) пользовательскую переменную

    ::var = var
    ::val = val
    ::result = ""

    py_code = "import winreg" + "\n"
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
    -- Читает из сис. реестра (HKEY_CURRENT_USER) пользовательскую переменную

    ::var = var
    ::result = ""

    py_code = "import winreg" + "\n"
	py_code += "md_var_path = winreg.OpenKeyEx(winreg.HKEY_CURRENT_USER, \"Environment\")" + "\n"
	py_code += "rt.result = (winreg.QueryValueEx(md_var_path, rt.var))[0]" + "\n"

	python.Execute py_code

    return result
)

fn ConvertValueToSystemUnits input_units val = 
(
    -- Возращает изменённое входное значение, исходя из текущих системных единиц измерения
	-- input_units: Единицы измерения входного числа [#mm | #cm | #m | #km]
	-- val: Входное значение [float | int]

	local new_val = undefined
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
	new_val = val*factor*shift

	new_val
)

fn GetAllLayerNodes layer_name =
(
	-- Возвращает массив объектов находящихся на указанным слое, включая подслои
	-- layer_name: Имя слоя [string]

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
	-- Удаляет все пустые подслои в указанном слое
	-- layer_name: Имя слоя [string]

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
	-- Создаёт битмап из указанного файла с изображением
	-- img_file: Имя файла с изображением [string]
	-- max_size: Размер битмапа по максимальной стороне [int]
	-- fill_bg: Заливать или нет задний фон (имеет значение, если изображение не квадратное) [bool]
	-- bg_color: Цвет заливки для заднего фона [int]
	-- type: Тип возвращаемого объекта [#max | #dotnet]
	-- Возвращает объект класса BitMap, если указан параметр type = #max, или dotNetObject, если type = #dotnet

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