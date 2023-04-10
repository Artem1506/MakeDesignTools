
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