
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

-- Структура для работы с глобальными данными
struct GlobalData
(
	Categories = #(),
	SubCategories = #(),
	ValidTasks = #(),
	InvalidTasks = #(),
	CompletedTasks = #(),
	DeletedTasks = #(),
	CurrentTasks = PY_BUILTINS.dict(), -- Задания для выбранной в данный момент подкатегории
	-- Catalog
	main_categs = #(),
	main_categ_ids = #(),
	sub_categs = #(),
	sub_categ_ids = #(),
	ActiveSection = 1, --> [int] Активная категория
	ActiveCategory = undefined, --> [int] Активная подкатегория
	ActiveSubCategory = undefined, --> [int] Активная подкатегория
	ActiveTask = undefined, --> [Task] Выбранное на текущий момент задание в списке MD_UI.ListMain
	CheckedTasks = #(), -- Отмеченные задания в списке MD_UI.ListMain
	exist_preview = Dictionary(),
	-- Projects
	proj_main_categs = #(),
	proj_main_categ_ids = #(),
	proj_sub_categs = #(),
	proj_sub_categ_ids = #(),
	proj_exist_preview = Dictionary(),

	Users = #(),

	fn Init = (
		-- Инициализирует исходные глобальные данные
		Categories = #()
		SubCategories = #()
		ValidTasks = #()
		InvalidTasks = #()
		CompletedTasks = #()
		DeletedTasks = #()
		CurrentTasks = PY_BUILTINS.dict()

		ReadDataFile MD_CATALOG_DATA_FILE

		exist_preview = #()
		users = #()
		main_categs = #()
		main_categ_ids = #()
		sub_categs = #()
		sub_categ_ids = #()

		free proj_exist_preview
		free proj_main_categs
		free proj_main_categ_ids
		free proj_sub_categs
		free proj_sub_categ_ids

		try MD_LIB_DIR = GetUserEnvVar "MD_LIB_DIR"
		catch (MD_Log.Warning "Путь к локальной базе MakeDesign не определён.")

		if MD_LIB_DIR != "" then
		(
			local arr_names = #()
			local arr_ids = #()

			for i in data as array do 
			(
				for k in i["children"] as array do 
				(
					append main_categs (k["article"] + " - " + (subString i["name"] 1 12) + " - " + k["name"])
					append main_categ_ids k["article"]
					arr_names = #()
					arr_ids = #()
					for j in k["children"] as array do 
					(
						append arr_names ((filterString j["article"] "-")[3] + " - " + j["name"])
						append arr_ids j["article"]
					)
					append sub_categs arr_names
					append sub_categ_ids arr_ids
				)
			)
			
			free arr_names
			free arr_ids

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
	),
	on create do Init()
)

-- Структура хранит диалоговые окна
struct UI_Dialogs
(
	Configure = dlg_configure,
	CheckTasksParams = dlg_check_tasks,
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
	Sections = Tasks.lst_sections,
	Categories = Tasks.lst_basic_catalog,
	SubCategories = Tasks.lst_sub_catalog,
	ListMain = Tasks.lv_main,
	ListAdd = Tasks.lv_add,
	ActiveMainItem = undefined,
	ActiveAddItem = undefined,
	CheckedItems = undefined,
	
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

				Categories.Items = MD_Data.main_categs
				try SubCategories.Items = MD_Data.sub_categs[Categories.Selection] 
				catch(SubCategories.Items = #())
			)
			2:(
				Categories.Items = MD_Data.proj_main_categs
				SubCategories.Items = MD_Data.proj_sub_categs
				try SubCategories.Items = MD_Data.proj_sub_categs[Categories.Selection] catch()
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

				if MD_Data.ActiveTask.State == STATES[2] then
				(
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
					if (MD_Data.ActiveTask.Layer != undefined and MD_Data.ActiveTask.Layer.getNumChildren != 0) then
					(
						ToolsCatalog.btn_save_work.enabled = true
					)

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
			)
			2:(

			)
		)
		ListMain.Focus()
	),

	fn Update = (
		-- Обновляет интерфейс исходя из текущих данных
		FillData()

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

			Tasks.Controls[1].enabled = true
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
		
		ListMain.Focus()
	),

	fn SwitchRollouts = (
		-- Переключает роллоуты в зависимости от того, какой раздел выбран

        removeSubRollout Main.sub_rlt Help
        case MD_Data.ActiveSection of
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

		Update()
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
		-- Создаёт главный роллаут
		Close()
		-- Установить цветовую схему
		SetColorScheme()

		createdialog Main width:(MAIN_RLT_WIDTH + 8) height:(MAIN_RLT_HEIGHT - 20) autoLayoutOnResize:true scrollBar:#on lockHeight:false

		AddSubRollout Main.sub_rlt Settings rolledUp:true
		AddSubRollout Main.sub_rlt Tasks rolledUp:false
		AddSubRollout Main.sub_rlt InfoCatalog rolledUp:true
		AddSubRollout Main.sub_rlt ToolsCatalog rolledUp:false
		AddSubRollout Main.sub_rlt Help rolledUp:true

		try (for sr in Main.sub_rlt.rollouts do GetINISettings sr MDT_CONFIG_FILE sr.name) 
		catch (MD_Log.Error "Не удалось загрузить данные конфигурации интерфейса.")

		Sections.Selection = MD_Data.ActiveSection
		SwitchRollouts()
		FillData()
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
		-- task_dir = get_active_categ_lib_path() + "\\" + active_task_id + "\\Task"
		-- data_file = task_dir + "\\data.json"
		-- ReadDataFile data_file
		-- data["pivot"] = #(pivot_pos[1], pivot_pos[2], pivot_pos[3])
		-- WriteDataFile data_file
	),
	
	fn read_pivot_data =
	(
		data_file = MD_Data.ActiveTask.File
		ReadDataFile data_file
		try(pivot_pos = data["pivot"])catch()
	),

	fn Update =
	(
		local arrow_offset = ConvertValueToSystemUnits #cm 10.0
		-- try
		-- (
		-- 	read_pivot_data()
		-- 	pp.pos = [pivot_pos[1], pivot_pos[2], pivot_pos[3]]
		-- )
		-- catch()

		if MD_Data.ActiveTask.State == STATES[1] then 
		(
			bbox_size = [0, 0, 0]
			pp.isHidden = true
			bb.wireColor = clr_main
			arrow.wireColor = clr_main
			arrow_rad = 0.0
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

		bb.length = bbox_size[1]
		bb.width = bbox_size[2]
		bb.height = bbox_size[3]
		arrow.radius = arrow_rad
		arrow.pos.x = (bb.width/2.0 + arrow_rad/2.0 + arrow_offset)

		completeRedraw()
	),

	fn Init =
	(
		Remove()
		CreateLayer()
		CreateBBox()
		-- try Update() catch()
	),
	on create do Init()
)


-- Структура материала активного задания
struct TaskMaterial
(
	parts,
	material,
	texture_d,
	texture_m,
	texture_n,
	texture_ard
)

-- Структура активного задания
struct Task
(
	File = undefined,
	Layer = undefined,
	Article = undefined,
	State = STATES[1],
	RefPhoto = undefined,
    RefPhotoFile = undefined,
	Website = undefined,
	Size = undefined,
	Group = undefined,
	SizeTrans = undefined,
	UserName = undefined,
	Materials = #(),
	BBoxSize = [0, 0, 0],
	Mesh = undefined,
	AddMesh = undefined,
	ActiveMesh = 1,
	SavedWorks = #(),
	Valid = False,

	fn Init = (
		-- Читает данные задания из json файла

        if File != undefined then
        (
            ReadDataFile File
            if data != undefined then
            (
                Article = data["article"]
                RefPhoto = undefined
                RefPhotoFile = undefined
                Website = data["web_site"]
                Size = #(
					data["size"][1],
					data["size"][2],
					data["size"][3]
				)
                Group = undefined
                try SizeTrans = #(data["size_trans"][1] as float, data["size_trans"][2]  as float, data["size_trans"][3]  as float) catch()
                UserName = undefined
                Materials = #()
                BBoxSize = [0, 0, 0]
				AddMesh = undefined
            )
        )
	),

	on create do Init()
)

