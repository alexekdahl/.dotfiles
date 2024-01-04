" Vim Color File
" Maintainer: https://github.com/deponian/vim-onedark
" License:    The MIT License (MIT)
" Based On:   https://github.com/joshdick/onedark.vim

highlight clear

if exists("syntax_on")
	syntax reset
endif

let g:colors_name="onedark"
let g:onedark_transparent = 1

let s:red = { "gui": "#E06C75", "cterm": "204"}
let s:error_red = { "gui": "#F44747", "cterm": "203"}
let s:dark_red = { "gui": "#BE5046", "cterm": "196"}
let s:green = { "gui": "#98C379", "cterm": "114"}
let s:yellow = { "gui": "#E5C07B", "cterm": "180"}
let s:dark_yellow = { "gui": "#D19A66", "cterm": "173"}
let s:blue = { "gui": "#61AFEF", "cterm": "39"}
let s:purple = { "gui": "#C678DD", "cterm": "170"}
let s:diff = { "gui": "#FF8800", "cterm": "208"}
let s:orange = { "gui": "#D19A66", "cterm": "173"}
let s:cyan = { "gui": "#56B6C2", "cterm": "38"}
let s:white = { "gui": "#ABB2BF", "cterm": "145"}
let s:black = { "gui": "#15171F", "cterm": "235"}
let s:visual_black = { "gui": "NONE", "cterm": "NONE"}
let s:comment_grey = { "gui": "#5C6370", "cterm": "59"}
let s:gutter_fg_grey = { "gui": "#4B5263", "cterm": "238"}
let s:cursor_grey = { "gui": "#2C323C", "cterm": "236"}
let s:visual_grey = { "gui": "#3E4452", "cterm": "237"}
let s:menu_grey = { "gui": "#3E4452", "cterm": "237"}
let s:special_grey = { "gui": "#3B4048", "cterm": "238"}
let s:vertsplit = { "gui": "#181A1F", "cterm": "59"}
let s:cursor_line_nr = { "gui": "#0087B4", "cterm": "39"}

" Syntax Groups (descriptions and ordering from `:h w18`)
execute "hi Comment"
		\ "guifg=" . s:comment_grey.gui "guibg=NONE gui=NONE"
execute "hi Constant"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi String"
		\ "guifg=" . s:green.gui "guibg=NONE gui=NONE"
execute "hi Character"
		\ "guifg=" . s:green.gui "guibg=NONE gui=NONE"
execute "hi Number"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi Boolean"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi Float"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi Identifier"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi Function"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi Statement"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi Conditional"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi Repeat"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi Label"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi Operator"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi Keyword"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi Exception"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi PreProc"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi Include"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi Define"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi Macro"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi PreCondit"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi Type"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi StorageClass"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi Structure"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi Typedef"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi Special"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi SpecialChar"
		\ "guifg=NONE guibg=NONE gui=NONE"
execute "hi Tag"
		\ "guifg=NONE guibg=NONE gui=NONE"
execute "hi Delimiter"
		\ "guifg=NONE guibg=NONE gui=NONE"
execute "hi SpecialComment"
		\ "guifg=" . s:comment_grey.gui "guibg=NONE gui=NONE"
execute "hi Debug"
		\ "guifg=NONE guibg=NONE gui=NONE"
execute "hi Underlined"
		\ "guifg=NONE guibg=NONE gui=underline"
execute "hi Ignore"
		\ "guifg=NONE guibg=NONE gui=NONE"
execute "hi Error"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi Todo"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"

" Highlighting Groups (descriptions and ordering from `:h highlight-groups`)
execute "hi ColorColumn"
		\ "guifg=NONE guibg=" . s:cursor_grey.gui "gui=NONE"
execute "hi Conceal"
		\ "guifg=NONE guibg=NONE gui=NONE"
execute "hi Cursor"
		\ "guifg=" . s:black.gui "guibg=" . s:blue.gui "gui=NONE"
execute "hi CursorIM"
		\ "guifg=NONE guibg=NONE gui=NONE"
execute "hi CursorColumn"
		\ "guifg=NONE guibg=" . s:cursor_grey.gui "gui=NONE"
if &diff
	execute "hi CursorLine"
		\ "guifg=NONE guibg=NONE gui=NONE"
