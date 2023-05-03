rollout dlg_configure "Configure" width:400 height:164
(
    local login, password
    local result_sum = 0
    local connection = false

    Label 'lbl_6' "Directory: " width:62 offset:[8, 20] align:#left across:3
    Label 'lbl_md_lib_dir' "" width:224 offset:[-58, 20] align:#left
    Button 'btn_md_lib_dir' "Browse" width:64 height:CTRL_HEIGHT_1 offset:[0, 16] align:#right

    Label 'lbl_8' "Login:" width:32 offset:[-132, 34] align:#right across:2
    editText 'etxt_log' "" width:160 height:20 offset:[-160, 32] align:#right

    Label 'lbl_9' "Password:" width:48 offset:[-136, 2] align:#right across:2
    editText 'etxt_pass' "" width:160 height:20 offset:[-160, 0] align:#right

    -- button 'btn_test' "Test Connection" width:150 height:CTRL_HEIGHT_1 offset:[-2, -51] align:#right enabled:false
    button 'btn_get_struct' "Get Data" width:150 height:48 offset:[-2, -52] align:#right enabled:true

    Label 'lbl_info' "Connection:" width:388 offset:[-4, 12] align:#left

    groupBox 'gbx_1' " Local Base " width:388 height:50 pos:[6, 4] align:#left
    groupBox 'gbx_2' " Remote Base " width:388 height:82 pos:[6, 56] align:#left

    on dlg_configure open do
    (
        -- Инициализация пути к локальной базе 
        try MD_LIB_DIR = GetUserEnvVar "MD_LIB_DIR" catch ()
        
        lbl_md_lib_dir.text = MD_LIB_DIR
        lbl_md_lib_dir.tooltip = MD_LIB_DIR

        -- Инициализация логина и пароля
        try(
            login = getINISetting HTTP_CLIENT_CONFIG_FILE "Authorization" "login" forceUTF16:false
            password = getINISetting HTTP_CLIENT_CONFIG_FILE "Authorization" "password" forceUTF16:false
            etxt_log.text = login
            etxt_pass.text = password
        )catch()
    )

    on dlg_configure close do
    (
        MD_Data.Init()
        MD_UI.Update()
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
            MD_Log.Warning "Путь к локальной базе MakeDesign не определён."
        )
        else
        (
            result = SetUserEnvVar "MD_LIB_DIR" dir

            if result == "" then (MD_Log.Error "Не удалось сохранить путь к локальной базе MakeDesign.")
            else 
            (
                MD_LIB_DIR = dir
                lbl_md_lib_dir.text = dir
                lbl_md_lib_dir.tooltip = dir
                MD_Log.Info ("Путь к локальной базе MakeDesign = " + result)
            )
        )
    )

--     on etxt_log changed arg do (if arg != "" and etxt_pass.text != "" then btn_test.enabled = true else btn_test.enabled = false)

--     on etxt_pass changed arg do (if arg != "" and etxt_log.text != "" then btn_test.enabled = true else btn_test.enabled = false)

    on etxt_log entered arg do
    (
        try(setINISetting HTTP_CLIENT_CONFIG_FILE "Authorization" "login" arg forceUTF16:false)catch()
        -- btn_get_struct.enabled = false
    )

    on etxt_pass entered arg do
    (
        try(setINISetting HTTP_CLIENT_CONFIG_FILE "Authorization" "password" arg forceUTF16:false)catch()
        -- btn_get_struct.enabled = false
    )

    -- on btn_test pressed do
    -- (
        -- try(setINISetting HTTP_CLIENT_CONFIG_FILE "Authorization" "login" etxt_log.text forceUTF16:false)catch()
        -- try(setINISetting HTTP_CLIENT_CONFIG_FILE "Authorization" "password" etxt_pass.text forceUTF16:false)catch()

        -- MD_Client.Request "test_request" "" "Test Connection"
        -- MD_Client.Log MD_Client.response_msg

        -- if MD_Client.response_status == "200" then 
        -- (
        --     btn_get_struct.enabled = true
        --     lbl_info.text = "INFO: Connection successful"
        -- )
        -- else lbl_info.text = "ERROR: Connection failed!"
    -- )

    on btn_get_struct pressed do 
    (
        MD_Client.Request "test_request" "" "Test Connection" dialog:false
        MD_Client.Log MD_Client.response_msg

        if MD_Client.response_status == "200" then 
        (
            lbl_info.text = "INFO: Connection successful"
            connection = true
        )
        else lbl_info.text = "ERROR: Connection failed!"

        if connection then
        (
            try(setINISetting HTTP_CLIENT_CONFIG_FILE "Authorization" "login" etxt_log.text forceUTF16:false)catch()
            try(setINISetting HTTP_CLIENT_CONFIG_FILE "Authorization" "password" etxt_pass.text forceUTF16:false)catch()

            MD_Client.Request "get_users_tree" ("\"" + MD_USERS_DATA_FILE + "\"") "Get Users Data"
            if MD_Client.response_status == "200" then (MD_Client.Log "Загружены данные о пользователях."; result_sum += 1)

            MD_Client.Request "get_catalog_tree" ("\"" + MD_CATALOG_DATA_FILE + "\"") "Get Objects Catalog Data"
            if MD_Client.response_status == "200" then (MD_Client.Log "Загружены данные о каталоге объектов."; result_sum += 1)

            MD_Client.Request "get_projects_tree" ("\"" + MD_PROJECTS_DATA_FILE + "\"") "Get Projects Data"
            if MD_Client.response_status == "200" then (MD_Client.Log "Загружены данные о проектах."; result_sum += 1)

            if result_sum == 3 then lbl_info.text = "INFO: OK"
            else lbl_info.text = "ERROR: Failed"            
        )
    )
)