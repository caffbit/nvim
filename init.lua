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
vim.keymap.set("n", "x", '"_x')                     -- Do things without affecting the registers
vim.keymap.set("n", "<C-d>", "<C-d>zz")             -- Scroll down and center the cursor
vim.keymap.set("n", "<C-u>", "<C-u>zz")             -- Scroll up and center the cursor

-- Move selected lines up/down
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Indent selection left/right
vim.keymap.set("v", "<C-h>", "<gv", { desc = "Indent left" })
vim.keymap.set("v", "<C-l>", ">gv", { desc = "Indent right" })

-- Copy current file path
vim.keymap.set("n", "<leader>cp", function()
    local path = vim.fn.expand("%:p")
    if path == "" then
        vim.notify("Current buffer has no file path", vim.log.levels.WARN)
        return
    end
    vim.fn.setreg("+", path)
    vim.notify("Copied path: " .. path)
end, { desc = "Copy current file path" })
--:

--: Plugins

--: theme
vim.pack.add({
    { src = "https://github.com/tjdevries/colorbuddy.nvim" },
    { src = "https://github.com/jesseleite/noirbuddy.nvim" },
})

require("noirbuddy").setup({
    colors = {
        background = "#0b0c0f",

        noir_0 = "#c4c4c4",
        noir_1 = "#b8b8b8",
        noir_2 = "#acacac",
        noir_3 = "#9a9a9a",
        noir_4 = "#888888",
        noir_5 = "#747474",
        noir_6 = "#606060",
        noir_7 = "#4c4c4c",
        noir_8 = "#2a2a2a",
        noir_9 = "#161616",

        primary = "#b8b8b8",
        secondary = "#888888",

        diagnostic_error = "#8c7a7a",
        diagnostic_warning = "#91856f",
        diagnostic_info = "#727c86",
        diagnostic_hint = "#707870",

        diff_add = "#667266",
        diff_change = "#6f6f6f",
        diff_delete = "#7f6666",
    },

    styles = {
        italic = false,
        bold = false,
        underline = false,
        undercurl = true,
    },
})

vim.cmd.colorscheme("noirbuddy")

local c = {
    bg        = "#0b0c0f",
    bg_subtle = "#101114",
    bg_ui     = "#161616",
    bg_sel    = "#1e1e1e",
    bg_search = "#8a8a8a",

    fg        = "#b8b8b8",
    fg_dim    = "#8a8a8a",
    fg_soft   = "#6a6a6a",
    fg_faint  = "#4c4c4c",

    comment   = "#6a6a6a",

    err       = "#8c7a7a",
    warn      = "#91856f",
    info      = "#727c86",
    hint      = "#707870",

    add       = "#667266",
    chg       = "#6f6f6f",
    del       = "#7f6666",
}