else
	execute "hi CursorLine"
		\ "guifg=NONE guibg=" . s:cursor_grey.gui "gui=NONE"
endif
execute "hi Directory"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi DiffAdd"
		\ "guifg=" . s:black.gui "guibg=" . s:green.gui "gui=NONE"
execute "hi DiffChange"
		\ "guifg=" . s:diff.gui "guibg=NONE gui=NONE"
execute "hi DiffDelete"
		\ "guifg=" . s:black.gui "guibg=" . s:red.gui "gui=NONE"
execute "hi DiffText"
		\ "guifg=" . s:black.gui "guibg=" . s:diff.gui "gui=NONE"
execute "hi ErrorMsg"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi VertSplit"
		\ "guifg=" . s:vertsplit.gui "guibg=NONE gui=NONE"
execute "hi Folded"
		\ "guifg=" . s:comment_grey.gui "guibg=NONE gui=NONE"
execute "hi FoldColumn"
		\ "guifg=NONE guibg=NONE gui=NONE"
execute "hi SignColumn"
		\ "guifg=NONE guibg=NONE gui=NONE"
execute "hi IncSearch"
		\ "guifg=" . s:yellow.gui "guibg=" . s:comment_grey.gui "gui=NONE"
execute "hi LineNr"
		\ "guifg=" . s:gutter_fg_grey.gui "guibg=NONE gui=NONE"
execute "hi CursorLineNr"
		\ "guifg=" . s:cursor_line_nr.gui "guibg=NONE gui=NONE"
execute "hi MatchParen"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi ModeMsg"
		\ "guifg=NONE guibg=NONE gui=NONE"
execute "hi MoreMsg"
		\ "guifg=NONE guibg=NONE gui=NONE"
execute "hi NonText"
		\ "guifg=" . s:special_grey.gui "guibg=NONE gui=NONE"
if g:onedark_transparent == 1
	execute "hi Normal"
		\ "guifg=" . s:white.gui "guibg=NONE gui=NONE"
else
	execute "hi Normal"
		\ "guifg=" . s:white.gui "guibg=" . s:black.gui "gui=NONE"
endif
execute "hi Pmenu"
		\ "guifg=NONE guibg=" . s:visual_grey.gui "gui=NONE"
execute "hi PmenuSel"
		\ "guifg=" . s:black.gui "guibg=" . s:blue.gui "gui=NONE"
execute "hi PmenuSbar"
		\ "guifg=NONE guibg=" . s:special_grey.gui "gui=NONE"
execute "hi PmenuThumb"
		\ "guifg=NONE guibg=" . s:white.gui "gui=NONE"
execute "hi Question"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi QuickFixLine"
		\ "guifg=" . s:black.gui "guibg=" . s:yellow.gui "gui=NONE"
execute "hi Search"
		\ "guifg=" . s:black.gui "guibg=" . s:yellow.gui "gui=NONE"
execute "hi SpecialKey"
		\ "guifg=" . s:special_grey.gui "guibg=NONE gui=NONE"
execute "hi SpellBad"
		\ "guifg=" . s:red.gui "guibg=NONE gui=underline"
execute "hi SpellCap"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi SpellLocal"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi SpellRare"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi StatusLine"
		\ "guifg=" . s:white.gui "guibg=" . s:cursor_grey.gui "gui=NONE"
execute "hi StatusLineNC"
		\ "guifg=" . s:comment_grey.gui "guibg=NONE gui=NONE"
execute "hi StatusLineTerm"
		\ "guifg=" . s:white.gui "guibg=" . s:cursor_grey.gui "gui=NONE"
execute "hi StatusLineTermNC"
		\ "guifg=" . s:comment_grey.gui "guibg=NONE gui=NONE"
execute "hi TabLine"
		\ "guifg=" . s:comment_grey.gui "guibg=NONE gui=NONE"
execute "hi TabLineFill"
		\ "guifg=NONE guibg=NONE gui=NONE"
execute "hi TabLineSel"
		\ "guifg=" . s:white.gui "guibg=NONE gui=NONE"
execute "hi Terminal"
		\ "guifg=" . s:white.gui "guibg=" . s:black.gui "gui=NONE"
