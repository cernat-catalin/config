-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

require("lspconfig").basedpyright.setup({
	settings = {
		basedpyright = {
			analysis = {
				typeCheckingMode = "standard", -- Switches from 'strict' to 'standard'
				diagnosticSeverityOverrides = {
					reportUnknownParameterType = "none",
					reportUnknownArgumentType = "none",
					reportUnknownLambdaType = "none",
					reportUnknownVariableType = "none",
					reportUnknownMemberType = "none",
					reportMissingTypeStubs = "none",
				},
			},
		},
	},
})
