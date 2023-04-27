
rollout dlg_check_tasks "Parameters" width:200 height:150
(
    radiobuttons 'rbtn_check_vars' labels:TASK_PARAMS_LIST default:1 columns:1 offsets:#([0, 10], [0, 16], [0, 22], [0, 28])\
        tooltip:#(MD_Tooltips.chk_01, MD_Tooltips.chk_02, MD_Tooltips.chk_03, MD_Tooltips.chk_04)
    button 'btn_check' "Check" width:(dlg_check_tasks.width - 20) height:CTRL_HEIGHT_2 align:#center offset:[0, 8]
    timer 'clock' "Clock" interval:500

    on dlg_check_tasks open do 
    (
        
    )

    on dlg_check_tasks close do 
    (
  
    )

    on btn_check pressed do
    (
        -- Закрыть текущее диалоговое окно
        DestroyDialog dlg_check_tasks
        -- Вызвать окно ожидания
        try(DestroyDialog MD_UI.Dialogs.Progress)catch()

        local active_catalog_article = (MD_Data.main_categ_ids[MD_Data.ActiveCategory][MD_Data.ActiveSubCategory])
        local args = ""
        local clr
        
        case rbtn_check_vars.state of
        (
            1:(args = active_catalog_article + SEPAR_1 + "1"; clr = DN_CLR_TEMP)
            2:(args = active_catalog_article + SEPAR_1 + "2"; clr = DN_CLR_BAD)
            3:(args = active_catalog_article + SEPAR_1 + "3"; clr = DN_CLR_DONE)
            4:(args = active_catalog_article + SEPAR_1 + "1"; clr = DN_CLR_TEMP) -- Изменить 1 на 4 !!!!!!!!!!!!!!!!!
        )

        response = MD_Data.request ("get_catalog_branch_ids " + args) waiting_txt:"Checking new tasks"
       
        -- try(
        --     resp_data = (execute response[3])
        --     checked_articles = check_exist_tasks resp_data
        --     articles = checked_articles[1]

        --     if articles.count != 0 then
        --     (
        --         show_temp_list = true
        --         fill_temp_list articles checked:true clr:clr
        --         try(resize_bbox())catch()
        --         clear_task_info()
        --         switch_btn_state()
        --         print_prompt (articles.count as string)

        --         try(
        --             sep = " | "
        --             for i in resp_data do 
        --             (
        --                 msg = "INFO: " + localtime + sep + rlt_categories.lst_basic_catalog.selected + " - " + rlt_tasks.lst_sub_catalog.selected + sep
        --                 msg_arr = filterstring i separ2
        --                 for k in msg_arr do msg += (k + sep)
        --                 f = findItem users[2] (msg_arr[msg_arr.count] as integer)
        --                 try(msg += users[1][f])catch()
        --             )
        --         )catch()
        --     )
        --     else
        --     (
        --         try(fill_main_list())catch()
        --         show_temp_list = false
        --         fill_task_data()
        --         switch_btn_state()
        --         print_prompt (articles.count as string)
        --     )
        -- )
        -- catch(messageBox "Something went wrong!" title:"ERROR!" icon:#critical)

        -- progress_dlg_title = "Checking available tasks"
        -- CreateDialog MD_UI.Dialogs.Progress modal:true style:#(#style_toolwindow) escapeEnable:True
    )
)