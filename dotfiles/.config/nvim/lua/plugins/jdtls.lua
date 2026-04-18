return {
	{
		"mfussenegger/nvim-jdtls",
		opts = {
			settings = {
				java = {
					maven = { downloadSources = true },
					eclipse = { downloadSources = true },
					signatureHelp = { enabled = true },
				},
			},
		},
	},
}
