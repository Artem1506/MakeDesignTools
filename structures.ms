
PrintData
-- Логирование
struct LogSys
(
	fn Info msg_text = (format "MDT_INFO: %\n" msg_text),
	fn Warning msg_text = (format "MDT_WARNING: %\n" msg_text),
	fn Error msg_text = (format "MDT_ERROR: %\n" msg_text)
)
MD_Log = LogSys()

-- Подсказки
struct UI_Tooltips
(
    -- Settings
	settings_01 = "ON - Показать габариты объекта. (Только если задание находится в состоянии \"In_Work\")",
	settings_02 = "ON - При экспорте объекта его пивот автоматически выравняется с пивотом габаритного контейнера.\nOFF - Будет использовано текущее положение пивота.",
	settings_03 = "Каждый раз при сохранении промежуточного этапа работы создаётся превью.\nON - Автоматически будет подобран ракурс так, чтобы охватить все объекты на сцене.\nOFF - Будет использован текущий ракурс.",
	settings_04 = "Максимальное количество сохранений промежуточных этапов работы.\nПри достижении этого числа, ранее сохранённые файлы будут удаляться по мере добавления новых.",
	settings_05 = "ON - При установке задания в состояние \"In_Work\" будет проверяться наличие ранее сохранённых этапов работы.\nИ если они есть, будет автоматически загружено последнее сохранение. ",
	settings_06 = "Включить подсказки. (Требуется перезагрузка)",
	-- Tasks
	tasks_01 = "Проверить наличие доступных заданий.",
	tasks_02_a = "Загрузить отмеченные задания и сохранить в локальную базу.",
	tasks_02_b = "Автоматическая разослать сообщения об ошибках.\nСообщения будут оправлены адресно для каждого отмеченного задания.",
	tasks_02_c = "Обновить отмеченные задания в случае их изменений на удалённом сервере.",
	tasks_03_a = "Очистить текущий список заданий.",
	tasks_03_b = "Удалить отмеченные задания. При этом, если задание уже было в работе и имеются сохранённые этапы работы, то оно будет помещено в собственную корзину локальной базы. В дальнейшем это задание можно будет либо восстановить, либо полностью удалить.",
	tasks_04_a = "Взять выбранное задание в работу. При этом будет создан рабочий слой и все выбранные в данный момент обекты будут добавлены в него.",
	tasks_04_b = "Обновить состояние текущей работы.",
	tasks_05 = "Прекратить работу над текущем заданием. При этом ранее сохранённая работа останется, изменится лишь её состояние.",
	-- ToolsCatalog
	tools_cat_01 = "Добавить выделенные объекты в рабочий слой.",
	tools_cat_02 = "Установить опорную точку габаритного контейнера. Если в свитке \"Settings\" параметр \"Auto Pivot\" = ON, то при экспорте опорная точка объекта будет автоматически установлена в положение опорной точки габаритного контейнера.",
	tools_cat_03 = "Назначить материал на выделенный объект, если он находится в рабочем слое.",
	tools_cat_04 = "Назначить текстуры на выбранный материал.",
	tools_cat_05 = "Сохранить текущее состояние работы. Будут сохранены только те объекты, которые находятся на рабочем слое.",
	tools_cat_06 = "ЛКМ - Загрузить последнее сохранение.\nПКМ - Открыть диалоговое окно, где можно увидеть все ранее сделанные сохранения.",
	tools_cat_07 = "Создать дополнительный объект (mesh). Необходимо только если активное задание имеет параметр \"Trans\" = true.",
	tools_cat_08 = "Переключиться между основным и дополнительным объектами.",
	tools_cat_09 = "Интерактивная проверка готовности задания.",
	tools_cat_10 = "Экспорт задания в локальную базу.",
	-- Сheck params
	chk_01 = "Запросить список новых корректно составленных заданий.\nТакие задания имеют все необходимые данные и их можно брать в работу.",
	chk_02 = "Запросить список новых НЕкорректно составленных заданий.\nТакие задания нельзя брать в работу и загружать в локальную базу, но можно разослать составителям сообщения об ошибках.",
	chk_03 = "Запросить список ранее сделанных заданий.\nИх можно загрузить в локальную базу в случае если данные были потеряны или если эти задания выполнял другой пользватель.\nПри необходимости можно возобновить работу над заданиями после того как администратор изменит их состояние на \"None\".",
	chk_04 = "Запросить список ранее удалённых заданий, хранящихся в корзине локальной базы."
)
MD_Tooltips = UI_Tooltips()

-- Структура материала активного задания
struct TaskMaterial
(
	Article = undefined,
	PartName = undefined,
	Material = undefined,
    RefFile = undefined,
	texture_d = undefined,
	texture_m = undefined,
	texture_n = undefined,
	texture_ard = undefined
)

