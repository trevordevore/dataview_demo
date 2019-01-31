script "DataView Tree Control Browser Behavior"

on ResizeView pWidth, pHeight
  local tRect

  set the bottomleft of button "ShowIDEStacks" to 20,pHeight-12

  put the rect of group "ControlBrowser" into tRect
  put pWidth - 20 into item 3 of tRect
  put the top of button "ShowIDEStacks" - 8 into item 4 of tRect
  set the rect of group "ControlBrowser" to tRect
end ResizeView


on OpenView pHasBeenOpened
  uiPopulateDataView
end OpenView


on closeCard
  dispatch "ResetView" to group "ControlBrowser"
end closeCard


command uiPopulateDataView
  local tNodesA

  put createNodesForEnvironment() into tNodesA
  set the dvTree of group "ControlBrowser" to tNodesA
end uiPopulateDataView


/**
Summary: Request from DataView Tree for node data to display.

Returns: nothing
*/
command DataForNode pNodeA, pRow, @rDataA, @rTemplate
  put pNodeA into rDataA

  if pNodeA["type"] is among the items of "stack,card,group" then
    put "expandable" into rTemplate
  else
    put "leaf" into rTemplate
  end if
end DataForNode


command uiToggleRow pRow
  if the dvRowIsExpanded[pRow] of group "ControlBrowser" then
    set the dvRowChildren[pRow] of group "ControlBrowser" to empty
    dispatch "SetRowIsExpanded" to group "ControlBrowser" with pRow, empty, false
  else
    local tNodesA

    put createNodesForControlChildren(the dvRowId[pRow] of group "ControlBrowser") into tNodesA
    set the dvRowChildren[pRow] of group "ControlBrowser" to tNodesA
    dispatch "SetRowIsExpanded" to group "ControlBrowser" with pRow, empty, true
  end if
end uiToggleRow


function GetIconForControlType pType
  switch pType
    case "stack"
      return the uStackIconPath of group "ControlBrowser"
    case "card"
      return the uCardIconPath of group "ControlBrowser"
    case "group"
      return the uGroupIconPath of group "ControlBrowser"
    case "field"
      return the uFieldIconPath of group "ControlBrowser"
    case "image"
      return the uImageIconPath of group "ControlBrowser"
    case "button"
      return the uButtonIconPath of group "ControlBrowser"
    case "player"
      return the uPlayerIconPath of group "ControlBrowser"
    case "widget"
      return the uWidgetIconPath of group "ControlBrowser"
    case "audioclip"
      return the uAudioClipIconPath of group "ControlBrowser"
    case "videoclip"
      return the uVideoClipIconPath of group "ControlBrowser"
    case "scrollbar"
      return the uScrollbarClipIconPath of group "ControlBrowser"
    case "graphic"
      return the uGraphicClipIconPath of group "ControlBrowser"
    case "eps"
      return the uEPSClipIconPath of group "ControlBrowser"
    default
      return empty
  end switch
end GetIconForControlType


private function createNodesForEnvironment
  local tMainStacks, tStack, tNodeA, tNodesA, tIndex

  put the mainstacks into tMainStacks
  sort tMainStacks

  if not the hilite of button "ShowIDEStacks" then
    put stripOutRevStacks(tMainStacks) into tMainStacks
  end if

  repeat for each line tStackName in tMainStacks
    put empty into tNodeA
    put the long id of stack tStackName into tNodeA["id"]
    put tStackName into tNodeA["name"]
    put "stack" into tNodeA["type"]
    put false into tNodeA["expanded"]
    put false into tNodeA["is leaf"]
    put empty into tNodeA["children"]

    add 1 to tIndex
    put tNodeA into tNodesA[tIndex]
  end repeat

  return tNodesA
end createNodesForEnvironment


private function createNodesForControlChildren pControlRef
  switch word 1 of pControlRef
    case "stack"
      return createNodesForStack(pControlRef)
    case "card"
    case "group"
      return createNodesForCardOrGroup(pControlRef)
    default
      return empty
  end switch
end createNodesForControlChildren


private function createNodesForStack pStackRef
  local tStack, tCardId, tNodeA, tNodesA, tIndex

  repeat for each line tStack in the substacks of pStackRef
    put empty into tNodeA
    put the long id of stack tStack of pStackRef into tNodeA["id"]
    put tStack into tNodeA["name"]
    put "stack" into tNodeA["type"]
    put false into tNodeA["expanded"]
    put false into tNodeA["is leaf"]
    put empty into tNodeA["children"]

    add 1 to tIndex
    put tNodeA into tNodesA[tIndex]
  end repeat

  repeat for each line tCardId in the cardIds of pStackRef
    put empty into tNodeA
    put the long id of card id tCardId of pStackRef into tNodeA["id"]
    put the short name of card id tCardId of pStackRef into tNodeA["name"]
    put "card" into tNodeA["type"]
    put false into tNodeA["expanded"]
    put false into tNodeA["is leaf"]
    put empty into tNodeA["children"]

    add 1 to tIndex
    put tNodeA into tNodesA[tIndex]
  end repeat

  return tNodesA
end createNodesForStack


private function createNodesForCardOrGroup pControlRef
  local tControlIds, tControlId, tNodeA, tNodesA, tIndex, tCardId

  put the childControlIDs of pControlRef into tControlIds

  repeat for each line tControlId in tControlIds
    put empty into tNodeA
    put the long id of control id tControlId of pControlRef into tNodeA["id"]
    put the short name of control id tControlId of pControlRef into tNodeA["name"]
    put word 1 of tNodeA["id"] into tNodeA["type"]
    put false into tNodeA["expanded"]
    put tNodeA["type"] is not "group" into tNodeA["is leaf"]
    put empty into tNodeA["children"]

    # For background groups (and any children controls) the card id must be updated
    # because the `long id` of the control will have the id of the current card.
    # This will lead to duplicate `id`s in the tree. If the group is shown in the tree
    # more than once than only the last instance will display data.
    get matchText(pControlRef, "card id ([0-9]+)", tCardId)
    put replacetext(tNodeA["id"], "card id ([0-9]+)", " card id" && tCardId) into tNodeA["id"]

    add 1 to tIndex
    put tNodeA into tNodesA[tIndex]
  end repeat

  return tNodesA
end createNodesForCardOrGroup


private function stripOutRevStacks pStacks
  local theStack, theLineNo

  filter pStacks without "rev*"
  filter pStacks without "com.livecode.*"
  repeat for each item theStack in "home,Ask Dialog,Answer Dialog,Message Box"
    put lineOffset(theStack, pStacks) into theLineNo
    if theLineNo > 0 then
      delete line theLineNo of pStacks
    end if
  end repeat

  return pStacks
end stripOutRevStacks
