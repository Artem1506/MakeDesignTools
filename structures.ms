
fn FullUpdate =
(
	-- Обновить данные
	MD_UI.Sort = false
	MD_Data.ActiveList = 1
	try MD_Data.ActiveTask = MD_Data.Tasks[MD_Data.ActiveTaskIndex] catch()

	-- Обновить интерфейс
	MD_UI.FillMainList()
	MD_UI.FillAddList()
	MD_UI.UpdateCatalogTasksRlt()
	MD_UI.UpdateCatalogInfoRlt()
	MD_UI.UpdateCatalogToolsRlt()

	-- Обновить габаритный контейнер
	WithoutRedraw MD_BBox.Update

	-- Создать рабочий слой, если есть задание в работе
	if MD_Data.InWorkTask.file != undefined and MD_Data.WorkLayer == undefined then MD_Data.CreateWorkLayer()

	-- Обновить рабочий слой, если он есть
	WithoutRedraw MD_Data.SwitchWorkLayer

	-- Попытаться выбрать первый элемент в списке
	if MD_Data.ActiveTaskIndex == undefined then try MD_UI.ListMain.Items.Item[0].selected = true catch()
)

struct LogSys
(
	source = "",

	fn Info msg_text = (format "%_INFO: % | %\n" source (GetTimeStamp()) msg_text),
	fn Warning msg_text = (format "%_WARNING: % | %\n" source (GetTimeStamp()) msg_text),
	fn Error msg_text = (format "%_ERROR: % | %\n" source (GetTimeStamp()) msg_text)
)

MD_Log = LogSys source:"MD"
Client_Log = LogSys source:"HTTP_CLIENT"

struct UI_Tooltips
(
    -- Settings
	settings_01_a = "ON - Показать габариты объекта. (Только если задание находится в состоянии \"In_Work\")",
	settings_01_b = "Цвет габаритного контейнера основного меша.",
	settings_01_c = "Цвет габаритного контейнера доп. меша.",
	settings_01_d = "Сбросить цвета до дефолтных значений.",
	settings_02 = "ON - При экспорте объекта его пивот автоматически выравняется с пивотом габаритного контейнера.\nOFF - Будет использовано текущее положение пивота.",
	settings_03 = "Каждый раз при сохранении промежуточного этапа работы создаётся превью.\nON - Автоматически будет подобран ракурс так, чтобы охватить все объекты на сцене.\nOFF - Будет использован текущий ракурс.",
	settings_04 = "Максимальное количество сохранений промежуточных этапов работы.\nПри достижении этого числа, ранее сохранённые файлы будут удаляться по мере добавления новых.",
	settings_05 = "При наличии ранее сохранённых рабочих файлов в текущем задании, после запуска утилиты будет автоматически загружено последнее сохранение.",
	settings_06 = "Включить подсказки. (Требуется перезагрузка)",
	-- Tasks
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
	-- ToolsCatalog
	tools_cat_01 = "Добавить выделенные объекты в рабочий слой.",
	tools_cat_02 = "Установить опорную точку габаритного контейнера. Если в свитке \"Settings\" параметр \"Auto Pivot\" = ON, то при экспорте опорная точка объекта будет автоматически установлена в положение опорной точки габаритного контейнера.",
	tools_cat_03 = "Назначить Material ID на выделенные полигоны, соответствующий порядковому номеру, выбранного в данный момент, элемента в списке материалов",
	tools_cat_04 = "Назначить текстуры на выбранный материал.",
	tools_cat_05 = "Сохранить текущее состояние работы. Будут сохранены только те объекты, которые находятся на рабочем слое.",
	tools_cat_06_a = "Загрузить последнее сохранение.",
	tools_cat_06_b = "Открыть диалоговое окно со списком ранее сделанных сохранений.",
	tools_cat_07_a = "Указать выделенный в данный момент объект в качеств основного.\nОбъект будет переименован в соответствии с артикулом задания.",
	tools_cat_07_b = "Указать выделенный в данный момент объект в качестве дополнительного. Необходимо только если активное задание имеет значение в поле \"Trans\".\nОбъект будет переименован в соответствии с артикулом задания.",
	tools_cat_08 = "Переключиться между основным и дополнительным объектами.",
	tools_cat_09 = "Интерактивная проверка готовности задания.",
	tools_cat_10 = "Проверка задания и экспорт в локальную базу.",
	-- Сheck params
	chk_01 = "Запросить список новых корректно составленных заданий.\nТакие задания имеют все необходимые данные и их можно брать в работу.",
	chk_02 = "Запросить список новых НЕкорректно составленных заданий.\nТакие задания нельзя брать в работу и загружать в локальную базу, но можно разослать составителям сообщения об ошибках.",
	chk_03 = "Запросить список ранее сделанных заданий.\nИх можно загрузить в локальную базу в случае если данные были потеряны или если эти задания выполнял другой пользватель.\nПри необходимости можно возобновить работу над заданиями после того как администратор изменит их состояние на \"None\".",
	chk_04 = "Запросить список ранее удалённых заданий, хранящихся в корзине локальной базы.",
	-- Validation and export
	val_exp_01 = "На рабочем слое должен быть только один объект (Main Mesh), за исключением тех случаев, когда задание имеет значение в поле Trans. В таких случаях на слое должен так же располагаться дополнительный объект (Additional Mesh), представляющий основной объект в трансформированном виде.",
	val_exp_02 = "Тип геометрии должен быть Editable Poly или Editable Mesh.",
	val_exp_03 = "Габаритные размеры объекта(ов) должны соответствовать указанным в задании. Так же он должен располагаться так, чтобы не выходить за границы вспомогательного габаритного контейнера.",
	val_exp_04 = "На объект(ы) должен быть назначен корректный материал. Материал создаётся автоматически при создании рабочего состояния и назначается на объект(ы) при указании его в качестве основного или вспомагательного меша.",
	val_exp_05 = "Количество Material ID должно соответствовать количеству элементов в списке матералов.",
	val_exp_06 = "Объект(ы) должны иметь минимум два канала UV развёртки."
)

