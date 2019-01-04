script "DataView Card Behavior"


on ResizeView pWidth, pHeight
  local tRect

  set the bottomleft of field "LblMessage" to 20,pHeight-12

  put the rect of group "Extensions" into tRect
  put pWidth - 20 into item 3 of tRect
  put the top of field "LblMessage" - 8 into item 4 of tRect
  set the rect of group "Extensions" to tRect
end ResizeView


on OpenView pHasBeenOpened
  _populateDataView
end OpenView


command uiRevealExtension pRow
  local tInstallPath

  dispatch function "GetValueForKeyInRow" to group "Extensions" with pRow, "install_path"
  put the result into tInstallPath

  launch document tInstallPath
end uiRevealExtension


private command _populateDataView
  local tDataA, tExtensionsA, tExtensions
  local i, tExtension

  put revIDEExtensions() into tExtensionsA

  put the keys of tExtensionsA into tExtensions
  sort tExtensions

  repeat for each line tExtension in tExtensions
    add 1 to i

    put tExtension into tDataA[i]["name"]
    put i into tDataA[i]["id"]
    put tExtensionsA[tExtension]["author"] into tDataA[i]["author"]
    put tExtensionsA[tExtension]["icon"] into tDataA[i]["icon"]
    put tExtensionsA[tExtension]["install_path"] into tDataA[i]["install_path"]
    put tExtensionsA[tExtension]["version"] into tDataA[i]["version"]
    put tExtensionsA[tExtension]["source_file"] into tDataA[i]["source_file"]
  end repeat

  set the dvData of group "Extensions" to tDataA
  dispatch "RenderView" to group "Extensions"
end _populateDataView
