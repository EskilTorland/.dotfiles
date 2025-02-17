-- Add this variable to track CodeLens state
local codelens_enabled = true

-- Add this function to toggle CodeLens
local function toggle_codelens()
	codelens_enabled = not codelens_enabled
	if codelens_enabled then
		vim.lsp.codelens.refresh()
	else
		-- Clear existing CodeLens
		vim.lsp.codelens.clear()
	end
	print("CodeLens " .. (codelens_enabled and "enabled" or "disabled"))
end

require("roslyn").setup({

	config = {
		settings = {
			["csharp|inlay_hints"] = {
				csharp_enable_inlay_hints_for_implicit_object_creation = true,
				csharp_enable_inlay_hints_for_implicit_variable_types = true,
				csharp_enable_inlay_hints_for_lambda_parameter_types = true,
				csharp_enable_inlay_hints_for_types = true,
				dotnet_enable_inlay_hints_for_indexer_parameters = true,
				dotnet_enable_inlay_hints_for_literal_parameters = true,
				dotnet_enable_inlay_hints_for_object_creation_parameters = true,
				dotnet_enable_inlay_hints_for_other_parameters = true,
				dotnet_enable_inlay_hints_for_parameters = true,
				dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
				dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
				dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
			},
			["csharp|codelens"] = {
				dotnet_enable_references_code_lens = true,
			},
		},
	},
	exe = {
		"dotnet",
		vim.fs.joinpath(vim.fn.stdpath("data") --[[@as string]], "roslyn", "Microsoft.CodeAnalysis.LanguageServer.dll"),
	},

	filewatching = true,
})

vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
	callback = function()
		if codelens_enabled then
			vim.lsp.codelens.refresh()
		end
	end,
})

vim.keymap.set("n", "<leader>l", toggle_codelens, { desc = "Toggle CodeLens" })
