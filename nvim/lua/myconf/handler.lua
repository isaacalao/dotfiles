return function(VER)
  local success, res = pcall(require, "myconf/"..VER)
  return success and res or nil
end