execute "hi Title"
		\ "guifg=" . s:green.gui "guibg=NONE gui=NONE"
execute "hi Visual"
		\ "guifg=NONE guibg=" . s:visual_grey.gui "gui=NONE"
execute "hi VisualNOS"
		\ "guifg=NONE guibg=" . s:visual_grey.gui "gui=NONE"
execute "hi WarningMsg"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi WildMenu"
		\ "guifg=" . s:black.gui "guibg=" . s:blue.gui "gui=NONE"

" LSP related
execute "hi DiagnosticError"
		\ "guifg=" . s:error_red.gui "guibg=NONE gui=NONE"
execute "hi DiagnosticWarn"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi DiagnosticInfo"
		\ "guifg=" . s:cyan.gui "guibg=NONE gui=NONE"
execute "hi DiagnosticHint"
		\ "guifg=" . s:comment_grey.gui "guibg=NONE gui=NONE"
execute "hi NormalFloat"
		\ "guifg=" . s:comment_grey.gui "guibg=NONE gui=NONE"
execute "hi FloatBorder"
		\ "guifg=" . s:comment_grey.gui "guibg=NONE gui=NONE"
execute "hi FloatBorderDark"
		\ "guifg=" . s:comment_grey.gui "guibg=NONE gui=NONE"
execute "hi FloatShadow"
		\ "guifg=" . s:comment_grey.gui "guibg=NONE gui=NONE"
execute "hi FloatShadowThrough"
		\ "guifg=" . s:comment_grey.gui "guibg=NONE gui=NONE"

" Termdebug highlighting for Vim 8.1+
" See `:h hl-debugPC` and `:h hl-debugBreakpoint`.
execute "hi debugPC"
		\ "guifg=NONE guibg=" . s:special_grey.gui "gui=NONE"
execute "hi debugBreakpoint"
		\ "guifg=" . s:black.gui "guibg=" . s:red.gui "gui=NONE"

" Treesitter highlighting
execute "hi TSError"
		\ "guifg=" . s:error_red.gui "guibg=NONE gui=NONE"
execute "hi TSPunctDelimiter"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi TSPunctBracket"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi TSPunctSpecial"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi TSConstant"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi TSConstBuiltin"
		\ "guifg=" . s:orange.gui "guibg=NONE gui=NONE"
execute "hi TSConstMacro"
		\ "guifg=" . s:cyan.gui "guibg=NONE gui=NONE"
execute "hi TSStringRegex"
		\ "guifg=" . s:green.gui "guibg=NONE gui=NONE"
execute "hi TSString"
		\ "guifg=" . s:green.gui "guibg=NONE gui=NONE"
execute "hi TSStringEscape"
		\ "guifg=" . s:cyan.gui "guibg=NONE gui=NONE"
execute "hi TSCharacter"
		\ "guifg=" . s:green.gui "guibg=NONE gui=NONE"
execute "hi TSNumber"
		\ "guifg=" . s:orange.gui "guibg=NONE gui=NONE"
execute "hi TSBoolean"
		\ "guifg=" . s:orange.gui "guibg=NONE gui=NONE"
execute "hi TSFloat"
		\ "guifg=" . s:green.gui "guibg=NONE gui=NONE"
execute "hi TSAnnotation"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi TSAttribute"
		\ "guifg=" . s:cyan.gui "guibg=NONE gui=NONE"
execute "hi TSNamespace"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi TSFuncBuiltin"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi TSFunction"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi TSFuncMacro"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi TSParameter"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi TSParameterReference"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi TSMethod"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi TSField"
		\ "guifg=" . s:cyan.gui "guibg=NONE gui=NONE"
execute "hi TSProperty"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi TSConstructor"
		\ "guifg=" . s:cyan.gui "guibg=NONE gui=NONE"
execute "hi TSConditional"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi TSRepeat"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi TSLabel"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi TSKeyword"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi TSKeywordFunction"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi TSKeywordOperator"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi TSOperator"
		\ "guifg=" . s:white.gui "guibg=NONE gui=NONE"
