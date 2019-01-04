# DataView Demo Levure Project

This repo contains a Levure application which demonstrates how to use the DataView and DataView Tree helpers. If you are checking this repo out with git on your local computer make sure you initialize submodules. Levure, DataView helper, and DataView Tree helper are all submodules.

To open the application, launch LiveCode and open the `./app/standalone.livecode` stack file, switch to the Browse tool, and click on the **Open Application** button.

Levure: https://github.com/trevordevore/levure

DataView helper: https://github.com/trevordevore/levurehelper-dataview

DataView Tree helper: https://github.com/trevordevore/levurehelper-dataview-tree

DataView Database Cursor helper: https://github.com/trevordevore/levurehelper-database_dbcursor

Requirements: Tested with LiveCode 9.

## DataView Example

The DataView example displays all of the extensions installed in the LiveCode IDE as returned by the function `revIDEExtensions()`. Each row lists the extension name, version, and author. Double-clicking on a row will reveal the folder where the extension is installed.

The behavior of the DataView group is set to `stack "DataView Array Controller Behavior"`. This is the default controller that comes with the DataView helper. The behavior scripts adds a `dvData` property (among many others) that is set to a numerically indexed array of row data arrays. This array is fed to the DataView.

You will find the row template used in the DataView in the `./app/templates/dataview templates` folder.

## DataView Tree Example

The DataView Tree example creates a tree UI based on a folder you select on your computer. The UI allows you to expand the contents of any folders listed. Double-clicking on a file or folder will open it.

The behavior of the DataView group is set to `stack "DataView Tree Behavior"`, the behavior that comes with the helper. The behavior scripts adds a `dvTree` property (among many others) that is set to a numerically indexed array of node arrays.

You can right-click on a file or folder and rename it using the contextual menu. The file/folder will not actually be renamed but an answer dialog will appear showing you what the new name would be.

You will find the row templates used in the DataView in the `./app/templates/dataview tree templates` folder.

## DataView Database Cursor Example

The DataView Database Cursor example uses the **dataview_dbcursor** helper to display a database cursor that has been opened using  `revQueryDatabase()`. The database contains the name of drawing representation (see `drawingSvgCompile()` in the LiveCode docs) of the FontAwesome icons.

The behavior of the DataView group is set to `stack "DataView Database Cursor Controller Behavior"`, the behavior that comes with the helper. The behavior script adds a `dvCursor` property that you can set to the cursor id returned by `revQueryDatabase()`. When scrolling through the DataView or setting properties such as the `dvSelectedId` the behavior will navigate the cursor and fetch the appropriate data.

You will find the row template used in the DataView in the `./app/templates/dataview db cursor templates` folder.

### Importing SVG files into the database

For reference, the following script was used to import the FontAwesome SVG files into the fontawesome.db included with this demo.

```
command ImportSVGs
  put levureAppFolder() & "/database/fontawesome.db" into tDbFile
  
  answer folder "Images"
  put it into tImageFolder
  
  put revOpenDatabase("sqlite", tDbFile) into tConnId
  
  put files(tImageFolder) into tFiles
  filter tFiles without ".*"
  
  set the itemDelimiter to "."
  repeat for each line tFile in tFiles
    put drawingSvgCompile(url("file:" & tImageFolder & "/" & tFile)) into tBinarySVG
    put item 1 of tFile into tName
    
    revExecuteSQL tConnId, "INSERT INTO icons (name, compiled_svg) VALUES(:1, :2)", "tName", "*btBinarySVG"
    if the result is not an integer then
      beep
      put the result
      exit repeat
    end if
  end repeat
  
  revCloseDatabase tConnId
end ImportSVGs
```
