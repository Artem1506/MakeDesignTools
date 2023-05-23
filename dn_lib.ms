struct DotNetLib
(
	Pixel = (DotNetClass "System.Drawing.GraphicsUnit").Pixel ,
	ControlMousePos = (DotNetClass "System.Windows.Forms.Control").MousePosition ,
	Clipboard = DotNetClass "System.Windows.Forms.Clipboard" ,
	Keys = DotNetClass "System.Windows.Forms.Keys" ,
-- Screen
	Screen = (DotNetClass "System.Windows.Forms.Screen").PrimaryScreen ,
	ScreenWidth = Screen.Bounds.Width ,
	ScreenHeight = Screen.Bounds.Height ,
-- MouseButtons
	MouseButtonLeft = (DotNetClass "System.Windows.Forms.MouseButtons").Left ,
	MouseButtonRight = (DotNetClass "System.Windows.Forms.MouseButtons").Right ,
	MouseButtonMiddle = (DotNetClass "System.Windows.Forms.MouseButtons").Middle ,
	MouseButtonNone = (DotNetClass "System.Windows.Forms.MouseButtons").None ,
-- FlatStyle
	Flat = (DotNetClass "System.Windows.Forms.FlatStyle").Flat ,
	Popup = (DotNetClass "System.Windows.Forms.FlatStyle").Popup ,
	Standard = (DotNetClass "System.Windows.Forms.FlatStyle").Standard ,
	System = (DotNetClass "System.Windows.Forms.FlatStyle").System ,
-- BorderStyle
	Fixed3D = (DotNetClass "System.Windows.Forms.BorderStyle").Fixed3D ,
	FixedSingle = (DotNetClass "System.Windows.Forms.BorderStyle").FixedSingle ,
	BorderNone = (DotNetClass "System.Windows.Forms.BorderStyle").None ,
-- FormBorderStyle
	FormFixed3D = (DotNetClass "System.Windows.Forms.FormBorderStyle").Fixed3D ,
	FormFixedDialog = (DotNetClass "System.Windows.Forms.FormBorderStyle").FixedDialog ,
	FormFixedSingle = (DotNetClass "System.Windows.Forms.FormBorderStyle").FixedSingle ,
	FormFixedToolWindow = (DotNetClass "System.Windows.Forms.FormBorderStyle").FixedToolWindow ,
	FormNone = (DotNetClass "System.Windows.Forms.FormBorderStyle").None ,
	FormSizable = (DotNetClass "System.Windows.Forms.FormBorderStyle").Sizable ,
	FormSizableToolWindow = (DotNetClass "System.Windows.Forms.FormBorderStyle").SizableToolWindow ,
-- AutoSizeMode
	GrowAndShrink = (DotNetClass "System.Windows.Forms.AutoSizeMode").GrowAndShrink ,
	GrowOnly = (DotNetClass "System.Windows.Forms.AutoSizeMode").GrowOnly ,
-- FlowDirection
	BottomUp = (DotNetClass "System.Windows.Forms.FlowDirection").BottomUp ,
	LeftToRight = (DotNetClass "System.Windows.Forms.FlowDirection").LeftToRight ,
	RightToLeft = (DotNetClass "System.Windows.Forms.FlowDirection").RightToLeft ,
	TopDown = (DotNetClass "System.Windows.Forms.FlowDirection").TopDown ,
-- ImageLayout
	Center = (DotNetClass "System.Windows.Forms.ImageLayout").Center ,
	None = (DotNetClass "System.Windows.Forms.ImageLayout").None ,
	Stretch = (DotNetClass "System.Windows.Forms.ImageLayout").Stretch ,
	Tile = (DotNetClass "System.Windows.Forms.ImageLayout").Tile ,
-- TextAlign
	BottomCenter = (DotNetClass "System.Drawing.ContentAlignment").BottomCenter ,
	BottomLeft = (DotNetClass "System.Drawing.ContentAlignment").BottomLeft ,
	BottomRight = (DotNetClass "System.Drawing.ContentAlignment").BottomRight ,
	MiddleCenter = (DotNetClass "System.Drawing.ContentAlignment").MiddleCenter ,
	MiddleLeft = (DotNetClass "System.Drawing.ContentAlignment").MiddleLeft ,
	MiddleRight = (DotNetClass "System.Drawing.ContentAlignment").MiddleRight ,
	TopCenter = (DotNetClass "System.Drawing.ContentAlignment").TopCenter ,
	TopLeft = (DotNetClass "System.Drawing.ContentAlignment").TopLeft ,
	TopRight = (DotNetClass "System.Drawing.ContentAlignment").TopRight ,
-- Orientation
	Horizontal = (DotNetClass "System.Windows.Forms.Orientation").Horizontal ,
	Vertical = (DotNetClass "System.Windows.Forms.Orientation").Vertical ,
-- Mouse Position
	MousePosition = (DotNetClass "System.Windows.Forms.Control").MousePosition ,
-- Transparent Color
	Transp = (DotNetClass "System.Drawing.Color").Transparent,	
-- Image
	fn Image bitmap_file = (DotNetClass "System.Drawing.Image").FromFile bitmap_file ,
-- Cursor
	Cursor = DotNetClass "System.Windows.Forms.Cursor",
-- Color
	fn dnColor r g b a = (DotNetClass "System.Drawing.Color").FromArgb a r g b ,
-- Padding
	fn Pad a b c d = DotNetObject "System.Windows.Forms.Padding" a b c d ,
-- Point		
	fn Pos x y = (DotNetObject "System.Drawing.Point" x y) ,
-- Size
	fn Size w h = (DotNetObject "System.Drawing.Size" w h) ,
-- Rectangle	
	fn Rect x y w h = (DotNetObject "System.Drawing.Rectangle" x y w h) ,
-- Font
	fn Font family size style = 
	(
		-- Defeaul 0 8.25 1
		fname
		fstyle
		case family of
		(
			0: (fname = "Microsoft Sans Serif")
			1: (fname = "Verdana")
			2: (fname = "Tahoma")
			3: (fname = "Arial")
			4: (fname = "Courier New")
			5: (fname = "Consolas")
			6: (fname = "Century Gothic")
			7: (fname = "Segoe UI Symbol")
			8: (fname = "Times New Roman")
		)
		case style of
		(
			1: (fstyle = (dotNetClass "System.Drawing.FontStyle").Regular)
			2: (fstyle = (dotNetClass "System.Drawing.FontStyle").Italic)
			3: (fstyle = (dotNetClass "System.Drawing.FontStyle").Bold)
		)
		dotNetObject "System.Drawing.Font" fname size fstyle
	) ,
-- Bitmap from file
	fn Bmap w h bitmap_file =
	(
		img = (DotNetClass "System.Drawing.Image").FromFile bitmap_file 
		dn_bitmap = DotNetObject "System.Drawing.Bitmap" w h
		graphic = (DotNetClass "System.Drawing.Graphics").FromImage dn_bitmap
		graphic.InterpolationMode = graphic.InterpolationMode.HighQualityBicubic
		graphic.PixelOffsetMode = graphic.PixelOffsetMode.highQuality
		graphic.DrawImage img 0 0 w h
		img.Dispose()
		dn_bitmap	
	) ,
-- Resize Bitmap
	fn ResizeBmap new_w new_h dn_bitmap quality:1 =
	(
		new_bitmap = DotNetObject "System.Drawing.Bitmap" new_w new_h
		graphic = (DotNetClass "System.Drawing.Graphics").FromImage new_bitmap
		case quality of
		(
			0:
			(
				graphic.InterpolationMode = graphic.InterpolationMode.NearestNeighbor
				graphic.PixelOffsetMode = graphic.PixelOffsetMode.HighSpeed					
			)
			1:
			(
				graphic.InterpolationMode = graphic.InterpolationMode.HighQualityBicubic
				graphic.PixelOffsetMode = graphic.PixelOffsetMode.highQuality				
			)
		)
		graphic.DrawImage dn_bitmap 0 0 new_w new_h
		new_bitmap	
	) ,
-- Create icon from image file
	fn IconMaker w h bitmap_file icon_num =
	(
		img = (DotNetClass "System.Drawing.Image").FromFile bitmap_file
		bmp_icon = DotNetObject "System.Drawing.Bitmap" w h
		graphic = (DotNetClass "System.Drawing.Graphics").FromImage bmp_icon
		graphic.DrawImage img (Rect 0 0 img.Width img.Height) (Rect (w * icon_num) 0 img.Width img.Height) Pixel
		img.Dispose()
		bmp_icon
	) ,
-- Bitmap from fill
	fn FillRectangle w h fill_color =
	(
		dn_bitmap = DotNetObject "System.Drawing.Bitmap" w h
		graphic = (DotNetClass "System.Drawing.Graphics").FromImage dn_bitmap
		fill_brush = dotnetobject "System.Drawing.SolidBrush" fill_color
		fill_rect = Rect 0 0 w h
		graphic.FillRectangle fill_brush fill_rect
		dn_bitmap
	) ,
-- .NET Controls
	fn newForm n:"" w:200 h:200 bc:(Color 0 0 0 255) fc:(Color 220 220 220 255) =
	(
		ctrl = DotNetObject "System.Windows.Forms.Form"
		ctrl.Name = n
		ctrl.Margin = ctrl.Padding = Pad 0 0 0 0
		ctrl.Width = w
		ctrl.Height = h
		ctrl.BackColor = bc
		ctrl.ForeColor = bc
		ctrl.AllowTransparency = true
		ctrl.Topmost = false
		ctrl.ShowInTaskbar = false
		ctrl.StartPosition = (DotNetClass "System.Windows.Forms.FormStartPosition").CenterScreen
-- 		ctrl.StartPosition = (DotNetClass "System.Windows.Forms.FormStartPosition").CenterParent
-- 		ctrl.StartPosition = (DotNetClass "System.Windows.Forms.FormStartPosition").WindowsDefaultBounds
-- 		ctrl.StartPosition = (DotNetClass "System.Windows.Forms.FormStartPosition").WindowsDefaultLocation
		ctrl
	) ,	
	
	fn newUserControl n:"" w:200 h:200 bc:(Color 0 0 0 255) fc:(Color 180 180 180 255) =
	(
		ctrl = DotNetObject "System.Windows.Forms.UserControl" 
		ctrl.Name = n
		ctrl.Margin = ctrl.Padding = Pad 0 0 0 0
		ctrl.Width = w
		ctrl.Height = h
		ctrl.BackColor = bc
		ctrl.ForeColor = bc
		ctrl
	) ,
	
	fn newPictureBox n:"" w:200 h:200 bc:(Color 0 0 0 255) fc:(Color 180 180 180 255) =
	(
		ctrl = DotNetObject "System.Windows.Forms.PictureBox"
		ctrl.Name = n
		ctrl.Margin = ctrl.Padding = Pad 0 0 0 0
		ctrl.Width = w
		ctrl.Height = h
		ctrl.BackColor = bc
		ctrl.ForeColor = bc
		ctrl
	) ,
	
	fn newFlowLayoutPanel n:"" w:200 h:200 bc:(Color 0 0 0 255) fc:(Color 180 180 180 255) =
	(
		ctrl = DotNetObject "System.Windows.Forms.FlowLayoutPanel"
		ctrl.Name = n
		ctrl.Margin = ctrl.Padding = Pad 0 0 0 0
		ctrl.Width = w
		ctrl.Height = h
		ctrl.BackColor = bc
		ctrl.ForeColor = bc
		ctrl
	) ,
	
	fn newSplitContainer n:"" w:200 h:200 bc:(Color 0 0 0 255) fc:(Color 180 180 180 255) =
	(
		ctrl = DotNetObject "System.Windows.Forms.SplitContainer"
		ctrl.Name = n
		ctrl.Margin = ctrl.Padding = Pad 0 0 0 0
		ctrl.Width = w
		ctrl.Height = h
		ctrl.BackColor = bc
		ctrl.ForeColor = bc
		ctrl
	) ,
	
	fn newLabel n:"" w:200 h:200 bc:(Color 0 0 0 255) fc:(Color 180 180 180 255) txt:"" =
	(
		ctrl = DotNetObject "System.Windows.Forms.Label"
		ctrl.Name = n
		ctrl.Margin = ctrl.Padding = Pad 0 0 0 0
		ctrl.Width = w
		ctrl.Height = h
		ctrl.BackColor = bc
		ctrl.ForeColor = fc
		ctrl.Text = txt
		ctrl.TextAlign = MiddleCenter
		ctrl.Font = Font 3 8 1
		ctrl
	)
)
DN_Lib = DotNetLib()


