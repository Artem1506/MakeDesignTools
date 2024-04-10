
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

	-- fn CreateMaterial =
	-- (
    --     local mat = Multimaterial name:Article
    --     local MatLib = materialLibrary()
	-- 	local m_name = ""

	-- 	mat.materialList.count = Materials.count

	-- 	for i = 1 to Materials.count do
	-- 	(
	-- 		local val = true

	-- 		m_name = "Material_" + (formattedPrint i format:#02d)

	-- 		mat.materialList[i] = Standardmaterial()
	-- 		mat.materialList[i].Diffuse = CLR_PALETTE_1[i]
	-- 		mat.materialList[i].Name = m_name
	-- 		mat.names[i] = Materials[i].MatIndex
	-- 	)

	-- 	Material = mat
    --     append MatLib mat
	-- 	if not DoesDirectoryExist InWorkDir do MakeDir InWorkDir
    --     saveTempMaterialLibrary MatLib MatLibFile
    --     -- saveMaterialLibrary MatLibFile
	-- ),

	fn CreateMaterial =
	(
        local mat = Multimaterial name:Article
        local MatLib = materialLibrary()
		local m_name = "Material_" + (formattedPrint 1 format:#02d)

		mat.materialList.count = 1
		mat.materialList[1] = Standardmaterial()
		mat.materialList[1].Diffuse = CLR_PALETTE_1[1]
		mat.materialList[1].Name = m_name
		-- mat.names[1] = ""

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
			-- try (select MD_Data.InWorkTask.Mesh) catch()
			load_result = true		
		)
		else try (select cur_sel_objs) catch()
		
		completeRedraw()

		-- MD_Callbacks.Add()

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
			-- else
			-- (
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

				-- Сохранить рабочий файл .max
				
				file_path = (pathconfig.appendpath save_dir (file_name + ".max"))
				save_nodes MD_Data.WorkLayerNodes file_path

				-- Сохранить скриншот сцены .jpg
				prev_file = (pathconfig.appendpath save_dir (file_name + ".jpg"))

				try ViewportSnapshot prev_file SAVED_PREVIEW_SIZE auto_frame:MD_UI.SettingsRoll.ckbx_auto_prev.checked catch()

				MD_Data.InWorkTask.SavedWorks = GetFiles (save_dir + "/*.max")
				sort MD_Data.InWorkTask.SavedWorks

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

				if data["finishing_materials"].count != 0 then
				(
					for i = 1 to data["finishing_materials"].count do
					(
						mat = TaskMaterial()
						try mat.Article = data["finishing_materials"][i]["article"] catch()
						try (f_str = (filterString mat.Article "-"); mat.MatIndex = f_str[f_str.count]) catch()
						try mat.Material = data["finishing_materials"][i]["finishing_components"] catch()
						try mat.RefFile = mat_ref_files[i] catch()
						try (mat.RefBitmap = CreatePreviewFromImageFile mat_ref_files[i] PREVIEW_SIZE)
						catch (mat.RefBitmap = CreatePreviewFromImageFile ICON_NO_PRVIEW_FILE PREVIEW_SIZE type:#dotnet)
						try (mat.WebSite = data["finishing_materials"][i]["link"]) catch()

						-- Проверка наличия текстур
						for t = 1 to mat.textures.count do
						(
							local tex_file = (pathConfig.appendPath TaskDir ("T_" + mat.Article + TEXTURES_SIFFIXES[t]))
							if doesFileExist tex_file then (mat.textures[t] = tex_file)
						)
						append this.Materials mat
					)					
				)
				else
				(
					mat = TaskMaterial()
					mat.Article = data["article"]
					mat.MatIndex = "01"
					mat.Material = ""
					-- mat.RefBitmap = CreatePreviewFromImageFile ICON_NO_PRVIEW_FILE SAVED_PREVIEW_SIZE
					-- mat.RefBitmap =  this.RefBitmap
					for t = 1 to mat.textures.count do
					(
						local tex_file = (pathConfig.appendPath TaskDir ("T_" + mat.Article + TEXTURES_SIFFIXES[t]))
						if doesFileExist tex_file then (mat.textures[t] = tex_file)
					)
					append this.Materials mat
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

				-- Создать материал
				-- if not DoesFileExist MatLibFile then CreateMaterial()
				-- else LoadMaterial()
            )
        )
	),

	on create do Init()
)