-- Структура задания
struct Task
(
	File = undefined,
	Article = undefined,
	DateCreate = undefined,
	Object = undefined,
	Website = undefined,
	Materials = #(),
	State = STATES[1],
	Pivot = undefined,
	Group = undefined,
	UserId = undefined,
	UserName = undefined,
    RefFile = undefined,
	Size = undefined,
	SizeTrans = undefined,

	Layer = undefined,
	Mesh = undefined,
	AddMesh = undefined,
	ActiveMesh = 1,
	SavedWorks = #(),
	RefBitmap = undefined,
	MatRefBitmaps = #(),
	MatLibFile = undefined,
	Valid = False,

	fn CreateMaterial =
	(

	),

	fn Update =
	(
		if MD_Data.ActiveTask != undefined then
		(
			ReadDataFile File
			data["state"] = State
			WriteDataFile File			
		)
	),

	fn Init = (
		-- Инициализация данных задания

        if (File != undefined and DoesFileExist File) then
        (
			-- Читать данные из json файла
            ReadDataFile File
            if data != undefined then
            (
				local task_file_dir = getFilenamePath File
				local task_in_work_dir = pathConfig.appendPath (pathConfig.removePathLeaf task_file_dir) "InWork"
				local ref_file_name = data["ref_photo_name"]
				local ref_file_type = getFilenameType ref_file_name
				local task_dir_files = GetFiles (task_file_dir + "/*.*")
				local mat_ref_files = #()

				-- Найти и отсортировать файлы референсов
				for f in task_dir_files do
				(
					if (FindString f data["article"]) then
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

					mat.Article = data["finishing_materials"][i]["article"]
					mat.PartName = data["finishing_materials"][i]["name_part_object"]
					mat.Material = data["finishing_materials"][i]["finishing_components"]
					mat.RefFile = mat_ref_files[i]

					append Materials mat
				)
				State = data["state"]
				Pivot = data["pivot"]
				try Group = data["tags"][1] catch()
				UserId = data["userId"]
                UserName = data["userName"]
                Size = #(
					ConvertValueToSystemUnits #cm data["size"][1],
					ConvertValueToSystemUnits #cm data["size"][2],
					ConvertValueToSystemUnits #cm data["size"][3]
				)
                try SizeTrans = #(
					ConvertValueToSystemUnits #cm data["size_trans"][1], 
					ConvertValueToSystemUnits #cm data["size_trans"][2], 
					ConvertValueToSystemUnits #cm data["size_trans"][3]
				) 
				catch()
				
				if pathConfig.doesFileExist task_in_work_dir then
				(
					SavedWorks = GetFiles (task_in_work_dir + "/*.max")
					sort SavedWorks
				)
				RefBitmap = CreatePreviewFromImageFile RefFile PREVIEW_SIZE
            )
        )
	),

	on create do Init()
)

