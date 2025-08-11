return {
	"neovim/nvim-lspconfig",
	opts = {
		servers = {
			basedpyright = {
				settings = {
					python = {
						analysis = {
							typeCheckingMode = "off",
						},
					},
				},
			},
		},
	},
}
