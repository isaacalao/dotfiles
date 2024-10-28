return function(VER)
  local success, res = pcall(
    function()
      return require("myconf/"..VER)
    end
  )
  return success and res or nil
end
