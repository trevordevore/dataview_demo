script "DataView Paginated Scroll Card Behavior"

constant kNumberPerPage = 20

local sCurrentURL
local sPageThatIsLoading


on ResizeView pWidth, pHeight
  local tRect

  set the bottomleft of field "LblMessage" to 20,pHeight-12

  put the rect of group "Pokemon" into tRect
  put pWidth - 20 into item 3 of tRect
  put the top of field "LblMessage" - 8 into item 4 of tRect
  set the rect of group "Pokemon" to tRect
end ResizeView


on OpenView pHasBeenOpened
  set the text of field "LblMessage" to "idle"

  LoadDataForPage 1
end OpenView


on closeCard
  dispatch "ResetView" to group "Pokemon"
  if sCurrentURL is not empty then
    unload url sCurrentURL
  end if
end closeCard


command LoadDataForPage pPage
  local tError, tOffset

  set the text of field "LblMessage" to param(0) && pPage && "[" & the milliseconds & "]"

  put pPage into sPageThatIsLoading
  put (pPage-1) * kNumberPerPage into tOffset

  put "https://pokeapi.co/api/v2/pokemon?offset=" & tOffset & "&limit=" & kNumberPerPage into sCurrentURL
  load url sCurrentURL with message "ReceiveDataForPage"
  put the result into tError

  AnswerError param(0), tError
end LoadDataForPage


command ReceiveDataForPage pUrl, pUrlStatus
  local tResponseA, i

  put empty into sCurrentURL

  # In case the user navigated away
  if the short name of me is not the currentCard of this stack then exit ReceiveDataForPage

  if pUrlStatus is "cached" then
    put URL pUrl into tResponseA
    if tResponseA is not empty then
      put JsonImport(tResponseA) into tResponseA
    end if
    unload URL pUrl

    set the text of field "LblMessage" to param(0) && sPageThatIsLoading && "Count:" && tResponseA["count"]

    if tResponseA["count"] is not the viewProp["number of rows"] of group "Pokemon" then
      set the viewProp["number of rows"] of group "Pokemon" to tResponseA["count"]
      set the viewProp["rows per page"] of group "Pokemon" to kNumberPerPage
      set the dvData of group "Pokemon" to empty
    end if

    set the dvDataForPage[sPageThatIsLoading] of group "Pokemon" to tResponseA["results"]

  else if pUrlStatus is among the items of "cancelled" then
    set the text of field "LblMessage" to param(0) && sPageThatIsLoading && "Error!"

    AnswerError param(0), pUrlStatus && libURLErrorData(pURL)
  end if
end ReceiveDataForPage


command AnswerError pContext, pError
  if pError is not empty then
    answer error "Error context:" && pContext & cr & cr & "Error:" && pError
  end if
end AnswerError
