-----------------------------------------
-- Tachyon
-- Ultra-fast Base16 Lua colorscheme
-- No italics, unified BG, plugin aware
-----------------------------------------

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end
vim.g.colors_name = "tachyon"

-----------------------------------------
-- PALETTE (Base16)
-----------------------------------------
local c = {
  base00 = "#030201",
  base01 = "#121212",
  base02 = "#222222",
  base03 = "#333333",
  base30 = "#727272",
  base04 = "#999999",
  base05 = "#c1c1c1",
  base06 = "#999999",
  base07 = "#c1c1c1",
  base08 = "#5f8787",
  base09 = "#aaaaaa",
  base0A = "#8c7f70",
  base0B = "#9b8d7f",
  base0C = "#aaaaaa",
  base0D = "#888888",
  base0E = "#999999",
  base0F = "#444444",
}

local set = vim.api.nvim_set_hl

-----------------------------------------
--  CORE UI
-----------------------------------------
set(0, "Normal", { fg = c.base05, bg = c.base00 })
set(0, "NormalFloat", { fg = c.base05, bg = c.base00 })
set(0, "FloatBorder", { fg = c.base03, bg = c.base00 })

set(0, "CursorLine", { bg = c.base01 })
set(0, "CursorColumn", { bg = c.base01 })
set(0, "CursorLineNr", { fg = c.base0A, bold = true })

set(0, "LineNr", { fg = c.base03 })
set(0, "WinSeparator", { fg = c.base02 })

set(0, "Visual", { bg = c.base02 })
set(0, "ColorColumn", { bg = c.base01 })
set(0, "SignColumn", { bg = c.base00 })

set(0, "StatusLine", { fg = c.base05, bg = c.base00 })
set(0, "StatusLineNC", { fg = c.base03, bg = c.base00 })

set(0, "Pmenu", { fg = c.base05, bg = c.base01 })
set(0, "PmenuSel", { fg = c.base00, bg = c.base05 })
set(0, "PmenuSbar", { bg = c.base01 })
set(0, "PmenuThumb", { bg = c.base03 })
set(0, "Directory", { fg = c.base04 })

-----------------------------------------
-- SYNTAX (Base16 strict)
-----------------------------------------
set(0, "Comment", { fg = c.base30 })
set(0, "Constant", { fg = c.base09 })
set(0, "String", { fg = c.base0B })
set(0, "Character", { fg = c.base0B })
set(0, "Number", { fg = c.base09 })
set(0, "Boolean", { fg = c.base09 })
set(0, "Float", { fg = c.base09 })

set(0, "Identifier", { fg = c.base08 })
set(0, "Function", { fg = c.base0D })

set(0, "Statement", { fg = c.base08 })
set(0, "Conditional", { fg = c.base0E })
set(0, "Repeat", { fg = c.base0E })
set(0, "Label", { fg = c.base0A })
set(0, "Operator", { fg = c.base05 })
set(0, "Keyword", { fg = c.base0E })

set(0, "PreProc", { fg = c.base0A })
set(0, "Include", { fg = c.base0D })
set(0, "Define", { fg = c.base0E })

set(0, "Type", { fg = c.base0A })
set(0, "StorageClass", { fg = c.base0A })
set(0, "Structure", { fg = c.base0E })
set(0, "Typedef", { fg = c.base0A })

set(0, "Special", { fg = c.base0C })
set(0, "SpecialComment", { fg = c.base03 })
set(0, "Todo", { fg = c.base0A, bg = c.base01 })

-----------------------------------------
-- DIAGNOSTICS / LSP
-----------------------------------------
set(0, "DiagnosticError", { fg = c.base08 })
set(0, "DiagnosticWarn", { fg = c.base0A })
set(0, "DiagnosticInfo", { fg = c.base0D })
set(0, "DiagnosticHint", { fg = c.base0C })

set(0, "DiagnosticUnderlineError", { sp = c.base08, underline = true })
set(0, "DiagnosticUnderlineWarn", { sp = c.base0A, underline = true })
set(0, "DiagnosticUnderlineInfo", { sp = c.base0D, underline = true })
set(0, "DiagnosticUnderlineHint", { sp = c.base0C, underline = true })

-----------------------------------------
-- TREESITTER
-----------------------------------------
local ts = {
  ["@comment"] = { fg = c.base30 },
  ["@constant"] = { fg = c.base09 },
  ["@string"] = { fg = c.base0B },
  ["@number"] = { fg = c.base09 },
  ["@boolean"] = { fg = c.base09 },
  ["@variable"] = { fg = c.base05 },
  ["@variable.builtin"] = { fg = c.base0E },
  ["@function"] = { fg = c.base0D },
  ["@function.builtin"] = { fg = c.base0D },
  ["@keyword"] = { fg = c.base0E },
  ["@type"] = { fg = c.base0A },
  ["@type.builtin"] = { fg = c.base0A },
  ["@field"] = { fg = c.base05 },
  ["@property"] = { fg = c.base05 },
  ["@operator"] = { fg = c.base05 },
  ["@punctuation"] = { fg = c.base04 },
  ["@text"] = { fg = c.base05 },
  ["@text.strong"] = { fg = c.base07, bold = true },
  ["@text.emphasis"] = { fg = c.base06, italic = true },
  ["@text.title"] = { fg = c.base07, bold = true },
  ["@text.literal"] = { fg = c.base0C }, -- inline code
  ["@text.uri"] = { fg = c.base0D, underline = true },
  ["@markup.quote"] = { fg = c.base0A, italic = true },
  ["@markup.list"] = { fg = c.base08 },
  ["@markup.link"] = { fg = c.base0D },
  ["@markup.link.label"] = { fg = c.base0D },
  ["@markup.raw"] = { fg = c.base0C }, -- fenced code blocks
}