execute "hi TSException"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi TSType"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi TSTypeBuiltin"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi TSStructure"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi TSInclude"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi TSVariable"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi TSVariableBuiltin"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi TSText"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi TSStrong"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi TSEmphasis"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi TSUnderline"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi TSTitle"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi TSLiteral"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi TSURI"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi TSTag"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi TSTagDelimiter"
		\ "guifg=" . s:comment_grey.gui "guibg=NONE gui=NONE"

" Language-Specific Highlighting

" CSS
execute "hi cssAttrComma"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi cssAttributeSelector"
		\ "guifg=" . s:green.gui "guibg=NONE gui=NONE"
execute "hi cssBraces"
		\ "guifg=" . s:white.gui "guibg=NONE gui=NONE"
execute "hi cssClassName"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi cssClassNameDot"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi cssDefinition"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi cssFontAttr"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi cssFontDescriptor"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi cssFunctionName"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi cssIdentifier"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi cssImportant"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi cssInclude"
		\ "guifg=" . s:white.gui "guibg=NONE gui=NONE"
execute "hi cssIncludeKeyword"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi cssMediaType"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi cssProp"
		\ "guifg=" . s:white.gui "guibg=NONE gui=NONE"
execute "hi cssPseudoClassId"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi cssSelectorOp"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi cssSelectorOp2"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi cssTagName"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"

" Fish Shell
execute "hi fishKeyword"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi fishConditional"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"

" Go
execute "hi goDeclaration"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi goBuiltins"
		\ "guifg=" . s:cyan.gui "guibg=NONE gui=NONE"
execute "hi goFunctionCall"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi goVarDefs"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi goVarAssign"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi goVar"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi goConst"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi goType"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi goTypeName"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi goDeclType"
		\ "guifg=" . s:cyan.gui "guibg=NONE gui=NONE"
execute "hi goTypeDecl"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"

" HTML (keep consistent with Markdown, below)
execute "hi htmlArg"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi htmlBold"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi htmlEndTag"
		\ "guifg=" . s:white.gui "guibg=NONE gui=NONE"
execute "hi htmlH1"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi htmlH2"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi htmlH3"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi htmlH4"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi htmlH5"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi htmlH6"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi htmlItalic"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi htmlLink"
		\ "guifg=" . s:cyan.gui "guibg=NONE gui=underline"
execute "hi htmlSpecialChar"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi htmlSpecialTagName"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi htmlTag"
		\ "guifg=" . s:white.gui "guibg=NONE gui=NONE"
execute "hi htmlTagN"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi htmlTagName"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi htmlTitle"
		\ "guifg=" . s:white.gui "guibg=NONE gui=NONE"

" JavaScript
execute "hi javaScriptBraces"
		\ "guifg=" . s:white.gui "guibg=NONE gui=NONE"
execute "hi javaScriptFunction"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi javaScriptIdentifier"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi javaScriptNull"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi javaScriptNumber"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi javaScriptRequire"
		\ "guifg=" . s:cyan.gui "guibg=NONE gui=NONE"
execute "hi javaScriptReserved"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
" https://github.com/pangloss/vim-javascript
execute "hi jsArrowFunction"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi jsClassKeyword"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi jsClassMethodType"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi jsDocParam"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi jsDocTags"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi jsExport"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi jsExportDefault"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi jsExtendsKeyword"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi jsFrom"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi jsFuncCall"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi jsFunction"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi jsGenerator"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi jsGlobalObjects"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi jsImport"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi jsModuleAs"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi jsModuleWords"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi jsModules"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi jsNull"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi jsOperator"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi jsStorageClass"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi jsSuper"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi jsTemplateBraces"
		\ "guifg=" . s:dark_red.gui "guibg=NONE gui=NONE"
execute "hi jsTemplateVar"
		\ "guifg=" . s:green.gui "guibg=NONE gui=NONE"
execute "hi jsThis"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi jsUndefined"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
" https://github.com/othree/yajs.vim
execute "hi javascriptArrowFunc"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi javascriptClassExtends"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi javascriptClassKeyword"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi javascriptDocNotation"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi javascriptDocParamName"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi javascriptDocTags"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi javascriptEndColons"
		\ "guifg=" . s:white.gui "guibg=NONE gui=NONE"
execute "hi javascriptExport"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi javascriptFuncArg"
		\ "guifg=" . s:white.gui "guibg=NONE gui=NONE"
