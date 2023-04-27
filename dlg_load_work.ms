
rollout dlg_load_work "Saved Works"
(
   dotNetControl 'lv_files' "System.Windows.Forms.ListView" width:220 height:346 align:#left offset:[-4, 2] across:2
   dotNetControl 'img_prew' "System.Windows.Forms.PictureBox" width:SAVED_PREVIEW_SIZE height:SAVED_PREVIEW_SIZE align:#left offset:[-78, 2] across:2
   button 'btn_load' "Load" width:111 height:CTRL_HEIGHT_2 align:#left offset:[-6, -37] acreoss:2 enabled:true
   button 'btn_delete' "Delete" width:111 height:CTRL_HEIGHT_2 align:#left offset:[107, -37] enabled:false

   on dlg_load_work open do
   (
      -- Инициализация содержимого диалогового окна
      MD_UI.Dialogs.InitLoadWork()
   )

   on lv_files Click self arg do
   (
      -- Обновить превью файла при выборе элемна в списке
      MD_UI.Dialogs.UpdatePreview()
   )

   on btn_load pressed do
   (
      -- Загрузить в сцену объекты из выбранного файл
      -- При этом все объекты на текущем рабочем слое будут удалены
      try(
         local load_result = MD_Data.ActiveTask.LoadWork \
         MD_Data.ActiveTask.SavedWorks[lv_files.SelectedItems.Item[0].Index + 1] quiet_mode:false
         
         if load_result then destroyDialog dlg_load_work
      )catch()
   )

   on lv_files ItemChecked self args do 
   (
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

       -- Вкл/Выкл кнопки "Clear"
       if self.CheckedItems.Count > 0 then
       btn_delete.enabled = true
       else btn_delete.enabled = false
   )

   on btn_delete pressed do
   (
      -- Удалить отмеченные файлы
      MD_UI.Dialogs.DeleteSavedFiles()

      -- Обновить
      MD_UI.Dialogs.InitLoadWork()

      -- При удалении всех заданий закрыть текущее диалоговое окно
      if MD_Data.ActiveTask.SavedWorks.Count == 0 then
      (
         destroyDialog dlg_load_work
         MD_UI.ToolsRltUpdate()
      )
   )
)