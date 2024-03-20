(
    -- Чтобы исключить "rlt_catalog_tools" нужно закомментировать строку "include "rlt_catalog_tools.ms"" в файле "__main__.ms"

    try (close in_stream) catch()
    try (close out_stream) catch()

    dev_dir = pathConfig.removePathLeaf (getThisScriptFileName())
    main_dir = (pathConfig.removePathLeaf (pathConfig.removePathLeaf (getThisScriptFileName())))
    main_file = pathConfig.appendPath main_dir "__main__.ms"
    release_dir = pathConfig.appendPath main_dir "Release"
    out_file = pathConfig.appendPath (pathConfig.removePathLeaf (getThisScriptFileName())) "mdt.ms"
    out_file_encrypt = pathConfig.appendPath (pathConfig.removePathLeaf (getThisScriptFileName())) "mdt.mse"
    out_release_file = pathConfig.appendPath release_dir "mdt.mse"

    -- Удалить папку release и создать новую
    if doesDirectoryExist release_dir then (dosCommand ("rmdir " + release_dir + " /s /q"))
    makeDir release_dir

    in_stream = openFile main_file mode:"r"
    out_stream = undefined
    if not (doesFileExist out_file) then out_stream = createFile out_file
    else out_stream = openFile out_file mode:"w+"
    end = false


    while not end do
    (
        local string_line = readLine in_stream

        if ((trimLeft string_line "\t ")[1] != "-") then 
        (
            if (findString string_line "include") != undefined then 
            (
                local sub_file = (FilterString string_line " ")
                sub_file = (substituteString sub_file[2] "\"" "")
                sub_file = pathConfig.appendPath main_dir sub_file

                local sub_stream = openFile sub_file mode:"r"
                local sub_end = false

                while not sub_end do
                (
                    local sub_string_line = readLine sub_stream
                    
                    if ((trimLeft sub_string_line "\t ")[1] != "-") then 
                    (
                        if (findString sub_string_line "%") != undefined then 
                        sub_string_line = (substituteString sub_string_line "%" "\%")
                        if sub_string_line != "" and sub_string_line != "\t" then 
                        (
                            format sub_string_line to:out_stream
                            format "\n" to:out_stream                    
                        )
                    )

                    sub_end = eof sub_stream
                )

                close sub_stream
                continue
            )
        )

        if ((trimLeft string_line "\t ")[1] != "-") then 
        (
            if (findString string_line "%") != undefined then 
            string_line = (substituteString string_line "%" "\%")
            if sub_string_line != "" and sub_string_line != "\t" then 
            (
                format string_line to:out_stream
                format "\n" to:out_stream
            )
        )

        end = eof in_stream
    )

    close in_stream
    close out_stream

    encryptScript out_file
    

    -- Скопировать папки
    dosCommand ("xcopy " + (pathConfig.appendPath main_dir "Resources") + " " + (pathConfig.appendPath release_dir "Resources") + " /S /E /I /Y /R /C")
    dosCommand ("xcopy " + (pathConfig.appendPath main_dir "md_client") + " " + (pathConfig.appendPath release_dir "md_client") + " /S /E /I /Y /R /C")
    
    copyFile (pathConfig.appendPath dev_dir "Install.ms") (pathConfig.appendPath release_dir "Install.ms")
    copyFile out_file_encrypt out_release_file
    encryptScript (pathConfig.appendPath release_dir "Install.ms")

    -- Удалить файл .mse
    deleteFile out_file_encrypt
    deleteFile (pathConfig.appendPath release_dir "Install.ms")

    -- Удалить файл .ms
    -- deleteFile out_file
)