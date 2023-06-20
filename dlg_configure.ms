rollout dlg_configure "Configure" width:400 height:164
(
    local login, password
    local result_sum = 0
    local cur_md_lib

    Label 'lbl_6' "Directory: " width:62 offset:[8, 20] align:#left across:3
    Label 'lbl_md_lib_dir' "" width:224 offset:[-58, 20] align:#left
    Button 'btn_md_lib_dir' "Browse" width:64 height:CTRL_HEIGHT_1 offset:[0, 16] align:#right

    Label 'lbl_8' "Login:" width:32 offset:[-132, 34] align:#right across:2
    editText 'etxt_log' "" width:160 height:20 offset:[-160, 32] align:#right multiLine:false

    Label 'lbl_9' "Password:" width:48 offset:[-136, 2] align:#right across:2
    editText 'etxt_pass' "" width:160 height:20 offset:[-160, 0] align:#right multiLine:false

    button 'btn_test' "Authorization Test" width:150 height:CTRL_HEIGHT_1 offset:[-2, -51] align:#right enabled:false
    button 'btn_get_struct' "Get MakeDesign Data" width:150 height:CTRL_HEIGHT_1 offset:[-2, -2] align:#right enabled:false

    Label 'lbl_info' "" width:388 offset:[-4, 12] align:#left across:3
    Label 'lbl_connect' "" width:388 offset:[168, 12] align:#left

    groupBox 'gbx_1' " Local Base " width:388 height:50 pos:[6, 4] align:#left
    groupBox 'gbx_2' " Remote Base " width:388 height:82 pos:[6, 56] align:#left

    on dlg_configure open do
    (
        -- Установит положение диалога
        try(
            dialog_pos = execute (GetINISetting MDT_CONFIG_FILE dlg_configure.name "pos")
            SetDialogPos dlg_configure dialog_pos
        )catch()

        -- Инициализация пути к локальной базе 
        try MD_LIB_DIR = GetUserEnvVar "MD_LIB_DIR" catch ()
        
        lbl_md_lib_dir.text = MD_LIB_DIR
        lbl_md_lib_dir.tooltip = MD_LIB_DIR

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
        cur_md_lib = lbl_md_lib_dir.text

        MD_Client.Request "check_connection" show_dialog:false title:"Check Internet Connection"
        
        if MD_Client.ResponseStatus == "200" then 
        (
            if etxt_log.text != "" and etxt_pass.text != "" then
            -- btn_test.enabled = true
            Client_Log.Info MD_Client.ResponseMessage
        )
        else(
            lbl_info.text = "ERROR: " + MD_Client.ResponseMessage
            Client_Log.Error MD_Client.ResponseMessage
            -- btn_test.enabled = false
            btn_get_struct.enabled = false
        )

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

        if (dir == undefined) then 
        (
            SetUserEnvVar "MD_LIB_DIR" ""
            lbl_md_lib_dir.text = ""
            lbl_md_lib_dir.tooltip = lbl_md_lib_dir.text
            MD_Log.Error "Путь к локальной базе MakeDesign не определён."
        )
        else
        (
            result = SetUserEnvVar "MD_LIB_DIR" dir

            if result == "" then (MD_Log.Error "Путь к локальной базе MakeDesign не определён.")
            else 
            (
                MD_LIB_DIR = dir
                lbl_md_lib_dir.text = dir
                lbl_md_lib_dir.tooltip = dir

                MD_Callbacks.Destruct()
                try MD_Data.ClearWorkLayer() catch()
                try MD_Data.DeleteWorkLayer() catch()
                MD_Data.Init()
                MD_Data.Update()
                -- MD_Callbacks.Add()
                try MD_UI.UpdateCatalogTasksRlt() catch()

                if MD_Data.ActiveTask != undefined and MD_Data.InWorkTask != undefined and MD_Data.ActiveTask.Article == MD_Data.InWorkTask.Article then 
                MD_Data.ShowLayers mode:#work_only
                else MD_Data.ShowLayers mode:#scene_only
                
                -- Попытаться выбрать последнее активное задание
                if MD_Data.Tasks.Count != 0 then
                (
                    local exist_task_index = undefined

                    try (exist_task_index = execute (GetINISetting MDT_CONFIG_FILE MD_UI.TasksCatalogRoll.Name (MD_UI.CatalogListMain.name + "_selection")) + 1) catch()

                    if exist_task_index != undefined and exist_task_index > 0 then
                    (
                        MD_Data.ActiveTaskIndex = exist_task_index
                        MD_Data.ActiveTask = MD_Data.Tasks[exist_task_index]
                    )

                    WithoutRedraw MD_Data.Update
                    WithoutRedraw MD_UI.Update               

                    -- переключить видимость слоёв
                    if MD_Data.ActiveTask != undefined and MD_Data.ActiveTask.State == STATES[2] then
                    (
                        MD_Data.ShowLayers mode:#work_only
                    )

                    -- Попытаться загрузить последнюю сохранённую работу, если рабочий слой пустой
                    if MD_UI.SettingsRoll.ckbx_load_last.checked then
                    (
                        try(
                            if MD_Data.WorkLayerNodes.count == 0 then
                            (
                                MD_Data.InWorkTask.LoadWork \
                                MD_Data.InWorkTask.SavedWorks[MD_Data.InWorkTask.SavedWorks.count] quiet_mode:true
                                MD_Data.ShowLayers()
                            )
                        ) catch()            
                    )
                )
                MD_Data.FullUpdate()

                MD_Log.Info ("Путь к локальной базе MakeDesign = " + result)
            )
        )
    )

    on etxt_log entered arg do
    (
        if etxt_log.text != "" and etxt_pass.text != "" then
        btn_test.enabled = true
        else btn_test.enabled = false
        updateRolloutLayout dlg_configure forceUpdate:true
    )

    on etxt_pass entered arg do
    (
        if etxt_log.text != "" and etxt_pass.text != "" then
        btn_test.enabled = true
        else btn_test.enabled = false

        updateRolloutLayout dlg_configure forceUpdate:true
    )

    on btn_test pressed do
    (
        SetUserEnvVar "MD_USER_LOGIN" etxt_log.text
        SetUserEnvVar "MD_USER_PASS" etxt_pass.text

        MD_Client.Request "test_request" title:"Authorization Test"
        
        if MD_Client.ResponseStatus == "200" then 
        (
            lbl_info.text = "INFO: " + MD_Client.ResponseMessage
            Client_Log.Info MD_Client.ResponseMessage
            btn_get_struct.enabled = true
        )
        else 
        (
            lbl_info.text = "ERROR: " + MD_Client.ResponseMessage
            Client_Log.Error MD_Client.ResponseMessage
        )
    )

    on btn_get_struct pressed do 
    (
        SetUserEnvVar "MD_USER_LOGIN" etxt_log.text
        SetUserEnvVar "MD_USER_PASS" etxt_pass.text

        lbl_connect.text = ""

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

        MD_Client.Request "get_catalog_tree" args:("\"" + MD_CATALOG_DATA_FILE + "\"") title:"Get Objects Catalog Data"

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

        if result_sum == 3 then 
        (
            destroyDialog dlg_configure

            if MD_Data.ActiveSection == 1 then
            (
                MD_Callbacks.Destruct()
                MD_Data.Init()
                MD_Data.CheckedTasks = #()
                MD_Data.ActiveList = 1
                MD_Data.ActiveTaskAddIndex = undefined
                MD_Data.Update()
                MD_UI.FillCategoriesLists()
                MD_Data.FullUpdate()
                MD_BBox.Update()
                
                if MD_Data.ActiveTask == MD_Data.InWorkTask then MD_Data.ShowLayers mode:#work_only
                else MD_Data.ShowLayers mode:#scene_only
            )
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
)