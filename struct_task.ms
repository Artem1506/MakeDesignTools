
struct Task
(
	File = undefined,
	Article = undefined,
	DateCreate = undefined,
	Object = undefined,
	WebSite = undefined,
	Materials = #(), -- Array of TaskMaterials
	-- Material = undefined,
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
	MainMesh = undefined,
	AddMesh = undefined,
	ActiveMeshIndex = 1,
	ActiveMatIndex = 1,
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

	-- fn CreateMaterial =
	-- (
    --     local mat = Multimaterial name:Article
    --     local MatLib = materialLibrary()
	-- 	local m_name = "Material_" + (formattedPrint 1 format:#02d)

	-- 	mat.materialList.count = 1
	-- 	mat.materialList[1] = Standardmaterial()
	-- 	mat.materialList[1].Diffuse = CLR_PALETTE_1[1]
	-- 	mat.materialList[1].Name = m_name
	-- 	-- mat.names[1] = ""

	-- 	Material = mat
    --     append MatLib mat
	-- 	if not DoesDirectoryExist InWorkDir do MakeDir InWorkDir
    --     saveTempMaterialLibrary MatLib MatLibFile
    --     -- saveMaterialLibrary MatLibFile
	-- ),
	fn CreateComposeMap =
	(
		local mask_map = Bitmaptexture()
		comp_map = CompositeTexturemap \
		mapEnabled:#(false, false, false, false, false, false, false, false, false, false) \
		maskEnabled:#(false, false, false, false, false, false, false, false, false, false) \
		layerName:#("Diffuse", "SRM", "Normal", "Diffuse (Tile)", "SRM (Tile)", "Normal (Tile)", "Emission", "Mixing", "SSS", "Displace")\
		mapList:#(Bitmaptexture(), (RGB_Tint map1:(Bitmaptexture()) red:(color 0 0 0) green:(color 0 0 0) blue:(color 0 0 0)), Bitmaptexture(),\
		Bitmaptexture(), (RGB_Tint map1:(Bitmaptexture()) red:(color 0 0 0) green:(color 0 0 0) blue:(color 0 0 0)), Bitmaptexture(), \
		Bitmaptexture(), mask_map, Bitmaptexture(), Bitmaptexture()) \
		mask:#(undefined, undefined, undefined, mask_map, mask_map, mask_map, undefined, undefined, undefined, undefined)
	),

	fn CreateMaterial mat_index =
	(
        local mat = Multimaterial name:Article
        -- local MatLib = materialLibrary()
		local m_name = "Material_" + (formattedPrint 1 format:#02d)

		mat.materialList.count = 1
		mat.materialList[1] = Standardmaterial()
		mat.materialList[1].Diffuse = CLR_PALETTE_1[1]
		mat.materialList[1].diffuseMap = this.CreateComposeMap()
		mat.materialList[1].Name = m_name
		-- mat.names[1] = ""

		this.Materials[mat_index].mat = mat
		showTextureMap mat false
		mat
        -- append MatLib mat
		-- if not DoesDirectoryExist InWorkDir do MakeDir InWorkDir
        -- saveTempMaterialLibrary MatLib MatLibFile
        -- saveMaterialLibrary MatLibFile
	),

	-- fn LoadMaterial mat_index =
	-- (
	-- 	try
	-- 	(
	-- 		this.Material = (loadMaterialLibrary MatLibFile)[mat_index]
	-- 		-- MatLib = loadTempMaterialLibrary MatLibFile
	-- 		-- this.Material = MatLib[1]
	-- 	)
	-- 	catch(this.Material = undefined)
	-- ),

	fn LoadWork saved_file quiet_mode:true =
	(
		local cur_sel_objs = (selection as array)
		local merged_objs = undefined
		local load_result = false
		local msg_box_val = undefined

		MD_Data.WorkLayerNodes = GetAllLayerNodes MD_Data.WorkLayer.Name
		MD_Data.WorkLayer.current = true
		
		if MD_Data.WorkLayerNodes.count != 0 and quiet_mode == false then
		(
			msg_box_val = yesNoCancelBox "Рабочий слой содержит объекты.\n\nУдалить их?\n" title:"Внимание!" icon:#question

			if msg_box_val == #yes then
			(
				delete MD_Data.WorkLayerNodes
				gc()
			)
		)

		if msg_box_val == undefined or msg_box_val == #yes or msg_box_val == #no then
		(
			clearSelection()
			MD_Callbacks.Destruct()

			-- mergeMAXFile saved_file #deleteOldDups #useMergedMtlDups #neverReparent
			mergeMAXFile saved_file #mergeDups #useSceneMtlDups #neverReparent

			merged_objs = getLastMergedNodes()

			-- Если кол-во смердженных объектов не равно нулю
			if merged_objs.count != 0 then
			(
				MD_Data.WorkLayerNodes = GetAllLayerNodes MD_Data.WorkLayer.Name
				for obj in merged_objs do
				(
					if MD_Data.InWorkTask != undefined then
					(
						local mat_lib_file = (filterString saved_file ".")[1] + ".mat"
						local mat_lib = loadTempMaterialLibrary mat_lib_file

						-- MD_Data.InWorkTask.Materials = undefined
						try(
							for i = 1 to mat_lib.count do MD_Data.InWorkTask.Materials[i].MultiMat = mat_lib[i]
						)catch()

						-- if MD_Data.InWorkTask.Group == undefined then 
						-- (
							if obj.name == MD_Data.InWorkTask.Article then
							(
								MD_Data.InWorkTask.MainMesh = obj
								try MD_Data.AssignMaterial obj MD_Data.InWorkTask.ActiveMatIndex catch()
							)
							if obj.name == (MD_Data.InWorkTask.Article + TRANS_POSTFIX) then
							(
								MD_Data.InWorkTask.AddMesh = obj
								try MD_Data.AssignMaterial obj MD_Data.InWorkTask.ActiveMatIndex catch()
							)						
						-- )
						-- else
						-- (
						-- 	if obj.name == MD_Data.InWorkTask.Group then
						-- 	(
						-- 		MD_Data.InWorkTask.MainMesh = obj
						-- 		try MD_Data.AssignMaterial obj MD_Data.InWorkTask.ActiveMatIndex catch()
						-- 	)
						-- 	if obj.name == (MD_Data.InWorkTask.Group + TRANS_POSTFIX) then
						-- 	(
						-- 		MD_Data.InWorkTask.AddMesh = obj
						-- 		try MD_Data.AssignMaterial obj MD_Data.InWorkTask.ActiveMatIndex catch()
						-- 	)	
						-- )
					)
				)
				-- try (select MD_Data.InWorkTask.MainMesh) catch()
				load_result = true
				
				-- Генерация хэш суммы
				MD_Data.LoadWorkHashSum = getHashCodeFromObjects MD_Data.WorkLayerNodes
				try (select MD_Data.InWorkTask.MainMesh) catch()

			)
			else 
			(
				try (select cur_sel_objs) catch()
				-- MD_Data.LoadWorkHashSum = 0
			)

			completeRedraw()

			MD_Callbacks.Add()
		)
		SetViewShading 0
		return load_result
	),

	fn SaveWork =
	(
		MD_Data.WorkLayerNodes = GetAllLayerNodes MD_Data.WorkLayer.Name

		local save = true
		local file_path
		local prev_file
		local save_dir
		local current_hash = getHashCodeFromObjects MD_Data.WorkLayerNodes
		local saved = true

		if MD_Data.LoadWorkHashSum == current_hash then
		(
			if not (queryBox "Рабочий слой не содержит изменений!\n\nВсё равно сохранить файл?\n" title:"Внимание!" icon:#question) then saved = false		
		)

		if MD_Data.WorkLayerNodes.count != 0 and saved then
		(
			-- if ((objects.count - MD_Data.TempLayerNodes.count) > MD_Data.WorkLayerNodes.count) then
			-- (
			-- 	msg = "На сцене имеются объекты вне рабочего слоя.\nБудут сохранены только объекты находящиеся на рабочем слое!"
			-- 	messageBox msg title:"Warning!" icon:#warning
			-- )
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
				local mat_lib = materialLibrary()

				-- if Group == undefined then 
				save_dir = pathConfig.appendPath task_dir TASK_INNER_DIRS[3]
				-- else save_dir = MD_Data.InWorkTask.GroupDir

				if not doesDirectoryExist save_dir then MakeDir save_dir

				-- Сохранить рабочий файл .max
				
				local file_path = (pathconfig.appendpath save_dir (file_name + ".max"))
				local mat_lib_file = (pathconfig.appendpath save_dir (file_name + ".mat"))
				save_nodes MD_Data.WorkLayerNodes file_path

				-- Сохранить материалы в библиотеку
				for m in this.Materials do append mat_lib m.MultiMat
				saveTempMaterialLibrary mat_lib mat_lib_file

				-- Сохранить скриншот сцены .jpg
				prev_file = (pathconfig.appendpath save_dir (file_name + ".jpg"))

				try ViewportSnapshot prev_file SAVED_PREVIEW_SIZE auto_frame:MD_UI.SettingsRoll.ckbx_auto_prev.checked catch()

				MD_Data.InWorkTask.SavedWorks = GetFiles (save_dir + "/*.max")
				sort MD_Data.InWorkTask.SavedWorks

				DisplayTempPrompt "Работа была сохранена." 5000
				MD_Log.Info ("Работа была сохранена  [" + file_name + "]")
				MD_Data.LoadWorkHashSum = current_hash
			-- )
		)
		else if MD_Data.WorkLayerNodes.count == 0 and saved then
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
			-- this.LoadMaterial()
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
				-- if Group != undefined then 
				-- (
				-- 	GroupDir = pathConfig.removePathLeaf task_file_dir
				-- 	GroupDir = pathConfig.removePathLeaf GroupDir
				-- 	GroupDir = pathConfig.appendPath GroupDir Group
				-- )
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
					mat.Article = (data["article"]+"-01")
					mat.MatIndex = "01"

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

				-- if Group == undefined then
				-- (
					if pathConfig.doesFileExist saved_dir then
					(
						SavedWorks = GetFiles (saved_dir + "/*.max")
						sort SavedWorks
					)					
				-- )
				-- else
				-- (
				-- 	if pathConfig.doesFileExist GroupDir then
				-- 	(
				-- 		SavedWorks = GetFiles (GroupDir + "/*.max")
				-- 		sort SavedWorks
				-- 	)	
				-- )
				try (RefBitmap = CreatePreviewFromImageFile RefFile PREVIEW_SIZE)
				catch(RefBitmap = CreatePreviewFromImageFile ICON_NO_PRVIEW_FILE PREVIEW_SIZE type:#dotnet)

				-- Создать материал
				-- if not DoesFileExist MatLibFile then CreateMaterial()
				-- else LoadMaterial()
            )
			-- try this.Material = this.Materials[this.ActiveMatIndex].MultiMat catch()
        )
	),

	on create do Init()
)

