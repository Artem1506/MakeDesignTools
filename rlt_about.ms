
rollout rlt_about "About"
(
    label 'lbl_author' "" align:#center offset:[0, 10]
    label 'lbl_organization' "" align:#center offset:[0, V_MARGIN]
    label 'lbl_version' "" align:#center offset:[0, V_MARGIN]
    hyperLink 'hpl_site' "Documentation" address:docs_file offset:[0, V_MARGIN] align:#center Color:(color 255 110 40) hoverColor:(color 255 130 60) visitedColor:(color 255 110 40)
    button 'btn_update' "Update" width:120 offset:[0, V_MARGIN] align:#center visible:false
    label 'lbl_empty' "" align:#center offset:[0, 8]

    on rlt_about open do 
    (
        lbl_author.text = "Author: " + author
        lbl_version.text = "Version: " + version
        lbl_organization.text = "Organization: Faberon Design"
        rlt_about.height = 140
    )

    on btn_update pressed do (
        -- result = UpdateVersion()
        -- if result then messageBox "Обновление прошло успешно!" title:"Сообщение" icon:#information
        -- else messagebox "Произошла непредвиденная ошибка!" title:"Ошибка" icon:#critical
        CheckUpdates()

        if check_result != version then 
        (
           if queryBox ("Доступна версия " + check_result + "\n\nЗагрузить обновлене?") title:"Сообщение" icon:#information then
           (
                local result = UpdateVersion()
                if result then messageBox "Обновление прошло успешно!\nТребуется перезагрузка плагина." title:"Сообщение" icon:#information
                else messagebox "Произошла непредвиденная ошибка!" title:"Ошибка" icon:#critical
           )
        )else(
            messageBox "Обновлений нет." title:"Сообщение" icon:#information
        )
        
    )
)

