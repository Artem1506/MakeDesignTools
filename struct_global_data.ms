
struct GlobalData
(
	Categories = #(),
	SubCategories = #(),
	WorkLayer = undefined,
	-- Tasks lists
	TempArticlesList = #(),
	InvalidTasks = #(),
	CompletedTasks = #(),
	DeletedTasks = #(),
	Tasks = #(), -- Задания для выбранной в данный момент подкатегории
	SortTasks = #(), -- Отсортированные задания для выбранной в данный момент подкатегории
	-- Catalog
	main_categs = #(), -- #("01-01 - Пол - Плитка", ...)
	main_categ_ids = #(), -- #(#("01-01-001", ...), ...)
	sub_categs = #(), -- #(#("001 - Керамическая плитка", "002 - Керамогранит", "003 - Мозаика", "004 - Неолит"), ... )
	sub_categ_lib_dirs = #(), -- #(#("D:\MakeDesignLib\Catalog\06-02-013", ...), ...) Пути к категориям в локальной базе
	ActiveSection = 1, --> [int] Активная категория
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
	-- Projects
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
		-- TempLayerNodes = GetAllLayerNodes MD_BBox.Layer.Name

		local obj, th, bb, sub_mats_count, mat_ids, uv_count
		sub_mats_count = 0
		local mat_ids = uv_count = #()
		local val = true
		local msg = ""
		local valids = #("X", "X", "X", "X", "X", "X", "X")
		local objs = #(InWorkTask.Mesh, InWorkTask.AddMesh)

		-- Check count
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
				
				-- Check dimensions and position
				threshold = ConvertSysUnitsToCentimeters 0.25
				
				if ((distance MD_BBox.bb.min obj.min) < threshold) and ((distance MD_BBox.bb.max obj.max) < threshold) then 
				(
					valids[3] = "OK"
					
				)else (msg = "Расположение или размеры объекта не соответствуют габаритному контейнеру.")
	
				-- Check material
				if this.ActiveTask.material != undefined then
				(
					-- Check submaterials count
					sub_mats_count = 0
					try(sub_mats_count = this.ActiveTask.material.count)catch()
					if (InWorkTask.Group == undefined and this.ActiveTask.material.name == this.ActiveTask.Article and sub_mats_count == this.ActiveTask.Materials.count) or \
					(InWorkTask.Group == this.ActiveTask.Group and this.ActiveTask.Material.name == this.ActiveTask.Article and sub_mats_count == this.ActiveTask.Materials.count) then
					(
						valids[4] = "OK"
	
						-- Check material id count
						mat_ids = GetMaterialIDList obj
						if mat_ids.count >= this.ActiveTask.Materials.count then
						(
							valids[5] = "OK"
						)else (msg = "Количество material IDs объекта не соответствует заданию.")
					)else (msg = "На объект назначен некорректный материал.")
				)else (msg = "На объект не назначен материал.")
	
				-- Check uv channels count
				uv_count = GetNumUVChannels obj
				if uv_count >= 1 then
				(
					valids[6] = "OK"                                    
				)else(msg = "Объект должен содержать хотя бы один UV канал.")

				-- Check icon
				
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

		-- --Переключение состояния кнопки "EXPORT"
		-- if val then MD_UI.Dialogs.Export.btn_export.enabled = true
		-- else MD_UI.Dialogs.Export.btn_export.enabled = false

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
		-- #all
		-- #scene_only
		-- #work_only
		-- #none

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
			local icon_file = pathConfig.appendPath SOURCE_ICONS_DIR (MD_Data.active_catalog_article + (ICON_POSTFIX + ".max"))
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
        
		-- Обновить
		ActiveTask.Update()
        
		local work_tasks = #()

		if this.ActiveTask.Group != undefined then
		(
			work_tasks = for t in this.Tasks where t.Group == this.ActiveTask.Group collect t
		)
		else work_tasks = #(this.ActiveTask)

		for t in work_tasks do
		(
			-- Создать рабочую папку
			MakeDir t.InWorkDir

			-- Создать материал
			if DoesFileExist (pathConfig.appendPath t.InWorkDir TASK_MAT_NAME) then
			(
				t.LoadMaterial()
				
			)else t.CreateMaterial()			
		)
		-- try MD_Callbacks.Add() catch()

		-- Иконка
		local icon_file = pathconfig.appendpath MD_Data.InWorkTask.InWorkDir TASK_ICON_NAME

		if (DoesFileExist icon_file) then 
		(
			MD_Data.ActiveCategoryIcon.SetIcon icon_file
		)
	),

	-- fn UpdateWorkState =
	-- (
	-- 	try MD_Callbacks.Destruct() catch()
	-- 	this.ActiveTask.State = STATES[2]
    --     this.ActiveTask.ActiveMesh = 1
    --     this.InWorkTask = this.ActiveTask
	-- 	this.InWorkTaskFile = this.ActiveTask.File
	-- 	this.CreateWorkLayer()
	-- 	this.ActiveTask.Update()
	-- 	try AttachObjectsToWorkState() catch()
	-- 	try (
	-- 		ReadDataFile MD_LIB_DATA_FILE
	-- 		data["in_work_task"] = substituteString InWorkTask.File "\\" "/"
	-- 		WriteDataFile MD_LIB_DATA_FILE
	-- 	)
	-- 	catch ()
	-- 	try MD_Callbacks.Add() catch()
		
	-- 	-- Иконка
	-- 	local icon_file = pathconfig.appendpath this.InWorkTask.InWorkDir TASK_ICON_NAME
		
	-- 	if (DoesFileExist icon_file) then 
	-- 	(
	-- 		this.ActiveCategoryIcon.SetIcon icon_file
	-- 	)else(
	-- 		try (
	-- 			this.active_catalog_article = (this.main_categ_ids[this.ActiveCategory][this.ActiveSubCategory])
	-- 			icon_file = pathConfig.appendPath SOURCE_ICONS_DIR (this.active_catalog_article + (ICON_POSTFIX + ".max"))
	-- 			this.ActiveCategoryIcon.SetIcon icon_file
	-- 		)catch(this.ActiveCategoryIcon.Icon = undefined)
	-- 	)
	-- ),

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
			-- MD_Callbacks.Add()

			-- Иконка
			local icon_file = pathconfig.appendpath this.InWorkTask.InWorkDir TASK_ICON_NAME
			
			if (DoesFileExist icon_file) then 
			(
				this.ActiveCategoryIcon.SetIcon icon_file
			)else(
				try (
					this.active_catalog_article = (this.main_categ_ids[this.ActiveCategory][this.ActiveSubCategory])
					icon_file = pathConfig.appendPath SOURCE_ICONS_DIR (this.active_catalog_article + (ICON_POSTFIX + ".max"))
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
			-- Валидация имени папки. (Для исключения папок для групп)
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
			-- Валидация имени папки. (Для исключения папок для групп)
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
			-- clearSelection()
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

			-- Запись данных в файл задания
			ReadDataFile this.ActiveTask.File
			-- max_size = amax #(this.InWorkTask.Size[1], this.InWorkTask.Size[2])
			data["icon_size"] = #(
				ICON_THICKNESS,
				ConvertSysUnitsToCentimeters this.InWorkTask.Size[1],
				ConvertSysUnitsToCentimeters this.InWorkTask.Size[2]
			)
			WriteDataFile this.ActiveTask.File

			-- Запись инфо о задании в lib_data.json для последующего импорта в UE	
			ReadDataFile MD_LIB_DATA_FILE
			local dict = PY_BUILTINS.dict()
			if data["to_import"] == undefined then data["to_import"] = dict
			else dict = data["to_import"]
			dict[this.ActiveTask.Article] = substituteString (pathConfig.removePathLeaf this.ActiveTask.InWorkDir) "\\" "/"
			data["to_import"] = dict
			WriteDataFile MD_LIB_DATA_FILE

			-- MD_Callbacks.Add()
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
					-- Установить активное задание
					try
					(
						if ActiveTaskIndex == undefined then
						ActiveTask = Tasks[1]
						else ActiveTask = Tasks[ActiveTaskIndex]
					)catch()

					-- Установить рабочее состояние
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
		-- Удаляет задания из локальной базы
		-- Если задание емеет ранее сохранённые рабочие файлы или выполненные файлы, 
		-- то папка с заданием помещается в собственную мусорную корзину лок. базы.

		local task_dir = pathConfig.appendPath sub_categ_lib_dirs[ActiveCategory][ActiveSubCategory] task.Article
		local done_files = getFiles (task_dir + "/*.*")
		local result = false
	
		if (doesFileExist task.File) == true then
		(
			if trash then
			(
				if done_files.count != 0 or task.SavedWorks.count != 0 then
				(
					-- Проверка существует ли папка корзины
					if not (doesDirectoryExist MD_LIB_TRASH_DIR) then
					(
						-- Создать папку корзины
						make_dir_cmd = "mkdir -p " + MD_LIB_TRASH_DIR
						HiddenDOSCommand make_dir_cmd donotwait:true
		
						-- Сделать папку скрытой
						add_hide_attrib_cmd = "attrib +h " + MD_LIB_TRASH_DIR
						HiddenDOSCommand add_hide_attrib_cmd donotwait:true 
					)

					local trash_dirs = getDirectories (MD_LIB_TRASH_DIR + "/*.*")
					local task_in_trash_dir = (pathConfig.appendPath MD_LIB_TRASH_DIR task.Article)
					local exists = #()

					-- Сущетвует ли в корзине папка с таким же заданием?
					for dir in trash_dirs do
					(
						f = findString dir task.Article
						if f != undefined then 
						append exists dir
					)
					-- Если существует, то удаляемая папка с занием будет переименована
					if exists.count != 0 then
					(
						copy_name = task.Article + "_" + ((formattedPrint (exists.count + 1) format:"01d") as string)
						task_in_trash_dir = (pathConfig.appendPath MD_LIB_TRASH_DIR copy_name)
					)
		
					-- Скопировать папку с заданием в корзину
					dosCommand ("xcopy " + task_dir + " " + task_in_trash_dir + " /S /E /I /Y /R /C")
				)					
			)
		)

		-- Если задание находится в работе
		if task.State == STATES[2] then this.ExitWorkState()

		-- Удалить папку с заданием
		dosCommand ("rmdir " + task_dir + " /S /Q")
		if not doesDirectoryExist task_dir then result = true

		result
	),

	fn FullUpdate =
	(
		-- Обновить данные
		try MD_UI.Sort = false catch()
		try this.ActiveList = 1 catch()
		try this.ActiveTask = this.Tasks[this.ActiveTaskIndex] catch()

		-- Обновить интерфейс
		try MD_UI.FillMainList() catch()
		try MD_UI.FillAddList() catch()
		try MD_UI.UpdateCatalogTasksRlt() catch()
		try MD_UI.UpdateCatalogInfoRlt() catch()
		try MD_UI.UpdateCatalogGeneralRlt() catch()
		try MD_UI.UpdateCatalogToolsRlt() catch()

		-- Обновить габаритный контейнер
		try MD_BBox.Update() catch()

		-- Создать рабочий слой, если есть задание в работе
		try if this.InWorkTask.file != undefined and this.WorkLayer == undefined then this.CreateWorkLayer() catch()

		-- Обновить рабочий слой, если он есть
		try this.SwitchWorkLayer catch()

		-- Попытаться выбрать первый элемент в списке
		if this.ActiveTaskIndex == undefined then try MD_UI.CatalogListMain.Items.Item[0].selected = true catch()

		-- Артикль текущей категории
		try this.active_catalog_article = (this.main_categ_ids[this.ActiveCategory][this.ActiveSubCategory]) catch()

		-- -- Попытаться установить иконку
		-- if this.ActiveCategoryIcon.Icon == undefined then
		-- (
		-- 	try (
		-- 		icon_file = pathConfig.appendPath SOURCE_ICONS_DIR (this.active_catalog_article + (ICON_POSTFIX + ".max"))
		-- 		this.ActiveCategoryIcon.SetIcon icon_file
		-- 	)catch()
		-- )
	),

	fn Init = (
		-- Инициализирует исходные глобальные данные

		MD_LIB_DIR = ""
		MD_CURRENT_PROJECT = ""
		MD_LIB_DATA_FILE = ""
		MD_LIB_TRASH_DIR = ""
		Tasks = #()
		sub_categs = #()
		main_categ_id = #()
		sub_categ_lib_dirs = #()
		main_categs = #()

		try (
			MD_LIB_DIR = GetUserEnvVar "MD_LIB_DIR"
			MD_CURRENT_PROJECT = GetUserEnvVar "MD_CURRENT_PROJECT"
			MD_LIB_DATA_FILE = pathConfig.appendPath MD_LIB_DIR COMMON_DATA_FILE_NAME
			MD_LIB_TRASH_DIR = pathConfig.appendPath MD_LIB_DIR "trash"
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
				local local_catalog_dir = pathConfig.AppendPath MD_LIB_DIR MD_CATEGS[2][1]

				for i in data as array do 
				(
					-- Парсинг артикула
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
			else MD_Log.Error "Отсутствуют данные о пользователях."
		)
	)

	-- on create do Init()
)