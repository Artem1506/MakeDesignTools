
struct UI
(
	MainRoll = rlt_make_design_tools,
	SettingsRoll = rlt_settings,
	AboutRoll = rlt_about,
	Dialogs = UI_Dialogs(),
	-- Catalog UI
	TasksCatalogRoll = rlt_catalog_tasks,
	InfoCatalogRoll = rlt_catalog_info,
	ToolsCatalogRoll = rlt_catalog_tools,
	GeneralCatalogRoll = rlt_catalog_general,
	-- Sections = rlt_catalog_tasks.lst_sections,
	Categories = rlt_catalog_tasks.lst_basic_catalog,
	SubCategories = rlt_catalog_tasks.lst_sub_catalog,
	CatalogListMain = rlt_catalog_tasks.lv_main,
	CatalogListAdd = rlt_catalog_tasks.lv_add,
	InfoCatalogPreview = rlt_catalog_info.img_prev,
	InfoCatalogWeb = rlt_catalog_info.hpl_site,
	InfoCatalogSize = rlt_catalog_info.lbl_size_txt,

	EMPTY_PREVIEW = undefined,
	LabelSizeText = "",
	LabelAddSizeText = "",
	Sort = False,

	fn SetListViewParams list_view CheckBoxes:true= (
		list_view.BorderStyle = list_view.BorderStyle.None
		list_view.gridLines = true
		list_view.View = (dotNetClass "System.Windows.Forms.View").Details
		list_view.fullRowSelect = true
		list_view.MultiSelect = false
		list_view.HideSelection = false
		list_view.HoverSelection  = false
		list_view.CheckBoxes = CheckBoxes
	),

	-- Добавляет колонки в листвью
	fn AddListViewColumns list_view columns widths:#() = (
		for i = 1 to columns.count do
		try(list_view.Columns.add columns[i] widths[i])
		catch(list_view.Columns.add columns[i])
	),

	fn InitCatalogLists = 
	(
		CatalogListMain.Columns.Clear()
		CatalogListAdd.Columns.Clear()

		SetListViewParams CatalogListMain
		SetListViewParams CatalogListAdd CheckBoxes:false

		AddListViewColumns CatalogListMain MAIN_LIST_COLUMNS_1 widths:#(110, 60, 86, 48, 160)
		AddListViewColumns CatalogListAdd ADD_LIST_COLUMNS_1 widths:#(70, 155)

		setFocus CatalogListMain
	),

	fn FillMainList =
	(			
		-- Заполнить данными список заданий панели Tasks
		local task_list = #()
		local main_items = #()
		local item_index = 0
		local cur_sel = undefined
		local work_group = ""

		-- Индекс выделенного элемента в стике
		if CatalogListMain.SelectedItems.Count != 0 then cur_sel = CatalogListMain.SelectedItems.Item[0].Index
		
		-- Проверка сортировки
		-- if Sort then task_list = MD_Data.SortTasks
		-- else task_list = MD_Data.Tasks

		for task in MD_Data.Tasks do
		(
			dn_list_item = dotNetObject "System.Windows.Forms.ListViewItem" task.Article
			dn_list_item.Checked = false
			dn_list_item.ForeColor = DN_CLR_DEFAULT
			dn_list_item.SubItems.add "" -- state (index = 1)

			-- Есть ли группа
			-- if (MD_Data.ActiveTask != undefined and task.State == STATES[2]) or \
			-- (MD_Data.ActiveTask != undefined and task.State == STATES[1] and MD_Data.InWorkTask != undefined and task.Group != undefined and task.Group == MD_Data.InWorkTask.Group) then
			-- (
			-- 	-- dn_list_item.ForeColor = DN_CLR_INWORK
			-- 	dn_list_item.ForeColor = DN_CLR_DEFAULT
			-- 	dn_list_item.Font = DN_FNT_GRP
				
			-- 	if task.Article == MD_Data.ActiveTask.Article then
			-- 	(
			-- 		MD_Data.InWorkTask = task
			-- 		dn_list_item.SubItems.add STATES[2]	
			-- 		MD_Data.CreateWorkLayer()				
			-- 	)
			-- 	else dn_list_item.SubItems.add ""
			-- )
			-- else dn_list_item.SubItems.add ""

			-- Добавить состояние
			if task.State == STATES[2] then
			(
				dn_list_item.SubItems.Item[1].Text = STATES[2]
			)

			-- Добавить название группы
			if task.Group != undefined then 
			(
				dn_list_item.SubItems.add task.Group
				if task.State == STATES[2] then work_group = task.Group
			)
			else dn_list_item.SubItems.add ""

			-- Transformation
			-- if task.SizeTrans != undefined then dn_list_item.SubItems.add "•" -- alt+0149
			if task.SizeTrans != undefined then dn_list_item.SubItems.add "True"
			else dn_list_item.SubItems.add ""

			-- User name
			if task.UserName != undefined then dn_list_item.SubItems.add task.UserName
			else dn_list_item.SubItems.add ""
			
			-- Отметить элемент как выделенный
			if cur_sel == item_index then dn_list_item.Selected = true

			-- Добавить к основному списку элементов
			append main_items dn_list_item

			item_index += 1
			try dn_list_item.tag = item_index catch()

			try MD_Data.CreateWorkLayer() catch()
		)

		-- Замена шрифта
		for i = 1 to main_items.Count do
		(
			if (work_group != "" and main_items[i].SubItems.Item[2].Text == work_group) or main_items[i].SubItems.Item[1].Text == STATES[2] then
			(
				main_items[i].Font = DN_FNT_GRP
			)
		)

		-- Заполнить основной список панели Tasks (задания)
		CatalogListMain.Items.Clear()
		CatalogListMain.Items.AddRange main_items
		CatalogListMain.Update()

		main_items = #()
		free main_items
		task_list = #()
		free task_list
	),

	fn FillCategoriesLists =
	(
		Categories.Items = MD_Data.main_categs
		try SubCategories.Items = MD_Data.sub_categs[Categories.Selection]
		catch(SubCategories.Items = #())
	),
	
	fn UpdateCatalogGeneralRlt =
	(
		try
		(
			GeneralCatalogRoll.btn_main_mesh.text = "Set Main Mesh"
			GeneralCatalogRoll.btn_add_mesh.text = "Set Add Mesh"
			GeneralCatalogRoll.btn_vis_switch.text = "Show All Layers"

			for ctrl in GeneralCatalogRoll.Controls do ctrl.enabled = false
			GeneralCatalogRoll.grp_01.enabled = true
			GeneralCatalogRoll.grp_02.enabled = true
			GeneralCatalogRoll.grp_03.enabled = true
			GeneralCatalogRoll.grp_04.enabled = true

			local objs = #()

			if (MD_Data.ActiveTask != undefined and MD_Data.WorkLayer != undefined and MD_Data.ActiveTask.State == STATES[2]) or \
			(MD_Data.ActiveTask != undefined and MD_Data.ActiveTask.Group != undefined and MD_Data.InWorkTask != undefined and MD_Data.ActiveTask.Group == MD_Data.InWorkTask.Group) then
			-- if MD_Data.ActiveTask != undefined and MD_Data.WorkLayer != undefined and MD_Data.ActiveTask == MD_Data.InWorkTask then
			(
				GeneralCatalogRoll.btn_vis_switch.enabled = true
				MD_Data.WorkLayerNodes = GetAllLayerNodes MD_Data.WorkLayer.Name

				objs = for obj in (objects as array) where (findItem MD_Data.TempLayerNodes obj == 0) collect obj

				-- Пивот
				GeneralCatalogRoll.btn_set_pivot.enabled = true

				-- Режим редактирования иконки
				if MD_Data.ActiveCategoryIcon.Icon != undefined then
				GeneralCatalogRoll.btn_edit_icon.enabled = true

				-- Основной меш
				if MD_Data.InWorkTask.MainMesh != undefined and not MD_Data.InWorkTask.MainMesh.IsDeleted then
				(
					GeneralCatalogRoll.btn_main_mesh.text = "Main Mesh •"
					if MD_Data.InWorkTask.ActiveMeshIndex == 1 and selection.count == 1 and selection[1] == MD_Data.InWorkTask.MainMesh then 
					(
						-- GeneralCatalogRoll.btn_assign_mat.enabled = true
						GeneralCatalogRoll.btn_update_mat.enabled = true
						GeneralCatalogRoll.btn_set_texture.enabled = true
					)
					try GeneralCatalogRoll.btn_main_mesh.tooltip = ("Текущий объект: " + MD_Data.InWorkTask.MainMesh.Name + "\nДля удаления статуса главного объекта необходимо повторно нажать на кнопку.") catch()
				)
				else
				(
					GeneralCatalogRoll.btn_main_mesh.text = "Set Main Mesh"
					if SettingsRoll.ckbx_tooltips.Checked == true then
					GeneralCatalogRoll.btn_main_mesh.tooltip = MD_Tooltips.tools_cat_07_a
				)

				-- Если задание имеет поле трансформации
				if MD_Data.InWorkTask.SizeTrans != undefined then 
				(

					GeneralCatalogRoll.btn_mesh_switch.enabled = true

					if MD_Data.InWorkTask.ActiveMeshIndex == 2 then
					GeneralCatalogRoll.btn_mesh_switch.text = "<< Switch To Main Mesh"	
					else GeneralCatalogRoll.btn_mesh_switch.text = ">> Switch To Additional Mesh"

					if (selection.count == 1 and \
						SuperClassOf selection[1] == GeometryClass and \
						findItem MD_Data.WorkLayerNodes selection[1] != 0) then
					(
						if MD_Data.InWorkTask.ActiveMeshIndex == 2 then
						(
							GeneralCatalogRoll.btn_mesh_switch.text = "<< Switch To Main Mesh"
							GeneralCatalogRoll.btn_add_mesh.enabled = true		
						)
						else
						(
							GeneralCatalogRoll.btn_mesh_switch.text = ">> Switch To Additional Mesh"
							GeneralCatalogRoll.btn_main_mesh.enabled = true
							GeneralCatalogRoll.btn_clear.enabled = true
							if MD_Data.InWorkTask.AddMesh == undefined or MD_Data.InWorkTask.AddMesh.IsDeleted then
							GeneralCatalogRoll.btn_add_mesh.enabled = true
						)
					)

					-- Доп. меш
					if MD_Data.InWorkTask.AddMesh != undefined and not MD_Data.InWorkTask.AddMesh.IsDeleted then
					(
						GeneralCatalogRoll.btn_add_mesh.text = "  Add Mesh •"
						if MD_Data.InWorkTask.ActiveMeshIndex == 2 and selection.count == 1 and selection[1] == MD_Data.InWorkTask.AddMesh then 
						(
							-- GeneralCatalogRoll.btn_assign_mat.enabled = true
							GeneralCatalogRoll.btn_update_mat.enabled = true
							GeneralCatalogRoll.btn_set_texture.enabled = true
						)
						try GeneralCatalogRoll.btn_add_mesh.tooltip = ("Текущий объект: " + MD_Data.InWorkTask.AddMesh.Name + "\nДля удаления статуса дополнительного объекта необходимо повторно нажать на кнопку.") catch()
					)
					else(
						GeneralCatalogRoll.btn_add_mesh.text = "Set Add Mesh"
						if SettingsRoll.ckbx_tooltips.Checked == true then
						GeneralCatalogRoll.btn_add_mesh.tooltip = MD_Tooltips.tools_cat_07_b
					)
				)
				-- Если задание НЕ имеет поле трансформации
				else
				(
					MD_Data.InWorkTask.ActiveMeshIndex = 1

					if (selection.count == 1 and \
						SuperClassOf selection[1] == GeometryClass and \
						findItem MD_Data.WorkLayerNodes selection[1] != 0) then
					(
						GeneralCatalogRoll.btn_main_mesh.enabled = true
						GeneralCatalogRoll.btn_clear.enabled = true
						if MD_Data.InWorkTask.MainMesh == 1 and selection[1] == MD_Data.InWorkTask.MainMesh then 
						(
							-- GeneralCatalogRoll.btn_assign_mat.enabled = true
							GeneralCatalogRoll.btn_update_mat.enabled = true
							GeneralCatalogRoll.btn_set_texture.enabled = true
						)
					)
				)
				
				-- Сохранить работу
				if (MD_Data.WorkLayer != undefined and MD_Data.WorkLayerNodes.count != 0) then
				(
					GeneralCatalogRoll.btn_save_work.enabled = true
					GeneralCatalogRoll.btn_clear.enabled = true
					GeneralCatalogRoll.btn_export.enabled = true
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
					GeneralCatalogRoll.btn_attach_to_task.enabled = true
				)

				-- Загрузить работу
				if MD_Data.InWorkTask.SavedWorks.count != 0 then
				(
					GeneralCatalogRoll.btn_load_work.enabled = true
					GeneralCatalogRoll.btn_work_list.enabled = true
				)
			)

			free MD_Data.WorkLayerNodes
			free objs
		)catch()
	),

	fn UpdateCatalogToolsRlt = 
	(
		-- for ctrl in ToolsCatalogRoll.Controls do ctrl.enabled = false
		if TasksCatalogRoll.lst_sub_catalog.selection != 0 then
		ToolsCatalogRoll.btn_create_icon.enabled = true
	),

	fn FillAddList =
	(
		local add_items = #()
		local tex_count = 0
		-- Материалы
		try
		(
			for mat in MD_Data.ActiveTask.Materials do
			(
				dn_list_item = dotNetObject "System.Windows.Forms.ListViewItem" mat.MatIndex
				dn_list_item.ForeColor = DN_CLR_DEFAULT

				tex_count = 0
				
				for t in mat.textures where t != undefined do tex_count += 1
				if tex_count != 0 then dn_list_item.SubItems.add (tex_count as string)

				-- Добавить к доп. списку элементов
				append add_items dn_list_item
			)					
		)
		catch()

		-- Заполнить доп. список панели Tasks (материалы)
		CatalogListAdd.Items.Clear()
		CatalogListAdd.Items.AddRange add_items
		CatalogListAdd.Update()

		add_items = #()
		free add_items
	),

	fn UpdateCatalogInfoRlt =
	(
		case MD_Data.ActiveList of
		(
			1:(
				InfoCatalogRoll.title = "Info"

				if MD_Data.ActiveTask != undefined then
				(
					try (
						if MD_Data.ActiveTask.RefBitmap != undefined then
						InfoCatalogPreview.bitmap = MD_Data.ActiveTask.RefBitmap
					) 
					catch()
					
					try (
						InfoCatalogWeb.text = ""
						InfoCatalogWeb.text = substring MD_Data.ActiveTask.Website 1 28
						InfoCatalogWeb.address = MD_Data.ActiveTask.Website
						
					) catch()

					try (
						LabelSizeText = ""
						LabelSizeText += ("W: " + (MD_Data.ActiveTask.Size[1] as float) as string + "    ")
						LabelSizeText += ("D: " + (MD_Data.ActiveTask.Size[2] as float) as string + "    ")
						LabelSizeText += ("H: " + (MD_Data.ActiveTask.Size[3] as float) as string)
						
					) catch()

					try (
						LabelAddSizeText = ""
						LabelAddSizeText += ("W: " + (MD_Data.ActiveTask.SizeTrans[1] as float) as string + "    ")
						LabelAddSizeText += ("D: " + (MD_Data.ActiveTask.SizeTrans[2] as float) as string + "    ")
						LabelAddSizeText += ("H: " + (MD_Data.ActiveTask.SizeTrans[3] as float) as string)
					) catch()

					
					InfoCatalogRoll.lbl_size.visible = true
					InfoCatalogRoll.lbl_size_txt.visible = true
					InfoCatalogRoll.lbl_site.visible = true
					InfoCatalogRoll.hpl_site.visible = true
					InfoCatalogRoll.hpl_site.text = ""

					try (InfoCatalogRoll.hpl_site.address = MD_Data.ActiveTask.WebSite) catch()

					case MD_Data.ActiveTask.ActiveMeshIndex of
					(
						1:(
							InfoCatalogRoll.lbl_size_txt.text = LabelSizeText
						)
						2:(
							InfoCatalogRoll.lbl_size_txt.text = LabelAddSizeText
						)
					)

					try (InfoCatalogRoll.hpl_site.text = substring MD_Data.ActiveTask.Website 1 28) catch()
					try InfoCatalogRoll.title = MD_Data.ActiveTask.Article catch()
					try InfoCatalogRoll.height = 280 catch()				
				)
			)
			2:(
				InfoCatalogRoll.hpl_site.text = ""
				if MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].RefBitmap != undefined then
				(
					InfoCatalogPreview.bitmap = MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].RefBitmap
					try (InfoCatalogRoll.hpl_site.address = MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].WebSite) catch()
					try (InfoCatalogRoll.hpl_site.text = substring MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].WebSite 1 28) catch()
				)
				InfoCatalogRoll.title = MD_Data.ActiveTask.Article + "  [Material-" + MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].MatIndex + "]"
				InfoCatalogRoll.lbl_size_txt.visible = false
				InfoCatalogRoll.height = 280
			)
		)
	),

	fn UpdateCatalogTasksRlt =
	(
		TasksCatalogRoll.btn_get.enabled = false
		TasksCatalogRoll.btn_clear.enabled = false
		TasksCatalogRoll.btn_assign_mat_id.enabled = false	
		TasksCatalogRoll.btn_assign_texts.enabled = false

		if MD_Data.ActiveTask == undefined then
		(
			for ctrl in TasksCatalogRoll.Controls do ctrl.enabled = false
			for ctrl in InfoCatalogRoll.Controls do ctrl.enabled = false
			for ctrl in GeneralCatalogRoll.Controls do ctrl.enabled = false

			TasksCatalogRoll.btn_work_state.text = "Set Work State"
			InfoCatalogPreview.bitmap = EMPTY_PREVIEW
			InfoCatalogWeb.text = ""
			InfoCatalogWeb.address = ""
			InfoCatalogSize.text = ""

			-- TasksCatalogRoll.lst_sections.enabled = true
			TasksCatalogRoll.lst_basic_catalog.enabled = true
			TasksCatalogRoll.lst_sub_catalog.enabled = true
			CatalogListMain.enabled = true
			CatalogListAdd.enabled = true
			if MD_Data.TempArticlesList.Count != 0 then TasksCatalogRoll.btn_clear.enabled = true

		)
		else
		(
			TasksCatalogRoll.btn_work_state.enabled = true
			if (MD_Data.InWorkTask != undefined and MD_Data.ActiveTask.Article != MD_Data.InWorkTask.Article and MD_Data.ActiveTask.Group == undefined) or \
			(MD_Data.InWorkTask == undefined and (MD_Data.ActiveTask.Group == undefined or MD_Data.ActiveTask.Group != undefined)) or \
			(MD_Data.InWorkTask != undefined and MD_Data.ActiveTask != MD_Data.InWorkTask and MD_Data.ActiveTask.Group != MD_Data.InWorkTask.Group) then
			(
				TasksCatalogRoll.btn_work_state.text = "Set Work State"
				TasksCatalogRoll.btn_exit_work_state.enabled = false
				for ctrl in GeneralCatalogRoll.Controls do ctrl.enabled = false
				-- for ctrl in GeneralProjectsRoll.Controls do ctrl.enabled = false
			)
			else if (MD_Data.InWorkTask != undefined and MD_Data.ActiveTask.Article == MD_Data.InWorkTask.Article and MD_Data.ActiveTask.Group == undefined) or \
			
			(MD_Data.InWorkTask != undefined and MD_Data.ActiveTask.Article == MD_Data.InWorkTask.Article and MD_Data.ActiveTask.Group == MD_Data.InWorkTask.Group) then
			(
				TasksCatalogRoll.btn_work_state.text = "Update Work State"
				TasksCatalogRoll.btn_work_state.enabled = true
				TasksCatalogRoll.btn_exit_work_state.enabled = true
				TasksCatalogRoll.btn_get.enabled = false
				TasksCatalogRoll.btn_clear.enabled = false
				TasksCatalogRoll.btn_get.text = "Get"
				TasksCatalogRoll.btn_clear.text = "Clear"
				if SettingsRoll.ckbx_tooltips.Checked == true then
				TasksCatalogRoll.btn_get.tooltip = MD_Tooltips.tasks_02_a
				if SettingsRoll.ckbx_tooltips.Checked == true then
				TasksCatalogRoll.btn_clear.tooltip = MD_Tooltips.tasks_03_a
				
				-- Material ID и текстуры
				if MD_Data.ActiveList == 2 then
				(
					TasksCatalogRoll.btn_assign_texts.enabled = true
					if subobjectLevel == 4 or subobjectLevel == 5 then TasksCatalogRoll.btn_assign_mat_id.enabled = true			
					else if subobjectLevel == 0 or subobjectLevel == undefined then TasksCatalogRoll.btn_assign_mat_id.enabled = false
				)
			)
			else if (MD_Data.InWorkTask != undefined and MD_Data.ActiveTask.Article != MD_Data.InWorkTask.Article and MD_Data.ActiveTask.Group == MD_Data.InWorkTask.Group) then
			(
				TasksCatalogRoll.btn_work_state.text = "Set Work State"
				TasksCatalogRoll.btn_work_state.enabled = true
				TasksCatalogRoll.btn_exit_work_state.enabled = true
			)
			for ctrl in InfoCatalogRoll.Controls do ctrl.enabled = true
			
			try (CatalogListMain.Items.Item[MD_Data.ActiveTaskIndex - 1].Selected = True) catch()
		)

		if MD_Data.TempArticlesList.count != 0 then
		(
			TasksCatalogRoll.btn_work_state.enabled = false
			TasksCatalogRoll.btn_exit_work_state.enabled = false

			for ctrl in GeneralCatalogRoll.Controls do ctrl.enabled = false

			case MD_Client.ActiveCheckParam of
			(
				1:(
					TasksCatalogRoll.btn_get.text = "Get"
					if SettingsRoll.ckbx_tooltips.Checked == true then
					TasksCatalogRoll.btn_get.tooltip = MD_Tooltips.tasks_02_a
				)
				2:(
					TasksCatalogRoll.btn_get.text = "Send"
					if SettingsRoll.ckbx_tooltips.Checked == true then
					TasksCatalogRoll.btn_get.tooltip = MD_Tooltips.tasks_02_b
				)
				3:(
					TasksCatalogRoll.btn_get.text = "Backup"
					if SettingsRoll.ckbx_tooltips.Checked == true then
					TasksCatalogRoll.btn_get.tooltip = MD_Tooltips.tasks_02_c
				)
				4:
				(
					TasksCatalogRoll.btn_get.text = "Restore"
					if SettingsRoll.ckbx_tooltips.Checked == true then
					TasksCatalogRoll.btn_get.tooltip = MD_Tooltips.tasks_02_d
				)
			)
			TasksCatalogRoll.btn_clear.text = "Clear"
			if SettingsRoll.ckbx_tooltips.Checked == true then
			TasksCatalogRoll.btn_clear.tooltip = MD_Tooltips.tasks_03_a
		)
		else
		(
			TasksCatalogRoll.btn_get.text = "Update"
			if SettingsRoll.ckbx_tooltips.Checked == true then
			TasksCatalogRoll.btn_get.tooltip = MD_Tooltips.tasks_02_e
			TasksCatalogRoll.btn_clear.text = "Delete"
			if SettingsRoll.ckbx_tooltips.Checked == true then
			TasksCatalogRoll.btn_clear.tooltip = MD_Tooltips.tasks_03_b
		)

		if MD_Data.CheckedTasks.Count > 0 then
		(
			TasksCatalogRoll.btn_get.enabled = true
			TasksCatalogRoll.btn_clear.enabled = true
			TasksCatalogRoll.btn_work_state.enabled = false
			TasksCatalogRoll.btn_exit_work_state.enabled = false
		)

		if SubCategories.Items.Count != 0 then
		(
			TasksCatalogRoll.lst_basic_catalog.enabled = true
			TasksCatalogRoll.lst_sub_catalog.enabled = true
			TasksCatalogRoll.btn_check.enabled = true
		)

		-- Обновить текст веб ссылки (баг макса)
		try
		(
			InfoCatalogWeb.text = ""
			InfoCatalogWeb.text = substring MD_Data.ActiveTask.Website 1 28
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

		CatalogListMain.Items.Clear()
		CatalogListMain.Items.AddRange main_items
		CatalogListMain.Update()

		CatalogListAdd.Items.Clear()
		CatalogListAdd.Update()
	),

	fn SwitchRollouts = (
		-- Переключает роллоуты в зависимости от того, какой раздел выбран
		try MD_Callbacks.Destruct() catch()
		-- windows.sendmessage (windows.getmaxhwnd()) 0x000B 0 0
		-- removeSubRollout MainRoll.sub_rlt GeneralProjectsRoll
		-- removeSubRollout MainRoll.sub_rlt InfoProjectsRoll
		-- removeSubRollout MainRoll.sub_rlt TasksProjectsRoll

		AddSubRollout MainRoll.sub_rlt TasksCatalogRoll rolledUp:false
		AddSubRollout MainRoll.sub_rlt InfoCatalogRoll rolledUp:true
		AddSubRollout MainRoll.sub_rlt ToolsCatalogRoll rolledUp:true
		AddSubRollout MainRoll.sub_rlt GeneralCatalogRoll rolledUp:true
        AddSubRollout MainRoll.sub_rlt AboutRoll rolledUp:True
		MD_Data.FullUpdate()

		-- Выравнить подроллаут
		MainRoll.sub_rlt.height = (MAIN_RLT_HEIGHT - 28)
		MainRoll.sub_rlt.pos = [2, 4]

		-- windows.sendmessage (windows.getmaxhwnd()) 0x000B 1 0

		-- updateRolloutLayout TasksProjectsRoll forceUpdate:true
		updateRolloutLayout TasksCatalogRoll forceUpdate:true

	),

	fn Close = (
		-- Удаляет главный роллаут, если он ткрыт

		try(cui.UnRegisterDialogBar ::rlt_make_design_tools)catch()
		try(destroyDialog ::rlt_make_design_tools)catch()
	),

	fn SetColorScheme =
	(
		-- Определить текущую тему 3ds Max
		-- get_max_ui_bg_color()
		local color_theme = colorMan.getColorTheme()

		-- DN_MAX_UI_CLR = (dotNetClass "system.Drawing.color").FromArgb 255 MAX_UI_BG_COLOR.r MAX_UI_BG_COLOR.g MAX_UI_BG_COLOR.b

		if color_theme == #light then
		(
			-- Если тема светлая
			DN_CLR_X = (dotNetClass "system.Drawing.color").FromArgb 255 200 50 50
			DN_CLR_OK = (dotNetClass "system.Drawing.color").FromArgb 255 10 130 10
			DN_MAX_UI_CLR = (dotNetClass "system.Drawing.color").FromArgb 255 214 214 214
		)
		else if color_theme == #dark then
		(
			-- Если тема тёмная
			DN_CLR_X = (dotNetClass "system.Drawing.color").FromArgb 255 255 90 50
			DN_CLR_OK = (dotNetClass "system.Drawing.color").FromArgb 255 55 200 55
			DN_MAX_UI_CLR = (dotNetClass "system.Drawing.color").FromArgb 255 68 68 68
		)
	),

	fn Init = (
		local exist_categ_index = undefined
		local exist_sub_categ_index = undefined

		Close()
		-- Установить цветовую схему
		SetColorScheme()
		
		createdialog MainRoll width:(MAIN_RLT_WIDTH + 8) height:(MAIN_RLT_HEIGHT - 20) autoLayoutOnResize:true scrollBar:#on lockHeight:false

		AddSubRollout MainRoll.sub_rlt SettingsRoll rolledUp:true
		AddSubRollout MainRoll.sub_rlt TasksCatalogRoll rolledUp:true
		AddSubRollout MainRoll.sub_rlt InfoCatalogRoll rolledUp:true
		try AddSubRollout MainRoll.sub_rlt ToolsCatalogRoll rolledUp:true catch()
		AddSubRollout MainRoll.sub_rlt GeneralCatalogRoll rolledUp:true

		-- AddSubRollout MainRoll.sub_rlt TasksProjectsRoll rolledUp:true
		-- AddSubRollout MainRoll.sub_rlt InfoProjectsRoll rolledUp:true
		-- AddSubRollout MainRoll.sub_rlt GeneralProjectsRoll rolledUp:true

		AddSubRollout MainRoll.sub_rlt AboutRoll rolledUp:true
		
		-- Инициализация входных значений
        try(
            GetINISettings SettingsRoll MDT_CONFIG_FILE SettingsRoll.name
            GetINISettings TasksCatalogRoll MDT_CONFIG_FILE TasksCatalogRoll.name include_list:#(TasksCatalogRoll.lst_basic_catalog, TasksCatalogRoll.lst_sub_catalog)
            GetINISettings InfoCatalogRoll MDT_CONFIG_FILE InfoCatalogRoll.name onlyRollState:true
            -- GetINISettings ToolsCatalogRoll MDT_CONFIG_FILE ToolsCatalogRoll.name onlyRollState:true
            -- GetINISettings GeneralCatalogRoll MDT_CONFIG_FILE GeneralCatalogRoll.name onlyRollState:true
            GetINISettings ToolsCatalogRoll MDT_CONFIG_FILE ToolsCatalogRoll.name
            GetINISettings GeneralCatalogRoll MDT_CONFIG_FILE GeneralCatalogRoll.name
        )catch ()
		
		if MD_Data.main_categs.count != 0 then
		(
			exist_categ_index = execute (GetINISetting MDT_CONFIG_FILE TasksCatalogRoll.Name "lst_basic_catalog_selection")
			if classOf exist_categ_index != Integer then exist_categ_index = 1
		)

		if MD_Data.sub_categs.count != 0 then
		(
			exist_sub_categ_index = execute (GetINISetting MDT_CONFIG_FILE TasksCatalogRoll.Name "lst_sub_catalog_selection")
			if classOf exist_sub_categ_index != Integer then exist_sub_categ_index = 1
		)

		-- Try select active task
		-- try (
			exist_task_index = execute (GetINISetting MDT_CONFIG_FILE TasksCatalogRoll.Name (CatalogListMain.name + "_selection"))
			if classOf exist_task_index == Integer then
			(
				exist_task_index += 1
				MD_Data.ActiveTaskIndex = exist_task_index
				MD_Data.ActiveTask = MD_Data.Tasks[exist_task_index]				
			)

		-- ) catch()

		try (
			if exist_categ_index > 0 then Categories.Selection = MD_Data.ActiveCategory = exist_categ_index
			else if exist_categ_index == 0 and MD_Data.main_categs.count != 0 then Categories.Selection = MD_Data.ActiveCategory = 1
			
			if exist_sub_categ_index > 0 then SubCategories.Selection = MD_Data.ActiveSubCategory = exist_sub_categ_index
			else if exist_sub_categ_index == 0 and MD_Data.sub_categs.count != 0 then SubCategories.Selection = MD_Data.ActiveSubCategory = 1
		)
		catch()

		try(
			EMPTY_PREVIEW = CreatePreviewFromImageFile ICON_NO_PRVIEW_FILE PREVIEW_SIZE
			InfoCatalogPreview.bitmap = EMPTY_PREVIEW
		)
		catch (MD_Log.Error "Не удалось загрузить изображение \"NO PREVIEW\".")

		-- Тултипы
		if SettingsRoll.ckbx_tooltips.Checked == false then
		(
			for ctrl in SettingsRoll.Controls do try(ctrl.tooltip = "")catch()
			for ctrl in TasksCatalogRoll.Controls do try(ctrl.tooltip = "")catch()
			for ctrl in InfoCatalogRoll.Controls do try(ctrl.tooltip = "")catch()
			try (for ctrl in ToolsCatalogRoll.Controls do try(ctrl.tooltip = "")catch()) catch()
			for ctrl in GeneralCatalogRoll.Controls do try(ctrl.tooltip = "")catch()
			-- for ctrl in GeneralProjectsRoll.Controls do try(ctrl.tooltip = "")catch()
		)
		SettingsRoll.ckbx_tooltips.tooltip = "Требуется перезагрузка."
		
		MD_Data.Update()
		
		this.InitCatalogLists()
		this.FillCategoriesLists()
		this.FillMainList()
		this.FillAddList()

		-- try MD_Callbacks.Destruct() catch()
		-- AddSubRollout MainRoll.sub_rlt TasksCatalogRoll rolledUp:false
		-- AddSubRollout MainRoll.sub_rlt InfoCatalogRoll rolledUp:true
		-- AddSubRollout MainRoll.sub_rlt ToolsCatalogRoll rolledUp:true
		-- AddSubRollout MainRoll.sub_rlt GeneralCatalogRoll rolledUp:true
        -- AddSubRollout MainRoll.sub_rlt AboutRoll rolledUp:True
		-- MD_Data.FullUpdate()

		-- Выравнить подроллаут
		MainRoll.sub_rlt.height = (MAIN_RLT_HEIGHT - 28)
		MainRoll.sub_rlt.pos = [2, 4]
		updateRolloutLayout TasksCatalogRoll forceUpdate:true

		MD_Data.LoadState = true
		-- UpdateCatalogTasksRlt()
		this.UpdateCatalogInfoRlt()
		-- UpdateCatalogGeneralRlt()
	),
	
	on create do Init()
)