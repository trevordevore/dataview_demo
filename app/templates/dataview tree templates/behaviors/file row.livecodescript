script "File Row Template Behavior"

on FillInData pDataA, pRow
  set the text of field "Filename" of me to pDataA["filename"]
  set the tooltip of field "Filename" of me to pDataA["filename"]
end FillInData


on LayoutControl pControlRect
  local tLevel, tInset, tRect

  put the dvtRowLevel[the dvRow of me] of me - 1 into tLevel
  put tLevel * 15 into tInset
  set the left of widget "Icon" of me to item 1 of pControlRect + 23 + tInset
  set the left of field "Filename" of me to the right of widget "Icon" of me + 1

  put the rect of field "Filename" of me into tRect
  put item 3 of pControlRect into item 3 of tRect
  set the rect of field "Filename" of me to tRect

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
    uiLaunchFile the dvRow of me
  end if
end mouseDoubleUp
