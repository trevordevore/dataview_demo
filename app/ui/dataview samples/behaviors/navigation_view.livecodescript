script "NavigationView Behavior"

on preOpenCard
  set the hilitedItemNames of widget "Navigation" of me to the short name of this card
  pass preOpenCard
end preOpenCard


on hiliteChanged
  go card (the hilitedItemNames of the target)
end hiliteChanged