execute "hi javascriptFuncKeyword"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi javascriptIdentifier"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi javascriptImport"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi javascriptMethodName"
		\ "guifg=" . s:white.gui "guibg=NONE gui=NONE"
execute "hi javascriptObjectLabel"
		\ "guifg=" . s:white.gui "guibg=NONE gui=NONE"
execute "hi javascriptOpSymbol"
		\ "guifg=" . s:cyan.gui "guibg=NONE gui=NONE"
execute "hi javascriptOpSymbols"
		\ "guifg=" . s:cyan.gui "guibg=NONE gui=NONE"
execute "hi javascriptPropertyName"
		\ "guifg=" . s:green.gui "guibg=NONE gui=NONE"
execute "hi javascriptTemplateSB"
		\ "guifg=" . s:dark_red.gui "guibg=NONE gui=NONE"
execute "hi javascriptVariable"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"

" JSON
execute "hi jsonCommentError"
		\ "guifg=" . s:white.gui "guibg=NONE gui=NONE"
execute "hi jsonKeyword"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi jsonBoolean"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi jsonNumber"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi jsonQuote"
		\ "guifg=" . s:white.gui "guibg=NONE gui=NONE"
execute "hi jsonMissingCommaError"
		\ "guifg=" . s:red.gui "guibg=NONE gui=reverse"
execute "hi jsonNoQuotesError"
		\ "guifg=" . s:red.gui "guibg=NONE gui=reverse"
execute "hi jsonNumError"
		\ "guifg=" . s:red.gui "guibg=NONE gui=reverse"
execute "hi jsonString"
		\ "guifg=" . s:green.gui "guibg=NONE gui=NONE"
execute "hi jsonStringSQError"
		\ "guifg=" . s:red.gui "guibg=NONE gui=reverse"
execute "hi jsonSemicolonError"
		\ "guifg=" . s:red.gui "guibg=NONE gui=reverse"

" LESS
execute "hi lessVariable"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi lessAmpersandChar"
		\ "guifg=" . s:white.gui "guibg=NONE gui=NONE"
execute "hi lessClass"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"

" Markdown (keep consistent with HTML, above)
execute "hi markdownBlockquote"
		\ "guifg=" . s:comment_grey.gui "guibg=NONE gui=NONE"
execute "hi markdownBold"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi markdownCode"
		\ "guifg=" . s:green.gui "guibg=NONE gui=NONE"
execute "hi markdownCodeBlock"
		\ "guifg=" . s:green.gui "guibg=NONE gui=NONE"
execute "hi markdownCodeDelimiter"
		\ "guifg=" . s:green.gui "guibg=NONE gui=NONE"
execute "hi markdownH1"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi markdownH2"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi markdownH3"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi markdownH4"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi markdownH5"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi markdownH6"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi markdownHeadingDelimiter"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi markdownHeadingRule"
		\ "guifg=" . s:comment_grey.gui "guibg=NONE gui=NONE"
execute "hi markdownId"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi markdownIdDeclaration"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi markdownIdDelimiter"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi markdownItalic"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi markdownLinkDelimiter"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi markdownLinkText"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi markdownListMarker"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi markdownOrderedListMarker"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi markdownRule"
		\ "guifg=" . s:comment_grey.gui "guibg=NONE gui=NONE"
execute "hi markdownUrl"
		\ "guifg=" . s:cyan.gui "guibg=NONE gui=underline"

" Perl
execute "hi perlFiledescRead"
		\ "guifg=" . s:green.gui "guibg=NONE gui=NONE"
execute "hi perlFunction"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi perlMatchStartEnd"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi perlMethod"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi perlPOD"
		\ "guifg=" . s:comment_grey.gui "guibg=NONE gui=NONE"
execute "hi perlSharpBang"
		\ "guifg=" . s:comment_grey.gui "guibg=NONE gui=NONE"
execute "hi perlSpecialString"
		\ "guifg=" . s:cyan.gui "guibg=NONE gui=NONE"
execute "hi perlStatementFiledesc"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi perlStatementFlow"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi perlStatementInclude"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi perlStatementScalar"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi perlStatementStorage"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi perlSubName"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi perlVarPlain"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"

" PHP
execute "hi phpVarSelector"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi phpOperator"
		\ "guifg=" . s:white.gui "guibg=NONE gui=NONE"
