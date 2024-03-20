function fn_getRolloutBackgroundColor type:#dotnet =
(
    /*<FUNCTION>
    Description
        gets the rollout background color from the current cui color file, or uses a default value if the user hasn't customized the colors before
        Supports the clrx <xml> and clr <ini> files.
        the colors are stored as an an integer in these files which can be converted by dotnet to a normal color value
    Arguments
        <name> #type: the type of output color #max | #dotnet
    Return
        <color> the background color
    <FUNCTION>*/
    
    --The custom colors are stored in a file. This file is named in the max ini file.
    local clrxFilePath = getIniSetting (getMAXIniFile()) "CuiConfiguration" "ColorFileName" --max 2013 and up
    local clrFilePath = getIniSetting (getMAXIniFile()) "CustomColors" "FileName" --max 2012 and down
        
    --try to get the background color value from either colorfile
    local theDecimalColor = case of
    (
        (doesFileExist clrxFilePath): --colors are stored in an xml format for max 2013 and up 
        (
            dotnet.loadAssembly "system.xml"
            local xmlDoc = dotNetObject "system.xml.xmlDocument"
            xmlDoc.load clrxFilePath

            local theStoredValue = xmlDoc.selectSingleNode "//ADSK_CLR/CustomColors/color[@name='Background' and @category='Appearance']/@ColorRef"
            theStoredValue.value as integer 
        )
        (doesFileExist clrFilePath): --colors are stored in an ini-format in max 2012 and down
        (
            local theStoredValue = getIniSetting clrFilePath "CustomColors" "Color_0"
            theStoredValue as integer
        )
    )
    
    if classof theDecimalColor != integer do theDecimalColor = 4473924 --if the user hasn't customized the colors before, we use a default value, that's rgb 68 68 68 from the dark theme
    local theTransparentColor = (dotnetclass "system.Drawing.color").FromArgb theDecimalColor --it's transparent by default, we don't want that since it turns the control white
    local theColor = (dotnetclass "system.Drawing.color").FromArgb 255 theTransparentColor.b theTransparentColor.g theTransparentColor.r --make a new color based on the old one but fully opaque
    if type == #max do theColor = color theColor.r theColor.g theColor.b --convert the dotnet color to a 3dsmax color value if needed
        
    theColor
)