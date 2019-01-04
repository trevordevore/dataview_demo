script "DataView Db Cursor Behavior"
local sConnId
local sCursorId

on PreOpenView
  local tDbFile

  put levureAppFolder() & "/database/fontawesome.db" into tDbFile
  put revOpenDatabase("sqlite", tDbFile) into sConnId
end PreOpenView


on closeCard
  set the dvCursor of group "Icons" to empty
  if sCursorId is an integer then
    revCloseCursor sCursorId
  end if
  if sConnId is an integer then
    revCloseDatabase sConnId
  end if
end closeCard


on ResizeView pWidth, pHeight
  local tRect

  set the bottomleft of field "LblMessage" to 20,pHeight-12

  put the rect of group "Icons" into tRect
  put pWidth - 20 into item 3 of tRect
  put the top of field "LblMessage" - 8 into item 4 of tRect
  set the rect of group "Icons" to tRect
end ResizeView


on OpenView pHasBeenOpened
  _populateDataView
  set the text of field "LblMessage" to "Number of icons:" && the viewProp["number of rows"] of group "Icons"
end OpenView


private command _populateDataView
  put revQueryDatabase(sConnId, "SELECT * FROM icons") into sCursorId
  set the dvCursor of group "Icons" to sCursorId
  dispatch "RenderView" to group "Icons"
end _populateDataView
