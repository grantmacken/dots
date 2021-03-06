; Modules
;--------
; module namespace newBase60  = "http://gmack.nz/#newBase60";


(default_namespace_declaration
   ["element" "function" ] @type)

; diff wildcard from multiplicative times op
; TODO name_test wildcard
[
(lookup_wildcard)
(wildcard)
] @method

[  ";" "," ] @punctuation.delimiter
;enclosing bracket markers
[ "(" ")" "{" "}"  ] @punctuation.bracket
;"[" "]" 
; XML tags
(end_tag [ "</"  ">" ]  @tag.delimiter)
(start_tag [ "<"  ">"] @tag.delimiter)
(empty_tag [ "<" "/>" ] @tag.delimiter)
(start_tag (identifier) @tag)
(end_tag (identifier) @tag)
(empty_tag (identifier) @tag)
(direct_attribute (identifier) @attribute)
(end_tag [ "</"  ">" ]  @tag.delimiter)
(start_tag [ "<"  ">"] @tag.delimiter)
(empty_tag [ "<" "/>" ] @tag.delimiter)
;
;(direct_attribute
;  name: (identifier) @attribute)

;(direct_attribute
;  value: (QName) @string)

;punctuation.special for symbols with special meaning like `{}` in string interpolation.

; CONSTANTS
; names of the constructed nodes are constants

;string
[
(string_literal) 
(char_group)
] @string
;string.regex
;string.escape
;string.special
;character
;number
[
(lookup_digit)
(integer_literal)
]
@number
;boolean
;float
 [
 (decimal_literal)
 (double_literal)
 ] @float

;FUNCTIONS
;function
;(function_declaration
; name: (identifier) @function)
;(arrow_function_call
;   (identifier) @function)
;(annotation 
;  name: (identifier) @function.annotation)
;function.builtin
;function.macro
;parameter
;  (param 
;    name: (identifier) @parameter)

;method
;field



; CONSTRUCTORS
(computed_constructor
  constructor: (keyword) @constructor)
(curly_array_constructor
  constructor: (keyword) @constructor)
(map_constructor
  constructor: (keyword) @constructor)
(square_array_constructor
  ["["  "]"] @constructor )
(string_constructor
  ["``["  "]``"] @constructor )
(interpolation
  ["`{"  "}`"] @constructor )


;conditional
[ 
"case"
"else" 
"every" 
"if" 
"some" 
"switch" 
"then" 
"typeswitch" 
"where" 
] @conditional
;repeat
[ "for" ] @repeat

;label for C/Lua-like labels
;operator (for symbolic operators, e.g. `+`, `*`)
[ 
"!" 
"=>"
"?"
"="
"%"
":="
] @operator

(comparison_expr
   comparison: (_) @operator)
 

;include for including modules

["import" "external"] @include

[ 
"allowing"
"ascending"
"by"
"collation"
"context"
"count"
"declare"
"default" 
"descending"
"descending"
"empty"
"empty"
"encoding"
"function"
"greatest"
"group"
"item"
"least"
"module"
"namespace" 
"option" 
"order"
"return" 
"schema"
"stable"
"variable"
"version"
"where"
"xquery" 
"ordered"
"unordered"
] @keyword

;keyword.operator (for operators that are English words, e.g. `and`, `or`)
[ 
  "as" 
  "at"
  "cast" 
  "castable"
  "in" 
  "instance" 
  "of"  
  "satisfies" 
  "treat" 
  ] @keyword.operator

;keyword.function
;exception 
[ "try" "catch" ] @exception

; NAMESPACES VARIABLES
(var_ref
  "$" @variable)
 
(NCName) @namespace

(EQName
 prefix: (identifier) @namespace
 [":"] @punctuation.delimiter
 local_part: (identifier) @variable)

(EQName
 ns_builtin: (identifier) @namespace
 [":"] @operator
 local_part: (identifier) @variable)

(EQName
 unprefixed: (identifier) @variable)

(EQName
 unprefixed: (identifier) @variable)

(function_call
  function_name: (EQName
    unprefixed: (identifier) @function))

; XPATH EXPRESSIONS

(context_item_expr) @property

(path_expr
  (next_step
    [
     path: (operator) @field
     node_name_test: (_) @property
     step: (_
             [ 
              axis: (keyword) @field
              "::" @punctuation.delimiter
              type: (keyword) @type
              node_name_test: (_) @property
              ]
            )
     ]))



; TYPE TESTS
(sequence_type
  [
   type: (keyword) @type
   (_
     [
      type: (keyword) @type
      param: (wildcard) @type
      param: (occurrence_indicator) @type
      ])
   ]
  )



(occurrence_indicator) @type
;comment
(comment) @comment
;; Error
(ERROR) @error
