rollout dlg_configure "Configure User Data" width:400 height:210
(
    local login, password
    local result_sum = 0
    local cur_md_lib

    Label 'lbl_6' "Local Database Dir: " width:92 offset:[8, 14] align:#left across:3
    editText 'etxt_local_dir' "" width:198 height:20 offset:[-20, 12] align:#left
    Button 'btn_md_lib_dir' "Browse" width:64 height:CTRL_HEIGHT_1 offset:[0, 11] align:#right
    
    Label 'lbl_8' "MD Login:" width:48 offset:[55, 2] align:#left across:2
    editText 'etxt_log' "" width:268 height:20 offset:[-2, 0] align:#right multiLine:false

    Label 'lbl_9' "MD Password:" width:68 offset:[33, 2] align:#left across:2
    editText 'etxt_pass' "" width:268 height:20 offset:[-2, 0] align:#right multiLine:false

    Label 'lbl_10' "Project Article:" width:70 offset:[30, 2] align:#left across:2
    editText 'etxt_proj_article' "" width:268 height:20 offset:[-2, 0] align:#right multiLine:false

    groupBox 'gbx_1' "" width:388 height:116 pos:[6, 2] align:#left

    button 'btn_confirm' "Confirm User Data" width:192 height:CTRL_HEIGHT_1 offset:[-7, 0] align:#left enabled:true across:2
    button 'btn_test' "Test Connection" width:192 height:CTRL_HEIGHT_1 offset:[7, 0] align:#right enabled:true
    button 'btn_get_data' "Get MakeDesign Data" width:388 height:CTRL_HEIGHT_2 offset:[0, -2] align:#center enabled:true

    Label 'lbl_info' "" width:388 offset:[-4, 2] align:#left across:3
    Label 'lbl_connect' "" width:388 offset:[168, 2] align:#left

    on dlg_configure open do
    (
        -- Установит положение диалога
        try(
            dialog_pos = execute (GetINISetting MDT_CONFIG_FILE dlg_configure.name "pos")
            SetDialogPos dlg_configure dialog_pos
        )catch()

        -- MD_Data.Init()
        etxt_local_dir.text = MD_LIB_DIR
        etxt_local_dir.tooltip = MD_LIB_DIR
        etxt_proj_article.text = MD_CURRENT_PROJECT

        -- Инициализация логина и пароля
        try(
            login = GetUserEnvVar "MD_USER_LOGIN"
            etxt_log.text = login
        )catch()
        try(
            password = GetUserEnvVar "MD_USER_PASS"
            etxt_pass.text = password
        )catch()

        -- Текущая директория локальной базы
        cur_md_lib = etxt_local_dir.text

        

        if etxt_log.text != "" and etxt_pass.text != "" then
        btn_test.enabled = true
    )

    on dlg_configure close do
    (
        -- Сохранить положение диалога
        SetINISetting MDT_CONFIG_FILE dlg_configure.name "pos" ((GetDialogPos dlg_configure) as string)
        SetUserEnvVar "MD_USER_LOGIN" etxt_log.text
        SetUserEnvVar "MD_USER_PASS" etxt_pass.text
    )

    on btn_md_lib_dir pressed do
    (
        -- Вызов диалогового окна для выбора директории локальной базы
        local dir = getSavePath caption:"Set MakeDesign data folder..." initialDir:MD_LIB_DIR
        
        if (dir == undefined) then etxt_local_dir.text = "" else 
        (
            SetUserEnvVar "MD_LIB_DIR" dir
            etxt_local_dir.text = dir
        )

        -- if (dir == undefined) then 
        -- (
        --     if etxt_local_dir.text == "" then 
        --         SetUserEnvVar "MD_LIB_DIR" ""
        --         -- etxt_local_dir.text = ""
        --         etxt_local_dir.tooltip = ""
        --         MD_Log.Error "Путь к локальной базе MakeDesign не определён."
        -- )
        -- else
        -- (
        --     result = SetUserEnvVar "MD_LIB_DIR" dir

        --     if result == "" then (MD_Log.Error "Путь к локальной базе MakeDesign не определён.")
        --     else 
        --     (
        --         MD_LIB_DIR = dir
        --         etxt_local_dir.text = dir
        --         etxt_local_dir.tooltip = dir

        --         MD_Callbacks.Destruct()
        --         try MD_Data.ClearWorkLayer() catch()
        --         try MD_Data.DeleteWorkLayer() catch()
        --         MD_Data.Init()
        --         MD_Data.Update()
        --         -- MD_Callbacks.Add()
        --         try MD_UI.UpdateCatalogTasksRlt() catch()

        --         if MD_Data.ActiveTask != undefined and MD_Data.InWorkTask != undefined and MD_Data.ActiveTask.Article == MD_Data.InWorkTask.Article then 
        --         MD_Data.ShowLayers mode:#work_only
        --         else MD_Data.ShowLayers mode:#scene_only
                
        --         -- Попытаться выбрать последнее активное задание
        --         if MD_Data.Tasks.Count != 0 then
        --         (
        --             local exist_task_index = undefined

        --             try (exist_task_index = execute (GetINISetting MDT_CONFIG_FILE MD_UI.TasksCatalogRoll.Name (MD_UI.CatalogListMain.name + "_selection")) + 1) catch()

        --             if exist_task_index != undefined and exist_task_index > 0 then
        --             (
        --                 MD_Data.ActiveTaskIndex = exist_task_index
        --                 MD_Data.ActiveTask = MD_Data.Tasks[exist_task_index]
        --             )

        --             WithoutRedraw MD_Data.Update
        --             WithoutRedraw MD_UI.Update               

        --             -- переключить видимость слоёв
        --             if MD_Data.ActiveTask != undefined and MD_Data.ActiveTask.State == STATES[2] then
        --             (
        --                 MD_Data.ShowLayers mode:#work_only
        --             )

        --             -- Попытаться загрузить последнюю сохранённую работу, если рабочий слой пустой
        --             if MD_UI.SettingsRoll.ckbx_load_last.checked then
        --             (
        --                 try(
        --                     if MD_Data.WorkLayerNodes.count == 0 then
        --                     (
        --                         MD_Data.InWorkTask.LoadWork \
        --                         MD_Data.InWorkTask.SavedWorks[MD_Data.InWorkTask.SavedWorks.count] quiet_mode:true
        --                         MD_Data.ShowLayers()
        --                     )
        --                 ) catch()            
        --             )
        --         )
        --         MD_Data.FullUpdate()

        --         MD_Log.Info ("Путь к локальной базе MakeDesign = " + result)
        --     )
        -- )
    )

    on etxt_log entered arg do
    (
        if etxt_log.text != "" and etxt_pass.text != "" then
        btn_test.enabled = true
        else btn_test.enabled = false
        updateRolloutLayout dlg_configure forceUpdate:true
        SetUserEnvVar "MD_USER_LOGIN" etxt_log.text
    )

    on etxt_pass entered arg do
    (
        if etxt_log.text != "" and etxt_pass.text != "" then
        btn_test.enabled = true
        else btn_test.enabled = false

        updateRolloutLayout dlg_configure forceUpdate:true
        SetUserEnvVar "MD_USER_PASS" etxt_pass.text
    )

    on etxt_local_dir entered arg do
    (
        SetUserEnvVar "MD_LIB_DIR" etxt_local_dir.text
    )

    on etxt_proj_article entered arg do
    (
        SetUserEnvVar "MD_CURRENT_PROJECT" etxt_proj_article.text
    )

    on btn_confirm pressed do 
    (
        SetUserEnvVar "MD_LIB_DIR" etxt_local_dir.text
        SetUserEnvVar "MD_USER_LOGIN" etxt_log.text
        SetUserEnvVar "MD_USER_PASS" etxt_pass.text
        SetUserEnvVar "MD_CURRENT_PROJECT" etxt_proj_article.text

        MD_Data.Init()
        lbl_info.text = "Ok"
    )

    on btn_test pressed do
    (
        MD_Client.Request "check_connection" show_dialog:false title:"Check Internet Connection"
        
        if MD_Client.ResponseStatus == "200" then 
        (
            if etxt_log.text != "" and etxt_pass.text != "" then
            -- btn_test.enabled = true
            Client_Log.Info MD_Client.ResponseMessage

            MD_Client.Request "test_request" title:"Authorization Test"
        
            if MD_Client.ResponseStatus == "200" then 
            (
                lbl_info.text = "INFO: " + MD_Client.ResponseMessage
                Client_Log.Info MD_Client.ResponseMessage
                btn_get_data.enabled = true
            )
            else 
            (
                lbl_info.text = "ERROR: " + MD_Client.ResponseMessage
                Client_Log.Error MD_Client.ResponseMessage
            )
        )
        else(
            lbl_info.text = "ERROR: " + MD_Client.ResponseMessage
            Client_Log.Error MD_Client.ResponseMessage
            -- btn_test.enabled = false
            btn_get_data.enabled = false
        )
    )

    on btn_get_data pressed do 
    (
        lbl_connect.text = ""
        
        SetUserEnvVar "MD_LIB_DIR" etxt_local_dir.text
        SetUserEnvVar "MD_USER_LOGIN" etxt_log.text
        SetUserEnvVar "MD_USER_PASS" etxt_pass.text
        SetUserEnvVar "MD_CURRENT_PROJECT" etxt_proj_article.text

        if etxt_local_dir.text != "" and etxt_log.text != "" and etxt_pass.text != "" and etxt_proj_article.text != ""  then
        (
            -- Запросить данные о пользователях MD

            MD_Client.Request "get_users_tree" args:("\"" + MD_USERS_DATA_FILE + "\"") title:"Get Users Data"

            if MD_Client.ResponseStatus == "200" then 
            (
                Client_Log.Info MD_Client.ResponseMessage
                lbl_info.text = "INFO: " + MD_Client.ResponseMessage
                result_sum += 1
            )
            else
            (
                Client_Log.Error MD_Client.ResponseMessage
                lbl_info.text = "ERROR: " + MD_Client.ResponseMessage
            )

            -- Запросить данные о проектах MD

            MD_Client.Request "get_projects_tree" args:("\"" + MD_PROJECTS_DATA_FILE + "\"") title:"Get Projects Data"

            if MD_Client.ResponseStatus == "200" then 
            (
                Client_Log.Info MD_Client.ResponseMessage
                lbl_info.text = "INFO: " + MD_Client.ResponseMessage
                result_sum += 1
            )
            else
            (
                Client_Log.Error MD_Client.ResponseMessage
                lbl_info.text = "ERROR: " + MD_Client.ResponseMessage
            )

            -- Запросить данные о каталоге текущего проекта MD

            MD_Client.Request "get_project_catalog" args:("\"" + MD_CURRENT_PROJECT + SEPAR + MD_CATALOG_DATA_FILE + "\"") title:("Get "+ MD_CURRENT_PROJECT + " Catalog Data")

            if MD_Client.ResponseStatus == "200" then 
            (
                Client_Log.Info MD_Client.ResponseMessage
                lbl_info.text = "INFO: " + MD_Client.ResponseMessage
                result_sum += 1
            )
            else
            (
                Client_Log.Error MD_Client.ResponseMessage
                lbl_info.text = "ERROR: " + MD_Client.ResponseMessage
            )

            if result_sum == 3 then 
            (
                destroyDialog dlg_configure
                
                MD_Data.CheckedTasks = #()
                MD_Callbacks.Destruct()
                MD_Data.Init()
                try (MD_UI.Categories.selection = 1) catch()
                try MD_Data.ActiveCategory = 1 catch()
                try MD_Data.ActiveSubCategory = 1 catch()
                try MD_UI.lst_sub_catalog.Items = MD_Data.sub_categs[MD_Data.ActiveCategory] catch()
                try MD_UI.lst_sub_catalog.selection = 1 catch()
                MD_Data.CheckedTasks = #()
                MD_Data.ActiveList = 1
                MD_Data.ActiveTaskAddIndex = 1
                MD_Data.FullUpdate()
                MD_UI.FillCategoriesLists()
                try MD_BBox.Update() catch()
                try (MD_UI.SubCategories.selection = 1) catch()
                MD_UI.UpdateCatalogTasksRlt()
                if MD_Data.ActiveTask == MD_Data.InWorkTask then MD_Data.ShowLayers mode:#work_only
                else MD_Data.ShowLayers mode:#scene_only
            )
            else if result_sum > 0 then
            (
                msg = "Не удалось загрузить некоторые данные."
                lbl_info.text = "WARNING: " + msg
                Client_Log.Warning msg
            ) 
            else
            (
                msg = "Данные не были загружены."
                lbl_info.text = "ERROR: " + msg
                Client_Log.Error msg
            )
        )
        else lbl_info.text = "WARNING: Необходимо заполнить все поля!"
    )
)