return {
	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		event = { "BufReadPost", "BufNewFile" },
		build = ":TSUpdate",

		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "c_sharp", "markdown", "markdown_inline", "go", "gomod", "gowork", "gosum", "json", "yaml" },
				sync_install = false,
				auto_install = true,
				highlight = { enable = false },
			})

			-- nvim-treesitter's query_predicates.lua is broken on Neovim 0.12:
			-- the directive/predicate API changed match[id] from TSNode to TSNode[].
			-- nvim-treesitter is archived and won't be fixed. Re-register with force.
			local ts_query = require("vim.treesitter.query")
			local force = { force = true }

			local function get_node(match, capture_id)
				local v = match[capture_id]
				if type(v) == "table" then
					return v[1]
				end
				return v
			end

			local injection_aliases = {
				ex = "elixir",
				pl = "perl",
				sh = "bash",
				uxn = "uxntal",
				ts = "typescript",
			}

			local html_type_languages = {
				importmap = "json",
				module = "javascript",
				["application/ecmascript"] = "javascript",
				["text/ecmascript"] = "javascript",
			}

			ts_query.add_predicate("nth?", function(match, _, _, pred)
				local node = get_node(match, pred[2])
				local n = tonumber(pred[3])
				if node and node:parent() and node:parent():named_child_count() > n then
					return node:parent():named_child(n) == node
				end
				return false
			end, force)

			ts_query.add_predicate("is?", function(match, _, bufnr, pred)
				local locals = require("nvim-treesitter.locals")
				local node = get_node(match, pred[2])
				local types = { unpack(pred, 3) }
				if not node then
					return true
				end
				local _, _, kind = locals.find_definition(node, bufnr)
				return vim.tbl_contains(types, kind)
			end, force)

			ts_query.add_predicate("kind-eq?", function(match, _, _, pred)
				local node = get_node(match, pred[2])
				local types = { unpack(pred, 3) }
				if not node then
					return true
				end
				return vim.tbl_contains(types, node:type())
			end, force)

			ts_query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
				local node = get_node(match, pred[2])
				if not node then
					return
				end
				local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
				local configured = html_type_languages[type_attr_value]
				if configured then
					metadata["injection.language"] = configured
				else
					local parts = vim.split(type_attr_value, "/", {})
					metadata["injection.language"] = parts[#parts]
				end
			end, force)

			ts_query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
				local node = get_node(match, pred[2])
				if not node then
					return
				end
				local alias = vim.treesitter.get_node_text(node, bufnr):lower()
				local lang = vim.filetype.match({ filename = "a." .. alias })
				metadata["injection.language"] = lang or injection_aliases[alias] or alias
			end, force)

			ts_query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
				local id = pred[2]
				local node = get_node(match, id)
				if not node then
					return
				end
				local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
				if not metadata[id] then
					metadata[id] = {}
				end
				metadata[id].text = string.lower(text)
			end, force)
		end,
	},
}