for group, spec in pairs(ts) do
  set(0, group, spec)
end

-----------------------------------------
-- CMP
-----------------------------------------
set(0, "CmpItemAbbr", { fg = c.base05 })
set(0, "CmpItemAbbrMatch", { fg = c.base0D, bold = true })
set(0, "CmpItemKind", { fg = c.base0A })
set(0, "CmpItemMenu", { fg = c.base03 })

-----------------------------------------
-- GITSIGNS
-----------------------------------------
set(0, "GitSignsAdd", { fg = c.base0B })
set(0, "GitSignsChange", { fg = c.base0D })
set(0, "GitSignsDelete", { fg = c.base08 })

-----------------------------------------
-- NOICE
-----------------------------------------
set(0, "NoiceCmdline", { fg = c.base05, bg = c.base00 })
set(0, "NoiceCmdlineIcon", { fg = c.base0D })
set(0, "NoicePopup", { fg = c.base05, bg = c.base00 })
set(0, "NoicePopupBorder", { fg = c.base02 })
set(0, "NoiceFormatProgress", { fg = c.base0A })

-----------------------------------------
-- SNACKS.NVIM
-----------------------------------------
local snacks = {
  -- Indent guides
  SnacksIndent = { fg = c.base02 },
  SnacksIndentScope = { fg = c.base04 },
  SnacksIndentCurrent = { fg = c.base04 },

  -- Explorer folders (no blue/teal)
  SnacksExplorerDirectory = { fg = c.base04 },     -- cold silver
  SnacksExplorerDirectoryIcon = { fg = c.base04 }, -- cold silver
  SnacksExplorerFolderArrow = { fg = c.base03 },   -- dark grey

  SnacksExplorerFile = { fg = c.base05 },
  SnacksExplorerSymlink = { fg = c.base0E },
  SnacksExplorerSpecialFile = { fg = c.base0A },

  -- Icons (monochrome metal)
  SnacksExplorerIcon = { fg = c.base04 },

  -- Git status (subtle)
  SnacksExplorerGitAdded = { fg = c.base0B },
  SnacksExplorerGitModified = { fg = c.base0D },
  SnacksExplorerGitDeleted = { fg = c.base08 },
  SnacksExplorerGitRenamed = { fg = c.base0A },
  SnacksExplorerGitUntracked = { fg = c.base04 },
  -- Selection
  SnacksExplorerSelection = { fg = c.base00, bg = c.base05, bold = true },
  SnacksExplorerCursorLine = { bg = c.base01 },

  -- Hidden
  SnacksExplorerHidden = { fg = c.base05 },

  -- Preview panel
  SnacksExplorerPreviewNormal = { fg = c.base05, bg = c.base00 },
  SnacksExplorerPreviewBorder = { fg = c.base02 },

  -- Title
  SnacksExplorerTitle = { fg = c.base0E, bold = true },

  -- Picker
  SnacksPickerNormal = { fg = c.base05, bg = c.base00 },
  SnacksPickerBorder = { fg = c.base02 },
  SnacksPickerTitle = { fg = c.base0D, bold = true },
  SnacksPickerMatch = { fg = c.base0A },
  SnacksPickerSelection = { fg = c.base00, bg = c.base05, bold = true },
  SnacksPickerPrompt = { fg = c.base0D },

  -- Picker links
  SnacksPickerCol = { fg = c.base03 },
  SnacksPickerDir = { fg = c.base04 },
  SnacksPickerBufFlags = { link = "SnacksPickerDir" },

  -- Menus
  SnacksMenuNormal = { fg = c.base05, bg = c.base00 },
  SnacksMenuBorder = { fg = c.base02 },
  SnacksMenuSelection = { fg = c.base00, bg = c.base05, bold = true },

  -- Notify
  SnacksNotifyInfo = { fg = c.base0D },
  SnacksNotifyWarn = { fg = c.base0A },
  SnacksNotifyError = { fg = c.base08 },
  SnacksNotifyBorder = { fg = c.base02 },
}

-- Apply
for group, spec in pairs(snacks) do
  vim.api.nvim_set_hl(0, group, spec)
end

-----------------------------------------
-- UNDOTREE
-----------------------------------------
set(0, "UndotreeNode", { fg = c.base0A })
set(0, "UndotreeBranch", { fg = c.base0D })
