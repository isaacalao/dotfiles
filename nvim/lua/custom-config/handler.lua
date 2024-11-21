return function(VER)
  local success, res = pcall(require, "custom-config."..VER)
  return success and res or nil
end
