
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
            try (
                MD_Data.ActiveTask = MD_Data.Tasks[1]
                MD_Data.ActiveTaskIndex = 1
            )catch(
                MD_Data.ActiveTask = undefined
                MD_Data.ActiveTaskIndex = undefined
            )
            MD_UI.SwitchRollouts()
            MD_Data.Update()
            MD_UI.Update()
            try MD_BBox.Update() catch()            
        )
    )
    
    on lst_basic_catalog selected arg do
    (
        if MD_Data.ActiveCategory != arg then
        (
            MD_Data.ActiveCategory = arg

            try MD_Callbacks.Destruct() catch()
            try (
                MD_Data.ActiveTask = MD_Data.Tasks[1]
                MD_Data.ActiveTaskIndex = 1
            )catch(
                MD_Data.ActiveTask = undefined
                MD_Data.ActiveTaskIndex = undefined
            )
            try lst_sub_catalog.selection = 1 catch()

            MD_Data.Update()
            MD_UI.Update()
            try MD_BBox.Update() catch()            
        )
    )

    on lst_sub_catalog selected arg do
    (
        if MD_Data.ActiveSubCategory != arg then
        (
            MD_Data.ActiveSubCategory = arg

            try MD_Callbacks.Destruct() catch()
            try (
                MD_Data.ActiveTask = MD_Data.Tasks[1]
                MD_Data.ActiveTaskIndex = 1
            )catch(
                MD_Data.ActiveTask = undefined
                MD_Data.ActiveTaskIndex = undefined
            )
            MD_Data.ActiveCategory = lst_basic_catalog.selection
            
            MD_Data.Update()
            MD_UI.Update()
            try MD_BBox.Update() catch()
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
        if MD_Data.ActiveTaskIndex != self.SelectedItems.Item[0].Index + 1 then
        (
            MD_Callbacks.Add()
            MD_Data.ActiveTaskIndex = self.SelectedItems.Item[0].Index + 1
            MD_Data.ActiveTask = MD_Data.Tasks[self.SelectedItems.Item[0].Index + 1]
            try MD_Data.SwitchWorkLayer() catch()
            MD_UI.Update()
            MD_BBox.Update()            
        )
    )

    on lv_add Click self arg do
    (
  
    )

    on lv_add MouseDoubleClick self arg do
    (

    )

    on btn_work_state pressed do
    (
        MD_Callbacks.Destruct()
        MD_Data.ActiveTask.State = STATES[2]
        MD_Data.ActiveTask.ActiveMesh = 1
        MD_Data.InWorkTask = MD_Data.ActiveTask.Article
        MD_Data.CreateWorkLayer()
        MD_Data.ActiveTask.Update()
        MD_UI.Update()
        MD_BBox.Update()
        MD_Callbacks.Add()
    )

    on btn_exit_work_state pressed do
    (
        MD_Data.ActiveTask.State = STATES[1]
        MD_Data.ActiveTask.ActiveMesh = 1
        MD_Data.DeleteWorkLayer()
        MD_Data.InWorkTask = undefined
        MD_Data.ActiveTask.Update() 
        MD_UI.Update()
        MD_BBox.Update()
        MD_Callbacks.Destruct()
    )

    on lv_add ColumnClick s e do
    (

    )
)