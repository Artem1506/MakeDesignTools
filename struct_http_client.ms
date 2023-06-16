
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