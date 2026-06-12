"" Source - https://stackoverflow.com/a/10140882
"" Posted by Janosimas
"" Retrieved 2026-06-12, License - CC BY-SA 3.0
syn match    cCustomParen    "?=(" contains=cParen,cCppParen
syn match    cCustomFunc     "\w\+\s*(\@=" contains=cCustomParen
syn match    cCustomScope    "::"
syn match    cCustomClass    "\w\+\s*::" contains=cCustomScope

hi def link cCustomFunc  Function
hi def link cCustomClass Function

syn match cOperator "[?!~*&%<>^|=+]"
hi def link cOperator Operator


syn match cCustomParentAccessA "\.\|->"
syn match cCustomParentAccess "?=\(\.\|->\)"
syn match cCustomParent       "\w\+\(\.\|->\)\@=" contains=cCustomParentAccess


hi def link cCustomParentAccessA Delimiter
hi def link cCustomParent cString

syn match cUpcase "\W[A-Z_][A-Z_0-9]\+\W"
hi def link cUpcase Upcase
