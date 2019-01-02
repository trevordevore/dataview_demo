script "Extension Row Template Behavior"

on FillInData pDataA, pRow
  set the text of field "Name" of me to pDataA["name"]
  set the tooltip of field "Name" of me to pDataA["name"]
  set the text of field "Version" of me to pDataA["version"]
  set the text of field "Author" of me to "Author:" && pDataA["author"]
end FillInData


on LayoutControl pControlRect
  local tRect

  set the left of widget "Icon" of me to item 1 of pControlRect + 20
  set the left of field "Name" of me to the right of widget "Icon" of me + 1

  set the left of field "Version" of me to the left of field "Name" of me

  put the rect of field "Name" of me into tRect
  put item 3 of pControlRect into item 3 of tRect
  set the rect of field "Name" of me to tRect

  put the rect of field "Author" of me into tRect
  put the right of field "Version" of me into item 1 of tRect
  put item 3 of pControlRect into item 3 of tRect
  set the rect of field "Author" of me to tRect

  set the rect of graphic "Background" of me to pControlRect
end LayoutControl


setprop dvHilite [pColor] pBoolean

  pass dvHilite
end dvHilite


getProp dvRowControl
  return the long id of me
end dvRowControl


on mouseDoubleUp pBtnNum
  if pBtnNum is 1 then
    uiRevealExtension the dvRow of me
  end if
end mouseDoubleUp
