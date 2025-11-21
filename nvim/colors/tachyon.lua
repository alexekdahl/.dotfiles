-----------------------------------------
-- Tachyon
-- Ultra-fast Base16 Lua colorscheme
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
  base00     = "#030201",
  base01     = "#121212",
  base02     = "#222222",
  base03     = "#333333",
  base30     = "#727272",
  base04     = "#999999",
  base05     = "#c1c1c1",
  base06     = "#999999",
  base07     = "#c1c1c1",
  base08     = "#5f8787",
  base09     = "#aaaaaa",
  base0A     = "#8c7f70",
  base0B     = "#9b8d7f",
  base0C     = "#aaaaaa",
  base0D     = "#888888",
  base0E     = "#999999",
  base0F     = "#444444",

  sl_normal  = "#aa749f",
  sl_insert  = "#aa749f",
  sl_visual  = "#85b884",
  sl_command = "#f6ad6c",
  sl_fg      = "#525252",
  sl_fg_nc   = "#3a3a3a",
}

-----------------------------------------
-- ALL HIGHLIGHTS IN ONE TABLE
-----------------------------------------
local highlights = {

  -----------------------------------------
  -- CORE UI
  -----------------------------------------
  Normal                      = { fg = c.base05, bg = c.base00 },
  NormalFloat                 = { fg = c.base05, bg = c.base00 },
  FloatBorder                 = { fg = c.base03, bg = c.base00 },

  CursorLine                  = { bg = c.base01 },
  CursorColumn                = { bg = c.base01 },
  CursorLineNr                = { fg = c.base0A, bold = true },

  LineNr                      = { fg = c.base03 },
  WinSeparator                = { fg = c.base02 },

  Visual                      = { bg = c.base02 },
  ColorColumn                 = { bg = c.base01 },
  SignColumn                  = { bg = c.base00 },

  Pmenu                       = { fg = c.base05, bg = c.base01 },
  PmenuSel                    = { fg = c.base00, bg = c.base05 },
  PmenuSbar                   = { bg = c.base01 },
  PmenuThumb                  = { bg = c.base03 },
  Directory                   = { fg = c.base04 },

  -----------------------------------------
  -- STATUSLINE (from statusline.lua)
  -----------------------------------------
  SLineNormal                 = { fg = c.sl_normal, bg = c.base00, bold = true },
  SLineInsert                 = { fg = c.sl_insert, bg = c.base00, bold = true },
  SLineVisual                 = { fg = c.sl_visual, bg = c.base00, bold = true },
  SLineCommand                = { fg = c.sl_command, bg = c.base00, bold = true },

  StatusLine                  = { fg = c.sl_fg, bg = c.base00, bold = true },
  StatusLineNC                = { fg = c.sl_fg_nc, bg = c.base00, bold = true },

  -----------------------------------------
  -- SYNTAX (Base16 strict)
  -----------------------------------------
  Comment                     = { fg = c.base30 },
  Constant                    = { fg = c.base09 },
  String                      = { fg = c.base0B },
  Character                   = { fg = c.base0B },
  Number                      = { fg = c.base09 },
  Boolean                     = { fg = c.base09 },
  Float                       = { fg = c.base09 },

  Identifier                  = { fg = c.base08 },
  Function                    = { fg = c.base0D },

  Statement                   = { fg = c.base08 },
  Conditional                 = { fg = c.base0E },
  Repeat                      = { fg = c.base0E },
  Label                       = { fg = c.base0A },
  Operator                    = { fg = c.base05 },
  Keyword                     = { fg = c.base0E },

  PreProc                     = { fg = c.base0A },
  Include                     = { fg = c.base0D },
  Define                      = { fg = c.base0E },

  Type                        = { fg = c.base0A },
  StorageClass                = { fg = c.base0A },
  Structure                   = { fg = c.base0E },
  Typedef                     = { fg = c.base0A },

  Special                     = { fg = c.base0C },
  SpecialComment              = { fg = c.base03 },
  Todo                        = { fg = c.base0A, bg = c.base01 },

  -----------------------------------------
  -- DIAGNOSTICS / LSP
  -----------------------------------------
  DiagnosticError             = { fg = c.base08 },
  DiagnosticWarn              = { fg = c.base0A },
  DiagnosticInfo              = { fg = c.base0D },
  DiagnosticHint              = { fg = c.base0C },

  DiagnosticUnderlineError    = { sp = c.base08, underline = true },
  DiagnosticUnderlineWarn     = { sp = c.base0A, underline = true },
  DiagnosticUnderlineInfo     = { sp = c.base0D, underline = true },
  DiagnosticUnderlineHint     = { sp = c.base0C, underline = true },

  -----------------------------------------
  -- TREESITTER
  -----------------------------------------
  ["@comment"]                = { fg = c.base30 },
  ["@constant"]               = { fg = c.base09 },
  ["@string"]                 = { fg = c.base0B },
  ["@number"]                 = { fg = c.base09 },
  ["@boolean"]                = { fg = c.base09 },
  ["@variable"]               = { fg = c.base05 },
  ["@variable.builtin"]       = { fg = c.base0E },
  ["@function"]               = { fg = c.base0D },
  ["@function.builtin"]       = { fg = c.base0D },
  ["@keyword"]                = { fg = c.base0E },
  ["@type"]                   = { fg = c.base0A },
  ["@type.builtin"]           = { fg = c.base0A },
  ["@field"]                  = { fg = c.base05 },
  ["@property"]               = { fg = c.base05 },
  ["@operator"]               = { fg = c.base05 },
  ["@punctuation"]            = { fg = c.base04 },
  ["@text"]                   = { fg = c.base05 },
  ["@text.strong"]            = { fg = c.base07, bold = true },
  ["@text.emphasis"]          = { fg = c.base06, italic = false },
  ["@text.title"]             = { fg = c.base07, bold = true },
  ["@text.literal"]           = { fg = c.base0C },
  ["@text.uri"]               = { fg = c.base0D, underline = true },
  ["@markup.quote"]           = { fg = c.base0A, italic = false },
  ["@markup.list"]            = { fg = c.base08 },
  ["@markup.link"]            = { fg = c.base0D },
  ["@markup.link.label"]      = { fg = c.base0D },
  ["@markup.raw"]             = { fg = c.base0C },

  -----------------------------------------
  -- CMP
  -----------------------------------------
  CmpItemAbbr                 = { fg = c.base05 },
  CmpItemAbbrMatch            = { fg = c.base0D, bold = true },
  CmpItemKind                 = { fg = c.base0A },
  CmpItemMenu                 = { fg = c.base03 },

  -----------------------------------------
  -- GITSIGNS
  -----------------------------------------
  GitSignsAdd                 = { fg = c.base0B },
  GitSignsChange              = { fg = c.base0D },
  GitSignsDelete              = { fg = c.base08 },

  -----------------------------------------
  -- SNACKS.NVIM
  -----------------------------------------
  SnacksIndent                = { fg = c.base02 },
  SnacksIndentScope           = { fg = c.base04 },
  SnacksIndentCurrent         = { fg = c.base04 },

  SnacksExplorerDirectory     = { fg = c.base04 },
  SnacksExplorerDirectoryIcon = { fg = c.base04 },
  SnacksExplorerFolderArrow   = { fg = c.base03 },

  SnacksExplorerFile          = { fg = c.base05 },
  SnacksExplorerSymlink       = { fg = c.base0E },
  SnacksExplorerSpecialFile   = { fg = c.base0A },

  SnacksExplorerIcon          = { fg = c.base04 },

  SnacksExplorerGitAdded      = { fg = c.base0B },
  SnacksExplorerGitModified   = { fg = c.base0D },
  SnacksExplorerGitDeleted    = { fg = c.base08 },
  SnacksExplorerGitRenamed    = { fg = c.base0A },
  SnacksExplorerGitUntracked  = { fg = c.base04 },

  SnacksExplorerSelection     = { fg = c.base00, bg = c.base05, bold = true },
  SnacksExplorerCursorLine    = { bg = c.base01 },

  SnacksExplorerHidden        = { fg = c.base05 },

  SnacksExplorerPreviewNormal = { fg = c.base05, bg = c.base00 },
  SnacksExplorerPreviewBorder = { fg = c.base02 },

  SnacksExplorerTitle         = { fg = c.base0E, bold = true },

  SnacksPickerNormal          = { fg = c.base05, bg = c.base00 },
  SnacksPickerBorder          = { fg = c.base02 },
  SnacksPickerTitle           = { fg = c.base0D, bold = true },
  SnacksPickerMatch           = { fg = c.base0A },
  SnacksPickerSelection       = { fg = c.base00, bg = c.base05, bold = true },
  SnacksPickerPrompt          = { fg = c.base0D },

  SnacksPickerCol             = { fg = c.base03 },
  SnacksPickerDir             = { fg = c.base04 },
  SnacksPickerBufFlags        = { link = "SnacksPickerDir" },

  SnacksMenuNormal            = { fg = c.base05, bg = c.base00 },
  SnacksMenuBorder            = { fg = c.base02 },
  SnacksMenuSelection         = { fg = c.base00, bg = c.base05, bold = true },

  SnacksNotifyInfo            = { fg = c.base0D },
  SnacksNotifyWarn            = { fg = c.base0A },
  SnacksNotifyError           = { fg = c.base08 },
  SnacksNotifyBorder          = { fg = c.base02 },

  -----------------------------------------
  -- UNDOTREE
  -----------------------------------------
  UndotreeNode                = { fg = c.base0A },
  UndotreeBranch              = { fg = c.base0D },
}

-----------------------------------------
-- APPLY ALL HIGHLIGHTS
-----------------------------------------
for group, spec in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, spec)
end
