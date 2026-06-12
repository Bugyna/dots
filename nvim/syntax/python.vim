syn match    cCustomParen    "?=(" contains=Paren
syn match    cCustomFunc     "\w\+\s*(\@=" contains=cCustomParen

hi def link cCustomFunc  Function

syn match cOperator "[?!~*&%<>^|=+]"
hi def link cOperator Operator

syn keyword Self self
hi def link Self Identifier

syn match cCustomParentAccessA "\.\|->"
syn match cCustomParentAccess "?=\(\.\|->\)"
syn match cCustomParent       "\w\+\(\.\|->\)\@=" contains=cCustomParentAccess


hi def link cCustomParentAccessA Delimiter
hi def link cCustomParent cString

syn match cUpcase "\W[A-Z_][A-Z_0-9]\+\W"
hi def link cUpcase Upcase
