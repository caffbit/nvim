local M = {}

function M.setup()
    local hl = vim.api.nvim_set_hl

    vim.o.termguicolors = true

    vim.cmd("highlight clear")

    if vim.fn.exists("syntax_on") == 1 then
        vim.cmd("syntax reset")
    end

    vim.g.colors_name = "sans_syntax"

    --------------------------------------------------------------------------
    -- Base
    --------------------------------------------------------------------------

    hl(0, "Normal", { fg = "#f7f7f8", bg = "#1e2025" })
    hl(0, "NormalFloat", { fg = "#f7f7f8", bg = "#21242b" })
    hl(0, "FloatBorder", { fg = "#2b2f38", bg = "#21242b" })

    hl(0, "LineNr", { fg = "#565960" })
    hl(0, "CursorLineNr", { fg = "#f8f8f9", bold = true })

    hl(0, "CursorLine", { bg = "#202329" })

    --------------------------------------------------------------------------
    -- Search / Selection
    --------------------------------------------------------------------------

    hl(0, "Search", { bg = "#195651" })

    hl(0, "CurSearch", {
        fg = "#1e2025",
        bg = "#10a793",
        bold = true,
    })

    hl(0, "IncSearch", {
        fg = "#1e2025",
        bg = "#10a793",
        bold = true,
    })

    hl(0, "Visual", {
        bg = "#174a45",
    })

    --------------------------------------------------------------------------
    -- LSP References
    --------------------------------------------------------------------------

    hl(0, "LspReferenceRead", {
        bg = "#1d2e30",
    })

    hl(0, "LspReferenceText", {
        bg = "#1d2e30",
    })

    hl(0, "LspReferenceWrite", {
        bg = "#3a3b42",
    })

    --------------------------------------------------------------------------
    -- Diagnostics
    --------------------------------------------------------------------------

    hl(0, "DiagnosticError", { fg = "#f82871" })
    hl(0, "DiagnosticWarn", { fg = "#fee56c" })
    hl(0, "DiagnosticInfo", { fg = "#10a793" })
    hl(0, "DiagnosticHint", { fg = "#618399" })

    --------------------------------------------------------------------------
    -- Diff
    --------------------------------------------------------------------------

    hl(0, "DiffAdd", { bg = "#184618" })
    hl(0, "DiffChange", { bg = "#5c5014" })
    hl(0, "DiffDelete", { bg = "#54051b" })
    hl(0, "DiffText", { bg = "#796b26" })

    --------------------------------------------------------------------------
    -- Comments
    --------------------------------------------------------------------------

    hl(0, "Comment", { fg = "#98aec4" })

    hl(0, "@comment", {
        fg = "#98aec4",
    })

    hl(0, "@comment.documentation", {
        fg = "#9fc498",
    })

    --------------------------------------------------------------------------
    -- Sans Syntax
    --------------------------------------------------------------------------

    local groups = {
        "Identifier",
        "Function",
        "Statement",
        "Keyword",
        "Type",
        "Constant",
        "String",
        "Number",
        "Boolean",
        "Operator",
        "Special",

        "@variable",
        "@property",
        "@function",
        "@keyword",
        "@type",
        "@string",
        "@number",
        "@boolean",
        "@constant",
        "@operator",
        "@punctuation",
    }

    for _, group in ipairs(groups) do
        hl(0, group, { link = "Normal" })
    end
end

return M
