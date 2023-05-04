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

    button 'btn_test' "Authorization Test" width:150 height:CTRL_HEIGHT_1 offset:[-2, -51] align:#right enabled:true
    button 'btn_get_struct' "Get MakeDesign Data" width:150 height:CTRL_HEIGHT_1 offset:[-2, -2] align:#right enabled:true

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
            login = getINISetting HTTP_CLIENT_CONFIG_FILE "Authorization" "login" forceUTF16:false
            password = getINISetting HTTP_CLIENT_CONFIG_FILE "Authorization" "password" forceUTF16:false
            etxt_log.text = login
            etxt_pass.text = password
        )catch()

        -- -- Тестовый запрос для проверки связи
        -- MD_Client.Request "test_request" "" "Authorization Test" dialog:false
        -- MD_Client.Log MD_Client.response_msg

        -- if MD_Client.response_status == "200" then 
        -- (
        --     lbl_info.text = "INFO: " + MD_Client.response_msg
        --     connection = true
        -- )
        -- else lbl_info.text = "ERROR: " + MD_Client.response_msg
    )

    on dlg_configure close do
    (
        MD_Callbacks.Destruct()
        MD_Data.Init()
        MD_Data.Update()
        MD_UI.Update()
        MD_UI.TasksRltUpdate()
        try MD_Data.UpdateWorkState() catch()
        MD_Data.VisibleLayers = false
        try MD_Data.ShowLayers mode:#work_only catch()
        try MD_BBox.Update() catch()
        MD_Callbacks.Add()

        -- Сохранить положение диалога
        SetINISetting MDT_CONFIG_FILE dlg_configure.name "pos" ((GetDialogPos dlg_configure) as string)
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

    on etxt_log entered arg do
    (
        try(setINISetting HTTP_CLIENT_CONFIG_FILE "Authorization" "login" arg forceUTF16:false)catch()
    )

    on etxt_pass entered arg do
    (
        try(setINISetting HTTP_CLIENT_CONFIG_FILE "Authorization" "password" arg forceUTF16:false)catch()
    )

    on btn_test pressed do
    (
        try(setINISetting HTTP_CLIENT_CONFIG_FILE "Authorization" "login" etxt_log.text forceUTF16:false)catch()
        try(setINISetting HTTP_CLIENT_CONFIG_FILE "Authorization" "password" etxt_pass.text forceUTF16:false)catch()

        MD_Client.Request "test_request" "" "Authorization Test"
        MD_Client.Log MD_Client.response_msg

        if MD_Client.response_status == "200" then 
        (
            lbl_info.text = "INFO: " + MD_Client.response_msg
            connection = true
        )
        else lbl_info.text = "ERROR: " + MD_Client.response_msg
    )

    on btn_get_struct pressed do 
    (
        if connection then
        (
            try(setINISetting HTTP_CLIENT_CONFIG_FILE "Authorization" "login" etxt_log.text forceUTF16:false)catch()
            try(setINISetting HTTP_CLIENT_CONFIG_FILE "Authorization" "password" etxt_pass.text forceUTF16:false)catch()

            lbl_connect.text = ""

            MD_Client.Request "get_users_tree" ("\"" + MD_USERS_DATA_FILE + "\"") "Get Users Data"

            if MD_Client.response_status == "200" then 
            (
                msg = "Загружены данные о пользователях."
                MD_Client.Log msg
                lbl_info.text = "INFO: " + msg
                result_sum += 1
            )
            else
            (
                msg = "Не удалось загрузить данные о пользователях."
                MD_Client.Log msg
                lbl_info.text = "ERROR: " + msg
            )

            MD_Client.Request "get_catalog_tree" ("\"" + MD_CATALOG_DATA_FILE + "\"") "Get Objects Catalog Data"

            if MD_Client.response_status == "200" then 
            (
                msg = "Загружены данные о каталоге объектов."
                MD_Client.Log msg
                lbl_info.text = "INFO: " + msg
                result_sum += 1
            )
            else
            (
                msg = "Не удалось загрузить данные о каталоге объектов."
                MD_Client.Log msg
                lbl_info.text = "ERROR: " + msg
            )

            MD_Client.Request "get_projects_tree" ("\"" + MD_PROJECTS_DATA_FILE + "\"") "Get Projects Data"

            if MD_Client.response_status == "200" then 
            (
                msg = "Загружены данные о проектах."
                MD_Client.Log msg
                lbl_info.text = "INFO: " + msg
                result_sum += 1
            )
            else
            (
                msg = "Не удалось загрузить данные о проектах."
                MD_Client.Log msg
                lbl_info.text = "ERROR: " + msg
            )

            if result_sum == 3 then 
            (
                msg = "Успешно! Все данные загружены."
                MD_Client.Log msg
                lbl_info.text = "INFO: " + msg
            )
            else if result_sum > 0 then
            (
                lbl_info.text = "WARNING: Не удалось загрузить некоторые данные."
            ) 
            else
            (
                lbl_info.text = "ERROR: Данные не были загружены."
            )     
        )
    )
)