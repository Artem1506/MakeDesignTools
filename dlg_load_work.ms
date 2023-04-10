
rollout dlg_load_work "Saved Works"
(
   dotNetControl 'lv_files' "System.Windows.Forms.ListView" width:220 height:346 align:#left offset:[-4, 2] across:2
   dotNetControl 'img_prew' "System.Windows.Forms.PictureBox" width:SAVED_PREVIEW_SIZE height:SAVED_PREVIEW_SIZE align:#left offset:[-78, 2] across:2
   button 'btn_load' "Load" width:111 height:CTRL_HEIGHT_2 align:#left offset:[-6, -37] acreoss:2 enabled:true
   button 'btn_clear' "Clear" width:111 height:CTRL_HEIGHT_2 align:#left offset:[107, -37] enabled:false

   on dlg_load_work open do
   (

   )

   on lv_files Click self arg do
   (

   )

   on btn_load pressed do
   (
   
   )

   on btn_clear pressed do
   (
   
   )
)