local function hl(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

local function link(from, to)
    vim.api.nvim_set_hl(0, from, { link = to })
end

-- ============================================================================
-- Base UI
-- ============================================================================

hl("Normal", { fg = c.fg, bg = c.bg, bold = false, italic = false })
hl("NormalNC", { fg = c.fg, bg = c.bg, bold = false, italic = false })
hl("EndOfBuffer", { fg = c.fg_faint, bg = c.bg })
hl("NonText", { fg = c.fg_faint })
hl("SpecialKey", { fg = c.fg_soft })

hl("LineNr", { fg = c.fg_soft, bg = c.bg })
hl("CursorLineNr", { fg = c.fg, bg = c.bg_subtle, bold = false })
hl("SignColumn", { fg = c.fg_soft, bg = c.bg })

hl("CursorLine", { bg = c.bg_subtle })
hl("CursorColumn", { bg = c.bg_subtle })
hl("ColorColumn", { bg = c.bg_subtle })

hl("VertSplit", { fg = c.bg_ui, bg = c.bg })
hl("WinSeparator", { fg = c.bg_ui, bg = c.bg })

hl("StatusLine", { fg = c.fg_dim, bg = c.bg_ui, bold = false })
hl("StatusLineNC", { fg = c.fg_soft, bg = c.bg_ui, bold = false })

hl("TabLine", { fg = c.fg_soft, bg = c.bg_ui })
hl("TabLineSel", { fg = c.fg_dim, bg = c.bg_ui, bold = false })
hl("TabLineFill", { fg = c.fg_soft, bg = c.bg_ui })

hl("Folded", { fg = c.fg_soft, bg = c.bg_subtle, bold = false, italic = false })
hl("FoldColumn", { fg = c.fg_soft, bg = c.bg })

hl("Conceal", { fg = c.fg_soft })
hl("Directory", { fg = c.fg, bold = false })

-- ============================================================================
-- Search / Selection
-- ============================================================================

hl("Visual", { bg = c.bg_sel })
hl("VisualNOS", { bg = c.bg_sel })

-- fogbell 核心之一：hlsearch 要有明顯區分
hl("Search", { fg = c.bg, bg = c.bg_search, bold = false })
hl("IncSearch", { fg = c.bg, bg = c.fg, bold = false })
hl("CurSearch", { fg = c.bg, bg = c.fg, bold = false })

hl("MatchParen", { fg = c.fg, bg = c.bg_sel, bold = false })

-- ============================================================================
-- Float / Popup
-- ============================================================================

hl("NormalFloat", { fg = c.fg, bg = c.bg_subtle })
hl("FloatBorder", { fg = c.fg_soft, bg = c.bg_subtle })
hl("FloatTitle", { fg = c.fg_dim, bg = c.bg_subtle, bold = false })

hl("Pmenu", { fg = c.fg, bg = c.bg_subtle })
hl("PmenuSel", { fg = c.fg, bg = c.bg_sel, bold = false })
hl("PmenuSbar", { bg = c.bg_ui })
hl("PmenuThumb", { bg = c.fg_soft })

-- ============================================================================
-- Syntax: flatten almost everything
-- ============================================================================

hl("Comment", { fg = c.comment, italic = false, bold = false })

hl("Constant", { fg = c.fg, italic = false, bold = false })
hl("String", { fg = c.fg, italic = false, bold = false })
hl("Character", { fg = c.fg, italic = false, bold = false })
hl("Number", { fg = c.fg, italic = false, bold = false })
hl("Boolean", { fg = c.fg, italic = false, bold = false })
hl("Float", { fg = c.fg, italic = false, bold = false })

hl("Identifier", { fg = c.fg, italic = false, bold = false })
hl("Function", { fg = c.fg, italic = false, bold = false })

hl("Statement", { fg = c.fg, italic = false, bold = false })
hl("Conditional", { fg = c.fg, italic = false, bold = false })
hl("Repeat", { fg = c.fg, italic = false, bold = false })
hl("Label", { fg = c.fg, italic = false, bold = false })
hl("Operator", { fg = c.fg, italic = false, bold = false })
hl("Keyword", { fg = c.fg, italic = false, bold = false })
hl("Exception", { fg = c.fg, italic = false, bold = false })

hl("PreProc", { fg = c.fg, italic = false, bold = false })
hl("Include", { fg = c.fg, italic = false, bold = false })
hl("Define", { fg = c.fg, italic = false, bold = false })
hl("Macro", { fg = c.fg, italic = false, bold = false })
hl("PreCondit", { fg = c.fg, italic = false, bold = false })

hl("Type", { fg = c.fg, italic = false, bold = false })
hl("StorageClass", { fg = c.fg, italic = false, bold = false })
hl("Structure", { fg = c.fg, italic = false, bold = false })
hl("Typedef", { fg = c.fg, italic = false, bold = false })

hl("Special", { fg = c.fg, italic = false, bold = false })
hl("SpecialChar", { fg = c.fg, italic = false, bold = false })
hl("Delimiter", { fg = c.fg, italic = false, bold = false })
hl("SpecialComment", { fg = c.comment, italic = false, bold = false })
hl("Tag", { fg = c.fg, italic = false, bold = false })

hl("@tag", { fg = c.fg, italic = false, bold = false })
hl("@tag.builtin", { fg = c.fg, italic = false, bold = false })
hl("@tag.attribute", { fg = c.fg, italic = false, bold = false })
hl("@tag.delimiter", { fg = c.fg, italic = false, bold = false })

hl("Title", { fg = c.fg, italic = false, bold = false })
hl("Todo", { fg = c.fg, bg = c.bg_sel, italic = false, bold = false })
hl("Underlined", { fg = c.fg, underline = true, italic = false, bold = false })
hl("Ignore", { fg = c.fg_soft })
hl("Error", { fg = c.err, bold = false })
hl("ErrorMsg", { fg = c.err, bold = false })
hl("WarningMsg", { fg = c.warn, bold = false })

-- ============================================================================
-- Diff: one of the few intentionally differentiated areas
-- ============================================================================

hl("DiffAdd", { fg = c.add, bg = c.bg_subtle, bold = false })
hl("DiffChange", { fg = c.chg, bg = c.bg_subtle, bold = false })
hl("DiffDelete", { fg = c.del, bg = c.bg_subtle, bold = false })
hl("DiffText", { fg = c.fg, bg = c.bg_sel, bold = false })

-- ============================================================================
-- Diagnostics: restrained, not a focus
-- ============================================================================

hl("DiagnosticError", { fg = c.err, bold = false })
hl("DiagnosticWarn", { fg = c.warn, bold = false })
hl("DiagnosticInfo", { fg = c.info, bold = false })
hl("DiagnosticHint", { fg = c.hint, bold = false })

hl("DiagnosticVirtualTextError", { fg = c.err, bg = c.bg_subtle, bold = false })
hl("DiagnosticVirtualTextWarn", { fg = c.warn, bg = c.bg_subtle, bold = false })
hl("DiagnosticVirtualTextInfo", { fg = c.info, bg = c.bg_subtle, bold = false })
hl("DiagnosticVirtualTextHint", { fg = c.hint, bg = c.bg_subtle, bold = false })

hl("DiagnosticUnderlineError", { undercurl = true, sp = c.err })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = c.warn })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = c.info })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = c.hint })

