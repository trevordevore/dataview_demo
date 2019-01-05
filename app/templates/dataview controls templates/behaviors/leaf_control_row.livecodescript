script "Leaf Control Row Behavior"

on FillInData pDataA, pRow
  local tName

  if word 1 to 2 of pDataA["name"] is not pDataA["type"] && "id" then
    put pDataA["type"] & " " & quote & pDataA["name"] & quote into tName
  else
    put pDataA["name"] into tName
  end if

  set the text of field "Name" of me to tName
  set the tooltip of field "Name" of me to pDataA["id"]

  set the iconPath of widget "Icon" of me to GetIconForControlType(pDataA["type"])
end FillInData


on LayoutControl pControlRect
  local tLevel, tInset, tRect

  put the dvtRowLevel[the dvRow of me] of me - 1 into tLevel
  put tLevel * 15 into tInset
  set the left of widget "Icon" of me to item 1 of pControlRect + 23 + tInset
  set the left of field "Name" of me to the right of widget "Icon" of me + 1

  put the rect of field "Name" of me into tRect
  put item 3 of pControlRect into item 3 of tRect
  set the rect of field "Name" of me to tRect

  set the rect of graphic "Background" of me to pControlRect
end LayoutControl


setprop dvHilite [pColor] pBoolean

  pass dvHilite
end dvHilite


getProp dvRowControl
  return the long id of me
end dvRowControl
