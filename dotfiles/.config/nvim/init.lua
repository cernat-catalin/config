-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Re-apply SpellBad highlight on ColorScheme and VimEnter because LazyVim
-- loads the colorscheme after init.lua, which would otherwise override it.
local function set_spell_hl()
	-- Use underline (not undercurl) for broader terminal compatibility.
	vim.api.nvim_set_hl(0, "SpellBad", { underline = true, sp = "red" })
end

vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
	pattern = "*",
	callback = set_spell_hl,
})