MD_Tooltips = UI_Tooltips()

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

	fn CreateMaterial =
	(
        local mat = Multimaterial name:Article
        local MatLib = materialLibrary()
		local clr_vals = #(45, 115, 185, 255)
		local exist_colors = #()
		local m_name = ""

		mat.materialList.count = Materials.count

		for i = 1 to Materials.count do
		(
			local val = true

			while val do
			(
				local rnd_clr = color \
				(random clr_vals[1] clr_vals[clr_vals.count]) \
				(random clr_vals[1] clr_vals[clr_vals.count]) \
				(random clr_vals[1] clr_vals[clr_vals.count])

				local f = findItem exist_colors rnd_clr

				if f == 0 then 
				(
					m_name = TASK_MAT_NAME + "_" + (formattedPrint i format:#02d)

					mat.materialList[i] = Standardmaterial()
					mat.materialList[i].Diffuse = rnd_clr
					mat.materialList[i].Name = m_name
					mat.names[i] = Materials[i].PartName

					append exist_colors rnd_clr
					val = false
				)
			)
		)
		Material = mat
        append MatLib mat
		if not DoesDirectoryExist InWorkDir do MakeDir InWorkDir
        saveTempMaterialLibrary MatLib MatLibFile
        -- saveMaterialLibrary MatLibFile
	),

	fn LoadMaterial =
	(
		try
		(
			-- Material = (loadMaterialLibrary MatLibFile)[1]
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
	
		-- mergeMAXFile saved_file #deleteOldDups #useMergedMtlDups #neverReparent
		mergeMAXFile saved_file #mergeDups #useSceneMtlDups #neverReparent

		merged_objs = getLastMergedNodes()

		if merged_objs.count != 0 then
		(
			for obj in merged_objs do
			(
				if obj.name == MD_Data.InWorkTask.Article then
				(
					MD_Data.InWorkTask.Mesh = obj
					MD_Data.AssignMaterial obj
				)
				if obj.name == (MD_Data.InWorkTask.Article + "_" + TRANS_POSTFIX) then
				(
					MD_Data.InWorkTask.AddMesh = obj
					MD_Data.AssignMaterial obj
				)
			)
			try (select MD_Data.ActiveTask.Mesh) catch()
			load_result = true		
		)
		else try (select cur_sel_objs) catch()
		
		completeRedraw()

		MD_Callbacks.Add()

		return load_result
	),

	fn SaveWork =
	(
		MD_Data.WorkLayerNodes = GetAllLayerNodes MD_Data.ActiveTask.Article
		local save = true
		local file_path
		local prev_file

		if MD_Data.WorkLayerNodes.count != 0 then
		(
			if ((objects.count - MD_Data.TempLayerNodes.count) > MD_Data.WorkLayerNodes.count) then
			(
				msg = "Будут сохранены только объекты находящиеся на рабочем слое!"
				messageBox msg title:"Warning!" icon:#warning
			)
			-- else
			-- (
				local index
		
				if MD_Data.ActiveTask.SavedWorks.count == 0 then
					index = formattedPrint 1 format:#02d
				else
				(
					if MD_Data.ActiveTask.SavedWorks.count >= MD_UI.Settings.spn_save_count.value then
					(
						local last_file = MD_Data.ActiveTask.SavedWorks[MD_Data.ActiveTask.SavedWorks.count]
						local last_file_index = (filterString (getFilenameFile last_file) "_")[2] as integer
						local first_max_file = MD_Data.ActiveTask.SavedWorks[1]
						local first_prev_file = (trimRight MD_Data.ActiveTask.SavedWorks[1] ".max") + ".jpg"
		
						index = formattedPrint (last_file_index + 1) format:#02d
		
						deleteFile first_max_file
						deleteFile first_prev_file
					)
					else
					(
						local max_index = 0
		
						for f in MD_Data.ActiveTask.SavedWorks do
						(
							local f_index = (filterString (getFilenameFile f) "_")[2] as integer
							if f_index > max_index then max_index = f_index
						)
		
						index = formattedPrint (max_index + 1) format:#02d
					)

				)

				local file_name = (SAVED_FILE_NAME + "_" + index)

				-- Сохранить рабочий файл .max
				file_path = (pathconfig.appendpath MD_Data.ActiveTask.InWorkDir (file_name + ".max"))
				save_nodes MD_Data.WorkLayerNodes file_path

				-- Сохранить скриншот сцены .jpg
				prev_file = (pathconfig.appendpath MD_Data.ActiveTask.InWorkDir (file_name + ".jpg"))

				ViewportSnapshot prev_file SAVED_PREVIEW_SIZE auto_frame:MD_UI.Settings.ckbx_auto_prev.checked

				MD_Data.ActiveTask.SavedWorks = GetFiles (MD_Data.ActiveTask.InWorkDir + "/*.max")
				sort MD_Data.ActiveTask.SavedWorks

				DisplayTempPrompt "Работа была сохранена." 5000
				MD_Log.Info ("Работа была сохранена  [" + file_name + "]")
			-- )
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

			-- Проверка наличия текстур
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

		-- Инициализация данных задания
        if (File != undefined and DoesFileExist File) then
        (
			-- Читать данные из json файла
            ReadDataFile File
            if data != undefined then
            (
				local task_file_dir = getFilenamePath File
				TaskDir = pathConfig.removePathLeaf task_file_dir
				InWorkDir = pathConfig.appendPath (pathConfig.removePathLeaf task_file_dir) "InWork"
				MatLibFile = (pathConfig.appendPath InWorkDir (TASK_MAT_NAME + ".mat"))
				local ref_file_name = data["ref_photo_name"]
				local ref_file_type = getFilenameType ref_file_name
				local task_dir_files = GetFiles (task_file_dir + "/*.*")
				local mat_ref_files = #()
				
				-- Найти и отсортировать файлы референсов
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

					mat.Article = data["finishing_materials"][i]["article"]
					mat.PartName = data["finishing_materials"][i]["name_part_object"]
					mat.Material = data["finishing_materials"][i]["finishing_components"]
					mat.RefFile = mat_ref_files[i]
					mat.RefBitmap = CreatePreviewFromImageFile mat_ref_files[i] PREVIEW_SIZE
					try (mat.WebSite = data["finishing_materials"][i]["web_site"]) catch()

					-- Проверка наличия текстур
					for t = 1 to mat.textures.count do
					(
						local tex_file = (pathConfig.appendPath TaskDir ("T_" + mat.Article + TEXTURES_SIFFIXES[t]))
						if doesFileExist tex_file then (mat.textures[t] = tex_file)
					)

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
				
				if pathConfig.doesFileExist InWorkDir then
				(
					SavedWorks = GetFiles (InWorkDir + "/*.max")
					sort SavedWorks
				)
				RefBitmap = CreatePreviewFromImageFile RefFile PREVIEW_SIZE

				-- Создать материал
				if not DoesFileExist MatLibFile then CreateMaterial()
				else LoadMaterial()
            )
        )
	),

	on create do Init()
)

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
	ActiveCategory = undefined, --> [int] Активная подкатегория
	ActiveSubCategory = undefined, --> [int] Активная подкатегория
	ActiveTask = undefined, --> [Task] Выбранное на текущий момент задание в списке MD_UI.ListMain
	ActiveTaskIndex = undefined, --> [int] Порядковый номер активного задания в списке MD_UI.ListMain
	ActiveTaskAddIndex = undefined, --> [int] Порядковый номер в списке MD_UI.ListAdd
	active_catalog_dir = undefined, --> [str] "01-01-001"
	active_catalog_article = undefined, --> [str] "01-01-001"
	ActiveList = 1, --> [int] Активный список
	InWorkTask = undefined, --> [task] Задание, находящееся в данный момент в рабочем состоянии
	InWorkTaskFile = undefined, --> [str] Задание, находящееся в данный момент в рабочем состоянии
	CheckedTasks = #(), -- Отмеченные задания в списке MD_UI.ListMain
	WorkLayerNodes = #(),
	TempLayerNodes = #(),
	-- Projects
	proj_main_categs = #(),
	proj_main_categ_ids = #(),
	proj_sub_categs = #(),
	proj_sub_categ_ids = #(),
	VisibleLayers = false,

	Users = #(),

	fn AssignMatID obj =
	(
		try(
			if subobjectLevel == 4 then
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
			obj.Material = MD_Data.InWorkTask.Material
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
		local valids = #("X", "X", "X", "X", "X", "X")
		local objs = #(ActiveTask.Mesh, ActiveTask.AddMesh)

		-- Check count
		if ActiveTask.SizeTrans == undefined then
		(
			if WorkLayerNodes.count == 1 and ActiveTask.Mesh != undefined and ActiveTask.AddMesh == undefined then
			(
				valids[1] = "OK"
				obj = WorkLayerNodes[1]
			)
		)else if WorkLayerNodes.count == 2 and ActiveTask.Mesh != undefined and ActiveTask.AddMesh != undefined then
		(
			valids[1] = "OK"
			obj = objs[MD_Data.ActiveTask.ActiveMesh]
		)
		else (msg = "The task layer contains more than one object.")
		
		if obj != undefined and not (isdeleted obj) then
		(
			if superClassOf obj == GeometryClass then
			(
				valids[2] = "OK"
				
				-- Check dimensions and position
				threshold = ConvertValueToSystemUnits #cm 0.25
				
				if ((distance MD_BBox.bb.min obj.min) < threshold) and ((distance MD_BBox.bb.max obj.max) < threshold) then 
				(
					valids[3] = "OK"
					
				)else (msg = "Either the dimensions of the object or its position is not correct.")
	
				-- Check material
				if obj.material != undefined then
				(
					-- Check submaterials count
					sub_mats_count = 0
					try(sub_mats_count = obj.material.count)catch()
					if obj.material.name == ActiveTask.Article and sub_mats_count == ActiveTask.Materials.count then
					(
						valids[4] = "OK"
	
						-- Check material id count
						mat_ids = GetMaterialIDList obj
						if mat_ids.count >= ActiveTask.Materials.count then
						(
							valids[5] = "OK"
						)else (msg = "The number of material IDs for the object does not match.")
					)else (msg = "The wrong material is assigned.")
				)else (msg = "The object has no material.")
	
				-- Check uv channels count
				uv_count = GetNumUVChannels obj
				if uv_count == 2 then
				(
					valids[6] = "OK"                                    
				)else(msg = "The number of UV channels is not equal to 2.")
			)else (msg = "The object must be of the Geometry type.")
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
				if obj.name == (ActiveTask.Article + "_" + TRANS_POSTFIX) then
				(
					MD_Data.SetAddMesh obj
					WorkLayer.addNode obj
					obj.Ishidden = true
				)
			)
		)catch()
	),

	fn SwitchWorkLayer =
	(
		try (
			if ActiveTask != undefined and ActiveTask.Article == InWorkTask.Article then 
			(
				-- WorkLayer.on = true
				-- WorkLayer.current = true
				this.ShowLayers mode:#work_only
			)
			else 
			(
				this.ShowLayers mode:#scene_only
				-- WorkLayer.on = False
				-- DEFAULT_LAYER.current = true
			)
			
			CompleteRedraw()
		)catch()
	),

    fn ShowLayers mode:#work_only =
    (
		-- #all
		-- #scene_only
		-- #work_only
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
							if lr == MD_BBox.Layer then lr.on = MD_UI.Settings.ckbx_show_bb.checked
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
			)			
		)catch()

		completeRedraw()
    ),

	fn CreateWorkLayer =
	(
		try (
			LayerManager.newLayerFromName InWorkTask.Article
			WorkLayer = LayerManager.getLayerFromName InWorkTask.Article
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

			WorkLayerNodes = GetAllLayerNodes ActiveTask.Article
			select cur_selection
		)catch()
	),

	fn DeleteWorkLayer =
	(
		try (
			local nodes = GetAllLayerNodes InWorkTask.Article

			-- for n in nodes do 
			-- (
			-- 	DEFAULT_LAYER.addNode n
			-- 	n.IsHidden = False
			-- )
			Delete nodes
			gc()
			DeleteAllSubLayers InWorkTask.Article
			LayerManager.deleteLayerByName InWorkTask.Article
			InWorkTask = undefined
			WorkLayer = undefined
			CompleteRedraw()
		)
		catch()
	),

	fn ExitWorkState =
	(
        ActiveTask.State = STATES[1]
        ActiveTask.ActiveMesh = 1
        DeleteWorkLayer()
        InWorkTask = undefined

		try (
			ReadDataFile MD_LIB_COMMON_DATA_FILE
			data["in_work_task"] = undefined
			WriteDataFile MD_LIB_COMMON_DATA_FILE
		)
		catch (MD_Log.Error "[ExitWorkState] Не удалось сохранить данные в файл.")

		ActiveTask.Update()
		try FullUpdate() catch()
        try MD_Callbacks.Destruct() catch()
	),

	fn CreateWorkState =
	(
		try MD_Callbacks.Destruct() catch()
		try InWorkTask.State = STATES[1] catch()
		try (
			ReadDataFile InWorkTaskFile
			data["state"] = STATES[1]
			WriteDataFile InWorkTaskFile
		)
		catch ()
		if ActiveTask != InWorkTask then DeleteWorkLayer()
        
		-- for task in MD_Data.Tasks do
		-- (
		-- 	if task.Group != undefined and task.Group == ActiveTask.Group then task.State = STATES[2]
		-- 	else if task.Group == undefined and task == ActiveTask then STATES[2]
		-- 	-- else task.State = STATES[1]			
		-- ) 

        ActiveTask.State = STATES[2]
        ActiveTask.ActiveMesh = 1
        InWorkTask = ActiveTask
		InWorkTaskFile = ActiveTask.File
		CreateWorkLayer()
		AttachSelectedToWorkLayer()
		try AttachObjectsToWorkState() catch()

		try (
			ReadDataFile MD_LIB_COMMON_DATA_FILE
			data["in_work_task"] = InWorkTask.File
			WriteDataFile MD_LIB_COMMON_DATA_FILE
		)
		catch ()
        
		-- Обновить
		SwitchWorkLayer()
		ActiveTask.Update()
        try FullUpdate() catch()
        try MD_Callbacks.Add() catch()

		-- Создать рабочую папку
		MakeDir MD_Data.ActiveTask.InWorkDir

		-- Создать материал
		if DoesFileExist (pathConfig.appendPath InWorkTask.InWorkDir (TASK_MAT_NAME + ".mat")) then
		(
			InWorkTask.LoadMaterial()
			
		)else InWorkTask.CreateMaterial()
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
		MD_Callbacks.Destruct()
        ActiveTask.State = STATES[2]
        ActiveTask.ActiveMesh = 1
        InWorkTask = ActiveTask
		InWorkTaskFile = ActiveTask.File
		CreateWorkLayer()
		try (
			ReadDataFile MD_LIB_COMMON_DATA_FILE
			data["in_work_task"] = InWorkTask.File
			WriteDataFile MD_LIB_COMMON_DATA_FILE
		)
		catch ()
		SwitchWorkLayer()
		MD_UI.UpdateCatalogToolsRlt()
		MakeDir MD_Data.ActiveTask.InWorkDir
		MD_Callbacks.Add()

		try ClearTrashLayers() catch()
	),

	fn GetTasksInActiveCategory =
	(
		Tasks = #()

		local activ_dir = sub_categ_lib_dirs[ActiveCategory][ActiveSubCategory]
		local tasks_dirs = GetDirectories (activ_dir + "\\*")

		for dir in tasks_dirs do
		(
			local task_file = pathConfig.AppendPath dir TASK_INNER_DIRS[1]
			task_file = pathConfig.AppendPath task_file TASK_FILE_NAME

			append Tasks (Task File:task_file)
		)
	),

	fn SetMesh obj =
	(
		if (SuperClassOf obj == GeometryClass) then
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
				WorkLayerNodes = GetAllLayerNodes InWorkTask.Article
				for task_obj in WorkLayerNodes where task_obj.name == InWorkTask.Article do
				(
					task_obj.Material = undefined
					task_obj.Name = uniqueName "Object"
				)
				obj.IsHidden = false
				this.InWorkTask.Mesh = obj
				this.InWorkTask.Mesh.Name = this.InWorkTask.Article
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
		if (SuperClassOf obj == GeometryClass) then
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
				WorkLayerNodes = GetAllLayerNodes InWorkTask.Article
				for task_obj in WorkLayerNodes where task_obj.name == (InWorkTask.Article + "_" + TRANS_POSTFIX) do
				(
					task_obj.Material = undefined
					task_obj.Name = uniqueName "Object"
				)
				this.InWorkTask.AddMesh = obj
				this.InWorkTask.AddMesh.Name = this.InWorkTask.Article + "_" + TRANS_POSTFIX
				obj.IsHidden = True
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

		if valid_result[1] then
		(
			MD_Callbacks.Destruct()

			if ActiveTask.SizeTrans == undefined then objs = #(ActiveTask.Mesh)
			else objs = #(ActiveTask.Mesh, ActiveTask.AddMesh)

			local main_dir = pathConfig.removePathLeaf (getFilenamePath ActiveTask.File)
			local save_fbx_path = pathConfig.appendPath main_dir (ActiveTask.Article + ".fbx")
			local save_max_path = pathConfig.appendPath main_dir (ActiveTask.Article + ".max")

			for obj in objs do 
			(
				if MD_UI.Settings.ckbx_auto_pivot.checked then 
				(
					obj.pivot.x = MD_BBox.pivot_pos[1]
					obj.pivot.y = MD_BBox.pivot_pos[2]
					obj.pivot.z = MD_BBox.pivot_pos[3]
				)				
			)

			with redraw off 
			(
				try(
					SaveSelectedObjects objs save_max_path
				)catch(MD_Log.Error "Не удалось сохранить текущее состояние сцены!")

				try(
					ExportToFBX objs save_fbx_path
				)catch(MD_Log.Error "Не удалось экспортировать задание!")
			)

			for obj in objs do 
			(
				obj.pos = MD_BBox.pp.pos
			)

			MD_Callbacks.Add()
			CompleteRedraw()
		)
	),

	fn ClearWorkLayer =
	(
		WorkLayerNodes = GetAllLayerNodes WorkLayer.Name

		if WorkLayerNodes.count != 0 then
		(
			if (queryBox "Все объекты, находящиеся на рабочем слое, будут удалены.\nСохранить работу перед удалением?" title:"Внимание!" icon:#question) then
			InWorkTask.SaveWork()
		)

		delete WorkLayerNodes
		gc()
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

	fn Init = (
		-- Инициализирует исходные глобальные данные

		MD_LIB_DIR = ""
		MD_LIB_COMMON_DATA_FILE = ""
		MD_LIB_TRASH_DIR = ""
		Tasks = #()
		sub_categs = #()
		main_categ_id = #()
		sub_categ_lib_dirs = #()

		try (
			MD_LIB_DIR = GetUserEnvVar "MD_LIB_DIR"
			MD_LIB_COMMON_DATA_FILE = pathConfig.appendPath MD_LIB_DIR COMMON_DATA_FILE_NAME
			MD_LIB_TRASH_DIR = pathConfig.appendPath MD_LIB_DIR "trash"
		)
		catch (MD_Log.Error "Не указан путь к локальной базе MakeDesign.")

		if DoesFileExist MD_LIB_COMMON_DATA_FILE then
		(
			ReadDataFile MD_LIB_COMMON_DATA_FILE
			InWorkTaskFile = data["in_work_task"]
			InWorkTask = Task file:InWorkTaskFile
		)
		else 
		(
			data = PY_BUILTINS.dict()
			data["in_work_task"] = undefined
			WriteDataFile MD_LIB_COMMON_DATA_FILE
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

				for i in data as array do 
				(
					
					for k in i["children"] as array do 
					(
						append main_categs (k["article"] + " - " + (subString i["name"] 1 12) + " - " + k["name"])
						-- append main_categ_ids k["article"]

						arr_names = #()
						arr_ids = #()
						arr_tasks = #()
						arr_idss = #()

						for j in k["children"] as array do 
						(
							append arr_names ((filterString j["article"] "-")[3] + " - " + j["name"])
							sub_categ_dir = pathConfig.AppendPath MD_LIB_DIR MD_CATEGS[2][1]
							sub_categ_dir = pathConfig.AppendPath sub_categ_dir j["article"]
							append arr_ids sub_categ_dir
							append arr_tasks undefined
							append arr_idss j["article"]
						)
						append sub_categs arr_names
						append main_categ_ids arr_idss
						append sub_categ_lib_dirs arr_ids
					)
				)
				arr_names = #()
				arr_ids = #()
				arr_tasks = #()
				arr_idss = #()
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
	),

	on create do Init()
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

			-- Удалить ненужные элементы в обраном порядке
			for i = indexes.count to 1 by -1 do
			(
				deleteItem MD_Data.ActiveTask.SavedWorks indexes[i]
				deleteItem MD_Data.ActiveTask.SavedWorksPreviews indexes[i]
			)
		)
	),

	fn InitLoadWork =
	(
		-- Список сохранённых работ
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

			-- Создать битмап с превью
			prev_file = (trimRight MD_Data.ActiveTask.SavedWorks[i] ".max") + ".jpg"
			try(
				prev_bm = CreatePreviewFromImageFile prev_file SAVED_PREVIEW_SIZE type:#dotnet
			)catch(
				prev_bm = CreatePreviewFromImageFile ICON_NO_PRVIEW_FILE SAVED_PREVIEW_SIZE type:#dotnet
			)
			append MD_Data.ActiveTask.SavedWorksPreviews prev_bm

			-- Дата сохранения
			date_time = filterString (getFileCreateDate MD_Data.ActiveTask.SavedWorks[i]) " "
			time_part = filterString date_time[2] ":"
			date_time = date_time[1] + "  " + time_part[1] + ":" + time_part[2]
			li.SubItems.add date_time

			append items li
		)

		-- Заполнить список
		LoadWork.lv_files.Items.Clear()
		LoadWork.lv_files.Items.AddRange items
		LoadWork.lv_files.Update()
		try LoadWork.lv_files.Items.Item[0].selected = true catch()

		-- Превью выбранной работы
		LoadWork.img_prew.backColor = DN_CLR_BG
		LoadWork.img_prew.Margin = LoadWork.img_prew.Padding = DN_Lib.Pad 0 0 0 0
		LoadWork.img_prew.SizeMode = LoadWork.img_prew.SizeMode.CenterImage
		try LoadWork.img_prew.Image = MD_Data.ActiveTask.SavedWorksPreviews[1] catch()

		LoadWork.lv_files.focus()
	)
)

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
	EMPTY_PREVIEW = undefined,
	size_txt = "",
	size_add_txt = "",
	Sort = False,

	fn InitLists = 
	(
		-- Инициализирует основной и доп. списки, исходя из выбранного раздела

		-- Устанавливает параметры для контрола листвью
		fn SetListViewParams list_view CheckBoxes:true= (
			list_view.BorderStyle = list_view.BorderStyle.None
			list_view.gridLines = true
			list_view.View = (dotNetClass "System.Windows.Forms.View").Details
			list_view.fullRowSelect = true
			list_view.MultiSelect = false
			list_view.HideSelection = false
			list_view.HoverSelection  = false
			list_view.CheckBoxes = CheckBoxes
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
		SetListViewParams ListAdd CheckBoxes:false

		case MD_Data.ActiveSection of
		(
			1:(
				AddListViewColumns ListMain MAIN_LIST_COLUMNS_1 widths:#(110, 60, 60, 60, 120)
				AddListViewColumns ListAdd ADD_LIST_COLUMNS_1 widths:#(70, 100, 55)
			)
			2:(
				AddListViewColumns ListMain MAIN_LIST_COLUMNS_2 widths:#(206)
				AddListViewColumns ListAdd ADD_LIST_COLUMNS_2 widths:#(206)
			)
		)
		setFocus ListMain
	),

	fn FillMainList =
	(
		-- print "FillMainList"
		case MD_Data.ActiveSection of
		(
			1:(
				-- Заполнить данными список заданий панели Tasks
				local task_list = #()
				local main_items = #()
				local item_index = 0
				local cur_sel = undefined

				-- Индекс выделенного элемента в стике
				if ListMain.SelectedItems.Count != 0 then cur_sel = ListMain.SelectedItems.Item[0].Index
				
				-- Проверка сортировки
				-- if this.Sort then task_list = MD_Data.SortTasks
				-- else task_list = MD_Data.Tasks

				for task in MD_Data.Tasks do
				(
					dn_list_item = dotNetObject "System.Windows.Forms.ListViewItem" task.Article
					dn_list_item.Checked = false
					dn_list_item.ForeColor = DN_CLR_DEFAULT
					
					-- State
					if MD_Data.ActiveTask != undefined and task.State == STATES[2] then 
					(
						dn_list_item.SubItems.add task.State
						if task.Article == MD_Data.ActiveTask.Article then
						(
							MD_Data.InWorkTask = task
							MD_Data.CreateWorkLayer()							
						)
					)
					else dn_list_item.SubItems.add ""

					-- Group
					if task.Group != undefined then dn_list_item.SubItems.add task.Group
					else dn_list_item.SubItems.add ""

					-- Transformation
					if task.SizeTrans != undefined then dn_list_item.SubItems.add "•" -- alt+0149
					-- if task.SizeTrans != undefined then dn_list_item.SubItems.add "YES"
					else dn_list_item.SubItems.add ""

					-- User name
					dn_list_item.SubItems.add task.UserName

					-- Отметить элемент как выделенный
					if cur_sel == item_index then dn_list_item.Selected = true

					-- Добавить к основному списку элементов
					append main_items dn_list_item

					item_index += 1
					try dn_list_item.tag = item_index catch()
				)

				-- Заполнить основной список панели Tasks (задания)
				ListMain.Items.Clear()
				ListMain.Items.AddRange main_items
				ListMain.Update()

				main_items = #()
				free main_items
				task_list = #()
				free task_list
			)
			2:(
				Categories.Items = MD_Data.proj_main_categs
				SubCategories.Items = MD_Data.proj_sub_categs
				try SubCategories.Items = MD_Data.proj_sub_categs[Categories.Selection] catch()
				ListMain.Items.Clear()
				ListMain.Update()
			)
		)
	),

	fn FillCategoriesLists =
	(
		case MD_Data.ActiveSection of
		(
			1:(
				-- Заполнить данными панель Info
				Categories.Items = MD_Data.main_categs
				try SubCategories.Items = MD_Data.sub_categs[Categories.Selection] 
				catch(SubCategories.Items = #())
			)
			2:(

			)
		)
	),
	
	fn UpdateCatalogToolsRlt =
	(
		try
		(
			ToolsCatalog.btn_main_mesh.text = "Main Mesh"
			ToolsCatalog.btn_add_mesh.text = "Additional Mesh"
			ToolsCatalog.btn_vis_switch.text = "Show Scene Objects"

			for ctrl in ToolsCatalog.Controls do ctrl.enabled = false
			for ctrl in ToolsProjects.Controls do ctrl.enabled = false

			local objs = #()

			if MD_Data.ActiveTask != undefined and MD_Data.WorkLayer != undefined and MD_Data.ActiveTask.State == STATES[2] then
			(
				ToolsCatalog.btn_vis_switch.enabled = true
				
				MD_Data.WorkLayerNodes = GetAllLayerNodes MD_Data.ActiveTask.Article

				objs = for obj in (objects as array) where (findItem MD_Data.TempLayerNodes obj == 0) collect obj

				-- Пивот
				ToolsCatalog.btn_set_pivot.enabled = true

				-- Основной меш
				if MD_Data.ActiveTask.Mesh != undefined and not MD_Data.ActiveTask.Mesh.IsDeleted then
				(
					ToolsCatalog.btn_main_mesh.text = "  Main Mesh •"
					if MD_Data.ActiveTask.ActiveMesh == 1 and selection.count == 1 and selection[1] == MD_Data.InWorkTask.Mesh then ToolsCatalog.btn_assign_mat_id.enabled = true
					try ToolsCatalog.btn_main_mesh.tooltip = ("Текущий объект: " + MD_Data.ActiveTask.Mesh.Name) catch()
				)
				else
				(
					ToolsCatalog.btn_main_mesh.text = "Main Mesh"
					ToolsCatalog.btn_main_mesh.tooltip = MD_Tooltips.tools_cat_07_a
				)

				-- Если задание имеет поле трансформации
				if MD_Data.ActiveTask.SizeTrans != undefined then 
				(

					ToolsCatalog.btn_mesh_switch.enabled = true

					if MD_Data.ActiveTask.ActiveMesh == 2 then
					ToolsCatalog.btn_mesh_switch.text = "<< Switch To Main Mesh"	
					else ToolsCatalog.btn_mesh_switch.text = ">> Switch To Additional Mesh"

					if (selection.count == 1 and \
						SuperClassOf selection[1] == GeometryClass and \
						findItem MD_Data.WorkLayerNodes selection[1] != 0) then
					(
						if MD_Data.ActiveTask.ActiveMesh == 2 then
						(
							ToolsCatalog.btn_mesh_switch.text = "<< Switch To Main Mesh"
							ToolsCatalog.btn_add_mesh.enabled = true		
						)
						else
						(
							ToolsCatalog.btn_mesh_switch.text = ">> Switch To Additional Mesh"
							ToolsCatalog.btn_main_mesh.enabled = true
							if MD_Data.ActiveTask.AddMesh == undefined or MD_Data.ActiveTask.AddMesh.IsDeleted then
							ToolsCatalog.btn_add_mesh.enabled = true
						)
					)

					-- Доп. меш
					if MD_Data.ActiveTask.AddMesh != undefined and not MD_Data.ActiveTask.AddMesh.IsDeleted then
					(
						ToolsCatalog.btn_add_mesh.text = "  Additional Mesh •"
						if MD_Data.ActiveTask.ActiveMesh == 2 and selection.count == 1 and selection[1] == MD_Data.InWorkTask.AddMesh then ToolsCatalog.btn_assign_mat_id.enabled = true
						try ToolsCatalog.btn_add_mesh.tooltip = ("Текущий объект: " + MD_Data.ActiveTask.AddMesh.Name) catch()
					)
					else(
						ToolsCatalog.btn_add_mesh.text = "Additional Mesh"
						ToolsCatalog.btn_add_mesh.tooltip = MD_Tooltips.tools_cat_07_b
					)
				)
				-- Если задание НЕ имеет поле трансформации
				else
				(
					if (selection.count == 1 and \
						SuperClassOf selection[1] == GeometryClass and \
						findItem MD_Data.WorkLayerNodes selection[1] != 0) then
					(
						ToolsCatalog.btn_main_mesh.enabled = true
						if MD_Data.ActiveTask.ActiveMes == 1 and selection[1] == MD_Data.ActiveTask.Mesh then ToolsCatalog.btn_assign_mat_id.enabled = true
					)
				)
				
				-- Сохранить работу
				if (MD_Data.WorkLayer != undefined and MD_Data.WorkLayerNodes.count != 0) then
				(
					ToolsCatalog.btn_save_work.enabled = true
					ToolsCatalog.btn_export.enabled = true
				)

				-- Добавить к рабочему слою
				if objs.count != MD_Data.WorkLayerNodes.count and objs.count != 0 then 
				(
					local obj_outside = false

					for obj in selection where obj.layer != MD_Data.WorkLayer do (obj_outside = true; exit)
					if obj_outside then
					local obj_outside = false

					for obj in selection where obj.layer != MD_Data.WorkLayer do (obj_outside = true; exit)
					if obj_outside then
					ToolsCatalog.btn_attach_to_task.enabled = true
				)

				-- Загрузить работу
				if MD_Data.ActiveTask.SavedWorks.count != 0 then
				(
					ToolsCatalog.btn_load_work.enabled = true
					ToolsCatalog.btn_work_list.enabled = true
				)

				-- Material ID и текстуры
				if MD_Data.ActiveList == 1 then
				(
					if subobjectLevel == 0 or subobjectLevel == undefined then
					(
						ToolsCatalog.btn_assign_mat_id.text = "Assign Material"
					)
				)
				else if MD_Data.ActiveList == 2 then
				(
					ToolsCatalog.btn_assign_texts.enabled = true
					ToolsCatalog.btn_assign_mat_id.text = "Assign Mat ID"

					if subobjectLevel == 4 then ToolsCatalog.btn_assign_mat_id.enabled = true					
					else if subobjectLevel == 0 or subobjectLevel == undefined then ToolsCatalog.btn_assign_mat_id.enabled = false
				)
			)

			free MD_Data.WorkLayerNodes
			free objs
		)catch()
	),

	fn FillAddList =
	(
		-- print "FillAddList"
		case Sections.Selection of
		(
			1:(
				local add_items = #()
				local tex_count = 0
				-- Материалы
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

						-- Добавить к доп. списку элементов
						append add_items dn_list_item
					)					
				)
				catch()

				-- Заполнить доп. список панели Tasks (материалы)
				ListAdd.Items.Clear()
				ListAdd.Items.AddRange add_items
				ListAdd.Update()

				add_items = #()
				free add_items
			)
			2:(
				ListAdd.Items.Clear()
				ListAdd.Update()
			)
		)
	),

	fn UpdateCatalogInfoRlt =
	(
		-- print "UpdateCatalogInfoRlt"
		case MD_Data.ActiveList of
		(
			1:(
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
					)
					catch()

					try (
						size_txt = ""
						size_txt += ("W: " + (MD_Data.ActiveTask.Size[1] as float) as string + "    ")
						size_txt += ("D: " + (MD_Data.ActiveTask.Size[2] as float) as string + "    ")
						size_txt += ("H: " + (MD_Data.ActiveTask.Size[3] as float) as string)
						
					) catch()

					try (
						size_add_txt = ""
						size_add_txt += ("W: " + (MD_Data.ActiveTask.SizeTrans[1] as float) as string + "    ")
						size_add_txt += ("D: " + (MD_Data.ActiveTask.SizeTrans[2] as float) as string + "    ")
						size_add_txt += ("H: " + (MD_Data.ActiveTask.SizeTrans[3] as float) as string)
					) catch()

					InfoCatalog.lbl_size.visible = true
					InfoCatalog.lbl_size_txt.visible = true
					InfoCatalog.lbl_site.visible = true
					InfoCatalog.hpl_site.visible = true
					InfoCatalog.hpl_site.text = ""
					try (InfoCatalog.hpl_site.address = MD_Data.ActiveTask.WebSite) catch()

					case MD_Data.ActiveTask.ActiveMesh of
					(
						1:(
							InfoCatalog.lbl_size_txt.text = size_txt
						)
						2:(
							InfoCatalog.lbl_size_txt.text = size_add_txt
						)
					)

					try (InfoCatalog.hpl_site.text = MD_Data.ActiveTask.WebSite) catch()
					InfoCatalog.title = "Info"
					InfoCatalog.height = 280					
				)
			)
			2:(
				InfoCatalogPreview.bitmap = MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].RefBitmap
				InfoCatalog.lbl_size.visible = false
				InfoCatalog.lbl_size_txt.visible = false
				InfoCatalog.lbl_site.visible = false
				InfoCatalog.hpl_site.visible = false

				-- Если будет указан сайт материала

				if MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].WebSite != undefined then
				(
					InfoCatalog.lbl_site.visible = true
					InfoCatalog.hpl_site.visible = true
					InfoCatalog.hpl_site.text = MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].WebSite
					InfoCatalog.hpl_site.address = MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].WebSite	
				)

				InfoCatalog.title = "Info (Materials)"
				InfoCatalog.height = 280
			)
		)
	),

	fn UpdateCatalogTasksRlt =
	(
		Tasks.btn_get.enabled = false
		Tasks.btn_clear.enabled = false

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

				Tasks.btn_get.enabled = false
				Tasks.btn_clear.enabled = false
				Tasks.btn_get.text = "Get"
				Tasks.btn_clear.text = "Clear"
				Tasks.btn_get.tooltip = MD_Tooltips.tasks_02_a
				Tasks.btn_clear.tooltip = MD_Tooltips.tasks_03_a
				Tasks.btn_work_state.enabled = true
				if MD_Data.ActiveTask == MD_Data.InWorkTask then
				Tasks.btn_exit_work_state.enabled = true
				else Tasks.btn_exit_work_state.enabled = false
			)
			for ctrl in InfoCatalog.Controls do ctrl.enabled = true
			
			try (ListMain.Items.Item[MD_Data.ActiveTaskIndex - 1].Selected = True) catch()
		)

		if MD_Data.TempArticlesList.count != 0 then
		(
			Tasks.btn_work_state.enabled = false
			Tasks.btn_exit_work_state.enabled = false

			for ctrl in ToolsCatalog.Controls do ctrl.enabled = false
			for ctrl in ToolsProjects.Controls do ctrl.enabled = false

			case MD_Client.ActiveCheckParam of
			(
				1:(
					Tasks.btn_get.text = "Get"
					Tasks.btn_get.tooltip = MD_Tooltips.tasks_02_a
				)
				2:(
					Tasks.btn_get.text = "Send"
					Tasks.btn_get.tooltip = MD_Tooltips.tasks_02_b
				)
				3:(
					Tasks.btn_get.text = "Backup"
					Tasks.btn_get.tooltip = MD_Tooltips.tasks_02_c
				)
				4:
				(
					Tasks.btn_get.text = "Restore"
					Tasks.btn_get.tooltip = MD_Tooltips.tasks_02_d
				)
			)
			Tasks.btn_clear.text = "Clear"
			Tasks.btn_clear.tooltip = MD_Tooltips.tasks_03_a
		)
		else
		(
			Tasks.btn_get.text = "Update"
			Tasks.btn_get.tooltip = MD_Tooltips.tasks_02_e
			Tasks.btn_clear.text = "Delete"
			Tasks.btn_clear.tooltip = MD_Tooltips.tasks_03_b
		)

		if MD_Data.CheckedTasks.Count > 0 then
		(
			Tasks.btn_get.enabled = true
			Tasks.btn_clear.enabled = true
			Tasks.btn_work_state.enabled = false
			Tasks.btn_exit_work_state.enabled = false
		)

		if SubCategories.Items.Count != 0 then
		(
			Tasks.lst_basic_catalog.enabled = true
			Tasks.lst_sub_catalog.enabled = true
			Tasks.btn_check.enabled = true
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

		ListMain.Items.Clear()
		ListMain.Items.AddRange main_items
		ListMain.Update()

		ListAdd.Items.Clear()
		ListAdd.Update()
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

		DN_MAX_UI_CLR = (dotNetClass "system.Drawing.color").FromArgb 255 MAX_UI_BG_COLOR.r MAX_UI_BG_COLOR.g MAX_UI_BG_COLOR.b

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

		try (for sr in Main.sub_rlt.rollouts do GetINISettings sr MDT_CONFIG_FILE sr.name) 
		catch ()

		try (exist_categ_index = execute (GetINISetting MDT_CONFIG_FILE Tasks.Name "lst_basic_catalog_selection")) catch()
		try (exist_sub_categ_index = execute (GetINISetting MDT_CONFIG_FILE Tasks.Name "lst_sub_catalog_selection")) catch()
		
		try (
			if exist_categ_index > 0 then Categories.Selection = MD_Data.ActiveCategory = exist_categ_index
			else if exist_categ_index == 0 and MD_Data.main_categs.count != 0 then Categories.Selection = MD_Data.ActiveCategory = 1
			if exist_sub_categ_index > 0 then SubCategories.Selection = MD_Data.ActiveSubCategory = exist_sub_categ_index
			else if exist_categ_index == 0 and MD_Data.main_categs.count != 0 then SubCategories.Selection = MD_Data.ActiveSubCategory = 1
		)
		catch()

		try(
			EMPTY_PREVIEW = CreatePreviewFromImageFile ICON_NO_PRVIEW_FILE PREVIEW_SIZE
			InfoCatalogPreview.bitmap = EMPTY_PREVIEW
		)
		catch (MD_Log.Error "Не удалось загрузить изображение \"NO PREVIEW\".")

		try (MD_Data.ActiveSection = Sections.Selection) catch()

		-- Тултипы
		if Settings.ckbx_tooltips.Checked == false then
		(
			for ctrl in Settings.Controls do try(ctrl.tooltip = "")catch()
			for ctrl in Tasks.Controls do try(ctrl.tooltip = "")catch()
			for ctrl in InfoCatalog.Controls do try(ctrl.tooltip = "")catch()
			for ctrl in ToolsCatalog.Controls do try(ctrl.tooltip = "")catch()
			for ctrl in ToolsProjects.Controls do try(ctrl.tooltip = "")catch()
		)

		SwitchRollouts()
		MD_Data.Update()
		FillCategoriesLists()
		FillMainList()
		FillAddList()
		UpdateCatalogTasksRlt()
		UpdateCatalogInfoRlt()
		UpdateCatalogToolsRlt()
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
	clr_main = MD_UI.Settings.clr_bb_main.color,
	clr_add = MD_UI.Settings.clr_bb_add.color,
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
		arrow.render_renderable = false
		arrow.render_useViewportSettings = false
		arrow.render_displayRenderMesh = false

		pp.centermarker = on
		pp.Box = off
		pp.cross = off
		pp.axistripod = off
		pp.drawontop = on
		pp.showFrozenInGray = off
		pp.isFrozen = on
		pp.wireColor = CLR_BBOX_PIVOT
		pp.ishidden = on

		Layer.addnode bb
		Layer.addnode arrow
		Layer.addnode pp

		select cur_sel
		snapMode.toFrozen = true
		completeRedraw()

		MD_Data.TempLayerNodes = GetAllLayerNodes Layer.Name
	),

	fn CreateLayer =
	(
		LayerManager.newLayerFromName mdt_temp_layer
		Layer = LayerManager.getLayerFromName mdt_temp_layer
		Layer.on = false
		Layer.lock = on
		Layer.ishidden = MD_UI.Settings.ckbx_show_bb.checked
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

	fn SetPivotPos =
	(
		try(
			bb_x = [bb.min.x, bb.center.x, bb.max.x]
			bb_y = [bb.min.y, bb.center.y, bb.max.y]
			bb_z = [bb.min.z, bb.center.z, bb.max.z]

			pivot_pos = [bb_x[MD_UI.Dialogs.PivotParams.lst_x.selection], \
			bb_y[MD_UI.Dialogs.PivotParams.lst_y.selection], \
			bb_z[MD_UI.Dialogs.PivotParams.lst_z.selection]]
			
			pp.pos = pivot_pos

			completeRedraw()
		)catch()
	),

	fn ResetPivot =
	(
		try(
			pivot_pos = [0.0, 0.0, 0.0]
			pp.pos = [pivot_pos[1], pivot_pos[2], pivot_pos[3]]
			write_pivot_data()
		)catch()
	),

	fn ResetPivot =
	(
		try(
			pivot_pos = [0.0, 0.0, 0.0]
			pp.pos = [pivot_pos[1], pivot_pos[2], pivot_pos[3]]
			write_pivot_data()
		)catch()
	),

	fn Update =
	(
		case MD_Data.ActiveSection of
		(
			1:(
				local arrow_offset = ConvertValueToSystemUnits #cm 10.0
				
				try read_pivot_data() catch()
				try pp.pos = [pivot_pos[1], pivot_pos[2], pivot_pos[3]] catch(
					Remove()
					CreateLayer()
					CreateBBox()
				)
				this.Layer.on = false
				arrow_rad = 0.0
				bbox_size = [0, 0, 0]
				bb.isHidden = false
				arrow.isHidden = false
				pp.isHidden = true
				bb.wireColor = clr_main
				arrow.wireColor = clr_main

				if MD_Data.ActiveTask != undefined then
				-- if MD_Data.ActiveTask != undefined and MD_Data.ActiveTask.State != STATES[1] then
				(
					MD_Data.WorkLayerNodes = GetAllLayerNodes MD_Data.ActiveTask.Article

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

							-- try (for n in MD_Data.WorkLayerNodes do n.IsHidden = false) catch()
							-- try MD_Data.ActiveTask.AddMesh.IsHidden = true catch()
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

							-- try (for n in MD_Data.WorkLayerNodes do n.IsHidden = true) catch()
							-- try MD_Data.ActiveTask.AddMesh.IsHidden = false catch()
						)
					)

					if MD_UI.Settings.ckbx_auto_pivot.checked == true then pp.isHidden = false
					else pp.isHidden = true
					
					arrow_rad = ConvertValueToSystemUnits #cm 20.0
				)
				this.Layer.on = MD_UI.Settings.ckbx_show_bb.checked

				bb.length = bbox_size[1]
				bb.width = bbox_size[2]
				bb.height = bbox_size[3]
				arrow.radius = arrow_rad
				arrow.pos.x = (bb.width/2.0 + arrow_rad/2.0 + arrow_offset)

			)
			2:(
				bb.isHidden = true
				arrow.isHidden = true
				pp.isHidden = true
			)
		)
	),

	fn ChangeColor =
	(
		clr_main = MD_UI.Settings.clr_bb_main.color
		clr_add = MD_UI.Settings.clr_bb_add.color

		case MD_Data.ActiveTask.ActiveMesh of
		(
			1:(
				bb.wireColor = clr_main
				arrow.wireColor = clr_main
			)
			2:(
				bb.wireColor = clr_add
				arrow.wireColor = clr_add
			)
		)
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

	fn UpdateUI ev nd = 
	(
		-- print "UpdateUI"
		MD_UI.UpdateCatalogToolsRlt()
	),

	fn AddObject = 
	(
		-- print "AddObject"
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
		MD_UI.UpdateCatalogToolsRlt()
	),

	fn DeleteObject = 
	(
		-- print "DeleteObject"
		try (
			local obj = callbacks.notificationParam()

			if MD_Data.InWorkTask != undefined then
			(
				if obj == MD_Data.InWorkTask.Mesh then MD_Data.InWorkTask.Mesh = undefined
				if obj == MD_Data.InWorkTask.AddMesh then MD_Data.InWorkTask.AddMesh = undefined
			)
		)catch()
		MD_UI.UpdateCatalogToolsRlt()
	),

	fn LayerChange = 
	(
		-- print "LayerChange"
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
		MD_UI.UpdateCatalogToolsRlt()
	),

	fn CheckExistTaskLayer =
	(
		-- print "CheckExistTaskLayer"

		if (callbacks.notificationParam()).name == MD_Data.ActiveTask.Article then
		(
			if MD_Data.ActiveTask != undefined then
			(
				MD_Data.ActiveTask.State = STATES[1]
				MD_Data.ActiveTask.ActiveMesh = 1
				MD_Data.InWorkTask = undefined
				MD_Data.WorkLayer = undefined
				MD_Data.ActiveTask.Update()
				
				try FullUpdate() catch()
			)
		)
	),

	-- fn RemoveFromTempLayer =
	-- (
	-- 	print "RemoveFromTempLayer"
		
	-- 	try(
	-- 		local obj = (callbacks.notificationParam())[1]

	-- 		if obj.Layer == MD_BBox.Layer then
	-- 		(
	-- 			with redraw off
	-- 			(
	-- 				DEFAULT_LAYER.addNode obj
	-- 				DEFAULT_LAYER.Current = true					
	-- 			)
	-- 		)		
	-- 	) catch()

	-- 	MD_UI.UpdateCatalogToolsRlt()
	-- ),

	fn UpdateState =
	(
		-- print "UpdateState"
		try(
			if MD_Data.ActiveTask == MD_Data.InWorkTask then
			(
				MD_Data.Update()
				try FullUpdate() catch()
			)	
		) catch()
	),

	fn MatChange ev nd =
	(
		-- print "MatChange"

		try (
			--print MD_Data.ActiveTask.Material.materialList.count
		)catch()
	),

	fn Add =
	(
		-- print "Add"

		callbacks.addScript #layerDeleted CheckExistTaskLayer id:#md_callbacks
		callbacks.addScript #filePostOpen UpdateState id:#md_callbacks
		callbacks.addScript #nodeCloned AddObject id:#md_callbacks
		callbacks.addScript #sceneNodeAdded AddObject id:#md_callbacks
		callbacks.addScript #nodeCreated AddObject id:#md_callbacks
		callbacks.addScript #nodePreDelete DeleteObject id:#md_callbacks
		callbacks.addScript #nodeLayerChanged LayerChange id:#md_callbacks
		-- callbacks.addScript #nodeLayerChanged RemoveFromTempLayer id:#md_callbacks
		-- callbacks.addScript #selectionSetChanged MD_UI.UpdateCatalogToolsRlt id:#md_callbacks

		ToolsUIUpdate = NodeEventCallback mouseUp:false delay:250 \
		subobjectSelectionChanged:UpdateUI \
		materialOtherEvent:MatChange \
		selectionChanged: UpdateUI
		-- deleted: DeleteObject \
		-- layerChanged: LayerChange \
		-- added: AddObject \
	),

	fn Destruct =
	(
		-- print "Destruct"
		callbacks.removeScripts id:#md_callbacks
		ToolsUIUpdate = undefined
		gc light:true
	)
)

