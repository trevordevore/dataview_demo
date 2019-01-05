script "DataView Samples Stack Behavior"

on saveStackRequest
  go card 1
  dispatch "ResetView" to group "Extensions"
  pass saveStackRequest
end saveStackRequest
