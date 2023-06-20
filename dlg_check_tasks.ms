
rollout dlg_check_tasks "Check Available Tasks" width:250 height:180
(
    radiobuttons 'rbtn_check_vars' labels:TASK_PARAMS_LIST default:1 columns:1 offsets:#([0, 24], [0, 30], [0, 36], [0, 42])\
        tooltip:#(MD_Tooltips.chk_01, MD_Tooltips.chk_02, MD_Tooltips.chk_03, MD_Tooltips.chk_04)

    groupBox 'grp_01' " Parameters: " width:(dlg_check_tasks.width - 20) height:120 align:#center offset:[0, -106]
    button 'btn_check' "Check" width:(dlg_check_tasks.width - 20) height:CTRL_HEIGHT_2 align:#center offset:[0, 2]
    
    on dlg_check_tasks open do 
    (
        MD_Client.ActiveCheckParam = rbtn_check_vars.state
    )

    on dlg_check_tasks close do 
    (
  
    )

    on rbtn_check_vars changed arg do
    (
        MD_Client.ActiveCheckParam = arg
    )

    on btn_check pressed do
    (
        -- Закрыть текущее диалоговое окно
        DestroyDialog dlg_check_tasks
        -- Вызвать окно ожидания
        try(DestroyDialog MD_UI.Dialogs.Request)catch()

        MD_Data.active_catalog_article = (MD_Data.main_categ_ids[MD_Data.ActiveCategory][MD_Data.ActiveSubCategory])
        local clr
        local args = ""

        case rbtn_check_vars.state of
        (
            1:(args = MD_Data.active_catalog_article + SEPAR_1 + "1"; clr = DN_CLR_TEMP)
            2:(args = MD_Data.active_catalog_article + SEPAR_1 + "2"; clr = DN_CLR_BAD)
            3:(args = MD_Data.active_catalog_article + SEPAR_1 + "3"; clr = DN_CLR_DONE)
            4:(args = MD_Data.active_catalog_article + SEPAR_1 + "1"; clr = DN_CLR_TEMP) -- Изменить 1 на 4 !!!!!!!!!!!!!!!!!
        )

        MD_Client.Request "get_catalog_branch_ids" args "Available Tasks Checkings" 
        msg = "Доступно заданий: " + (MD_Data.TempArticlesList.count as string) + " из " + MD_Client.ResponseMessage
        Client_Log.Info msg

        if MD_Data.TempArticlesList.count == 0 then 
        (
            try FullUpdate() catch()
        )
    )
)