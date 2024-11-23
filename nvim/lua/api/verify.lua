return function(VER)
  local success, res = pcall(require, string.lower("api."..VER))
  return success and res or nil
end
