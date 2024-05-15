
rollout rlt_catalog_tasks "Catalog"
(
    dropdownlist 'lst_basic_catalog' "" items:#() width:CTRL_WIDTH_1 height:50 offset:[0, V_MARGIN] align:#center selection:1 enabled:true
    dropdownlist 'lst_sub_catalog' "" items:#() width:CTRL_WIDTH_1 height:50 offset:[1, V_MARGIN] align:#center selection:1 enabled:true
    button 'btn_check' "Check tasks" width:(CTRL_WIDTH_1/2 - 3) height:CTRL_HEIGHT_1 align:#center offset:[11, V_MARGIN] across:3 enabled:false tooltip:MD_Tooltips.tasks_01
    button 'btn_get' "Get" width:(CTRL_WIDTH_1/4 - 2) height:CTRL_HEIGHT_1 align:#center offset:[29, V_MARGIN] enabled:false tooltip:MD_Tooltips.tasks_02_a
    button 'btn_clear' "Clear" width:(CTRL_WIDTH_1/4 - 2) height:CTRL_HEIGHT_1 align:#center offset:[19, V_MARGIN] enabled:false tooltip:MD_Tooltips.tasks_03_a
    dotNetControl 'lv_main' "System.Windows.Forms.ListView" width:(CTRL_WIDTH_1) height:210 align:#center offset:[1, 0] enabled:true
    button 'btn_work_state' "Set Work State" width:CTRL_WIDTH_2 height:CTRL_HEIGHT_1 align:#center offset:[-5, 0] across:2 enabled:false tooltip:MD_Tooltips.tasks_04_a
    button 'btn_exit_work_state' "Exit Work State" width:CTRL_WIDTH_2 height:CTRL_HEIGHT_1 align:#center offset:[7, 0] enabled:false tooltip:MD_Tooltips.tasks_05
    
    -- dropdownlist 'lst_mats' "" items:#() width:CTRL_WIDTH_1 height:50 offset:[0, V_MARGIN] align:#center selection:1 enabled:true
    -- Доп. список материалов объекта (Скрыты в интерфейсе)
    dotNetControl 'lv_add' "System.Windows.Forms.ListView" width:(CTRL_WIDTH_1) height:0 align:#center offset:[1, 0] enabled:true visible:false
    button 'btn_assign_mat_id' "Set Material ID" width:CTRL_WIDTH_2 height:0 align:#center offset:[-5, 0] across:2 enabled:false tooltip:MD_Tooltips.tasks_06 visible:false
    button 'btn_assign_texts' "Assign Textures" width:CTRL_WIDTH_2 height:0 align:#center offset:[7, 0] enabled:false tooltip:MD_Tooltips.tasks_07 visible:false
    
    on rlt_catalog_tasks open do
    (
        lv_main.Name = "lv_main"

        if MD_Data.LoadState then
        (
            try lst_basic_catalog.Items = MD_Data.main_categs catch()
            try lst_sub_catalog.Items = MD_Data.sub_categs[MD_Data.ActiveCategory] catch()
            try lst_basic_catalog.selection = MD_Data.ActiveCategory catch()
            try lst_sub_catalog.selection = MD_Data.ActiveSubCategory catch()
            try MD_UI.InitCatalogLists() catch()
            try lv_main.Items.Item[MD_Data.ActiveTaskIndex - 1].selected = true catch()
            
            try MD_Data.active_catalog_article = (MD_Data.main_categ_ids[MD_Data.ActiveCategory][MD_Data.ActiveSubCategory]) catch()

            -- Попытаться установить иконку
            try (
                icon_file = pathConfig.appendPath DECALS_DIR (MD_Data.active_catalog_article + (ICON_POSTFIX + ".max"))

                MD_Data.ActiveCategoryIcon.SetIcon icon_file
            )catch(MD_Data.ActiveCategoryIcon.Icon = undefined)
        )

        if MD_Data.ActiveTask == MD_Data.InWorkTask then MD_Data.ShowLayers mode:#work_only
        else MD_Data.ShowLayers mode:#scene_only
        rlt_catalog_tasks.height = 324
    )
    
    on rlt_catalog_tasks close do
    (
  
    )

    on lst_basic_catalog selected arg do
    (   
        try( lv_main.Items.Item[0].selected = true 
            MD_Data.ActiveTaskIndex = 1
            MD_Data.ActiveTask = MD_Data.Tasks[1]
        )catch()

        if MD_Data.ActiveCategory != arg then
        (
            MD_Data.ShowLayers mode:#none

            MD_Data.CheckedTasks = #()
            try MD_Callbacks.Destruct() catch()
            MD_Data.ActiveCategory = arg
            try lst_sub_catalog.Items = MD_Data.sub_categs[MD_Data.ActiveCategory] catch()
            -- MD_Data.ActiveTaskIndex = undefined
            try lst_sub_catalog.selection = 1 catch()
            MD_Data.ActiveSubCategory = lst_sub_catalog.selection
            MD_Data.ActiveList = 1
            MD_Data.ActiveTaskMatIndex = 1
            MD_Data.Update()
            -- MD_UI.FillCategoriesLists()
            MD_Data.FullUpdate()
            try MD_BBox.Update() catch()
            -- if MD_Data.ActiveTask == MD_Data.InWorkTask then MD_Data.ShowLayers mode:#work_only
            -- else MD_Data.ShowLayers mode:#scene_only
            try (
                MD_Data.active_catalog_article = (MD_Data.main_categ_ids[MD_Data.ActiveCategory][MD_Data.ActiveSubCategory])
			    local icon_file = pathConfig.appendPath DECALS_DIR (MD_Data.active_catalog_article + (ICON_POSTFIX + ".max"))
			    MD_Data.ActiveCategoryIcon.SetIcon icon_file
            ) catch()
        )
        if MD_Data.ActiveTask == MD_Data.InWorkTask then MD_Data.ShowLayers mode:#work_only
        else MD_Data.ShowLayers mode:#scene_only
        try (destroyDialog MD_UI.Dialogs.EditMaterial) catch() ; print MD_Data.active_catalog_article
    )

    on lst_sub_catalog selected arg do
    (
        try( lv_main.Items.Item[0].selected = true 
            MD_Data.ActiveTaskIndex = 1
            MD_Data.ActiveTask = MD_Data.Tasks[1]
        )catch()

        if MD_Data.ActiveSubCategory != arg then
        (
            MD_Data.ShowLayers mode:#none

            MD_Data.CheckedTasks = #()
            try MD_Callbacks.Destruct() catch()
            MD_Data.ActiveSubCategory = arg
            -- MD_Data.ActiveTaskIndex = undefined
            MD_Data.ActiveList = 1
            MD_Data.ActiveTaskMatIndex = 1
            MD_Data.Update()
            MD_Data.FullUpdate()
            try MD_BBox.Update() catch()
            
            try (
                MD_Data.active_catalog_article = (MD_Data.main_categ_ids[MD_Data.ActiveCategory][MD_Data.ActiveSubCategory])
                local icon_file = pathConfig.appendPath DECALS_DIR (MD_Data.active_catalog_article + (ICON_POSTFIX + ".max"))
                MD_Data.ActiveCategoryIcon.SetIcon icon_file
            ) catch()
        )

        try (destroyDialog MD_UI.Dialogs.EditMaterial) catch()
        try (
			if MD_Data.ActiveCategoryIcon.Icon != undefined then
			MD_UI.ToolsCatalogRoll.btn_mode.text = "Edit Icon"
			else MD_UI.ToolsCatalogRoll.btn_mode.text = "Create Icon"			
		)catch()
        
        if MD_Data.ActiveTask == MD_Data.InWorkTask then MD_Data.ShowLayers mode:#work_only
        else MD_Data.ShowLayers mode:#scene_only 
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
        local download_articles = ""
        MD_Data.ShowLayers mode:#none
        MD_Callbacks.Destruct()

        case btn_get.text of
        (
            "Send":( 
                -- Отправить сообщения об ошибках

                local article = ""
                local msg = ""
                local user_id = ""
                local temp_txt = #()

                for i in MD_Data.CheckedTasks do
                (
                    local split = FilterString MD_Client.ResponseData[i] SEPAR2
                    article = split[1]
                    msg = split[3]
                    user_id = split[4]
                    args += user_id + SEPAR2
                    append temp_txt (article + " | " + msg)
                )
                args = trimRight args SEPAR2
                args += SEPAR

                for txt in temp_txt do
                (
                    args += (txt + SEPAR2)
                )
                args = "\"" + (trimRight args SEPAR2) + "\""

                MD_Client.Request "send_message" args:args title:"Sending Messages"
                Client_Log.Info MD_Client.ResponseMessage
            )

            "Update":(
                -- Обновить отмеченные задания
                for i in MD_Data.CheckedTasks do
                (
                    download_articles += MD_Data.Tasks[i].Article + SEPAR1
                )
                download_articles = trimRight download_articles SEPAR1
                lib_path = pathConfig.AppendPath MD_LIB_DIR MD_CATEGS[2][1]
                MD_Data.active_catalog_article = (MD_Data.main_categ_ids[MD_Data.ActiveCategory][MD_Data.ActiveSubCategory])
                args = MD_Data.active_catalog_article + SEPAR + lib_path + SEPAR + download_articles

                MD_Client.Request "download_tasks" args:args title:"Updating Tasks"
                if MD_Client.ResponseStatus == "200" then
                (
                    msg = "Обновлено заданий: " + MD_Client.ResponseMessage
                    Client_Log.Info msg          
                )
                else
                (
                    msg = MD_Client.ResponseMessage
                    Client_Log.Error msg
                )
            )

            "Download":(
                -- Скачать файлы контента в локальную базу
                for i in MD_Data.CheckedTasks do
                (
                    download_articles += MD_Data.TempArticlesList[i] + SEPAR1
                )
                download_articles = trimRight download_articles SEPAR1
                lib_path = pathConfig.AppendPath MD_LIB_DIR MD_CATEGS[2][1]
                
                -- Загрузить файлы контента в локальную базу
                dl_content_args = "1" + SEPAR + download_articles + SEPAR + lib_path

                MD_Client.Request "download_items_content" args:dl_content_args title:"Download Content"
                if MD_Client.ResponseStatus == "200" then
                (
                    msg = "Загружено контента: " + MD_Client.ResponseMessage
                    Client_Log.Info msg
                )
                else
                (
                    msg = MD_Client.ResponseMessage
                    Client_Log.Error msg
                )
                MD_Data.CheckedTasks = #() 

                -- Загрузить файлы задания в локальную базу
                MD_Data.active_catalog_article = (MD_Data.main_categ_ids[MD_Data.ActiveCategory][MD_Data.ActiveSubCategory])
                args = MD_Data.active_catalog_article + SEPAR + lib_path + SEPAR + download_articles

                MD_Client.Request "download_tasks" args:args title:"Updating Tasks"
                if MD_Client.ResponseStatus == "200" then
                (
                    msg = "Обновлено заданий: " + MD_Client.ResponseMessage
                    Client_Log.Info msg 
                )
                else
                (
                    msg = MD_Client.ResponseMessage
                    Client_Log.Error msg
                )
            )

            default:(
                -- Скачать задания в локальную базу
                for i in MD_Data.CheckedTasks do
                (
                    download_articles += MD_Data.TempArticlesList[i] + SEPAR1
                )
                download_articles = trimRight download_articles SEPAR1
                lib_path = pathConfig.AppendPath MD_LIB_DIR MD_CATEGS[2][1]
                args = MD_Data.active_catalog_article + SEPAR + lib_path + SEPAR + download_articles

                MD_Client.Request "download_tasks" args:args title:"Downloading Tasks"
                if MD_Client.ResponseStatus == "200" then
                (
                    msg = "Скачано заданий: " + MD_Data.CheckedTasks.count as string
                    Client_Log.Info msg
                )
                else
                (
                    msg = MD_Client.ResponseMessage
                    Client_Log.Error msg
                )
            )
        )
        -- Обновить
        MD_Data.TempArticlesList = #()
        MD_Data.Update()
        -- MD_Data.UpdateWorkState()
        -- MD_UI.UpdateCatalogTasksRlt()
        MD_UI.FillMainList()
        MD_UI.FillAddList()
        MD_UI.UpdateCatalogTasksRlt()
        MD_UI.UpdateCatalogGeneralRlt()
        
        if MD_Data.ActiveTask.State == STATES[2] then MD_Data.ShowLayers mode:#work_only
        else
        (
            local current_state = MD_Data.ActiveTask.State
            MD_Data.ExitWorkState()
            -- MD_Data.ActiveTask.Icon = undefined
            MD_Data.ActiveTask.State = current_state
            try MD_BBox.Update() catch()
            MD_Data.ShowLayers mode:#scene_only
        )

        MD_Data.FullUpdate()
        -- try MD_BBox.Update() catch()
        MD_UI.UpdateCatalogInfoRlt()
        MD_Callbacks.Add()
        
    )
    
    on btn_clear pressed do 
    (
        MD_Data.ShowLayers mode:#none

        case btn_clear.text of
        (
            "Clear":(
                MD_Data.TempArticlesList = #()
            )
            "Delete":
                (
                    MD_Data.ExitWorkState()
                    MD_Data.InWorkTask = Undefined
                    if keyboard.shiftPressed then
                    (
                        local del_task_dirs = 0

                        for i in MD_Data.CheckedTasks do
                        (
                            del = MD_Data.DeleteEmptyTask MD_Data.Tasks[i] trash:false
                            del_task_dirs += 1
                        )
                        if del_task_dirs > 0 then MD_Log.Info ("Удаленно заданий: " + del_task_dirs as string)
                    )
                    else
                    (
                        if (queryBox "Дейсвительно удалить отмеченные задания?\n" title:"Внимание!" icon:#warning) then
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
        )
        MD_Data.CheckedTasks = #()
        MD_Data.Update()
        MD_UI.FillMainList()
        MD_UI.FillAddList()
        try MD_Data.ActiveTask = MD_Data.Tasks[MD_Data.ActiveTaskIndex] catch()
        MD_UI.UpdateCatalogTasksRlt()
        MD_UI.UpdateCatalogInfoRlt()
        MD_UI.UpdateCatalogGeneralRlt()
        try MD_BBox.Update() catch()
        if MD_Data.ActiveTask == MD_Data.InWorkTask then 
        (
            if MD_Data.InWorkTask != undefined then MD_Data.ShowLayers mode:#work_only
            else MD_Data.ShowLayers mode:#none
        )
        else MD_Data.ShowLayers mode:#scene_only
    )

    on lv_main ItemChecked self args do
    (   
        if not MD_Data.edit_icon_mode then
        (
            try(
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
            )catch()            
        )
    )

    on lv_main ColumnClick self arg do 
    (
        if not MD_Data.edit_icon_mode then
        (
            case arg.column of
            (
                0:(
                    for i = 0 to self.Items.count-1 do 
                    (
                        if self.Items.Item[i].Checked == true then self.Items.Item[i].Checked = false
                        else self.Items.Item[i].Checked = true
                    )
                    MD_UI.UpdateCatalogGeneralRlt()
                )
                -- 4:(
                --     local sel_user = undefined
                --     try sel_user = self.SelectedItems.Item[0].SubItems.Item[4].text catch()
                --     MD_Data.SortTasks = #()
                --     free MD_Data.SortTasks

                --     if NOT MD_UI.Sort and sel_user != undefined then 
                --     (
                --         for i = 0 to self.Items.Count - 1 do
                --         (

                --             if self.Items.Item[i].SubItems.Item[4].text == sel_user then
                --             (
                --                 -- append main_items self.Items.Item[i]
                --                 append MD_Data.SortTasks MD_Data.Tasks[self.Items.Item[i].Tag]
                --             )
                --         )

                --         MD_UI.Sort = true                    
                --     )
                --     else MD_UI.Sort = false

                --     MD_UI.FillMainList()
                --     MD_UI.FillAddList()
                --     try MD_Data.ActiveTask = MD_Data.Tasks[MD_Data.ActiveTaskIndex] catch()
                --     MD_UI.UpdateCatalogTasksRlt()
                --     MD_UI.UpdateCatalogInfoRlt()
                --     MD_UI.UpdateCatalogGeneralRlt()

                --     try self.Items.Item[self.Items.Item[i].Tag - 1].selected = true catch()
                -- )
            )            
        )
    )

    on lv_main Click self arg do
    (
        if not MD_Data.edit_icon_mode then
        (
            MD_Data.ActiveList = 1
            try MD_Data.ActiveTaskMatIndex = 1 catch()
            try MD_Data.ActiveTask.ActiveMatIndex = 1 catch()
            subobjectLevel = 0
            MD_Callbacks.Destruct()
    
            -- Если временный список заданий пуст
            if MD_Data.TempArticlesList.count == 0 then
            (
                if (self.SelectedItems.count != 0 and (MD_Data.ActiveTaskIndex != self.SelectedItems.Item[0].Tag)) or self.Items.count == 1 then
                (
                    try MD_Data.ActiveTaskIndex = self.SelectedItems.Item[0].Tag catch()
    
                    -- Проверка сортировки
                    -- if MD_UI.Sort then MD_Data.ActiveTask = MD_Data.SortTasks[self.SelectedItems.Item[0].Tag]
                    -- else MD_Data.ActiveTask = MD_Data.Tasks[self.SelectedItems.Item[0].Tag]
    
                    try MD_Data.ActiveTask = MD_Data.Tasks[self.SelectedItems.Item[0].Tag] catch()
                    MD_Data.ActiveTaskMatIndex = 1
    
                    -- Проверка состояния
                    try if MD_Data.ActiveTask.state == STATES[2] then MD_Data.InWorkTask = MD_Data.ActiveTask catch()
    
                    if MD_Data.InWorkTask != undefined and MD_Data.ActiveTask.Article == MD_Data.InWorkTask.Article then
                    (
                        MD_Data.WorkLayerNodes = GetAllLayerNodes MD_Data.InWorkTask.Article
                        MD_Data.InWorkTask.ActiveMeshIndex = 1
                        
                        for obj in MD_Data.WorkLayerNodes do
                        (
                            if obj.name == MD_Data.InWorkTask.Article then
                            (
                                MD_Data.InWorkTask.MainMesh = obj
                            )
                            if obj.name == (MD_Data.InWorkTask.Article + TRANS_POSTFIX) then
                            (
                                MD_Data.InWorkTask.AddMesh = obj
                                MD_Data.InWorkTask.AddMesh.isHidden = true
                            )    
                        )
    
                        -- if MD_Data.InWorkTask.Group == MD_Data.ActiveTask.Group then
                        -- ( 
                        --     try MD_Data.InWorkTask.MainMesh.Material = MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex].MultiMat catch()
                        --     try MD_Data.InWorkTask.AddMesh.Material = MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex].MultiMat catch()
    
                        --     completeRedraw()
                        -- )
                        try MD_BBox.Update() catch()
                        MD_Data.ShowLayers mode:#work_only
                        -- Добавить функции обратного вызова
                        try MD_Callbacks.Add() catch()
                    )
                    else 
                    (
                        if MD_Data.InWorkTask != undefined and \
                        MD_Data.InWorkTask != undefined and \
                        MD_Data.InWorkTask.Article != undefined and \
                        MD_Data.ActiveTask.Group != undefined and \
                        MD_Data.ActiveTask.Article == MD_Data.InWorkTask.Article then
                        (
                            try MD_BBox.Update() catch()
                            MD_Data.ShowLayers mode:#work_only
                            -- try MD_Data.InWorkTask.MainMesh.Material = MD_Data.ActiveTask.Materials[MD_Data.ActiveTask.ActiveMatIndex].MultiMat catch()
                            -- try MD_Data.InWorkTask.AddMesh.Material = MD_Data.ActiveTask.Materials[MD_Data.ActiveTask.ActiveMatIndex].MultiMat catch()
                            -- Добавить функции обратного вызова
                            try MD_Callbacks.Add() catch()
                            completeRedraw()
                        )
                        else 
                        (
                            try MD_BBox.Update() catch()
                            try(destroyDialog MD_UI.Dialogs.Export)catch()
                            MD_Data.ShowLayers mode:#scene_only
                        )
                    )
    
                    MD_UI.FillAddList()
                    try MD_Data.ActiveTask = MD_Data.Tasks[self.SelectedItems.Item[0].Tag] catch()
                    MD_UI.UpdateCatalogTasksRlt()
                    -- MD_UI.UpdateCatalogInfoRlt()
                    MD_UI.UpdateCatalogGeneralRlt()
                )
            )
            MD_UI.UpdateCatalogInfoRlt()
            -- try (destroyDialog MD_UI.Dialogs.EditMaterial) catch()
            
            try MD_Data.CreateWorkLayer() catch()
    
            try MD_Data.WorkLayerNodes = GetAllLayerNodes MD_Data.InWorkTask.Article catch()
    
            if MD_UI.SettingsRoll.ckbx_load_last.checked and MD_Data.WorkLayerNodes.count == 0 then
            (
                if MD_Data.ActiveTask != undefined and MD_Data.InWorkTask != undefined and MD_Data.InWorkTask == MD_Data.ActiveTask then
                -- Загрузить последнюю работу
                try (MD_Data.InWorkTask.LoadWork \
                MD_Data.InWorkTask.SavedWorks[MD_Data.InWorkTask.SavedWorks.count] quiet_mode:true) catch()
            )
    
            try MD_Data.AssignMaterial MD_Data.InWorkTask.MainMesh MD_Data.ActiveTask.ActiveMatIndex catch()
            try MD_Data.AssignMaterial MD_Data.InWorkTask.AddMesh MD_Data.ActiveTask.ActiveMatIndex catch()
    
            if MD_UI.Dialogs.EditMaterial.Visible then MD_UI.Dialogs.EditMaterial.InitExistTextures MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex]
    
            if MD_Data.ActiveTask != undefined and MD_Data.InWorkTask != undefined and MD_Data.InWorkTask == MD_Data.ActiveTask then
            (try select MD_Data.InWorkTask.MainMesh catch())
            else clearselection()
        )
        else
        (try MD_Data.ActiveTask = MD_Data.Tasks[self.SelectedItems.Item[0].Tag] catch())
    )

    on lv_add Click self arg do
    (
        MD_Data.ActiveList = 2
        MD_Data.ActiveTaskIndex = 0
        MD_Data.ActiveTask.ActiveMatIndex = self.SelectedItems.Item[0].Index + 1

        if (MD_Data.ActiveTaskMatIndex != self.SelectedItems.Item[0].Index + 1) then
        (
            MD_Data.ActiveList = 2
            MD_Data.ActiveTaskMatIndex = self.SelectedItems.Item[0].Index + 1
            MD_UI.UpdateCatalogTasksRlt()
            MD_UI.UpdateCatalogInfoRlt()
            MD_UI.UpdateCatalogGeneralRlt()
        )
        
        -- Обновить состояние окна загрузки текстур, если оно открыто
        if MD_UI.Dialogs.EditMaterial.Visible then MD_UI.Dialogs.EditMaterial.InitExistTextures MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex]

        try MD_Data.AssignMaterial MD_Data.InWorkTask.MainMesh MD_Data.ActiveTask.ActiveMatIndex catch()
        try MD_Data.AssignMaterial MD_Data.InWorkTask.AddMesh MD_Data.ActiveTask.ActiveMatIndex catch()
    )

    on lv_add MouseDoubleClick self arg do
    (
        try(
            subobjectLevel = 4
            $.selectByMaterial (self.SelectedItems.Item[0].Index + 1)
            completeRedraw()
        )catch()
    )

    on btn_work_state pressed do
    ( 
        MD_Data.ShowLayers mode:#none
        try ClearTrashLayers() catch()
        local exec = true
        MD_Callbacks.Destruct()
        -- Проверка состояния кнопки
        case btn_work_state.text of
        (
            "Set Work State":(
                if (MD_Data.ActiveTask.State == STATES[3] and \
                (not (queryBox "Данное задание имеет состояние выполнения \"Check\".
После того, как оно будет взято в работу, его состояние изменится на \"InWork\",
и далее не сможет быть вновь изменено на \"Check\", до тех пор пока не будет обновлено или загружено в удалённую базу.\n
Всё равно продолжить?" \
                title:("Внимание! " + (MD_Data.ActiveTask.Article as string)) icon:#warning))) then exec = false
                
                if exec then
                (
                    
                    try ClearTrashLayers() catch()
                    
                    MD_Data.CreateWorkState MD_Data.ActiveTask
                    

                    -- Если имеются ранее сохранённые рабочие файлы
                    if MD_Data.InWorkTask != undefined and MD_Data.InWorkTask.SavedWorks.count != 0 then
                    (
                        dlg_msg = "Загрузить последнее сохранённое рабочее состояние сцены?\n"
                        dlg_msg += "При этом все объекты на текущем рабоче слое будут удалены!"

                        -- Попытаться загрузить последнюю сохранённую работу, если рабочий слой пустой
                        if MD_UI.SettingsRoll.ckbx_load_last.checked then
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
                            MD_Data.InWorkTask.SavedWorks[MD_Data.InWorkTask.SavedWorks.count] quiet_mode:true
                            MD_Data.InWorkTask.ActiveMeshIndex = 2
                            MD_UI.GeneralCatalogRoll.SwitchMeshes()
                        )
                    )
                    MD_Data.ShowLayers mode:#work_only                   
                )
            )
            "Update Work State":(
                -- Создать рабочее состояние

                MD_Data.UpdateWorkState()
                MD_UI.UpdateCatalogTasksRlt()
                MD_Data.ShowLayers mode:#work_only
            )
        )
        MD_Data.FullUpdate()
        MD_UI.UpdateCatalogInfoRlt()
        try MD_BBox.Update() catch()
        -- MD_Data.ShowLayers mode:#work_only
        try select MD_Data.InWorkTask.MainMesh catch()
        MD_Callbacks.Add()
    )

    on btn_exit_work_state pressed do
    (
        -- Взять массив объектов на рабочем слое
        try MD_Data.WorkLayerNodes = GetAllLayerNodes MD_Data.WorkLayer.Name catch()
        try destroyDialog MD_UI.Dialogs.Export catch()
        MD_Data.ClearWorkLayer()

        -- Выход из рабочего состояния
        MD_Data.ExitWorkState()
        MD_Data.FullUpdate()
        try MD_BBox.Update() catch()
        MD_Data.ShowLayers mode:#scene_only
        try destroyDialog MD_UI.Dialogs.EditMaterial catch()
    )

    on lv_add ColumnClick s e do
    (

    )

    on btn_assign_mat_id pressed do
    (
        MD_Data.AssignMatID selection[1]
    )

    on btn_assign_texts pressed do
    (
        try (destroyDialog MD_UI.Dialogs.EditMaterial) catch()
        CreateDialog MD_UI.Dialogs.EditMaterial modal:false
    )
)