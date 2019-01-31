script "Movies Db Cursor Behavior"
local sConnId
local sCursorId

on PreOpenView
  local tDbFile

  put levureAppFolder() & "/database/movies.db" into tDbFile
  put revOpenDatabase("sqlite", tDbFile) into sConnId
end PreOpenView


on closeCard
  set the dvCursor of group "Movies" to empty
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

  put the rect of group "Movies" into tRect
  put pWidth - 20 into item 3 of tRect
  put the top of field "LblMessage" - 8 into item 4 of tRect
  set the rect of group "Movies" to tRect
end ResizeView


on OpenView pHasBeenOpened
  # allow view to load immediately
  send "PopulateDataView" to me in 0 seconds
end OpenView


command PopulateDataView
  put revQueryDatabase(sConnId, "SELECT * FROM movies") into sCursorId
  set the dvCursor of group "Movies" to sCursorId
  set the text of field "LblMessage" to "Number of movies:" && the viewProp["number of rows"] of group "Movies"
end PopulateDataView


function ConvertGMTTimestampToInternetTimeStamp pGMTTime
  local theGMTOffset

  set the wholematches to true
  if the last word of pGMTTime is among the items of "UTC,GMT" then delete the last word of pGMTTime

  ## 1) Determine local system GMT offset
  put LocalSystemGMTOffset() into theGMTOffset

  ## 2) Convert GMT to date items
  replace "-" with comma in pGMTTime
  replace " " with comma in pGMTTime
  replace ":" with comma in pGMTTime
  put comma & 0 after pGMTTime ## we don't know day of week

  ## 3) subtract the GMT offset from item 4 of the date items
  add theGMTOffset to item 4 of pGMTTime

  ## 4) convert date items to the internet date
  convert pGMTTime from dateItems to internet date
  return pGMTTime
end ConvertGMTTimestampToInternetTimeStamp


function InternetTimeStampGMTOffset pInternetTime
  local theGMTOffset

  put the last word of pInternetTime into theGMTOffset
  delete the char -2 to -1 of theGMTOffset
  if char 2 of theGMTOffset is 0 then delete char 2 of theGMTOffset
  if char 1 of theGMTOffset is "+" then delete char 1 of theGMTOffset
  return theGMTOffset
end InternetTimeStampGMTOffset


function LocalSystemGMTOffset
  local theDate

  put the internet date into theDate
  return InternetTimeStampGMTOffset(theDate)
end LocalSystemGMTOffset


command ResizeLabelFieldtoFit pField
  local theAlignment, theRect, theDontWrap, theLoc

  put the textalign of pField into theAlignment
  put the rect of pField into theRect
  put the dontwrap of pField into theDontWrap
  set the dontwrap of pField to true

  switch theAlignment
    case "left"
      put item 1 of theRect + the formattedwidth of pField into item 3 of theRect
      set the rect of pField to theRect
      break
    case "right"
      put item 3 of theRect - the formattedwidth of pField into item 1 of theRect
      set the rect of pField to theRect
      break
    case "center"
      lock screen
      put the loc of pField into theLoc
      set the width of pField to the formattedwidth of pField
      set the loc of pField to theLoc
      unlock screen
      break
  end switch
  set the dontwrap of pField to theDontWrap
end ResizeLabelFieldtoFit
