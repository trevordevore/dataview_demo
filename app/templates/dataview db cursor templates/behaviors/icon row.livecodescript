script "Icon Row Template Behavior"

on FillInData pDataA, pRow
  set the text of field "Name" of me to pDataA["name"] && "(id:" && pDataA["id"] & ")"

  # `compiled_svg` contains result of `drawingSvgCompile()`
  set the text of image "Icon" of me to pDataA["compiled_svg"]
end FillInData


on LayoutControl pControlRect
  local tRect

  set the left of image "Icon" of me to item 1 of pControlRect + 20
  set the left of field "Name" of me to the right of image "Icon" of me + 1

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
