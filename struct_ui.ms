
struct UI
(
	MainRoll = rlt_make_design,
	SettingsRoll = rlt_settings,
	TasksRoll = rlt_tasks,
	InfoCatalogRoll = rlt_info_catalog,
	InfoProjectsRoll = rlt_info_projects,
	GeneralCatalogRoll = rlt_general_catalog,
	GeneralProjectsRoll = rlt_general_projects,
	ToolsCatalogRoll = rlt_tools_catalog,
	HelpRoll = rlt_about,
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
			this.GeneralCatalogRoll.btn_main_mesh.text = "Main Mesh"
			this.GeneralCatalogRoll.btn_add_mesh.text = "Additional Mesh"
			this.GeneralCatalogRoll.btn_vis_switch.text = "Show Scene Objects"

			for ctrl in this.GeneralCatalogRoll.Controls do ctrl.enabled = false
			for ctrl in this.GeneralProjectsRoll.Controls do ctrl.enabled = false

			local objs = #()

			if (MD_Data.ActiveTask != undefined and MD_Data.WorkLayer != undefined and MD_Data.ActiveTask.State == STATES[2]) or \
			(MD_Data.ActiveTask != undefined and MD_Data.ActiveTask.Group != undefined and MD_Data.InWorkTask != undefined and MD_Data.ActiveTask.Group == MD_Data.InWorkTask.Group) then
			-- if MD_Data.ActiveTask != undefined and MD_Data.WorkLayer != undefined and MD_Data.ActiveTask == MD_Data.InWorkTask then
			(
				this.GeneralCatalogRoll.btn_vis_switch.enabled = true
				MD_Data.WorkLayerNodes = GetAllLayerNodes MD_Data.WorkLayer.Name

				objs = for obj in (objects as array) where (findItem MD_Data.TempLayerNodes obj == 0) collect obj

				-- Пивот
				this.GeneralCatalogRoll.btn_set_pivot.enabled = true

				-- Режим редактирования иконки
				if MD_Data.ActiveCategoryIcon.Icon != undefined then
				this.GeneralCatalogRoll.btn_edit_icon.enabled = true

				-- Основной меш
				if MD_Data.InWorkTask.Mesh != undefined and not MD_Data.InWorkTask.Mesh.IsDeleted then
				(
					this.GeneralCatalogRoll.btn_main_mesh.text = "  Main Mesh •"
					if MD_Data.InWorkTask.ActiveMesh == 1 and selection.count == 1 and selection[1] == MD_Data.InWorkTask.Mesh then this.GeneralCatalogRoll.btn_assign_mat.enabled = true
					try this.GeneralCatalogRoll.btn_main_mesh.tooltip = ("Текущий объект: " + MD_Data.InWorkTask.Mesh.Name + "\nДля удаления статуса главного объекта необходимо повторно нажать на кнопку.") catch()
				)
				else
				(
					this.GeneralCatalogRoll.btn_main_mesh.text = "Main Mesh"
					this.GeneralCatalogRoll.btn_main_mesh.tooltip = MD_Tooltips.tools_cat_07_a
				)

				-- Если задание имеет поле трансформации
				if MD_Data.InWorkTask.SizeTrans != undefined then 
				(

					this.GeneralCatalogRoll.btn_mesh_switch.enabled = true

					if MD_Data.InWorkTask.ActiveMesh == 2 then
					this.GeneralCatalogRoll.btn_mesh_switch.text = "<< Switch To Main Mesh"	
					else this.GeneralCatalogRoll.btn_mesh_switch.text = ">> Switch To Additional Mesh"

					if (selection.count == 1 and \
						SuperClassOf selection[1] == GeometryClass and \
						findItem MD_Data.WorkLayerNodes selection[1] != 0) then
					(
						if MD_Data.InWorkTask.ActiveMesh == 2 then
						(
							this.GeneralCatalogRoll.btn_mesh_switch.text = "<< Switch To Main Mesh"
							this.GeneralCatalogRoll.btn_add_mesh.enabled = true		
						)
						else
						(
							this.GeneralCatalogRoll.btn_mesh_switch.text = ">> Switch To Additional Mesh"
							this.GeneralCatalogRoll.btn_main_mesh.enabled = true
							if MD_Data.InWorkTask.AddMesh == undefined or MD_Data.InWorkTask.AddMesh.IsDeleted then
							this.GeneralCatalogRoll.btn_add_mesh.enabled = true
						)
					)

					-- Доп. меш
					if MD_Data.InWorkTask.AddMesh != undefined and not MD_Data.InWorkTask.AddMesh.IsDeleted then
					(
						this.GeneralCatalogRoll.btn_add_mesh.text = "  Additional Mesh •"
						if MD_Data.InWorkTask.ActiveMesh == 2 and selection.count == 1 and selection[1] == MD_Data.InWorkTask.AddMesh then this.GeneralCatalogRoll.btn_assign_mat.enabled = true
						try this.GeneralCatalogRoll.btn_add_mesh.tooltip = ("Текущий объект: " + MD_Data.InWorkTask.AddMesh.Name + "\nДля удаления статуса дополнительного объекта необходимо повторно нажать на кнопку.") catch()
					)
					else(
						this.GeneralCatalogRoll.btn_add_mesh.text = "Additional Mesh"
						this.GeneralCatalogRoll.btn_add_mesh.tooltip = MD_Tooltips.tools_cat_07_b
					)
				)
				-- Если задание НЕ имеет поле трансформации
				else
				(
					MD_Data.InWorkTask.ActiveMesh = 1

					if (selection.count == 1 and \
						SuperClassOf selection[1] == GeometryClass and \
						findItem MD_Data.WorkLayerNodes selection[1] != 0) then
					(
						this.GeneralCatalogRoll.btn_main_mesh.enabled = true
						if MD_Data.InWorkTask.Mesh == 1 and selection[1] == MD_Data.InWorkTask.Mesh then this.GeneralCatalogRoll.btn_assign_mat.enabled = true
					)
				)
				
				-- Сохранить работу
				if (MD_Data.WorkLayer != undefined and MD_Data.WorkLayerNodes.count != 0) then
				(
					this.GeneralCatalogRoll.btn_save_work.enabled = true
					this.GeneralCatalogRoll.btn_export.enabled = true
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
					this.GeneralCatalogRoll.btn_attach_to_task.enabled = true
				)

				-- Загрузить работу
				if MD_Data.InWorkTask.SavedWorks.count != 0 then
				(
					this.GeneralCatalogRoll.btn_load_work.enabled = true
					this.GeneralCatalogRoll.btn_work_list.enabled = true
				)
			)

			free MD_Data.WorkLayerNodes
			free objs
		)catch()
	),

	fn FillAddList =
	(
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
		case MD_Data.ActiveList of
		(
			1:(
				this.InfoCatalogRoll.title = "Info"

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

					this.InfoCatalogRoll.lbl_size.visible = true
					this.InfoCatalogRoll.lbl_size_txt.visible = true
					this.InfoCatalogRoll.lbl_site.visible = true
					this.InfoCatalogRoll.hpl_site.visible = true
					this.InfoCatalogRoll.hpl_site.text = ""
					try (this.InfoCatalogRoll.hpl_site.address = MD_Data.ActiveTask.WebSite) catch()

					case MD_Data.ActiveTask.ActiveMesh of
					(
						1:(
							this.InfoCatalogRoll.lbl_size_txt.text = size_txt
						)
						2:(
							this.InfoCatalogRoll.lbl_size_txt.text = size_add_txt
						)
					)

					try (this.InfoCatalogRoll.hpl_site.text = MD_Data.ActiveTask.WebSite) catch()
					this.InfoCatalogRoll.title = MD_Data.ActiveTask.Article
					this.InfoCatalogRoll.height = 280					
				)
			)
			2:(
				InfoCatalogPreview.bitmap = MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].RefBitmap
				this.InfoCatalogRoll.title = MD_Data.ActiveTask.Article + "  [" + MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].PartName + "]"
				this.InfoCatalogRoll.height = 280
			)
		)
	),

	fn UpdateCatalogTasksRlt =
	(
		this.TasksRoll.btn_get.enabled = false
		this.TasksRoll.btn_clear.enabled = false
		this.TasksRoll.btn_assign_mat_id.enabled = false	
		this.TasksRoll.btn_assign_texts.enabled = false

		if MD_Data.ActiveTask == undefined then
		(
			for ctrl in this.TasksRoll.Controls do ctrl.enabled = false
			for ctrl in this.InfoCatalogRoll.Controls do ctrl.enabled = false
			for ctrl in this.GeneralCatalogRoll.Controls do ctrl.enabled = false
			for ctrl in this.GeneralProjectsRoll.Controls do ctrl.enabled = false

			this.TasksRoll.btn_work_state.text = "Set Work State"
			InfoCatalogPreview.bitmap = EMPTY_PREVIEW
			InfoCatalogWeb.text = ""
			InfoCatalogWeb.address = ""
			InfoCatalogSize.text = ""

			this.TasksRoll.lst_sections.enabled = true
			this.TasksRoll.lst_basic_catalog.enabled = true
			this.TasksRoll.lst_sub_catalog.enabled = true
			ListMain.enabled = true
			ListAdd.enabled = true
		)
		else
		(
			this.TasksRoll.btn_work_state.enabled = true
			if (MD_Data.InWorkTask != undefined and MD_Data.ActiveTask.Article != MD_Data.InWorkTask.Article and MD_Data.ActiveTask.Group == undefined) or \
			(MD_Data.InWorkTask == undefined and (MD_Data.ActiveTask.Group == undefined or MD_Data.ActiveTask.Group != undefined)) or \
			(MD_Data.InWorkTask != undefined and MD_Data.ActiveTask != MD_Data.InWorkTask and MD_Data.ActiveTask.Group != MD_Data.InWorkTask.Group) then
			(
				this.TasksRoll.btn_work_state.text = "Set Work State"
				this.TasksRoll.btn_exit_work_state.enabled = false
				for ctrl in this.GeneralCatalogRoll.Controls do ctrl.enabled = false
				for ctrl in this.GeneralProjectsRoll.Controls do ctrl.enabled = false
			)
			else if (MD_Data.InWorkTask != undefined and MD_Data.ActiveTask.Article == MD_Data.InWorkTask.Article and MD_Data.ActiveTask.Group == undefined) or \
			
			(MD_Data.InWorkTask != undefined and MD_Data.ActiveTask.Article == MD_Data.InWorkTask.Article and MD_Data.ActiveTask.Group == MD_Data.InWorkTask.Group) then
			(
				this.TasksRoll.btn_work_state.text = "Update Work State"
				this.TasksRoll.btn_exit_work_state.enabled = true
				this.TasksRoll.btn_get.enabled = false
				this.TasksRoll.btn_clear.enabled = false
				this.TasksRoll.btn_get.text = "Get"
				this.TasksRoll.btn_clear.text = "Clear"
				this.TasksRoll.btn_get.tooltip = MD_Tooltips.tasks_02_a
				this.TasksRoll.btn_clear.tooltip = MD_Tooltips.tasks_03_a
				this.TasksRoll.btn_work_state.enabled = true

				-- Material ID и текстуры
				if MD_Data.ActiveList == 2 then
				(
					this.TasksRoll.btn_assign_texts.enabled = true
					if subobjectLevel == 4 or subobjectLevel == 5 then this.TasksRoll.btn_assign_mat_id.enabled = true			
					else if subobjectLevel == 0 or subobjectLevel == undefined then this.TasksRoll.btn_assign_mat_id.enabled = false
				)
			)
			else if (MD_Data.InWorkTask != undefined and MD_Data.ActiveTask.Article != MD_Data.InWorkTask.Article and MD_Data.ActiveTask.Group == MD_Data.InWorkTask.Group) then
			(
				this.TasksRoll.btn_work_state.text = "Set Work State"
				this.TasksRoll.btn_work_state.enabled = true
				this.TasksRoll.btn_exit_work_state.enabled = true
			)
			for ctrl in this.InfoCatalogRoll.Controls do ctrl.enabled = true
			
			try (ListMain.Items.Item[MD_Data.ActiveTaskIndex - 1].Selected = True) catch()
		)

		if MD_Data.TempArticlesList.count != 0 then
		(
			this.TasksRoll.btn_work_state.enabled = false
			this.TasksRoll.btn_exit_work_state.enabled = false

			for ctrl in this.GeneralCatalogRoll.Controls do ctrl.enabled = false
			for ctrl in this.GeneralProjectsRoll.Controls do ctrl.enabled = false

			case MD_Client.ActiveCheckParam of
			(
				1:(
					this.TasksRoll.btn_get.text = "Get"
					this.TasksRoll.btn_get.tooltip = MD_Tooltips.tasks_02_a
				)
				2:(
					this.TasksRoll.btn_get.text = "Send"
					this.TasksRoll.btn_get.tooltip = MD_Tooltips.tasks_02_b
				)
				3:(
					this.TasksRoll.btn_get.text = "Backup"
					this.TasksRoll.btn_get.tooltip = MD_Tooltips.tasks_02_c
				)
				4:
				(
					this.TasksRoll.btn_get.text = "Restore"
					this.TasksRoll.btn_get.tooltip = MD_Tooltips.tasks_02_d
				)
			)
			this.TasksRoll.btn_clear.text = "Clear"
			this.TasksRoll.btn_clear.tooltip = MD_Tooltips.tasks_03_a
		)
		else
		(
			this.TasksRoll.btn_get.text = "Update"
			this.TasksRoll.btn_get.tooltip = MD_Tooltips.tasks_02_e
			this.TasksRoll.btn_clear.text = "Delete"
			this.TasksRoll.btn_clear.tooltip = MD_Tooltips.tasks_03_b
		)

		if MD_Data.CheckedTasks.Count > 0 then
		(
			this.TasksRoll.btn_get.enabled = true
			this.TasksRoll.btn_clear.enabled = true
			this.TasksRoll.btn_work_state.enabled = false
			this.TasksRoll.btn_exit_work_state.enabled = false
		)

		if SubCategories.Items.Count != 0 then
		(
			this.TasksRoll.lst_basic_catalog.enabled = true
			this.TasksRoll.lst_sub_catalog.enabled = true
			this.TasksRoll.btn_check.enabled = true
		)

		-- Обновить текст веб ссылки (баг макса)
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

		ListMain.Items.Clear()
		ListMain.Items.AddRange main_items
		ListMain.Update()

		ListAdd.Items.Clear()
		ListAdd.Update()
	),

	fn SwitchRollouts = (
		-- Переключает роллоуты в зависимости от того, какой раздел выбран

        removeSubRollout this.MainRoll.sub_rlt HelpRoll
        case Sections.Selection of
        (
            1:(
                removeSubRollout this.MainRoll.sub_rlt this.GeneralProjectsRoll
				-- removeSubRollout this.MainRoll.sub_rlt this.InfoProjectsRoll
                AddSubRollout this.MainRoll.sub_rlt this.InfoCatalogRoll rolledUp:false
				AddSubRollout this.MainRoll.sub_rlt this.GeneralCatalogRoll rolledUp:false
            )
            2:(
                removeSubRollout this.MainRoll.sub_rlt this.GeneralCatalogRoll
                removeSubRollout this.MainRoll.sub_rlt this.InfoCatalogRoll
                -- AddSubRollout this.MainRoll.sub_rlt this.InfoProjectsRoll rolledUp:false
                AddSubRollout this.MainRoll.sub_rlt this.GeneralProjectsRoll rolledUp:false
            )
        )
        AddSubRollout this.MainRoll.sub_rlt HelpRoll rolledUp:True

		-- Выравнить подроллаут
		this.MainRoll.sub_rlt.height = (MAIN_RLT_HEIGHT - 28)
		this.MainRoll.sub_rlt.pos = [2, 4]

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

		createdialog this.MainRoll width:(MAIN_RLT_WIDTH + 8) height:(MAIN_RLT_HEIGHT - 20) autoLayoutOnResize:true scrollBar:#on lockHeight:false

		AddSubRollout this.MainRoll.sub_rlt this.SettingsRoll rolledUp:true
		AddSubRollout this.MainRoll.sub_rlt this.TasksRoll rolledUp:true
		AddSubRollout this.MainRoll.sub_rlt this.InfoCatalogRoll rolledUp:true
		AddSubRollout this.MainRoll.sub_rlt this.ToolsCatalogRoll rolledUp:true
		AddSubRollout this.MainRoll.sub_rlt this.GeneralCatalogRoll rolledUp:true
		
		AddSubRollout this.MainRoll.sub_rlt HelpRoll rolledUp:true

		-- Инициализация входных значений
        try(
            GetINISettings this.SettingsRoll MDT_CONFIG_FILE this.SettingsRoll.name
            GetINISettings this.TasksRoll MDT_CONFIG_FILE this.TasksRoll.name include_list:#(this.TasksRoll.lst_basic_catalog, this.TasksRoll.lst_sub_catalog)
            GetINISettings this.InfoCatalogRoll MDT_CONFIG_FILE this.InfoCatalogRoll.name onlyRollState:true
            GetINISettings this.ToolsCatalogRoll MDT_CONFIG_FILE this.ToolsCatalogRoll.name onlyRollState:true
            GetINISettings this.GeneralCatalogRoll MDT_CONFIG_FILE this.GeneralCatalogRoll.name onlyRollState:true
        )catch ()

		try (exist_categ_index = execute (GetINISetting MDT_CONFIG_FILE this.TasksRoll.Name "lst_basic_catalog_selection")) catch()
		try (exist_sub_categ_index = execute (GetINISetting MDT_CONFIG_FILE this.TasksRoll.Name "lst_sub_catalog_selection")) catch()

		-- Try select active task
		try (
			exist_task_index = execute (GetINISetting MDT_CONFIG_FILE this.TasksRoll.Name (this.ListMain.name + "_selection")) + 1
			MD_Data.ActiveTaskIndex = exist_task_index
			MD_Data.ActiveTask = MD_Data.Tasks[exist_task_index]
		) catch()

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
		if this.SettingsRoll.ckbx_tooltips.Checked == false then
		(
			for ctrl in this.SettingsRoll.Controls do try(ctrl.tooltip = "")catch()
			for ctrl in this.TasksRoll.Controls do try(ctrl.tooltip = "")catch()
			for ctrl in this.InfoCatalogRoll.Controls do try(ctrl.tooltip = "")catch()
			for ctrl in this.ToolsCatalogRoll.Controls do try(ctrl.tooltip = "")catch()
			for ctrl in this.GeneralCatalogRoll.Controls do try(ctrl.tooltip = "")catch()
			for ctrl in this.GeneralProjectsRoll.Controls do try(ctrl.tooltip = "")catch()
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