-- Структура для работы с глобальными данными
struct GlobalData
(
	Categories = #(),
	SubCategories = #(),
	WorkLayer = undefined,
	-- Tasks lists
	ValidTasks = #(),
	InvalidTasks = #(),
	CompletedTasks = #(),
	DeletedTasks = #(),
	Tasks = #(), -- Задания для выбранной в данный момент подкатегории
	-- Catalog
	main_categs = #(), -- #("01-01 - Пол - Плитка", ...)
	main_categ_ids = #(), -- #("01-01", ...)
	sub_categs = #(), -- #(#("001 - Керамическая плитка", "002 - Керамогранит", "003 - Мозаика", "004 - Неолит"), ... )
	sub_categ_lib_dirs = #(), -- #(#()) Пути к категориям в локальной базе
	ActiveSection = 1, --> [int] Активная категория
	ActiveCategory = undefined, --> [int] Активная подкатегория
	ActiveSubCategory = undefined, --> [int] Активная подкатегория
	ActiveTask = undefined, --> [Task] Выбранное на текущий момент задание в списке MD_UI.ListMain
	ActiveTaskIndex = undefined, --> [int] Порядковый номер активного задания в списке MD_UI.ListMain
	InWorkTask = undefined, --> [string] Задание, находящееся в данный момент в рабочем состоянии
	CheckedTasks = #(), -- Отмеченные задания в списке MD_UI.ListMain

	-- Projects
	proj_main_categs = #(),
	proj_main_categ_ids = #(),
	proj_sub_categs = #(),
	proj_sub_categ_ids = #(),

	Users = #(),

	-- fn GetTasksInActiveCategory =
	-- (
	-- 	local activ_dir = sub_categ_lib_dirs[ActiveCategory][ActiveSubCategory]
	-- 	local tasks_dirs = GetDirectories (activ_dir + "\\*")
	-- 	local arr = #()

	-- 	for dir in tasks_dirs do
	-- 	(
	-- 		local task_file = pathConfig.AppendPath dir TASK_INNER_DIRS[1]
	-- 		task_file = pathConfig.AppendPath task_file TASK_FILE_NAME

	-- 		append arr (Task File:task_file)
	-- 	)
	-- 	Tasks[ActiveCategory][ActiveSubCategory] = arr
	-- 	arr = #()
	-- ),
	fn SwitchWorkLayer =
	(
		if ActiveTask.Article == InWorkTask then WorkLayer.on = true
		else WorkLayer.on = false
	),

	fn CreateWorkLayer =
	(
		if ActiveTask != undefined then
		(
			LayerManager.newLayerFromName ActiveTask.Article
			WorkLayer = LayerManager.getLayerFromName ActiveTask.Article
			WorkLayer.on
			WorkLayer.current = true
		)
	),

	fn DeleteWorkLayer =
	(
		if ActiveTask != undefined then
		(
			local nodes = GetAllLayerNodes WorkLayer.name

			for n in nodes do DEFAULT_LAYER.addNode n
			DeleteAllSubLayers WorkLayer.name
			LayerManager.deleteLayerByName WorkLayer.name
		)
		WorkLayer = undefined
	),

	fn GetTasksInActiveCategory =
	(
		local activ_dir = sub_categ_lib_dirs[ActiveCategory][ActiveSubCategory]
		local tasks_dirs = GetDirectories (activ_dir + "\\*")

		Tasks = #()

		for dir in tasks_dirs do
		(
			local task_file = pathConfig.AppendPath dir TASK_INNER_DIRS[1]
			task_file = pathConfig.AppendPath task_file TASK_FILE_NAME

			append Tasks (Task File:task_file)
		)
	),

	fn Update =
	(
		case ActiveSection of
		(
			1:(
				try (GetTasksInActiveCategory()) catch()

				if Tasks.count != 0 then
				(
					-- Установить активное задание
					if ActiveTaskIndex == undefined then
					ActiveTask = Tasks[1]
					else ActiveTask = Tasks[ActiveTaskIndex]

					-- Установить рабочее состояние
					if ActiveTask != undefined then
					(
						if ActiveTask.State != STATES[1] then
						(
							InWorkTask = ActiveTask.Article
							CreateWorkLayer()				
						)
					)						
				)
				else 
				(
					ActiveTask = undefined

					try MD_Data.SwitchWorkLayer() catch()
				)
			)
			2:(

			)
		)
	),

	fn Init = (
		-- Инициализирует исходные глобальные данные
		Categories = #()
		SubCategories = #()
		ValidTasks = #()
		InvalidTasks = #()
		CompletedTasks = #()
		DeletedTasks = #()
		CurrentTasks = #()

		users = #()
		main_categs = #()
		main_categ_ids = #()
		sub_categs = #()
		sub_categ_lib_dirs = #()

		proj_main_categs = #()
		proj_main_categ_ids = #()
		proj_sub_categs = #()
		proj_sub_categ_ids = #()

		try MD_LIB_DIR = GetUserEnvVar "MD_LIB_DIR"
		catch (MD_Log.Warning "Путь к локальной базе MakeDesign не определён.")

		-- Инициализация списков категорий
		if DoesDirectoryExist MD_LIB_DIR then
		(
			-- Импорт данных каталога объектов
			if DoesFileExist MD_CATALOG_DATA_FILE then
			(
				ReadDataFile MD_CATALOG_DATA_FILE

				local arr_names = #()
				local arr_ids = #()
				local arr_tasks = #()

				for i in data as array do 
				(
					
					for k in i["children"] as array do 
					(
						append main_categs (k["article"] + " - " + (subString i["name"] 1 12) + " - " + k["name"])
						append main_categ_ids k["article"]

						arr_names = #()
						arr_ids = #()
						arr_tasks = #()

						for j in k["children"] as array do 
						(
							append arr_names ((filterString j["article"] "-")[3] + " - " + j["name"])
							-- append arr_ids j["article"]
							sub_categ_dir = pathConfig.AppendPath MD_LIB_DIR MD_CATEGS[2][1]
							sub_categ_dir = pathConfig.AppendPath sub_categ_dir j["article"]
							append arr_ids sub_categ_dir
							append arr_tasks undefined
						)
						append sub_categs arr_names
						append sub_categ_lib_dirs arr_ids
						-- append Tasks arr_tasks
					)
				)
				arr_names = #()
				arr_ids = #()
				arr_tasks = #()
			)
			
			-- Импорт данных пользователей
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

			
		)
		Update()
	),

	on create do Init()
)

