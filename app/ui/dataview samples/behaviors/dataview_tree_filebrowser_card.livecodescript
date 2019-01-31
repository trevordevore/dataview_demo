script "File Browser Example Card Behavior"

on ResizeView pWidth, pHeight
  local tRect

  set the bottomleft of field "LblMessage" to 20,pHeight-12

  put the rect of group "FileBrowser" into tRect
  put pWidth - 20 into item 3 of tRect
  put the top of field "LblMessage" - 8 into item 4 of tRect
  set the rect of group "FileBrowser" to tRect
end ResizeView


on closeCard
  dispatch "ResetView" to group "FileBrowser"
end closeCard


/**
Summary: Respond to the "FileBrowserContextual" contextual menu menuPick message.

Description:
This will trigger a sequence of events which will open a field
for editing the filename of the selected row.

Returns: nothing
*/
on menuPick pItem
  switch pItem
    case "rename"
      uiRenameCurrentSelection
      break
  end switch
end menuPick


/**
Summary: Ask user to select folder to display in DataView.

Returns: nothing
*/
command uiSelectFolder
  local tFolder

  answer folder "Select folder to display:"
  put it into tFolder

  if tFolder is not empty then
    set the dvRootFolder of group "FileBrowser" to tFolder
  end if
end uiSelectFolder


command uiLaunchFile pRow
  local tFilepath

  put the dvPathOfRow[pRow] of group "FileBrowser" into tFilePath

  launch document tFilepath
end uiLaunchFile


command uiResetFileBrowser
  dispatch "ResetView" to group "FileBrowser"
end uiResetFileBrowser


/**
Summary: Tell the DataView to start editing the filename of the currently selected row.

Description:
Refer to the `EditKey` handler in the behavior attached to the
**FileBrowser** group (file_browser.livecodescript).

Returns: nothing
*/
command uiRenameCurrentSelection
  dispatch "EditKeyOfRow" to group "FileBrowser" with "filename", the dvHilitedRow of group "FileBrowser"
end uiRenameCurrentSelection


/**
Summary: Called from the FileBrowser behaivor (file_browser.livecodescript) script when the user has entered a new filename.

Parameters:
pRow: The target row.
pNewName: The new name.

Returns: nothing
*/
command uiRenameFileOrFolder pRow, pNewName
  local tFilepath, tNewFilePath

  dispatch function "GetValueForKeyInRow" to group "FileBrowser" with pRow, "relative path"
  put the dvPathOfRow[pRow] of group "FileBrowser" into tFilePath
  put tFilePath into tNewFilePath

  set the itemdelimiter to "/"
  put pNewName into the last item of tNewFilePath

  answer quote & tFilepath & quote && "would be renamed to" && quote & tNewFilePath & quote
end uiRenameFileOrFolder
