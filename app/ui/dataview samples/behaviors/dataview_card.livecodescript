script "DataView Card Behavior"


on ResizeView pWidth, pHeight
  local tRect

  put the rect of group "DataView" into tRect
  put pWidth - 20 into item 3 of tRect
  put pHeight - 20 into item 4 of tRect
  set the rect of group "DataView" to tRect
end ResizeView