struct HTTPClient
(
	response_status,
	response_msg,
	response_data,
	ActiveCheckParam = 1,
	request_dlg_title,
	dialog_mode = True,

	fn ExistTasksFilter =
	(
		-- Фильтрует список артикулов для загрузки в локальную базу
		local filter_articles = #()
		local categ_lib_dirs = GetDirectories (MD_Data.sub_categ_lib_dirs[MD_Data.ActiveCategory][MD_Data.ActiveSubCategory] + "/*")
		local exist_articles = #()

		-- Список артиклей существующих заданий
		for dir in categ_lib_dirs do 
		(
		   local categ = pathConfig.stripPathToLeaf (trimRight dir "\\/")
		   append exist_articles categ
		)
		
		-- Перебор списка из ответа от http-client
		for rd in response_data do 
		(
			local resp = FilterString rd SEPAR_2
			-- resp[1] = артикул
			-- resp[2] = дата создания
			-- resp[3] = сообщение
			-- resp[4] = ID пользователя
	
			-- Проверить существует ли задание в локальной базе
			local f = findItem exist_articles resp[1]
			
			if f == 0 then (append filter_articles resp[1])
			else 
			(
				local exist_task_file = pathConfig.AppendPath categ_lib_dirs[f] TASK_INNER_DIRS[1]
				exist_task_file = pathConfig.AppendPath exist_task_file TASK_FILE_NAME

				-- Проверка даты создания задания
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

    fn Request request args title dialog:True =
    (
		response_status = undefined
		response_msg = undefined
		response_data = undefined

		if DoesFileExist HTTP_CLIENT then
		(
			this.dialog_mode = dialog
			request_dlg_title = title
			shellLaunch HTTP_CLIENT (request + " " + args)
			CreateDialog MD_UI.Dialogs.Request modal:true
		)
		else 
		(
			response_msg = "Не удалось обнаружить http-клиент."
			MD_Log.Error response_msg
		)
    ),

	fn Log msg =
	(
		if MD_Client.response_status == "200" then
        (
            msg = "Код ответа: " + MD_Client.response_status + " | " + msg
            Client_Log.Info msg
        )
        
        if MD_Client.response_status == "401" then
        (
			response_msg = "Проблемы с авторизацией."
            msg = "Код ответа: " + MD_Client.response_status + " | " + response_msg
            Client_Log.Error msg
        )

		if MD_Client.response_status == "400" then
		(
			response_msg = "Что-то пошло не так. Возможно, проблемы на сервере."
            msg = "Код ответа: " + MD_Client.response_status + " | " + response_msg
            Client_Log.Error msg
        )
	)
)


