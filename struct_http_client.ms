
struct HTTPClient
(
	ResponseStatus,
	ResponseMessage,
	ResponseData,
	ActiveCheckParam = 1,
	RequestDialogTitle,
	RequestDialogShow = True,

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
		for rd in this.ResponseData do 
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

    fn Request request args:"" title:"" show_dialog:True =
    (
		this.ResponseStatus = undefined
		this.ResponseMessage = undefined
		this.ResponseData = undefined

		if DoesFileExist HTTP_CLIENT then
		(
			this.RequestDialogShow = show_dialog
			this.RequestDialogTitle = title
			shellLaunch HTTP_CLIENT (request + " " + args)
			CreateDialog MD_UI.Dialogs.Request modal:true
		)
		else 
		(
			this.ResponseMessage = "Не удалось обнаружить http-клиент."
			Client_Log.Error this.ResponseMessage
		)
    )
)