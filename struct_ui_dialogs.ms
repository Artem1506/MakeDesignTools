
struct UI_Dialogs
(
	Configure = dlg_configure,
	CheckTasks = dlg_check_tasks,
	PivotParams = dlg_pivot_params,
	LoadWork = dlg_load_work,
	Export = dlg_export,
	Request = dlg_request,
	EditMaterial = dlg_edit_material,

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

		if (queryBox "Действительно удалить отмеченные файлы?\n" title:"Внимание!" icon:#warning) then
		(
			for i = 0 to LoadWork.lv_files.Items.count - 1 do
			(
				if LoadWork.lv_files.Items.Item[i].Checked == true then
				(
					local index = LoadWork.lv_files.Items.Item[i].Index + 1
					max_file = MD_Data.ActiveTask.SavedWorks[index]
					prev_file = (trimRight max_file ".max") + ".jpg"
					mat_lib_file = (trimRight max_file ".max") + ".mat"
					
					deleteFile max_file
					deleteFile prev_file
					deleteFile mat_lib_file

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