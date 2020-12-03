# DataView Demo Levure Project

This repo contains a Levure application which demonstrates how to use
the DataView, DataView Tree, DataView DBCursor, and DataView Paginated Scroll helpers. If you are checking this repo
out with git on your local computer make sure you initialize submodules.
Levure, DataView helper, DataView Tree helper, and DataView Database
Cursor helper, and DataView Paginated Scroll helper are all submodules.

Screencast walkthrough: https://youtu.be/euIHj1Qrokk

Levure: https://github.com/trevordevore/levure

DataView helper: https://github.com/trevordevore/levurehelper-dataview

DataView Tree helper: https://github.com/trevordevore/levurehelper-dataview-tree

DataView Database Cursor helper: https://github.com/trevordevore/levurehelper-database_dbcursor

DataView Paginated Scroll helper: https://github.com/trevordevore/levurehelper-dataview_paginated_scroll

File Browser helper: https://github.com/trevordevore/levurehelper-file_browser

Requirements: Tested with LiveCode 9.

## Usage

1. Download the sample folder with all necessary files: https://github.com/trevordevore/dataview_demo/releases/download/v0.4.0/dataview_demo.zip
If instead you would like to checkout using Git, be sure to include the `--recurse-submodules` option to include all required files: `git clone --recurse-submodules https://github.com/trevordevore/dataview_demo.git`
2. To open the application, launch LiveCode and open the
`./app/standalone.livecode` stack file, switch to the Browse tool, and
click on the **Open Application** button.

## DataView Example

The DataView example displays all of the extensions installed in the
LiveCode IDE as returned by the function `revIDEExtensions()`. Each row
lists the extension name, version, and author. Double-clicking on a row
will reveal the folder where the extension is installed.

The behavior of the DataView group is set to `stack "DataView Array
Controller Behavior"`. This is the default controller that comes with
the DataView helper. The behavior scripts adds a `dvData` property
(among many others) that is set to a numerically indexed array of row
data arrays. This array is fed to the DataView.

You will find the row template used in the DataView in the
`./app/templates/dataview templates` folder.

## File Browser: DataView Tree Example

The File Browser helper is a helper built on top of the DataView Tree. It creates a tree UI based on a folder you select
on your computer. The UI allows you to expand the contents of any
folders listed. Double-clicking on a file or folder will open it.

You can right-click on a file or folder and rename it using the
contextual menu. The file/folder will not actually be renamed but an
answer dialog will appear showing you what the new name would be.

## Stack Browser: DataView Tree Example

The stack browser example is built on top of the DataView Tree. It creates a tree UI for browsing the open stacks in the IDE. The behavior of the DataView group is set to `stack "DataView Tree
Behavior"`, the behavior that comes with the helper. The behavior
scripts adds a `dvTree` property (among many others) that is set to a
numerically indexed array of node arrays.

You will find the row templates used in the DataView in the
`./app/templates/dataview controls templates` folder.

## FontAwesome: DataView Database Cursor Example

The FontAwesome tab is an example that uses the **dataview_dbcursor**
helper to display a database cursor that has been opened using
`revQueryDatabase()`. The database contains the name of drawing
representations (see `drawingSvgCompile()` in the LiveCode docs) of the
FontAwesome icons.

The behavior of the DataView group is set to `stack "DataView Database
Cursor Controller Behavior"`, the behavior that comes with the helper.
The behavior script adds a `dvCursor` property that you can set to the
cursor id returned by `revQueryDatabase()`. When scrolling through the
DataView or setting properties such as the `dvSelectedId` the behavior
will navigate the cursor and fetch the appropriate data.

You will find the row template used in the DataView in the
`./app/templates/dataview db cursor templates` folder.

### Importing SVG files into the database

For reference, the following script was used to import the FontAwesome
SVG files into the fontawesome.db included with this demo.

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
    
    revExecuteSQL tConnId, "INSERT INTO icons (name, compiled_svg)" && \
        "VALUES(:1, :2)", "tName", "*btBinarySVG"
    if the result is not an integer then
      beep
      put the result
      exit repeat
    end if
  end repeat
  
  revCloseDatabase tConnId
end ImportSVGs
```

## Movies: DataView Database Cursor Example

The Movies tab also uses the **dataview_dbcursor** helper.

You will find the row template used in the DataView in the
`./app/templates/dataview movies templates` folder.

## Pokemon: DataView Paginated Scroll Example

The Pokemon tab uses the **dataview_paginated_scroll** helper. This example uses the JSON API available at https://pokeapi.co to show how to gradually feed pages of API results into a DataView while the user scrolls through it.

You will find the row template used in the DataView in the `./app/templates/dataview pokemon templates` folder.