execute "hi phpParent"
		\ "guifg=" . s:white.gui "guibg=NONE gui=NONE"
execute "hi phpMemberSelector"
		\ "guifg=" . s:white.gui "guibg=NONE gui=NONE"
execute "hi phpType"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi phpKeyword"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi phpClass"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi phpUseClass"
		\ "guifg=" . s:white.gui "guibg=NONE gui=NONE"
execute "hi phpUseAlias"
		\ "guifg=" . s:white.gui "guibg=NONE gui=NONE"
execute "hi phpInclude"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi phpClassExtends"
		\ "guifg=" . s:green.gui "guibg=NONE gui=NONE"
execute "hi phpDocTags"
		\ "guifg=" . s:white.gui "guibg=NONE gui=NONE"
execute "hi phpFunction"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi phpFunctions"
		\ "guifg=" . s:cyan.gui "guibg=NONE gui=NONE"
execute "hi phpMethodsVar"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi phpMagicConstants"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi phpSuperglobals"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi phpConstants"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"

" Ruby
execute "hi rubyBlockParameter"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi rubyBlockParameterList"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi rubyClass"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi rubyConstant"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi rubyControl"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi rubyEscape"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi rubyFunction"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi rubyGlobalVariable"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi rubyInclude"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi rubyIncluderubyGlobalVariable"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi rubyInstanceVariable"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi rubyInterpolation"
		\ "guifg=" . s:cyan.gui "guibg=NONE gui=NONE"
execute "hi rubyInterpolationDelimiter"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi rubyInterpolationDelimiter"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi rubyRegexp"
		\ "guifg=" . s:cyan.gui "guibg=NONE gui=NONE"
execute "hi rubyRegexpDelimiter"
		\ "guifg=" . s:cyan.gui "guibg=NONE gui=NONE"
execute "hi rubyStringDelimiter"
		\ "guifg=" . s:green.gui "guibg=NONE gui=NONE"
execute "hi rubySymbol"
		\ "guifg=" . s:cyan.gui "guibg=NONE gui=NONE"

" Sass
" https://github.com/tpope/vim-haml
execute "hi sassAmpersand"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi sassClass"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi sassControl"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi sassExtend"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi sassFor"
		\ "guifg=" . s:white.gui "guibg=NONE gui=NONE"
execute "hi sassFunction"
		\ "guifg=" . s:cyan.gui "guibg=NONE gui=NONE"
execute "hi sassId"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi sassInclude"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi sassMedia"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi sassMediaOperators"
		\ "guifg=" . s:white.gui "guibg=NONE gui=NONE"
execute "hi sassMixin"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi sassMixinName"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi sassMixing"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi sassVariable"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
" https://github.com/cakebaker/scss-syntax.vim
execute "hi scssExtend"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi scssImport"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi scssInclude"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi scssMixin"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi scssSelectorName"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi scssVariable"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"

" TeX
execute "hi texStatement"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi texSubscripts"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi texSuperscripts"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi texTodo"
		\ "guifg=" . s:dark_red.gui "guibg=NONE gui=NONE"
execute "hi texBeginEnd"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi texBeginEndName"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi texMathMatcher"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi texMathDelim"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi texDelimiter"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi texSpecialChar"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi texCite"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi texRefZone"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"

" TypeScript
execute "hi typescriptReserved"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi typescriptEndColons"
		\ "guifg=" . s:white.gui "guibg=NONE gui=NONE"
execute "hi typescriptBraces"
		\ "guifg=" . s:white.gui "guibg=NONE gui=NONE"

" XML
execute "hi xmlAttrib"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi xmlEndTag"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi xmlTag"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi xmlTagName"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"

" Plugin Highlighting

" airblade/vim-gitgutter
hi link GitGutterAdd    SignifySignAdd
hi link GitGutterChange SignifySignChange
hi link GitGutterDelete SignifySignDelete

" easymotion/vim-easymotion
execute "hi EasyMotionTarget"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi EasyMotionTarget2First"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi EasyMotionTarget2Second"
		\ "guifg=" . s:dark_yellow.gui "guibg=NONE gui=NONE"
