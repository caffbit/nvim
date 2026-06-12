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

--: Filetype-specific indentation
-- 2-space indentation languages
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "lua", "javascript", "typescript", "javascriptreact", "typescriptreact", "yaml", "json", "jsonc", "html", "css", "scss", "markdown", "vim", "nix" },
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.tabstop = 2
    end,
})

-- Go: use tabs
vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        vim.opt_local.expandtab = false
        vim.opt_local.shiftwidth = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.tabstop = 4
    end,
})

-- Python: 4 spaces (default, but explicit)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.opt_local.shiftwidth = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.tabstop = 4
    end,
})

--: Basic keymaps
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>") -- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "x", '"_x')                     -- Do things without affecting the registers
vim.keymap.set("n", "<C-d>", "<C-d>zz")             -- Scroll down and center the cursor
vim.keymap.set("n", "<C-u>", "<C-u>zz")             -- Scroll up and center the cursor

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

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

-- theme
require('colors.sans_syntax').setup()
--

--: icon
vim.pack.add({
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
})
--

--: gitsigns
vim.pack.add({
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
})

require("gitsigns").setup({
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- navigation（核心）
        map("n", "]c", gs.next_hunk, "Next Change")
        map("n", "[c", gs.prev_hunk, "Prev Change")

        -- diff（統一 namespace）
        map("n", "<leader>df", gs.diffthis, "Diff File")
        map("n", "<leader>dp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>dr", gs.reset_hunk, "Revert Hunk")

        -- visual mode（只保留 restore）
        map("v", "<leader>dr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Revert Selection")
    end,
})
--

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
--

-- Zed-style Ctrl mappings
vim.keymap.set("n", "<C-p>", "<Cmd>lua require('fzf-lua').files()<CR>", { desc = "Files" })
vim.keymap.set("n", "<C-f>", "<Cmd>lua require('fzf-lua').live_grep()<CR>", { desc = "Search" })
vim.keymap.set("n", "<C-g>", "<Cmd>lua require('fzf-lua').grep_project()<CR>", { desc = "Project Search" })
vim.keymap.set("n", "<C-b>", "<Cmd>lua require('fzf-lua').buffers()<CR>", { desc = "Buffers" })
vim.keymap.set({ "n", "i" }, "<C-s>", "<Cmd>w<CR>", { desc = "Save" })
vim.keymap.set("n", "<F1>", "<Cmd>lua require('fzf-lua').help_tags()<CR>", { desc = "Help Tags" })
--

--: Oil
vim.pack.add({
    { src = "https://github.com/stevearc/oil.nvim" },
})

require("oil").setup({
    keymaps = {
        gs = {
            callback = function()
                local prefills = { paths = require("oil").get_current_dir() }
                local grug_far = require("grug-far")

                if not grug_far.has_instance("explorer") then
                    grug_far.open({
                        instanceName = "explorer",
                        prefills = prefills,
                        staticTitle = "Find and Replace from Explorer",
                        windowCreationCommand = "tab split",
                    })
                else
                    grug_far.get_instance("explorer"):open()
                    grug_far.get_instance("explorer"):update_input_values(prefills, false)
                end
            end,
            desc = "Search in directory",
        },
    },
})

vim.keymap.set("n", "<leader>o", require("oil").open_float, { desc = "Explorer" })
--

--: grug-far
vim.pack.add({
    { src = "https://github.com/MagicDuck/grug-far.nvim" },
})

require("grug-far").setup({
    windowCreationCommand = "tab split",
})

vim.keymap.set("n", "<leader>sr", function()
    require("grug-far").open({})
end, { desc = "Search & Replace" })

vim.keymap.set("v", "<leader>sr", function()
    require("grug-far").open({
        visualSelectionUsedAsSearchString = true,
    })
end, { desc = "Search & Replace (selection)" })
--

-- Done specifying packages. Update them all!
vim.pack.update(nil, { force = true })
