script "File Browser Behavior" with behavior "File Browser DataView Tree Behavior"

/**
Summary: Look for right-clicks which trigger contextual menu.

Description:
If the dvRowControl property of `the target` is non-empty
then a row was clicked on.
*/
on mouseDown pBtnNum
  # dvMouseDown is defined in the DataView behavior. It will select the
  # row that the user clicked on. This is necessary in order for the
  # contextual menu to target the right row.
  dvMouseDown pBtnNum

  if pBtnNum is 3 then
    if the dvRowControl of the target is not empty then
      # Note: `menuPick` is defined in the card behavior script.
      popup button "FileBrowserContextual"
    end if
  end if
end mouseDown


/**
Summary: Look for double-clicks which trigger an action.

Description:
If the dvRowControl property of `the target` is non-empty
then a row was clicked on.
*/
on mouseDoubleUp pBtnNumber
  if pBtnNumber is 1 and the dvRowControl of the target is not empty then
    uiLaunchFile the dvRow of the dvRowControl of the target
  end if
end mouseDoubleUp


/**
Summary: Open field for renaming selected file/folder.

Parameters:
pKey: The name of the key in the node array to edit. This will always be `filename` in this app.

Description:
The `uiRenameCurrentSelection` handler in the card script dispatches the
`EditKeyOfRow` message to the DataView. This in turn sends this `EditKey` message
to the row control associated with the target row.

Since the editing behavior will be the same for files or folders the message is
handled in the DataView itself. `EditKey` could be handled in the individual
row template behavior scripts, however.

Returns: nothing
*/
on EditKey pKey
  local tRowControl

  # Resolve the target row control.
  put the dvRowControl of the target into tRowControl

  # Start editing the "Filename" field in the target row control.
  CreateFieldEditorForField the long id of field "Filename" of tRowControl, "filename"
end EditKey


/**
Summary: This message is sent when the user makes changes in the field editor.

Parameters:
pEditorField: The long id of the field where the edits were made.
pRow: The target row.
pKey: The target key the edits apply to.
pEventThatTriggeredClose: The name of the event that triggered the closing of the edit field.

Description:

Possible values for pEventThatTriggeredClose are `close control`,
`closeField`, `exitField`, `returnInField`, `enterInField`, and `tabKey`.

`close control` is sent when the user scrolls the row that is being edited out of view
and caching is not turned on.

Returns: nothing
*/
on CloseFieldEditor pEditorField, pRow, pKey, pEventThatTriggeredClose
  uiRenameFileOrFolder pRow, the text of pEditorField
end CloseFieldEditor


/**
Summary: This message is sent if the user didn't change anthing during the edit.

Returns: nothing
*/
on ExitFieldEditor pEditorField, pRow, pKey, pEventThatTriggeredClose
  # nothing to do here
end ExitFieldEditor