execute "hi EasyMotionShade"
		\ "guifg=" . s:comment_grey.gui "guibg=NONE gui=NONE"

" mhinz/vim-signify
execute "hi SignifySignAdd"
		\ "guifg=" . s:green.gui "guibg=NONE gui=NONE"
execute "hi SignifySignChange"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi SignifySignDelete"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"

" neomake/neomake
execute "hi NeomakeWarningSign"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi NeomakeErrorSign"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi NeomakeInfoSign"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"

" plasticboy/vim-markdown (keep consistent with Markdown, above)
execute "hi mkdDelimiter"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi mkdHeading"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi mkdLink"
		\ "guifg=" . s:blue.gui "guibg=NONE gui=NONE"
execute "hi mkdUrl"
		\ "guifg=" . s:cyan.gui "guibg=NONE gui=underline"

" tpope/vim-fugitive
execute "hi diffAdded"
		\ "guifg=" . s:green.gui "guibg=NONE gui=NONE"
execute "hi diffRemoved"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"

" Git Highlighting
execute "hi gitcommitComment"
		\ "guifg=" . s:comment_grey.gui "guibg=NONE gui=NONE"
execute "hi gitcommitUnmerged"
		\ "guifg=" . s:green.gui "guibg=NONE gui=NONE"
execute "hi gitcommitOnBranch"
		\ "guifg=NONE guibg=NONE gui=NONE"
execute "hi gitcommitBranch"
		\ "guifg=" . s:purple.gui "guibg=NONE gui=NONE"
execute "hi gitcommitDiscardedType"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi gitcommitSelectedType"
		\ "guifg=" . s:green.gui "guibg=NONE gui=NONE"
execute "hi gitcommitHeader"
		\ "guifg=NONE guibg=NONE gui=NONE"
execute "hi gitcommitUntrackedFile"
		\ "guifg=" . s:cyan.gui "guibg=NONE gui=NONE"
execute "hi gitcommitDiscardedFile"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"
execute "hi gitcommitSelectedFile"
		\ "guifg=" . s:green.gui "guibg=NONE gui=NONE"
execute "hi gitcommitUnmergedFile"
		\ "guifg=" . s:yellow.gui "guibg=NONE gui=NONE"
execute "hi gitcommitFile"
		\ "guifg=NONE guibg=NONE gui=NONE"
execute "hi gitcommitSummary"
		\ "guifg=" . s:white.gui "guibg=NONE gui=NONE"
execute "hi gitcommitOverflow"
		\ "guifg=" . s:red.gui "guibg=NONE gui=NONE"

hi link gitcommitNoBranch gitcommitBranch
hi link gitcommitUntracked gitcommitComment
hi link gitcommitDiscarded gitcommitComment
hi link gitcommitSelected gitcommitComment
hi link gitcommitDiscardedArrow gitcommitDiscardedFile
hi link gitcommitSelectedArrow gitcommitSelectedFile
hi link gitcommitUnmergedArrow gitcommitUnmergedFile


" Neovim terminal colors

if has("nvim")
	let g:terminal_color_0 =  s:black.gui
	let g:terminal_color_1 =  s:red.gui
	let g:terminal_color_2 =  s:green.gui
	let g:terminal_color_3 =  s:yellow.gui
	let g:terminal_color_4 =  s:blue.gui
	let g:terminal_color_5 =  s:purple.gui
	let g:terminal_color_6 =  s:cyan.gui
	let g:terminal_color_7 =  s:white.gui
	let g:terminal_color_8 =  s:visual_grey.gui
	let g:terminal_color_9 =  s:dark_red.gui
	let g:terminal_color_10 = s:green.gui " No dark version
	let g:terminal_color_11 = s:dark_yellow.gui
	let g:terminal_color_12 = s:blue.gui " No dark version
	let g:terminal_color_13 = s:purple.gui " No dark version
	let g:terminal_color_14 = s:cyan.gui " No dark version
	let g:terminal_color_15 = s:comment_grey.gui
	let g:terminal_color_background = g:terminal_color_0
	let g:terminal_color_foreground = g:terminal_color_7
endif

" Must appear at the end of the file to work around this oddity:
" https://groups.google.com/forum/#!msg/vim_dev/afPqwAFNdrU/nqh6tOM87QUJ
set background=dark