return {
	"neovim/nvim-lspconfig",
	opts = {
		servers = {
			basedpyright = {
				settings = {
					basedpyright = {
						analysis = {
							typeCheckingMode = "standard",
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
			},
		},
	},
}