-- Структура хранит диалоговые окна
struct UI_Dialogs
(
	Configure = dlg_configure,
	CheckTasks = dlg_check_tasks,
	PivotParams = dlg_pivot_params,
	LoadWork = dlg_load_work,
	Validation = dlg_validation,
	Progress = dlg_progress
)

-- Структура для работы с интерфейсом
struct UI
(
	Main = rlt_make_design,
	Settings = rlt_settings,
	Tasks = rlt_tasks,
	InfoCatalog = rlt_info_catalog,
	InfoProjects = rlt_info_projects,
	ToolsCatalog = rlt_tools_catalog,
	ToolsProjects = rlt_tools_projects,
	Help = rlt_about,
	Dialogs = UI_Dialogs(),
	Sections = rlt_tasks.lst_sections,
	Categories = rlt_tasks.lst_basic_catalog,
	SubCategories = rlt_tasks.lst_sub_catalog,
	ListMain = rlt_tasks.lv_main,
	ListAdd = rlt_tasks.lv_add,
	InfoCatalogPreview = rlt_info_catalog.img_prev,
	InfoCatalogWeb = rlt_info_catalog.hpl_site,
	InfoCatalogSize = rlt_info_catalog.lbl_size_txt,
	ActiveMainItem = undefined,
	ActiveAddItem = undefined,
	CheckedItems = undefined,
	EMPTY_PREVIEW = undefined,

	fn InitLists = (
		-- Инициализирует основной и доп. списки, исходя из выбранного раздела

		-- Устанавливает параметры для контрола листвью
		fn SetListViewParams list_view = (
			list_view.BorderStyle = list_view.BorderStyle.None
			list_view.gridLines = true
			list_view.View = (dotNetClass "System.Windows.Forms.View").Details
			list_view.fullRowSelect = true
			list_view.MultiSelect = false
			list_view.HideSelection = false
			list_view.HoverSelection  = false
			list_view.CheckBoxes = true
		)

		-- Добавляет колонки в листвью
		fn AddListViewColumns list_view columns widths:#() = (
			for i = 1 to columns.count do
			try(list_view.Columns.add columns[i] widths[i])
			catch(list_view.Columns.add columns[i])
		)
		ListMain.Columns.Clear()
		ListAdd.Columns.Clear()
		SetListViewParams ListMain
		SetListViewParams ListAdd

		case MD_Data.ActiveSection of
		(
			1:(
				AddListViewColumns ListMain MAIN_LIST_COLUMNS_1 widths:#(110, 60, 60, 60, 120)
				AddListViewColumns ListAdd ADD_LIST_COLUMNS_1 widths:#(58, 58, 25, 25, 25, 35)
			)
			2:(
				AddListViewColumns ListMain MAIN_LIST_COLUMNS_2 widths:#(206)
				AddListViewColumns ListAdd ADD_LIST_COLUMNS_2 widths:#(206)
			)
		)
		setFocus ListMain
	),

	fn FillData =
	(
		case MD_Data.ActiveSection of
		(
			1:(
				MD_Data.ActiveCategory = Categories.Selection
				MD_Data.ActiveSubCategory = SubCategories.Selection

				-- Заполнить данными список заданий панели Tasks
				local main_items = #()
				local item_index = 0
				local cur_sel = undefined

				-- Индекс выделенного элемента в стике
				if ListMain.SelectedItems.Count != 0 then cur_sel = ListMain.SelectedItems.Item[0].Index

				for task in MD_Data.Tasks do
				(
					dn_list_item = dotNetObject "System.Windows.Forms.ListViewItem" task.Article
					dn_list_item.Checked = false
					dn_list_item.ForeColor = DN_CLR_DEFAULT

					-- State
					if task.State == STATES[2] then 
					(
						dn_list_item.SubItems.add task.State
						if task.Article == MD_Data.ActiveTask.Article then
						(
							MD_Data.InWorkTask = task.Article
							MD_Data.CreateWorkLayer()							
						)
					)
					else dn_list_item.SubItems.add ""

					-- Group
					if task.Group != undefined then dn_list_item.SubItems.add task.Group
					else dn_list_item.SubItems.add ""

					-- Transformation
					-- if task.SizeTrans != undefined then dn_list_item.SubItems.add "•" -- alt+0149
					if task.SizeTrans != undefined then dn_list_item.SubItems.add "YES"
					else dn_list_item.SubItems.add ""

					-- User name
					dn_list_item.SubItems.add task.UserName

					-- Отметить элемент как выделенный
					if cur_sel == item_index then dn_list_item.Selected = true

					append main_items dn_list_item 
					item_index += 1
				)

				ListMain.Items.Clear()
				ListMain.Items.AddRange main_items
				ListMain.Update()

				-- Заполнить данными список материалов панели Tasks
				local add_items = #()
				

				ListAdd.Items.Clear()
				ListAdd.Items.AddRange add_items
				ListAdd.Update()

				-- Заполнить данными панель Info
				Categories.Items = MD_Data.main_categs
				try SubCategories.Items = MD_Data.sub_categs[Categories.Selection] 
				catch(SubCategories.Items = #())

				try (
					if MD_Data.ActiveTask.RefBitmap != undefined then
					InfoCatalogPreview.bitmap = MD_Data.ActiveTask.RefBitmap
				) 
				catch()
				-- catch(MD_Log.Error "Не удалось загрузить изображение референса.")
				
				try (
					InfoCatalogWeb.text = ""
					InfoCatalogWeb.text = substring MD_Data.ActiveTask.Website 1 30
					InfoCatalogWeb.address = MD_Data.ActiveTask.Website
				)
				catch()

				try (
					local size_txt = ""
					size_txt += ("W: " + (MD_Data.ActiveTask.Size[1] as string) + "    ")
					size_txt += ("D: " + (MD_Data.ActiveTask.Size[2] as string) + "    ")
					size_txt += ("H: " + (MD_Data.ActiveTask.Size[3] as string))
					InfoCatalogSize.text = size_txt
				) catch()
			)
			2:(
				Categories.Items = MD_Data.proj_main_categs
				SubCategories.Items = MD_Data.proj_sub_categs
				try SubCategories.Items = MD_Data.proj_sub_categs[Categories.Selection] catch()
				ListMain.Items.Clear()
				ListMain.Update()

				ListAdd.Items.Clear()
				ListAdd.Update()
			)
		)
	),

	fn ToolsRltUpdate =
	(
		case Sections.Selection of
		(
			1:(
				for ctrl in ToolsCatalog.Controls do ctrl.enabled = false
				for ctrl in ToolsProjects.Controls do ctrl.enabled = false
				local task_layer_nodes = #()
				local temp_layer_nodes = #()
				local objs = #()

				if MD_Data.ActiveTask != undefined and MD_Data.WorkLayer != undefined and MD_Data.ActiveTask.State == STATES[2] then
				(
					task_layer_nodes = GetAllLayerNodes MD_Data.ActiveTask.Article
					temp_layer_nodes = GetAllLayerNodes mdt_temp_layer
					objs = for obj in (objects as array) where (findItem temp_layer_nodes obj == 0) collect obj

					-- Пивот
					ToolsCatalog.btn_set_pivot.enabled = true

					-- Доп. меш
					if MD_Data.ActiveTask.SizeTrans != undefined and MD_Data.ActiveTask.AddMesh != undefined then
					(
						ToolsCatalog.btn_mesh_switch.enabled = true

						case MD_Data.ActiveTask.ActiveMesh of
						(
							1:(
								ToolsCatalog.btn_mesh_switch.text = ">> Add"								
							)
							2:(
								ToolsCatalog.btn_mesh_switch.text = "<< Main"
							)							
						)
					)

					-- Сохранить работу
					-- if (MD_Data.WorkLayer != undefined and task_layer_nodes.count != 0) then
					-- (
					-- 	ToolsCatalog.btn_save_work.enabled = true
					-- )

					if objs.count != task_layer_nodes.count and objs.count != 0 then 
					(
						ToolsCatalog.btn_attach_to_task.enabled = true
						ToolsCatalog.btn_save_work.enabled = false
					)
					else ToolsCatalog.btn_save_work.enabled = true

					-- Загрузить работу
					if MD_Data.ActiveTask.SavedWorks.count != 0 then
					(
						ToolsCatalog.btn_load_work.enabled = true
					)

					-- Экспорт
					if MD_Data.ActiveTask.Valid != False then
					(
						ToolsCatalog.btn_export.enabled = true
					)
				)
				free task_layer_nodes
				free temp_layer_nodes
				free objs
			)
			2:(

			)
		)
	),

	fn Update = (
		-- Обновляет интерфейс исходя из текущих данных
		FillData()

        try MD_Data.ActiveCategory = Categories.selection catch()
        try MD_Data.ActiveSubCategory = SubCategories.selection catch()

		if MD_Data.ValidTasks.count != 0 or MD_Data.InvalidTasks.count != 0 or MD_Data.CompletedTasks.count != 0 or MD_Data.DeletedTasks.count != 0 then
		(
			Tasks.btn_get.enabled = true
			Tasks.btn_clear.enabled = true
		)

		if MD_Data.InvalidTasks.count != 0 then
		(
			Tasks.btn_get.text = "Send"
		)

		if MD_Data.CheckedTasks.count != 0 then
		(
			Tasks.btn_clear.enabled = true
			Tasks.btn_clear.text = "Delete"
		)

		if MD_Data.ActiveTask == undefined then
		(
			for ctrl in Tasks.Controls do ctrl.enabled = false
			for ctrl in InfoCatalog.Controls do ctrl.enabled = false
			for ctrl in ToolsCatalog.Controls do ctrl.enabled = false
			for ctrl in ToolsProjects.Controls do ctrl.enabled = false

			Tasks.btn_work_state.text = "Set Work State"
			InfoCatalogPreview.bitmap = EMPTY_PREVIEW
			InfoCatalogWeb.text = ""
			InfoCatalogWeb.address = ""
			InfoCatalogSize.text = ""

			Tasks.lst_sections.enabled = true
			Tasks.lst_basic_catalog.enabled = true
			Tasks.lst_sub_catalog.enabled = true
			ListMain.enabled = true
			ListAdd.enabled = true
		)
		else
		(
			Tasks.btn_work_state.enabled = true
			if MD_Data.ActiveTask.State == STATES[1] then
			(
				Tasks.btn_work_state.text = "Set Work State"
				Tasks.btn_exit_work_state.enabled = false

				for ctrl in ToolsCatalog.Controls do ctrl.enabled = false
				for ctrl in ToolsProjects.Controls do ctrl.enabled = false
			)
			else if MD_Data.ActiveTask.State == STATES[2] then
			(
				Tasks.btn_work_state.text = "Update Work State"
				Tasks.btn_exit_work_state.enabled = true

				ToolsRltUpdate()
			)
			for ctrl in InfoCatalog.Controls do ctrl.enabled = true
			
			try (ListMain.Items.Item[MD_Data.ActiveTaskIndex - 1].Selected = True) catch()
		)

		if SubCategories.Items.Count != 0 then
		(
			Tasks.lst_basic_catalog.enabled = true
			Tasks.lst_sub_catalog.enabled = true
			Tasks.btn_check.enabled = true
		)

		if Settings.ckbx_tooltips.Checked == false then
		(
			for ctrl in Settings.Controls do try(ctrl.tooltip = "")catch()
			for ctrl in Tasks.Controls do try(ctrl.tooltip = "")catch()
			for ctrl in InfoCatalog.Controls do try(ctrl.tooltip = "")catch()
			for ctrl in ToolsCatalog.Controls do try(ctrl.tooltip = "")catch()
			for ctrl in ToolsProjects.Controls do try(ctrl.tooltip = "")catch()
		)

		-- Обновить текст веб ссылки (баг макса)
		try
		(
			InfoCatalogWeb.text = ""
			InfoCatalogWeb.text = substring MD_Data.ActiveTask.Website 1 30
		)
		catch()

		ListMain.Focus()
	),

	fn SwitchRollouts = (
		-- Переключает роллоуты в зависимости от того, какой раздел выбран

        removeSubRollout Main.sub_rlt Help
        case Sections.Selection of
        (
            1:(
                removeSubRollout Main.sub_rlt ToolsProjects
				-- removeSubRollout Main.sub_rlt InfoProjects
                AddSubRollout Main.sub_rlt InfoCatalog rolledUp:false
				AddSubRollout Main.sub_rlt ToolsCatalog rolledUp:false
            )
            2:(
                removeSubRollout Main.sub_rlt ToolsCatalog
                removeSubRollout Main.sub_rlt InfoCatalog
                -- AddSubRollout Main.sub_rlt InfoProjects rolledUp:false
                AddSubRollout Main.sub_rlt ToolsProjects rolledUp:false
            )
        )
        AddSubRollout Main.sub_rlt Help rolledUp:True

		-- Выравнить подроллаут
		Main.sub_rlt.height = (MAIN_RLT_HEIGHT - 28)
		Main.sub_rlt.pos = [2, 4]

		InitLists()

		-- Update()
	),

	fn Close = (
		-- Удаляет главный роллаут, если он ткрыт

		try(cui.UnRegisterDialogBar ::rlt_make_design)catch()
		try(destroyDialog ::rlt_make_design)catch()
	),

	fn SetColorScheme =
	(
		-- Определить текущую тему 3ds Max
		get_max_ui_bg_color()

		dn_max_ui_bg_color = (dotNetClass "system.Drawing.color").FromArgb 255 MAX_UI_BG_COLOR.r MAX_UI_BG_COLOR.g MAX_UI_BG_COLOR.b

		if MAX_UI_BG_COLOR.r > 100 then
		(
			-- Если тема светлая
			DN_CLR_X = (dotNetClass "system.Drawing.color").FromArgb 255 200 50 50
			DN_CLR_OK = (dotNetClass "system.Drawing.color").FromArgb 255 10 130 10
		)
		else
		(
			-- Если тема тёмная
			DN_CLR_X = (dotNetClass "system.Drawing.color").FromArgb 255 255 90 50
			DN_CLR_OK = (dotNetClass "system.Drawing.color").FromArgb 255 55 200 55
		)
	),

	fn Init = (

		local exist_task_index = undefined
		local exist_categ_index = undefined
		local exist_sub_categ_index = undefined

		Close()
		-- Установить цветовую схему
		SetColorScheme()

		createdialog Main width:(MAIN_RLT_WIDTH + 8) height:(MAIN_RLT_HEIGHT - 20) autoLayoutOnResize:true scrollBar:#on lockHeight:false

		AddSubRollout Main.sub_rlt Settings rolledUp:true
		AddSubRollout Main.sub_rlt Tasks rolledUp:false
		AddSubRollout Main.sub_rlt InfoCatalog rolledUp:true
		AddSubRollout Main.sub_rlt ToolsCatalog rolledUp:false
		AddSubRollout Main.sub_rlt Help rolledUp:true

		-- Инициализация входных значений
		try(
			Categories.Selection = MD_Data.ActiveCategory
			SubCategories.Selection = MD_Data.ActiveSubCategory
		)catch()

		try (for sr in Main.sub_rlt.rollouts do GetINISettings sr MDT_CONFIG_FILE sr.name) 
		catch (MD_Log.Error "Не удалось загрузить данные конфигурации интерфейса.")

		try (exist_categ_index = execute (GetINISetting MDT_CONFIG_FILE Tasks.Name "lst_basic_catalog_selection")) catch()
		try (exist_sub_categ_index = execute (GetINISetting MDT_CONFIG_FILE Tasks.Name "lst_sub_catalog_selection")) catch()
		try (exist_task_index = execute (GetINISetting MDT_CONFIG_FILE Tasks.Name "lv_main_selection") + 1) catch()
		
		try (
			if exist_categ_index > 0 then Categories.Selection = MD_Data.ActiveCategory = exist_categ_index
			else if exist_categ_index == 0 and MD_Data.main_categs.count != 0 then Categories.Selection = MD_Data.ActiveCategory = 1
			if exist_sub_categ_index > 0 then SubCategories.Selection = MD_Data.ActiveSubCategory = exist_sub_categ_index
			else if exist_categ_index == 0 and MD_Data.main_categs.count != 0 then SubCategories.Selection = MD_Data.ActiveSubCategory = 1
		)
		catch (MD_Log.Error "Не удалось загрузить данные конфигурации интерфейса. [ActiveCategory, ActiveSubCategory]")

		try(
			EMPTY_PREVIEW = CreatePreviewFromImageFile ICON_NO_PRVIEW_FILE PREVIEW_SIZE
			InfoCatalogPreview.bitmap = EMPTY_PREVIEW
		)
		catch (MD_Log.Error "Не удалось загрузить изображение \"NO PREVIEW\".")

		MD_Data.ActiveSection = Sections.Selection

		try MD_Data.ActiveTaskIndex = exist_task_index 
		catch(MD_Log.Error "Не удалось инициализировать переменную. [ActiveTaskIndex]")

		try MD_Data.ActiveTask = MD_Data.Tasks[exist_task_index]
		catch(MD_Log.Error "Не удалось инициализировать переменную. [ActiveTask]")
		
		SwitchRollouts()
		MD_Data.Update()
		Update()
	),
	
	on create do Init()
)

