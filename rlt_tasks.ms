
rollout rlt_tasks "Tasks"
(
    dropdownlist 'lst_sections' "" items:MD_CATEGS[1] width:CTRL_WIDTH_1 offset:[1, V_MARGIN] align:#center selection:1 enabled:true
    dropdownlist 'lst_basic_catalog' "" items:#() width:CTRL_WIDTH_1 height:50 offset:[1, V_MARGIN] align:#center selection:1 enabled:true
    dropdownlist 'lst_sub_catalog' "" items:#() width:CTRL_WIDTH_1 height:50 offset:[1, V_MARGIN] align:#center selection:1 enabled:true
    button 'btn_check' "Check tasks" width:(CTRL_WIDTH_1/2 - 3) height:CTRL_HEIGHT_1 align:#center offset:[11, V_MARGIN] across:3 enabled:false tooltip:MD_Tooltips.tasks_01
    button 'btn_get' "Get" width:(CTRL_WIDTH_1/4 - 2) height:CTRL_HEIGHT_1 align:#center offset:[29, V_MARGIN] enabled:false tooltip:MD_Tooltips.tasks_02_a
    button 'btn_clear' "Clear" width:(CTRL_WIDTH_1/4 - 2) height:CTRL_HEIGHT_1 align:#center offset:[19, V_MARGIN] enabled:false tooltip:MD_Tooltips.tasks_03_a
    dotNetControl 'lv_main' "System.Windows.Forms.ListView" width:(CTRL_WIDTH_1) height:140 align:#center offset:[1, 0] enabled:true
    dotNetControl 'lv_add' "System.Windows.Forms.ListView" width:(CTRL_WIDTH_1) height:92 align:#center offset:[1, V_MARGIN] enabled:true
    button 'btn_work_state' "Set Work State" width:CTRL_WIDTH_2 height:CTRL_HEIGHT_1 align:#center offset:[-5, 0] across:2 enabled:false tooltip:MD_Tooltips.tasks_04_a
    button 'btn_exit_work_state' "Exit Work State" width:CTRL_WIDTH_2 height:CTRL_HEIGHT_1 align:#center offset:[7, 0] enabled:false tooltip:MD_Tooltips.tasks_05
    
    on rlt_tasks open do
    (
        lv_main.Name = "lv_main"
        MD_Data.ActiveSection = lst_sections.selection
        MD_Data.ActiveCategory = lst_basic_catalog.selection
        MD_Data.ActiveSubCategory = lst_sub_catalog.selection
    )
    
    on rlt_tasks close do
    (
  
    )

    on lst_sections selected arg do 
    (
        if MD_Data.ActiveSection != arg then
        (
            try MD_Callbacks.Destruct() catch()
            MD_Data.ActiveSection = arg
            MD_Data.ActiveTaskIndex = undefined
            MD_UI.SwitchRollouts()
            MD_Data.ActiveList = 1
            MD_Data.ActiveTaskAddIndex = undefined

            MD_Data.Update()
            -- MD_Data.SwitchWorkLayer()
            MD_UI.FillCategoriesLists()
            try FullUpdate() catch()
        )
        try (destroyDialog MD_UI.Dialogs.LoadTextures) catch()
    )

    on lst_basic_catalog selected arg do
    (
        if MD_Data.ActiveCategory != arg then
        (
            try MD_Callbacks.Destruct() catch()
            MD_Data.ActiveCategory = arg
            MD_Data.ActiveTaskIndex = undefined
            try lst_sub_catalog.selection = 1 catch()
            MD_Data.ActiveSubCategory = lst_sub_catalog.selection
            MD_Data.ActiveList = 1
            MD_Data.ActiveTaskAddIndex = undefined

            MD_Data.Update()
            -- MD_Data.SwitchWorkLayer()
            MD_UI.FillCategoriesLists()
            try FullUpdate() catch()
        )
        try (destroyDialog MD_UI.Dialogs.LoadTextures) catch()
    )

    on lst_sub_catalog selected arg do
    (
        if MD_Data.ActiveSubCategory != arg then
        (
            try MD_Callbacks.Destruct() catch()
            MD_Data.ActiveSubCategory = arg
            MD_Data.ActiveTaskIndex = undefined
            MD_Data.ActiveList = 1
            MD_Data.ActiveTaskAddIndex = undefined

            MD_Data.Update()
            -- MD_Data.SwitchWorkLayer()
            try FullUpdate() catch()
        )
        try (destroyDialog MD_UI.Dialogs.LoadTextures) catch()
    )

    on lst_sub_catalog rightClick do
    (

    ) 
    
    on btn_check pressed do 
    (
        try(DestroyDialog MD_UI.Dialogs.CheckTasks)catch()
        CreateDialog MD_UI.Dialogs.CheckTasks
    )

    on btn_get pressed do 
    (
        local args = ""
        local msg = ""

        case btn_get.text of
        (
            "Send":( 
                -- Отправить сообщения об ошибках

                local article = ""
                local msg = ""
                local user_id = ""

                for i in MD_Data.CheckedTasks do
                (
                    local split = FilterString MD_Client.response_data[i] SEPAR_2
                    article = split[1]
                    msg = split[3]
                    user_id = split[4]

                    args += user_id + SEPAR_2
                )
                args = trimRight args SEPAR_2
                args += SEPAR_1

                for i in MD_Data.CheckedTasks do
                (
                    args += (article + " | " + msg + SEPAR_2)
                )
                args = "\"" + (trimRight args SEPAR_2) + "\""

                MD_Client.Request "send_message" args "Sending Messages"
                msg = "Отправлено сообщений: " + MD_Client.response_msg as string
                MD_Client.Log msg
            )
            "Update":(
                -- Обновить отмеченные задания

                for i in MD_Data.CheckedTasks do
                (
                    args += MD_Data.Tasks[i].Article + SEPAR_1
                )
                args = trimRight args SEPAR_1
                lib_path = pathConfig.AppendPath MD_LIB_DIR MD_CATEGS[2][1]
                MD_Data.active_catalog_article = (MD_Data.main_categ_ids[MD_Data.ActiveCategory][MD_Data.ActiveSubCategory])
                args = MD_Data.active_catalog_article + SEPAR_1 + lib_path + SEPAR_1 + args

                MD_Client.Request "download_tasks" args "Updating Tasks"
                msg = "Обновлено заданий: " + MD_Client.response_msg + " из " + MD_Data.CheckedTasks.count as string
                MD_Client.Log msg
            )
            default:(
                -- Скачать задания в локальную базу

                for i in MD_Data.CheckedTasks do
                (
                    args += MD_Data.TempArticlesList[i] + SEPAR_1
                )
                args = trimRight args SEPAR_1
                lib_path = pathConfig.AppendPath MD_LIB_DIR MD_CATEGS[2][1]
                args = MD_Data.active_catalog_article + SEPAR_1 + lib_path + SEPAR_1 + args

                MD_Client.Request "download_tasks" args "Downloading Tasks"
                msg = "Скачано заданий: " + MD_Data.CheckedTasks.count as string
                MD_Client.Log msg
            )
        )
        -- Обновить
        MD_Data.TempArticlesList = #()
        MD_Data.Update()
        MD_UI.FillMainList()
        MD_UI.FillAddList()
        MD_UI.UpdateCatalogTasksRlt()
        MD_UI.UpdateCatalogInfoRlt()
        MD_UI.UpdateCatalogToolsRlt()
        WithoutRedraw MD_BBox.Update
    )
    
    on btn_clear pressed do 
    (
        case btn_clear.text of
        (
            "Clear":(
                MD_Data.TempArticlesList = #()
            )
            "Delete":
                (
                    if (queryBox "Дейсвительно удалить отмеченные задания?" title:"Внимание!" icon:#warning) then
                    (
                        
                        local del_task_dirs = 0
                        for i in MD_Data.CheckedTasks do
                        (
                            del = MD_Data.DeleteEmptyTask MD_Data.Tasks[i]
                            del_task_dirs += 1
                        )
                        if del_task_dirs > 0 then MD_Log.Info ("Удаленно заданий: " + del_task_dirs as string)
                        -- MD_Data.Update()
                    )
                )
        )
        -- MD_Data.Update()
        MD_UI.FillMainList()
        MD_UI.FillAddList()
        try MD_Data.ActiveTask = MD_Data.Tasks[MD_Data.ActiveTaskIndex] catch()
        MD_UI.UpdateCatalogTasksRlt()
        MD_UI.UpdateCatalogInfoRlt()
        MD_UI.UpdateCatalogToolsRlt()
        WithoutRedraw MD_BBox.Update
    )

    on lv_main ItemChecked self args do
    (   
        -- Занести отмеченные элемента списка в массив MD_Data.CheckedTasks
        MD_Data.CheckedTasks = for i = 0 to (self.CheckedItems.Count - 1) collect (self.CheckedItems.Item[i].Index + 1)

        -- Отметить все элементы списка если нажат control
        if keyboard.controlPressed == true then
        (
            for i = 0 to self.Items.count-1 do self.Items.Item[i].Checked = true
        )
        -- Снять галочки со всех элементов если нажат alt
        else if keyboard.altPressed == true then
        (
            for i = 0 to self.Items.count-1 do self.Items.Item[i].Checked = false
        )
        -- Обоновить интерфейс
        try MD_UI.UpdateCatalogTasksRlt() catch()
    )

    on lv_main ColumnClick self arg do 
    (
        case arg.column of
        (
            0:(
                for i = 0 to self.Items.count-1 do 
                (
                    if self.Items.Item[i].Checked == true then self.Items.Item[i].Checked = false
                    else self.Items.Item[i].Checked = true
                )
                MD_UI.UpdateCatalogToolsRlt()
            )
            4:(
                local sel_user = undefined
                try sel_user = self.SelectedItems.Item[0].SubItems.Item[4].text catch()
                MD_Data.SortTasks = #()
                free MD_Data.SortTasks

                if NOT MD_UI.Sort and sel_user != undefined then 
                (
                    for i = 0 to self.Items.Count - 1 do
                    (

                        if self.Items.Item[i].SubItems.Item[4].text == sel_user then
                        (
                            -- append main_items self.Items.Item[i]
                            append MD_Data.SortTasks MD_Data.Tasks[self.Items.Item[i].Tag]
                        )
                    )

                    MD_UI.Sort = true                    
                )
                else MD_UI.Sort = false

                MD_UI.FillMainList()
                MD_UI.FillAddList()
                try MD_Data.ActiveTask = MD_Data.Tasks[MD_Data.ActiveTaskIndex] catch()
                MD_UI.UpdateCatalogTasksRlt()
                MD_UI.UpdateCatalogInfoRlt()
                MD_UI.UpdateCatalogToolsRlt()

                try self.Items.Item[self.Items.Item[i].Tag - 1].selected = true catch()
            )
        )
    )

    on lv_main Click self arg do
    (
        MD_Data.ActiveList = 1
        MD_Data.ActiveTaskAddIndex = 0

        -- Если временный список заданий пуст
        if MD_Data.TempArticlesList.count == 0 then
        (
            if (self.SelectedItems.count != 0 and (MD_Data.ActiveTaskIndex != self.SelectedItems.Item[0].Tag)) or self.Items.count == 1 then
            (
                MD_Data.ActiveTaskIndex = self.SelectedItems.Item[0].Tag

                -- Проверка сортировки
				if MD_UI.Sort then MD_Data.ActiveTask = MD_Data.SortTasks[self.SelectedItems.Item[0].Tag]
				else MD_Data.ActiveTask = MD_Data.Tasks[self.SelectedItems.Item[0].Tag]

                -- MD_Data.ActiveTask = MD_Data.Tasks[self.SelectedItems.Item[0].Tag]
                MD_Data.ActiveTaskAddIndex = undefined

                if MD_Data.ActiveTask.State == STATES[2] then
                (
                    MD_Data.WorkLayerNodes = GetAllLayerNodes MD_Data.ActiveTask.Article
                    MD_Data.ActiveTask.ActiveMesh = 1

                    for obj in MD_Data.WorkLayerNodes do
                    (
                        if obj.name == MD_Data.ActiveTask.Article then
                        (
                            MD_Data.ActiveTask.Mesh = obj
                        )
                        if obj.name == (MD_Data.ActiveTask.Article + "_" + TRANS_POSTFIX) then
                        (
                            MD_Data.ActiveTask.AddMesh = obj
                            MD_Data.ActiveTask.AddMesh.isHidden = true
                        )
                        
                    )
                    MD_Data.ShowLayers mode:#work_only
                )
                else MD_Data.ShowLayers mode:#scene_only

                MD_UI.FillAddList()
                try MD_Data.ActiveTask = MD_Data.Tasks[self.SelectedItems.Item[0].Tag] catch()
                if MD_Data.WorkLayer == undefined then MD_Data.CreateWorkLayer()
                MD_UI.UpdateCatalogTasksRlt()
                MD_UI.UpdateCatalogInfoRlt()
                MD_UI.UpdateCatalogToolsRlt()
                WithoutRedraw MD_BBox.Update
            )
        )

        WithoutRedraw MD_Data.SwitchWorkLayer
        try (destroyDialog MD_UI.Dialogs.LoadTextures) catch()
    )

    on lv_add Click self arg do
    (
        MD_Data.ActiveList = 2
        MD_Data.ActiveTaskIndex = 0

        if (MD_Data.ActiveTaskAddIndex != self.SelectedItems.Item[0].Index + 1) then
        (
            MD_Data.ActiveList = 2
            MD_Data.ActiveTaskAddIndex = self.SelectedItems.Item[0].Index + 1
            MD_UI.UpdateCatalogInfoRlt()
            MD_UI.UpdateCatalogToolsRlt()
        )

        if MD_UI.Dialogs.LoadTextures.Visible then MD_UI.Dialogs.LoadTextures.InitExistTextures()
    )

    on lv_add MouseDoubleClick self arg do
    (

    )

    on btn_work_state pressed do
    (
        -- Проверка состояния кнопки
        case btn_work_state.text of
        (
            "Set Work State":(
                
                try ClearTrashLayers() catch()
                MD_Data.CreateWorkState()

                -- Если имеются ранее сохранённые рабочие файлы
                if MD_Data.ActiveTask.SavedWorks.count != 0 then
                (
                    dlg_msg = "Загрузить последнее сохранённое рабочее состояние сцены?\n"
                    dlg_msg += "При этом все объекты на текущем рабоче слое будут удалены!"

                    -- Попытаться загрузить последнюю сохранённую работу, если рабочий слой пустой
                    if MD_UI.Settings.ckbx_load_last.checked then
                    (
                        if MD_Data.WorkLayerNodes.count != 0 then
                        (
                            if queryBox dlg_msg title:"Сообщение" then 
                            (
                                -- Удалить все объекты с рабочего слоя
                                try MD_Data.ClearWorkLayer() catch()
                            )
                        )
                        -- Загрузить последнюю работу
                        MD_Data.InWorkTask.LoadWork \
                        MD_Data.ActiveTask.SavedWorks[MD_Data.ActiveTask.SavedWorks.count] quiet_mode:true
                    )
                )
                MD_Data.VisibleLayers = false
                MD_Data.ShowLayers mode:#work_only
            )
            "Update Work State":(

                -- Создать рабочее состояние
                MD_Data.UpdateWorkState()
                MD_Data.VisibleLayers = false
                MD_Data.ShowLayers mode:#work_only
            )
        )
        MD_UI.UpdateCatalogToolsRlt()
    )

    on btn_exit_work_state pressed do
    (
        -- Взять массив объектов на рабочем слое
        MD_Data.WorkLayerNodes = GetAllLayerNodes MD_Data.WorkLayer.Name

        MD_Data.ClearWorkLayer()

        -- Выход из рабочего состояния
        MD_Data.ExitWorkState()
        MD_UI.UpdateCatalogToolsRlt()
    )

    on lv_add ColumnClick s e do
    (

    )
)