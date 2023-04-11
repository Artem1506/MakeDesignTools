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
			)
			setINISetting ini_file_path ini_tag (ctrl.name + "_enabled") (ctrl.enabled as string)
		)
	)
	setINISetting ini_file_path roll.name "opened" (roll.open as string)
)

fn ReadDataFile file =
(
    -- Читает данных из json файла и записывает в глобальную переменную "data"
    --> PyWrapperBase

    ::data_file = file
    ::data = undefined

    local py_code = ""
    py_code += "import json" + "\n"
    py_code += "import pymxs" + "\n"
    py_code += "rt = pymxs.runtime" + "\n"
    py_code += "with open(rt.data_file, 'r', encoding='utf-8') as f:" + "\n"
    py_code += "    rt.data = json.load(f)"

    try(python.Execute py_code)
    catch(MD_Log.Error "Не удалось загрузить данные для задания | global data = undefined")
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

-- fn SetSysEnvVar var val =
-- (
-- 	HiddenDOSCommand ("setx \"" + var + "\" \"" + val + "\" /m") prompt:"" donotwait:true ExitCode:&result

--     if result == 0 then (DisplayTempPrompt (var + " = " + val) 3000; return val)
--     else (DisplayTempPrompt "Error" 3000; return "")
-- )

fn SetUserEnvVar var val =
(
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
    ::var = var
    ::result = ""

    py_code = "import winreg" + "\n"
	py_code += "md_var_path = winreg.OpenKeyEx(winreg.HKEY_CURRENT_USER, \"Environment\")" + "\n"
	py_code += "rt.result = (winreg.QueryValueEx(md_var_path, rt.var))[0]" + "\n"

	python.Execute py_code

    return result
)