script "Pokemon Row Template Behavior"

on FillInData pDataA, pRow
  if pDataA["name"] is not empty then
    set the htmltext of field "Name" of me to "<b>" & pDataA["name"] & "</b>" && "[url:" && pDataA["url"] & "]"
  else
    set the text of field "Name" of me to "loading..."
  end if
end FillInData


on LayoutControl pControlRect
  local tRect

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
