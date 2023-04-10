
rollout dlg_progress "Progress" width:350 height:100
(
    local dots = ""
    local index = 1

    label 'lbl_01' "Waiting " align:#left offset:[30, 37] across:2
    label 'lbl_02' "" align:#left offset:[-90, 37]
    timer clock "Clock" interval:500
    
    on clock tick do
    (
        lbl_02.text = dots
        if (mod index 6) == 0 then (index = 1; dots = "") else (index += 1; dots += ".") 
    )
)

