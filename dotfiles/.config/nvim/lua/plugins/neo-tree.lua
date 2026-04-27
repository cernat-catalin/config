local current_file = nil

vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("neotree_track_current_file", { clear = true }),
	callback = function(args)
		if vim.bo[args.buf].buftype == "" then
			local name = vim.api.nvim_buf_get_name(args.buf)
			if name ~= "" then
				current_file = name
			end
		end
	end,
})

return {
	"nvim-neo-tree/neo-tree.nvim",
	opts = {
		filesystem = {
			follow_current_file = {
				enabled = true,
				leave_dirs_open = false,
			},
			components = {
				name = function(config, node, state)
					local common = require("neo-tree.sources.common.components")
					local result = common.name(config, node, state)
					if node.type == "file" and node.path == current_file then
						result.highlight = "NeoTreeFileNameOpened"
					end
					return result
				end,
			},
		},
	},
	init = function()
		-- Preserve LazyVim's directory-loading behavior (init is not merged across specs)
		vim.api.nvim_create_autocmd("BufEnter", {
			group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
			desc = "Start Neo-tree with directory",
			once = true,
			callback = function()
				if package.loaded["neo-tree"] then
					return
				end
				local stats = vim.uv.fs_stat(vim.fn.argv(0))
				if stats and stats.type == "directory" then
					require("neo-tree")
				end
			end,
		})

		local function set_hl()
			vim.api.nvim_set_hl(0, "NeoTreeFileNameOpened", { bold = true, underline = true })
		end
		set_hl()
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "*",
			callback = set_hl,
		})
	end,
}
