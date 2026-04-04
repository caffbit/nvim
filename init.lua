--: Options
vim.g.mapleader = " "
-- vim.o.mouse = ""
vim.o.background = "dark"
vim.o.number = true
vim.o.relativenumber = true
vim.o.showmode = false
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.winborder = "rounded"
vim.o.wrap = false
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.tabstop = 4
vim.o.smartindent = true
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.backup = false
vim.o.swapfile = false
vim.o.updatetime = 50
vim.o.scrolloff = 8
vim.o.cursorline = false

-- Enable automatic reading of external changes
vim.o.autoread = true

-- Check file changes when focus returns to neovim
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	command = "checktime",
})

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Sync with system clipboard. Deferred to avoid startup side effects.
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- Use OSC52 to write to host clipboard across SSH/container/remote environments.
-- OSC52 is write-only; paste falls back to neovim's internal register.
-- vim.g.clipboard = {
--   name = "OSC52",
--   copy = {
--     ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
--     ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
--   },
--   paste = {
--     -- No OSC52 read support; use internal register instead
--     ["+"] = function() return vim.fn.getreg('"') end,
--     ["*"] = function() return vim.fn.getreg('"') end,
--   },
-- }

--: Basic keymaps
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>") -- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "x", '"_x') -- Do things without affecting the registers
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- Scroll down and center the cursor
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- Scroll up and center the cursor

-- Move selected lines up/down
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Indent selection left/right
vim.keymap.set("v", "<C-h>", "<gv", { desc = "Indent left" })
vim.keymap.set("v", "<C-l>", ">gv", { desc = "Indent right" })
--:

--: Plugins

--: theme
vim.pack.add({
	{ src = "https://github.com/jaredgorski/fogbell.vim" },
})
vim.cmd.colorscheme("fogbell")
--:

--: icon
vim.pack.add({
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
})
--

--: which-key
vim.pack.add({
	{ src = "https://github.com/folke/which-key.nvim" },
})

require("which-key").setup({})
--

--: undotree
vim.pack.add({
	{ src = "https://github.com/mbbill/undotree" },
})

vim.keymap.set("n", "<leader>u", "<Cmd>UndotreeToggle<CR>", { desc = "Toggle Undotree" })
--

--: gitsigns
vim.pack.add({
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
})

require("gitsigns").setup({})
--

--: treesitter
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		if ev.data.spec.name == "nvim-treesitter" then
			vim.cmd("TSUpdate")
		end
	end,
})

vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
})

require("nvim-treesitter")
	.install({
		"lua",
		"javascript",
		"typescript",
		"tsx",
		"jsx",
		"html",
		"css",
	})
	:wait(300000)

require("nvim-treesitter").setup({})

vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"lua",
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"html",
		"css",
	},
	callback = function()
		vim.treesitter.start()
	end,
})
--:

--: vim-tmux-navigator
vim.pack.add({
	{ src = "https://github.com/christoomey/vim-tmux-navigator" },
})

vim.keymap.set("n", "<C-h>", "<Cmd>TmuxNavigateLeft<CR>", { desc = "Tmux Navigate Left" })
vim.keymap.set("n", "<C-j>", "<Cmd>TmuxNavigateDown<CR>", { desc = "Tmux Navigate Down" })
vim.keymap.set("n", "<C-k>", "<Cmd>TmuxNavigateUp<CR>", { desc = "Tmux Navigate Up" })
vim.keymap.set("n", "<C-l>", "<Cmd>TmuxNavigateRight<CR>", { desc = "Tmux Navigate Right" })
vim.keymap.set("n", "<C-\\>", "<Cmd>TmuxNavigatePrevious<CR>", { desc = "Tmux Navigate Previous" })
--

--: fzf-lua
vim.pack.add({
	{ src = "https://github.com/ibhagwan/fzf-lua" },
})

require("fzf-lua").setup()

vim.keymap.set("n", "<C-b>", "<Cmd>lua require('fzf-lua').buffers()<CR>", { desc = "FZF Buffers" })
vim.keymap.set("n", "<leader>k", "<Cmd>lua require('fzf-lua').builtin()<CR>", { desc = "FZF Builtin" })
vim.keymap.set("n", "<C-p>", "<Cmd>lua require('fzf-lua').files()<CR>", { desc = "FZF Files" })
vim.keymap.set("n", "<C-f>", "<Cmd>lua require('fzf-lua').live_grep()<CR>", { desc = "FZF Live Grep" })
vim.keymap.set("n", "<C-g>", "<Cmd>lua require('fzf-lua').grep_project()<CR>", { desc = "FZF Grep Project" })
vim.keymap.set("n", "<F1>", "<Cmd>lua require('fzf-lua').help_tags()<CR>", { desc = "FZF Help Tags" })
--

-- Otree.nvim
vim.pack.add({
	{ src = "https://github.com/Eutrius/Otree.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
})
require("oil").setup()
require("Otree").setup({
	show_hidden = true,
	show_ignore = true,
})
vim.keymap.set("n", "<leader>e", "<CMD>Otree<CR>", { desc = "Otree" })
--

-- LSP
vim.pack.add({
	{ src = "https://github.com/williamboman/mason.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
})

require("mason").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"vtsls",
		"tailwindcss-language-server",
		"eslint-lsp",
		"prettierd",
		"stylua",
		"eslint_d",
	},
})

