
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
    
    fn UpdateAll =
    (
        try (
            MD_Data.ActiveTask = MD_Data.Tasks[1]
            MD_Data.ActiveTaskIndex = 1
        )catch(
            MD_Data.ActiveTask = undefined
            MD_Data.ActiveTaskIndex = undefined
        )
        
        MD_Data.SwitchWorkLayer()
        MD_Data.Update()
        MD_UI.Update()
        try MD_BBox.Update() catch()
    )

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
            MD_Data.ActiveSection = arg
            
            try MD_Callbacks.Destruct() catch()
            MD_UI.SwitchRollouts()

            UpdateAll()
        )
    )
    
    on lst_basic_catalog selected arg do
    (
        if MD_Data.ActiveCategory != arg then
        (
            MD_Data.ActiveCategory = arg
            try lst_sub_catalog.selection = 1 catch()
            MD_Data.ActiveSubCategory = lst_sub_catalog.selection            

            UpdateAll()
        )
    )

    on lst_sub_catalog selected arg do
    (
        if MD_Data.ActiveSubCategory != arg then
        (
            MD_Data.ActiveCategory = lst_basic_catalog.selection
            MD_Data.ActiveSubCategory = arg
            
            UpdateAll()
        )
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
        -- case btn_get.text of
        -- (
        --     "Get":()
        --     "Send":()
        --     "Update":()
        -- )
    )

    on lv_main ItemChecked self args do 
    (
        -- Занести отмеченные элемента списка в массив MD_Data.CheckedTasks
        MD_Data.CheckedTasks = 
        for i = 0 to (self.CheckedItems.Count - 1) collect (self.CheckedItems.Item[i].Index + 1)

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
        try MD_UI.TasksRltUpdate() catch()
    )

    on btn_clear pressed do 
    (
        -- case btn_clear.text of
        -- (
        --     "Clear":()
        --     "Delete":
        --         (
        --             if (queryBox "You want to delete these tasks?" title:"WARNING" icon:#warning) then
        --             (

        --             )
        --         )
        -- )
    )

    on lv_main ItemSelectionChanged self arg do 
    (

    )

    on lv_main Click self arg do
    (
        MD_Data.ActiveList = 1
        MD_Data.ActiveTaskAddIndex = 0

        if (MD_Data.ActiveTaskIndex != self.SelectedItems.Item[0].Index + 1) then
        (
            MD_Data.ActiveList = 1
            MD_Callbacks.Add()
            MD_Data.ActiveTaskIndex = self.SelectedItems.Item[0].Index + 1
            MD_Data.ActiveTask = MD_Data.Tasks[self.SelectedItems.Item[0].Index + 1]
            MD_Data.SwitchWorkLayer()
            MD_UI.Update()
            MD_BBox.Update()
            MD_UI.CatalogPreviewRltUpdate()
        )  
    )

    on lv_add Click self arg do
    (
        MD_Data.ActiveList = 2
        MD_Data.ActiveTaskIndex = 0

        if (MD_Data.ActiveTaskAddIndex != self.SelectedItems.Item[0].Index + 1) then
        (
            MD_Data.ActiveList = 2
            MD_Data.ActiveTaskAddIndex = self.SelectedItems.Item[0].Index + 1
            MD_UI.CatalogPreviewRltUpdate()
        ) 
    )

    on lv_add MouseDoubleClick self arg do
    (

    )

    on btn_work_state pressed do
    (
        MD_Data.CreateWorkState()
    )

    on btn_exit_work_state pressed do
    (
        MD_Data.ExitWorkState()
    )

    on lv_add ColumnClick s e do
    (

    )
)