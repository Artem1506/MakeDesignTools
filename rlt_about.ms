
rollout rlt_about "About"
(
    label 'lbl_author' "" align:#center offset:[0, 10]
    label 'lbl_version' "" align:#center offset:[0, V_MARGIN]
    hyperLink 'hpl_site' "Documentation" address:docs_file offset:[0, V_MARGIN] align:#center Color:(color 255 110 40) hoverColor:(color 255 130 60) visitedColor:(color 255 110 40)
    label 'lbl_empty' "" align:#center offset:[0, 8]

    on rlt_about open do 
    (
        lbl_author.text = "Author: " + author
        lbl_version.text = "Version: " + version
    )
)