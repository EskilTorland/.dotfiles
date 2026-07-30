return {
	{
		"mfussenegger/nvim-dap",
		dependencies = { {
			"theHamsta/nvim-dap-virtual-text",
			opts = {},
		} },
		--optional = true,

		keys = {
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Breakpoint Condition",
			},
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Run/Continue",
			},
			{
				"<leader>da",
				function()
					require("dap").continue({ before = get_args })
				end,
				desc = "Run with Args",
			},
			{
				"<leader>dC",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "Run to Cursor",
			},
			{
				"<leader>dg",
				function()
					require("dap").goto_()
				end,
				desc = "Go to Line (No Execute)",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Step Into",
			},
			{
				"<leader>dj",
				function()
					require("dap").down()
				end,
				desc = "Down",
			},
			{
				"<leader>dk",
				function()
					require("dap").up()
				end,
				desc = "Up",
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "Run Last",
			},
			{
				"<leader>do",
				function()
					require("dap").step_out()
				end,
				desc = "Step Out",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over",
			},
			{
				"<leader>dP",
				function()
					require("dap").pause()
				end,
				desc = "Pause",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.toggle()
				end,
				desc = "Toggle REPL",
			},
			{
				"<leader>ds",
				function()
					require("dap").session()
				end,
				desc = "Session",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
			{
				"<leader>dw",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "Widgets",
			},
		},
		config = function()
			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

			local dap_signs = {
				Stopped = { text = "󰁕 ", texthl = "DiagnosticWarn", linehl = "DapStoppedLine" },
				Breakpoint = { text = " ", texthl = "DiagnosticError" },
				BreakpointCondition = { text = " ", texthl = "DiagnosticWarn" },
				BreakpointRejected = { text = " ", texthl = "DiagnosticError" },
				LogPoint = { text = ".>", texthl = "DiagnosticInfo" },
			}

			for name, sign in pairs(dap_signs) do
				vim.fn.sign_define("Dap" .. name, sign)
			end

			local dap = require("dap")
			if not dap.adapters["netcoredbg"] then
				dap.adapters["netcoredbg"] = {
					type = "executable",
					command = vim.fn.stdpath("data") .. "/lazy/netcoredbg-macOS-arm64.nvim/netcoredbg/netcoredbg",
					args = { "--interpreter=vscode" },
					options = {
						detached = false,
					},
				}
			end

			dap.configurations.cs = dap.configurations.cs or {}
			table.insert(dap.configurations.cs, {
				type = "netcoredbg",
				name = "Launch (integratedTerminal)",
				request = "launch",
				console = "integratedTerminal",
				program = function()
					return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
				end,
			})
		end,
	},
}
