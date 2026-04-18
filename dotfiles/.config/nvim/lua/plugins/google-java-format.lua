return {
	{
		"mason-org/mason.nvim",
		opts = { ensure_installed = { "google-java-format" } },
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				java = { "google-java-format" },
			},
		},
	},
}