-- Габаритный контейнер
struct BoundingBox
(
	Layer = undefined,
	bbox_size = [0, 0, 0],
	pivot_pos = [0, 0, 0],
	bb = undefined,
	arrow = undefined,
	pp = undefined,
	clr_main = (color 90 150 255),
	clr_add = (color 255 100 50),
	arrow_offset = ConvertValueToSystemUnits #cm 10.0,
	arrow_rad = ConvertValueToSystemUnits #cm 20.0,

	fn Remove =
	(
		try(delete $bbox* )catch()
		try(delete $barrow* )catch()
		try(delete $ppoin* )catch()
		try(LayerManager.deleteLayerByName mdt_temp_layer)catch()

		gc()
	),

	fn CreateBBox =
	(
		-- Bounding box
		bb = Box name:(uniqueName "bbox_") length:0.0 width:0.0 height:0.0 isSelected:off
		arrow = Ngon name:(uniqueName "barrow_") radius:0.0 cornerRadius:0 nsides:3 circular:off scribe:1 pos:[0, 0, 0] isSelected:off
		pp = Point name:(uniqueName "ppoint_") isSelected:off
		cur_sel = selection

		bb.boxmode = on
		bb.showFrozenInGray = arrow.showFrozenInGray = off
		bb.isFrozen = arrow.isFrozen = on
		bb.isSelected = arrow.isSelected = off
		bb.renderable = arrow.renderable = off
		bb.wireColor = arrow.wireColor = clr_main

		pp.centermarker = on
		pp.Box = off
		pp.cross = off
		pp.axistripod = off
		pp.drawontop = on
		pp.showFrozenInGray = off
		pp.isFrozen = on
		pp.wireColor = (color 14 255 2)
		pp.ishidden = on

		Layer.addnode bb
		Layer.addnode arrow
		Layer.addnode pp

		select cur_sel
		snapMode.toFrozen = true
		completeRedraw()
	),

	fn CreateLayer =
	(
		LayerManager.newLayerFromName mdt_temp_layer
		Layer = LayerManager.getLayerFromName mdt_temp_layer
		Layer.lock = on
		if MD_UI.Settings.ckbx_show_bb.checked == true then Layer.ishidden  = off
		else Layer.ishidden  = on
	),

	fn write_pivot_data =
	(
		if MD_Data.ActiveTask != undefined then
		(
			ReadDataFile MD_Data.ActiveTask.File
			data["pivot"] = #(pivot_pos[1], pivot_pos[2], pivot_pos[3])
			WriteDataFile MD_Data.ActiveTask.File
		)
	),
	
	fn read_pivot_data =
	(
		if MD_Data.ActiveTask != undefined then
		(
			ReadDataFile MD_Data.ActiveTask.File
			pivot_pos = data["pivot"]
		)
	),

	fn Update =
	(
		local arrow_offset = ConvertValueToSystemUnits #cm 10.0

		try read_pivot_data() catch()
		pp.pos = [pivot_pos[1], pivot_pos[2], pivot_pos[3]]
		arrow_rad = 0.0

		if MD_Data.ActiveTask != undefined then
		(
			if MD_Data.ActiveTask.State == STATES[1] then 
			(
				bbox_size = [0, 0, 0]
				pp.isHidden = true
				bb.wireColor = clr_main
				arrow.wireColor = clr_main
			)
			else 
			(
				case MD_Data.ActiveTask.ActiveMesh of
				(
					1:(
						bb_w = MD_Data.ActiveTask.Size[1]
						bb_d = MD_Data.ActiveTask.Size[2]
						bb_h = MD_Data.ActiveTask.Size[3]

						bbox_size = [ConvertValueToSystemUnits #cm bb_w,\
						ConvertValueToSystemUnits #cm bb_d,\
						ConvertValueToSystemUnits #cm bb_h]

						bb.wireColor = clr_main
						arrow.wireColor = clr_main
					)
					2:(
						bt_w = MD_Data.ActiveTask.SizeTrans[1]
						bt_d = MD_Data.ActiveTask.SizeTrans[2]
						bt_h = MD_Data.ActiveTask.SizeTrans[3]

						bbox_size = [ConvertValueToSystemUnits #cm bt_w,\
						ConvertValueToSystemUnits #cm bt_d,\
						ConvertValueToSystemUnits #cm bt_h]

						bb.wireColor = clr_add
						arrow.wireColor = clr_add
					)
				)

				if MD_UI.Settings.ckbx_auto_pivot.checked == true then pp.isHidden = false
				else pp.isHidden = true
				
				arrow_rad = ConvertValueToSystemUnits #cm 20.0

			)
		)

		bb.length = bbox_size[1]
		bb.width = bbox_size[2]
		bb.height = bbox_size[3]
		arrow.radius = arrow_rad
		arrow.pos.x = (bb.width/2.0 + arrow_rad/2.0 + arrow_offset)

		if MD_UI.Settings.ckbx_show_bb.checked then Layer.on = true
		else Layer.on = false

		completeRedraw()
	),

	fn Init =
	(
		Remove()
		CreateLayer()
		CreateBBox()
	),
	on create do Init()
)

struct Callback
(
	ToolsUIUpdate = undefined,

	fn CallbackFn1 ev nd = 
	(
		MD_UI.ToolsRltUpdate()
	),

	fn Destruct =
	(
		callbacks.removeScripts id:#CheckExistTaskLayer
		ToolsUIUpdate = undefined
		gc light:true
	),

	fn CheckExistTaskLayer =
	(
		if (callbacks.notificationParam()).name == MD_Data.ActiveTask.Article then
		(
			if MD_Data.ActiveTask != undefined then
			(
				MD_Data.ActiveTask.State = STATES[1]
				MD_Data.ActiveTask.ActiveMesh = 1
				MD_Data.WorkLayer = undefined
				MD_Data.ActiveTask.Update()
				
				MD_UI.Update()
				MD_BBox.Update()				
			)
		)
	),

	fn Add =
	(
		callbacks.addScript #layerDeleted CheckExistTaskLayer id:#CheckExistTaskLayer
		ToolsUIUpdate = NodeEventCallback mouseUp:true delay:1000 \
		added:CallbackFn1 \
		deleted:CallbackFn1 \
		layerChanged:CallbackFn1 \
		selectionChanged:CallbackFn1
	)
)