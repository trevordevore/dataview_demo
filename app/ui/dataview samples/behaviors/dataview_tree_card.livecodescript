script "DataView Tree Card Behavior"

local sRootFolder


on resizeStack pWidth, pHeight
  local tRect

  set the bottomleft of field "LblMessage" to 20,pHeight-12

  put the rect of group "FolderListing" into tRect
  put pWidth - 20 into item 3 of tRect
  put the top of field "LblMessage" - 8 into item 4 of tRect
  set the rect of group "FolderListing" to tRect
end resizeStack

/**
Summary: Request from DataView Tree for node data to display.

Returns: nothing
*/
command DataForNode pNodeA, pRow, @rDataA, @rTemplate
  put pNodeA into rDataA
  put pNodeA["type"] into rTemplate
end DataForNode


/**
Summary: Ask user to select folder to display in DataView.

Returns: nothing
*/
command uiSelectFolder
  local tFolder

  answer folder "Select folder to display:"
  put it into tFolder

  if tFolder is not empty then
    DisplayFolderInDataView tFolder
  end if
end uiSelectFolder


command uiToggleRow pRow
  if the dvtRowIsExpanded[pRow] of group "FolderListing" then
    set the dvtRowChildren[pRow] of group "FolderListing" to empty
    dispatch "SetRowIsExpanded" to group "FolderListing" with pRow, empty, false
  else
    local tFolder, tNodesA

    dispatch function "GetValueForKeyInRow" to group "FolderListing" with pRow, "relative path"
    put sRootFolder & "/" & the result into tFolder
    put createNodesForFolder(tFolder) into tNodesA
    set the dvtRowChildren[pRow] of group "FolderListing" to tNodesA
    dispatch "SetRowIsExpanded" to group "FolderListing" with pRow, empty, true
  end if
end uiToggleRow


command uiLaunchFile pRow
  local tFilepath

  dispatch function "GetValueForKeyInRow" to group "FolderListing" with pRow, "relative path"
  put sRootFolder & "/" & the result into tFilepath

  launch document tFilepath
end uiLaunchFile


/**
Summary: Populate tree with level 1 contents of folder.

Parameters:
pFolder: The folder to display.

Returns: nothing
*/
command DisplayFolderInDataView pFolder
  local tFolders
  local tNodesA

  put pFolder into sRootFolder

  put createNodesForFolder(pFolder) into tNodesA

  set the dvtTree of group "FolderListing" to tNodesA
  dispatch "RenderView" to group "FolderListing"
end DisplayFolderInDataView


private function createNodesForFolder pFolder
  local tRelativeFolder, tFolders, tFiles, tNodeA, tIndex, tNodesA

  put pFolder into tRelativeFolder
  replace sRootFolder with empty in tRelativeFolder
  delete char 1 of tRelativeFolder # strip leading "/"
  if tRelativeFolder is not empty then put "/" after tRelativeFolder

  put getFoldersInFolder(pFolder) into tFolders
  put getFilesInFolder(pFolder) into tFiles

  repeat for each line tFolder in tFolders
    put empty into tNodeA
    put tFolder into tNodeA["filename"]
    put tRelativeFolder & tFolder into tNodeA["relative path"]
    put hashForFile(tNodeA["relative path"]) into tNodeA["id"]
    put "folder" into tNodeA["type"]
    put false into tNodeA["expanded"]
    put false into tNodeA["is leaf"]
    put empty into tNodeA["children"]

    add 1 to tIndex
    put tNodeA into tNodesA[tIndex]
  end repeat

  repeat for each line tFile in tFiles
    put empty into tNodeA
    put tFile into tNodeA["filename"]
    put tRelativeFolder & tFile into tNodeA["relative path"]
    put hashForFile(tNodeA["relative path"]) into tNodeA["id"]
    put "file" into tNodeA["type"]
    put true into tNodeA["is leaf"]

    add 1 to tIndex
    put tNodeA into tNodesA[tIndex]
  end repeat

  return tNodesA
end createNodesForFolder


private function getFoldersInFolder pFolder
  local tFolders

  put folders(pFolder) into tFolders
  filter tFolders without ".*"
  sort tFolders
  return tFolders
end getFoldersInFolder


private function getFilesInFolder pFolder
  local tFiles

  put files(pFolder) into tFiles
  filter tFiles without ".*"
  sort tFiles
  return tFiles
end getFilesInFolder


private function hashForFile pFilename
  return strDigest(sRootFolder & "/" & pFilename)
end hashForFile


private function strDigest pString
  local tDigest, tHash
  put md5Digest(pString) into tDigest
  get binarydecode("H*", tDigest, tHash)
  return tHash
end strDigest