-- ============================================================================
-- Spelling
-- ============================================================================

hl("SpellBad", { undercurl = true, sp = c.err })
hl("SpellCap", { undercurl = true, sp = c.info })
hl("SpellRare", { undercurl = true, sp = c.warn })
hl("SpellLocal", { undercurl = true, sp = c.hint })

-- ============================================================================
-- Treesitter: flatten aggressively
-- ============================================================================

link("@comment", "Comment")
link("@comment.documentation", "Comment")
link("@comment.error", "Comment")
link("@comment.warning", "Comment")
link("@comment.todo", "Comment")
link("@comment.note", "Comment")

link("@string", "String")
link("@string.documentation", "String")
link("@string.escape", "String")
link("@string.special", "String")
link("@character", "Character")
link("@character.special", "Character")

link("@constant", "Constant")
link("@constant.builtin", "Constant")
link("@constant.macro", "Constant")
link("@number", "Number")
link("@number.float", "Float")
link("@boolean", "Boolean")

link("@variable", "Identifier")
link("@variable.builtin", "Identifier")
link("@variable.member", "Identifier")
link("@parameter", "Identifier")
link("@parameter.reference", "Identifier")
link("@field", "Identifier")
link("@property", "Identifier")

link("@function", "Function")
link("@function.builtin", "Function")
link("@function.call", "Function")
link("@method", "Function")
link("@method.call", "Function")
link("@constructor", "Function")

link("@keyword", "Keyword")
link("@keyword.function", "Keyword")
link("@keyword.operator", "Keyword")
link("@keyword.return", "Keyword")
link("@keyword.import", "Keyword")
link("@keyword.conditional", "Keyword")
link("@keyword.repeat", "Keyword")
link("@keyword.exception", "Keyword")

link("@conditional", "Conditional")
link("@repeat", "Repeat")
link("@label", "Label")
link("@operator", "Operator")

link("@type", "Type")
link("@type.builtin", "Type")
link("@type.definition", "Type")
link("@storageclass", "StorageClass")
link("@attribute", "Identifier")
link("@module", "Identifier")
link("@namespace", "Identifier")

