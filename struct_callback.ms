
struct Callback
(
	ToolsUIUpdate = undefined,

	fn UpdateUI ev nd = 
	(
		MD_UI.UpdateCatalogToolsRlt()
		MD_UI.UpdateCatalogTasksRlt()

		if not MD_UI.SettingsRoll.ckbx_show_icon.checked then
		(
			try MD_Data.ActiveCategoryIcon.Icon.IsHidden = not MD_UI.SettingsRoll.ckbx_show_icon.checked catch()
			try MD_Data.WorkLayer.on = on catch()
			completeRedraw()			
		)
	),

	fn UpdateUI2 ev nd = 
	(
		MD_UI.UpdateCatalogToolsRlt()
		MD_UI.UpdateCatalogTasksRlt()
	),

	fn AddObject = 
	(
		-- print "AddObject"
		try (
			local obj = callbacks.notificationParam()

			if obj.Layer != MD_Data.WorkLayer then
			(
				obj.Material = undefined
				if (findString obj.Name MD_Data.WorkLayer.Name) != undefined then 
				(
					obj.Name = uniqueName "Object"
					obj.IsHidden = False
				)
			)
			if obj != MD_Data.ActiveTask.Mesh and obj != MD_Data.ActiveTask.AddMesh then
			(
				obj.Name = uniqueName "Object"
				obj.Material = undefined
			)
		)catch()
		MD_UI.UpdateCatalogToolsRlt()
	),

	fn DeleteObject = 
	(
		-- print "DeleteObject"
		try (
			local obj = callbacks.notificationParam()

			if MD_Data.InWorkTask != undefined then
			(
				if obj == MD_Data.InWorkTask.Mesh then MD_Data.InWorkTask.Mesh = undefined
				if obj == MD_Data.InWorkTask.AddMesh then MD_Data.InWorkTask.AddMesh = undefined
			)
			
		)catch()
		try (if obj == MD_Data.ActiveCategoryIcon.Icon then MD_Data.ActiveCategoryIcon.Icon = undefined) catch()
		MD_UI.UpdateCatalogToolsRlt()
	),

	fn LayerChange = 
	(
		-- print "LayerChange"
		try (
			local params = callbacks.notificationParam()
			local obj = params[1]
			local old_layer = params[2]
			local new_layer = params[3]

			if obj.Layer == MD_BBox.Layer then
			(
				with redraw off
				(
					DEFAULT_LAYER.addNode obj
					DEFAULT_LAYER.Current = true					
				)
			)

			if new_layer != MD_Data.WorkLayer then
			(
				if obj == MD_Data.InWorkTask.Mesh then 
				(
					MD_Data.InWorkTask.Mesh = undefined
					obj.Name = uniqueName "Object"
				)
				if obj == MD_Data.InWorkTask.AddMesh then 
				(
					MD_Data.InWorkTask.AddMesh = undefined
					obj.Name = uniqueName "Object"
				)
				if obj.Material == MD_Data.InWorkTask.Material then obj.Material = undefined
			)

			completeRedraw()
		)catch()
		MD_UI.UpdateCatalogToolsRlt()
	),

	fn CheckExistTaskLayer =
	(
		-- print "CheckExistTaskLayer"

		if (callbacks.notificationParam()).name == MD_Data.ActiveTask.Article then
		(
			if MD_Data.ActiveTask != undefined then
			(
				MD_Data.ActiveTask.State = STATES[1]
				MD_Data.ActiveTask.ActiveMesh = 1
				MD_Data.InWorkTask = undefined
				MD_Data.WorkLayer = undefined
				MD_Data.ActiveTask.Update()
				
				try FullUpdate() catch()
			)
		)
	),

	-- fn RemoveFromTempLayer =
	-- (
	-- 	print "RemoveFromTempLayer"
		
	-- 	try(
	-- 		local obj = (callbacks.notificationParam())[1]

	-- 		if obj.Layer == MD_BBox.Layer then
	-- 		(
	-- 			with redraw off
	-- 			(
	-- 				DEFAULT_LAYER.addNode obj
	-- 				DEFAULT_LAYER.Current = true					
	-- 			)
	-- 		)		
	-- 	) catch()

	-- 	MD_UI.UpdateCatalogToolsRlt()
	-- ),

	fn UpdateState =
	(
		-- print "UpdateState"
		try(
			if MD_Data.ActiveTask == MD_Data.InWorkTask then
			(
				MD_Data.Update()
				try FullUpdate() catch()
			)	
		) catch()
	),

	fn MatChange ev nd =
	(
		-- print "MatChange"

		try (
			--print MD_Data.ActiveTask.Material.materialList.count
		)catch()
	),

	fn Add =
	(
		-- print "Add"

		callbacks.addScript #layerDeleted CheckExistTaskLayer id:#md_callbacks
		callbacks.addScript #filePostOpen UpdateState id:#md_callbacks
		callbacks.addScript #nodeCloned AddObject id:#md_callbacks
		callbacks.addScript #sceneNodeAdded AddObject id:#md_callbacks
		callbacks.addScript #nodeCreated AddObject id:#md_callbacks
		callbacks.addScript #nodePreDelete DeleteObject id:#md_callbacks
		callbacks.addScript #nodeLayerChanged LayerChange id:#md_callbacks
		-- callbacks.addScript #nodeLayerChanged RemoveFromTempLayer id:#md_callbacks
		-- callbacks.addScript #selectionSetChanged MD_UI.UpdateCatalogToolsRlt id:#md_callbacks

		ToolsUIUpdate = NodeEventCallback mouseUp:false delay:250 \
		materialOtherEvent:MatChange \
		selectionChanged: UpdateUI \
		subobjectSelectionChanged:UpdateUI2
		-- deleted: DeleteObject \
		-- layerChanged: LayerChange \
		-- added: AddObject \
	),

	fn Destruct =
	(
		-- print "Destruct"
		callbacks.removeScripts id:#md_callbacks
		ToolsUIUpdate = undefined
		gc light:true
	)
)