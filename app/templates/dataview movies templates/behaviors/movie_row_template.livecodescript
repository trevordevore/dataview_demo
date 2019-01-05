script "Movie Row Template Behavior"

on FillInData pDataA, pRow
  local tDate

  set the text of field "Title" of me to pDataA["title"]

  lock messages
  set the menuhistory of button "Genre" of me to lineoffset(pDataA["genre"], the text of button "Genre" of me)
  unlock messages

  put ConvertGMTTimestampToInternetTimeStamp(pDataA["release_date"]) into tDate
  convert tDate from internet date to abbreviated system date
  set the text of field "ReleaseDate" of me to "Release Date:" && tDate

  ResizeLabelFieldtoFit the long id of field "LblGenre" of me
  ResizeLabelFieldtoFit the long id of field "ReleaseDate" of me
end FillInData


on LayoutControl pControlRect
  local tRect

  set the left of button "Genre" of me to the right of field "LblGenre" of me
  set the right of field "ReleaseDate" of me to item 3 of pControlRect

  put the rect of graphic "Background" of me into tRect
  put item 3 of pControlRect into item 3 of tRect
  set the rect of graphic "Background" of me to tRect
end LayoutControl


setprop dvHilite [pColor] pBoolean

  pass dvHilite
end dvHilite


getProp dvRowControl
  return the long id of me
end dvRowControl