link("@punctuation.delimiter", "Delimiter")
link("@punctuation.bracket", "Delimiter")
link("@punctuation.special", "Delimiter")

link("@tag", "Tag")
link("@tag.attribute", "Identifier")
link("@tag.delimiter", "Delimiter")

-- ============================================================================
-- LSP semantic tokens: flatten aggressively
-- ============================================================================

link("@lsp.type.class", "Type")
link("@lsp.type.comment", "Comment")
link("@lsp.type.decorator", "Identifier")
link("@lsp.type.enum", "Type")
link("@lsp.type.enumMember", "Constant")
link("@lsp.type.event", "Identifier")
link("@lsp.type.function", "Function")
link("@lsp.type.interface", "Type")
link("@lsp.type.keyword", "Keyword")
link("@lsp.type.macro", "Identifier")
link("@lsp.type.method", "Function")
link("@lsp.type.modifier", "Keyword")
link("@lsp.type.namespace", "Identifier")
link("@lsp.type.number", "Number")
link("@lsp.type.operator", "Operator")
link("@lsp.type.parameter", "Identifier")
link("@lsp.type.property", "Identifier")
link("@lsp.type.regexp", "String")
link("@lsp.type.string", "String")
link("@lsp.type.struct", "Type")
link("@lsp.type.type", "Type")
link("@lsp.type.typeParameter", "Type")
link("@lsp.type.variable", "Identifier")
--

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

require("oil").setup({
    keymaps = {
        -- create a new mapping, gs, to search and replace in the current directory
        gs = {
            callback = function()
                -- get the current directory
                local prefills = { paths = require("oil").get_current_dir() }

                local grug_far = require "grug-far"
                -- instance check
                if not grug_far.has_instance "explorer" then
                    grug_far.open {
                        instanceName = "explorer",
                        prefills = prefills,
                        staticTitle = "Find and Replace from Explorer",
                        windowCreationCommand = 'tab split',
                    }
                else
                    grug_far.get_instance('explorer'):open()
                    -- updating the prefills without clearing the search and other fields
                    grug_far.get_instance('explorer'):update_input_values(prefills, false)
                end
            end,
            desc = "oil: Search in directory",
        },
    },
})

vim.keymap.set("n", "<leader>o", require("oil").open_float, { desc = "Oil open" })

require("Otree").setup({
    show_hidden = true,
    show_ignore = true,
})

vim.keymap.set("n", "<leader>e", "<CMD>OtreeFocus<CR>", { desc = "Otree focus" })
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
    "vtsls",       -- JS/TS
    "tailwindcss", -- TailwindCSS
    "eslint",      -- ESLint
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
        map("n", "<leader>d", function()
            fzf.diagnostics_document({
                actions = { ["ctrl-q"] = require("fzf-lua.actions").file_sel_to_qf }
            })
        end, { buffer = args.buf, desc = "Open Document Diagnostics" })
        map("n", "<leader>D", fzf.diagnostics_workspace, { buffer = args.buf, desc = "Open Workspace Diagnostics" })
        map("n", "grn", vim.lsp.buf.rename, { buffer = args.buf, desc = "R]e[n]ame" })

        map("n", "gl", vim.diagnostic.open_float, {
            buffer = args.buf,
            desc = "Show Line Diagnostics",
        })
        map("n", "[d", vim.diagnostic.goto_prev, { buffer = args.buf, desc = "Prev Diagnostic" })
        map("n", "]d", vim.diagnostic.goto_next, { buffer = args.buf, desc = "Next Diagnostic" })
    end,
})
--

-- blink.cmp
vim.pack.add({
    -- Snippet collection; blink will auto-load if available
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    { src = "https://github.com/saghen/blink.cmp",            version = "v1.10.1" },
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
require("grug-far").setup({
    windowCreationCommand = 'tab split',
})

vim.keymap.set("n", "<leader>sr", function()
    require("grug-far").open({
    })
end, { desc = "Search & Replace" })

vim.keymap.set("v", "<leader>sr", function()
    require("grug-far").open({
        visualSelectionUsedAsSearchString = true,
    })
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
