vim.opt.tabstop = 2
vim.opt.wrap = false
vim.opt.number = true
vim.opt.shiftwidth = 2
vim.opt.textwidth = 80
vim.opt.expandtab = true
vim.opt.showmode = false -- disable mode status
vim.cmd.colorscheme("habamax")



--[[ NORMAL MODE ]]
-- Show Floating Terminal
vim.keymap.set('n', 'Tf', function()
  vim.cmd("ToggleTerm direction=float")
  print(" ")
end)

-- Show Diagnostics
vim.keymap.set('n', 'Td', function()
	vim.cmd("Trouble diagnostics")
end)

-- Telescope
vim.keymap.set('n', 'TT', function ()
  vim.cmd("Telescope")
end)

-- No Highlight 
vim.keymap.set('n', 'NH', function ()
  vim.cmd("nohl")
end)

--[[ TERMINAL MODE ]]
-- Hide Terminal
vim.keymap.set('t', '<Esc><Esc><Esc>', function()
  vim.cmd("ToggleTerm")
end)