vim.lsp.config("tailwindcss", {
	settings = {
		tailwindCSS = {
			colorDecorators = false,
		},
	},
})

vim.lsp.enable({
	"vtsls", -- JS/TS
	"tailwindcss", -- TailwindCSS
	"eslint", -- ESLint
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local map = vim.keymap.set
		local fzf = require("fzf-lua")

		map("n", "gd", fzf.lsp_definitions, { buffer = args.buf, desc = "[G]oto [D]efinition" })
		map("n", "gr", fzf.lsp_references, { buffer = args.buf, desc = "[G]oto [R]eferences" })
		map("n", "gi", fzf.lsp_implementations, { buffer = args.buf, desc = "[G]oto [I]mplementation" })
		map("n", "gt", fzf.lsp_typedefs, { buffer = args.buf, desc = "[G]oto [T]ype Definition" })
		map("n", "gO", fzf.lsp_document_symbols, { buffer = args.buf, desc = "Open Document Symbols" })
		map("n", "gW", fzf.lsp_live_workspace_symbols, { buffer = args.buf, desc = "Open Workspace Symbols" })
		map("n", "ga", fzf.lsp_code_actions, { buffer = args.buf, desc = "[G]oto Code [A]ction" })
		map("n", "<leader>d", fzf.diagnostics_document, { buffer = args.buf, desc = "Open Document Diagnostics" })
		map("n", "<leader>D", fzf.diagnostics_workspace, { buffer = args.buf, desc = "Open Workspace Diagnostics" })
		map("n", "grn", vim.lsp.buf.rename, { buffer = args.buf, desc = "R]e[n]ame" })
	end,
})
--

-- blink.cmp
vim.pack.add({
	-- Snippet collection; blink will auto-load if available
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/saghen/blink.cmp", version = "v1.10.1" },
})
require("blink.cmp").setup({
	-- Use default preset: C-y to confirm, C-n/C-p to navigate
	keymap = { preset = "default" },

	appearance = {
		nerd_font_variant = "mono",
	},

	snippets = {
		-- Use built-in vim.snippet engine; auto-loads friendly-snippets
		preset = "default",
	},

	sources = {
		-- LSP, path, snippets, buffer in priority order
		default = { "lsp", "path", "snippets", "buffer" },
	},

	completion = {
		accept = {
			-- Auto-insert brackets after function completion
			auto_brackets = { enabled = true },
		},
		documentation = {
			-- Show docs popup automatically
			auto_show = true,
			auto_show_delay_ms = 200,
		},
		ghost_text = { enabled = false },
	},

	fuzzy = {
		-- Use Rust fuzzy matcher if available, fallback to Lua
		implementation = "prefer_rust_with_warning",
	},
})

--

--: conform
vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
})
require("conform").setup({
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
	},
	formatters_by_ft = {
		lua = { "stylua" },
		html = { "prettierd" },
		javascript = { "eslint_d", "prettierd" },
		javascriptreact = { "eslint_d", "prettierd" },
		typescript = { "eslint_d", "prettierd" },
		typescriptreact = { "eslint_d", "prettierd" },
		json = { "prettierd" },
		markdown = { "prettierd" },
	},
	formatters = {
		eslint = {
			command = "eslint_d",
			args = { "--fix-to-stdout", "--stdin", "--stdin-filename", "$FILENAME" },
			stdin = true,
		},
	},
})

vim.keymap.set({ "n", "v" }, "<leader>f", function()
	require("conform").format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 500,
	})
end, { desc = "Format file or range" })
--:

-- grug-far
vim.pack.add({
	{ src = "https://github.com/MagicDuck/grug-far.nvim" },
})
require("grug-far").setup({})

vim.keymap.set("n", "<leader>sr", function()
	require("grug-far").open()
end, { desc = "Search & Replace" })

vim.keymap.set("v", "<leader>sr", function()
	require("grug-far").open({ visualSelectionUsedAsSearchString = true })
end, { desc = "Search & Replace (selection)" })
--

--: todo-comments
vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/folke/todo-comments.nvim" },
})

require("todo-comments").setup({})

vim.keymap.set("n", "]t", function()
	require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
	require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

vim.keymap.set("n", "<leader>st", "<Cmd>TodoFzfLua<CR>", { desc = "Search Todos (FzfLua)" })
--

--: bufferline
-- vim.pack.add({
-- 	{ src = "https://github.com/akinsho/nvim-bufferline.lua" },
-- })
--
-- require("bufferline").setup({
-- 	options = {
-- 		mode = "buffers",
-- 		separator_style = "thin",
-- 		show_buffer_close_icons = true,
-- 		show_close_icon = true,
-- 	},
-- })
--

--: lualine
vim.pack.add({
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
})
require("lualine").setup({})
--

-- Done specifying packages. Update them all!
-- vim.pack.update(nil, { force = true })
