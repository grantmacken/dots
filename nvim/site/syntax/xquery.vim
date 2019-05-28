"VIM Syntax file
" 
" Language:    XQuery 3.1
" Maintainer:  Grant MacKenzie
" Last Change: 
" Based on fork of https://github.com/james-jw/vim-xquery-syntax
" which is based on fork of https://github.com/jeroenp/vim-xquery-syntax
" 
if exists("b:current_syntax")
   finish
endif

let b:current_syntax = "xquery"

"------------------------------------------------------------------------------------------
"              NEW STUFF                                                                   
"------------------------------------------------------------------------------------------
syn match xqXpathFunctions          /(QName\|abs\|adjust-date-to-timezone\|adjust-dateTime-to-timezone\|adjust-time-to-timezone\|analyze-string\|apply\|available-environment-variables\|avg\|base-uri\|boolean\|ceiling\|codepoint-equal\|codepoints-to-string\|collection\|compare\|concat\|contains\|count\|current-date\|current-dateTime\|current-time\|data\|dateTime\|day-from-date\|day-from-dateTime\|days-from-duration\|deep-equal\|default-collation\|distinct-values\|doc\|doc-available\|document-uri\|empty\|encode-for-uri\|ends-with\|environment-variable\|equals\|error\|escape-html-uri\|escape-uri\|exactly-one\|exists\|false\|filter\|floor\|fold-left\|fold-right\|for-each\|for-each-pair\|format-date\|format-dateTime\|format-number\|format-time\|function-arity\|function-lookup\|function-name\|generate-id\|head\|hours-from-dateTime\|hours-from-duration\|hours-from-time\|id\|idref\|implicit-timezone\|in-scope-prefixes\|index-of\|insert-before\|iri-to-uri\|json-doc\|lang\|last\|local-name\|local-name-from-QName\|lower-case\|map\|map-pairs\|matches\|max\|min\|minutes-from-dateTime\|minutes-from-duration\|minutes-from-time\|month-from-date\|month-from-dateTime\|months-from-duration\|name\|namespace-uri\|namespace-uri-for-prefix\|namespace-uri-from-QName\|nilled\|node-name\|normalize-space\|normalize-unicode\|not\|number\|one-or-more\|parse-json\|parse-xml\|parse-xml-fragment\|position\|prefix-from-QName\|remove\|replace\|resolve-QName\|resolve-uri\|reverse\|root\|round\|round-half-to-even\|seconds-from-dateTime\|seconds-from-duration\|seconds-from-time\|serialize\|starts-with\|static-base-uri\|string\|string-join\|string-length\|string-to-codepoints\|subsequence\|substring\|substring-after\|substring-before\|sum\|tail\|timezone-from-date\|timezone-from-dateTime\|timezone-from-time\|tokenize\|trace\|translate\|true\|unordered\|upper-case\|year-from-date\|year-from-dateTime\|years-from-duration\|zero-or-one)/
syn match xqXpathFunctionsMath      /(acos\|asin\|atan\|atan2\|cos\|exp\|exp10\|log\|log10\|pi\|pow\|sin\|sqrt\|tan)/
syn match xqTransformFunctions    /transform:( current\|document\|format-date\|format-dateTime\|format-number\|format-time\|generate-id\|key\|system-property\|unparsed-entity-public-id\|unparsed-entity-uri\|unparsed-text\|unparsed-text-available)/
syn match xqExistCompression /compression:(gzip\|tar\|ungzip\|untar\|unzip\|zip)/
syn match xqExistContentextraction /contentextraction:(get-metadata\|get-metadata-and-content\|stream-content)/
syn match xqExistCounter /counter:(create\|destroy\|next-value)/
syn match xqExistDatetime /datetime:(count-day-in-month\|date-for\|date-from-dateTime\|date-range\|datetime-range\|day-in-week\|days-in-month\|format-date\|format-dateTime\|format-time\|parse-date\|parse-dateTime\|parse-time\|time-from-dateTime\|time-range\|timestamp\|timestamp-to-datetime\|week-in-month)/
syn match xqExistExamples /examples:(echo)/
syn match xqExistFile /file:(delete\|directory-list\|exists\|is-directory\|is-readable\|is-writeable\|list\|mkdir\|mkdirs\|move\|read\|read-binary\|read-unicode\|serialize\|serialize-binary\|sync)/
syn match xqExistHttpclient /httpclient:(clear-all\|delete\|get\|head\|options\|post\|post-form\|put\|set-parser-options)/
syn match xqExistImage /image:(crop\|get-height\|get-metadata\|get-width\|scale\|thumbnail)/
syn match xqExistInspection /inspection:(inspect-function\|inspect-module\|inspect-module-uri\|module-functions\|module-functions-by-uri)/
syn match xqExistLucene /lucene:(close\|get-field\|has-index\|index\|optimize\|query\|query-field\|remove-index\|score\|search)/
syn match xqExistMail /mail:(close-mail-folder\|close-mail-store\|close-message-list\|get-mail-folder\|get-mail-session\|get-mail-store\|get-message-list\|get-message-list-as-xml\|get-messages\|search-message-list\|send-email)/
syn match xqExistMath /math:(abs\|acos\|asin\|atan\|atan2\|ceil\|cos\|degrees\|e\|exp\|floor\|log\|pi\|power\|radians\|random\|round\|sin\|sqrt\|tan)/
syn match xqExistNgram /ngram:(add-match\|contains\|ends-with\|filter-matches\|starts-with\|wildcard-contains)/
syn match xqExistProcess /process:(execute)/
syn match xqExistRange /range:(contains\|ends-with\|eq\|field\|field-contains\|field-ends-with\|field-eq\|field-ge\|field-gt\|field-le\|field-lt\|field-matches\|field-ne\|field-starts-with\|ge\|gt\|index-keys-for-field\|le\|lt\|matches\|ne\|optimize\|starts-with)/
syn match xqExistRepo /repo:(deploy\|get-resource\|get-root\|install\|install-and-deploy\|install-and-deploy-from-db\|install-from-db\|list\|remove\|undeploy)/
syn match xqExistRequest /request:(attribute-names\|exists\|get-attribute\|get-context-path\|get-cookie-names\|get-cookie-value\|get-data\|get-effective-uri\|get-header\|get-header-names\|get-hostname\|get-method\|get-parameter\|get-parameter-names\|get-path-info\|get-query-string\|get-remote-addr\|get-remote-host\|get-remote-port\|get-scheme\|get-server-name\|get-server-port\|get-servlet-path\|get-uploaded-file-data\|get-uploaded-file-name\|get-uploaded-file-size\|get-uri\|get-url\|is-multipart-content\|set-attribute)/
syn match xqExistResponse /response:(exists\|redirect-to\|set-cookie\|set-date-header\|set-header\|set-status-code\|stream\|stream-binary)/
syn match xqExistScheduler /scheduler:(delete-scheduled-job\|get-scheduled-jobs\|pause-scheduled-job\|resume-scheduled-job\|schedule-java-cron-job\|schedule-java-periodic-job\|schedule-xquery-cron-job\|schedule-xquery-periodic-job)/
syn match xqExistSecuritymanager /securitymanager:(add-group-ace\|add-group-manager\|add-group-member\|add-user-ace\|chgrp\|chmod\|chown\|clear-acl\|create-account\|create-group\|delete-group\|find-groups-by-groupname\|find-groups-where-groupname-contains\|find-users-by-name\|find-users-by-name-part\|find-users-by-username\|get-account-metadata\|get-account-metadata-keys\|get-group-managers\|get-group-members\|get-group-metadata\|get-group-metadata-keys\|get-groups\|get-permissions\|get-umask\|get-user-groups\|get-user-primary-group\|group-exists\|has-access\|id\|insert-group-ace\|insert-user-ace\|is-account-enabled\|is-authenticated\|is-dba\|is-externally-authenticated\|list-groups\|list-users\|mode-to-octal\|modify-ace\|octal-to-mode\|passwd\|passwd-hash\|remove-account\|remove-ace\|remove-group\|remove-group-manager\|remove-group-member\|set-account-enabled\|set-account-metadata\|set-group-metadata\|set-umask\|set-user-primary-group\|user-exists)/
syn match xqExistSession /session:(clear\|create\|encode-url\|exists\|get-attribute\|get-attribute-names\|get-creation-time\|get-id\|get-last-accessed-time\|get-max-inactive-interval\|invalidate\|remove-attribute\|set-attribute\|set-current-user\|set-max-inactive-interval)/
syn match xqExistSort /sort:(create-index\|create-index-callback\|has-index\|index\|remove-index)/
syn match xqExistSql /sql:(execute\|get-connection\|get-jndi-connection\|prepare)/
syn match xqExistSystem /system:(as-user\|clear-trace\|clear-xquery-cache\|count-instances-active\|count-instances-available\|count-instances-max\|enable-tracing\|export\|export-silently\|function-available\|get-build\|get-exist-home\|get-index-statistics\|get-memory-free\|get-memory-max\|get-memory-total\|get-module-load-path\|get-revision\|get-running-jobs\|get-running-xqueries\|get-scheduled-jobs\|get-uptime\|get-version\|import\|import-silently\|kill-running-xquery\|restore\|shutdown\|trace\|tracing-enabled\|trigger-system-task\|update-statistics)/
syn match xqExistTransform /transform:(stream-transform\|transform)/
syn match xqExistUtil /util:(absolute-resource-id\|base-to-integer\|base64-decode\|base64-encode\|binary-doc\|binary-doc-available\|binary-to-string\|call\|catch\|collations\|collection-name\|compile\|compile-query\|declare-namespace\|declare-option\|declared-variables\|deep-copy\|describe-function\|disable-profiling\|doctype\|document-id\|document-name\|enable-profiling\|eval\|eval-async\|eval-inline\|eval-with-context\|exclusive-lock\|expand\|function\|get-fragment-between\|get-module-description\|get-module-info\|get-option\|get-resource-by-absolute-id\|get-sequence-type\|hash\|import-module\|index-key-documents\|index-key-occurrences\|index-keys\|index-keys-by-qname\|index-type\|inspect-function\|int-to-octal\|integer-to-base\|is-binary-doc\|is-module-mapped\|is-module-registered\|list-functions\|log\|log-app\|log-system-err\|log-system-out\|map-module\|mapped-modules\|node-by-id\|node-id\|node-xpath\|octal-to-int\|parse\|parse-html\|qname-index-lookup\|random\|random-ulong\|registered-functions\|registered-modules\|serialize\|shared-lock\|string-to-binary\|system-date\|system-dateTime\|system-property\|system-time\|unescape-uri\|unmap-module\|uuid\|wait)/
syn match xqExistValidation /validation:(clear-grammar-cache\|jaxp\|jaxp-parse\|jaxp-report\|jaxv\|jaxv-report\|jing\|jing-report\|pre-parse-grammar\|show-grammar-cache\|validate\|validate-report)/
syn match xqExistXmldb /xmldb:(add-user-to-group\|authenticate\|change-user\|chmod-collection\|chmod-resource\|clear-lock\|collection-available\|copy\|create-collection\|create-group\|create-user\|created\|decode\|decode-uri\|defragment\|delete-user\|document\|document-has-lock\|encode\|encode-uri\|exists-user\|find-last-modified-since\|get-child-collections\|get-child-resources\|get-current-user\|get-current-user-attribute\|get-current-user-attribute-names\|get-group\|get-mime-type\|get-owner\|get-permissions\|get-user-groups\|get-user-home\|get-user-primary-group\|get-users\|group-exists\|is-admin-user\|is-authenticated\|last-modified\|login\|match-collection\|move\|permissions-to-string\|register-database\|reindex\|remove\|remove-user-from-group\|rename\|set-collection-permissions\|set-mime-type\|set-resource-permissions\|size\|store\|store-files-from-pattern\|string-to-permissions\|touch\|update\|xcollection)/
syn match xqExistXmldiff /xmldiff:(compare)/
syn match xqExistXqdoc /xqdoc:(scan)/
syn match xqExistXslfo /xslfo:(render)/
syn match xqExpathClient /client:(send-request)/
syn match xqExpathZip /zip:(binary-entry\|entries\|html-entry\|text-entry\|update\|xml-entry)/
syn match xqExqueryRequest /request:(address\|cookie\|header\|header-names\|hostname\|method\|parameter\|parameter-names\|path\|port\|query\|remote-address\|remote-hostname\|remote-port\|scheme\|uri)/
syn match xqExqueryRestxq /restxq:(base-uri\|resource-functions\|uri)/
syn match xqExqueryExist /exist:(deregister-module\|deregister-resource-function\|find-resource-functions\|register-module\|register-resource-function)/


"-----------------
" PredefinedEntity
"
" &amp;
" ^^^^^
"-----------------

syn match  xqPredefinedEntityRef /&\(lt\|gt\|amp\|quot\|apos\);/

hi def link xqPredefinedEntityRef           Special


"-----------------
" DEFAULT STATE
"-----------------

"-----------------
" xquery version '3.1'
" ^^^^^^^^^^^^^^  ^^^
"-------------------

syn region  xqVersionDec  start=/xquery version/ end=/;/  contains=xqStringLiteral
syn region xqStringLiteral start=/\z(['"]\)/ skip=/\\z1/ end=/\z1/ contained contains=xqVersionNumber

syn match   xqVersionNumber /3\.1/
syn match   xqSeparator /;/

hi def link xqVersionDec     PreProc
hi def link xqVersionNumber  Number
hi def link xqStringLiteral  StringDelimiter
hi def link xqSeparator      Delimiter

"------------------------------------------------------------------------------------------
"              COPY OVER OLD FILE                                                          
"------------------------------------------------------------------------------------------

syn match   xqyQName            /\k\+\(:\k\+\)\?/ contained contains=NONE transparent
"syn region  xqyBlock            start=/{/ end=/}/ contains=ALLBUT,@xqyPrologStatements

syn region  xqyString           start=/\z(['"]\)/ skip=/\\z1/ end=/\z1/ keepend
"syn region  xqyAttrString       start=/\z(['"]\)/ skip=/\\z1/ end=/\z1/ contained contains=xqyBlock
syn region  xqyStartTag         start=#<\([= \/]\)\@!# end=#># contains=xqyAttrString
syn region  xqyEndTag           start=#</# end=#># contains=xqyQName

" syn region  jsonProp          start=/\z(['"]\)/ skip=/\\z1/ end=/\z1[:]/ contained 
syn match   jsonProp            /["']\(\w\|[@_:-]\)*["']:/

syn keyword xqyPrologKeyword    module namespace import at external
syn keyword xqyDecl             declare nextgroup=xqyOption,xqyContext,xqyDeclFun,xqyDeclVar,xqyDeclCons skipwhite
syn keyword xqyDeclCons         construction nextgroup=xqyDeclConsOpt skipwhite
syn keyword xqyDeclConsOpt      strip preserve
syn keyword xqyDeclVar          variable nextgroup=xqyVariable external skipwhite
syn keyword xqyContext          context item skipwhite
syn keyword xqyOption           option skipwhite
syn keyword xqyDeclFun          function nextgroup=xqyFunction skipwhite
syn match   xqyNamespace        /\(\w\|[-_]\)*:/ 

syn match   xqyVariable         /$\k\+/
syn match   xqyAnnotation       /%\k\+\(:\k\+\)\?/
syn match   xqyFunction         /\k\+\(:\k\+\)\?()/ " FIXME 
syn keyword xqyTypeSigKeyword   as xs nextgroup=xqyType skipwhite
syn match   xqyType             /\k+\(:\k\+\)\?/ contained
syn cluster xqyPrologStatements contains=xqyPrologKeyword,xqyDecl,xqyDeclVar,xyDeclFun,xqyDeclCons,xqyDeclConsOpt

syn keyword xqyFLWOR            for in let where group by order by at count return
syn keyword xqyUpdate           modify copy delete rename insert node nodes into last first before after
syn keyword xqyWindow           tumbling sliding window start when end only

syn keyword xqyConstructor      attribute
syn match   xqyConstructor      /\(element\|comment\|processing-instruction\)\ze\s/

syn keyword xqyConditional      if then else every some
syn keyword xqyConditional      or 
syn keyword xqyConditional      typeswitch 
syn keyword xqyConditional      switch case default
syn keyword xqyConditional      try catch
syn keyword xqyConditional      text not in ftor ftand ftnot any all ordered distance most words same sentence without occurs
syn keyword xqyConditional      using case sensitive diacritics using stemming language stop wildcards score fuzzy thesaurus
syn match   xqyConditional      /contains/
syn keyword xqyMapArrayType     map array

syn match   xqyMap              /\s!\s\|=>/

syn keyword xqyTodo             TODO XXX FIXME contained
syn match   xqyDocKeyword       display /@\(version\|since\|deprecated\|error\|return\|param\|author\|see\)/ contained nextgroup=xqyVariable skipwhite
syn region  xqyDocComment       start="(:\~" end=":)" contains=xqyTodo,xqyDocKeyword,xqyVariable,xqyComment,xqyDocComment,@Spell fold
syn region  xqyComment          start="(\:\(\~\)\@!" end="\:)" contains=xqyTodo,xqyComment,xqyDocComment,@Spell fold
"------------------------------------------------------------------------------------------
"              NEW HiLight STUFF                                                           
"------------------------------------------------------------------------------------------

hi def link xqXpathFunctions        Function
hi def link xqXpathFunctionsMath    Function
hi def link xqTransformFunctions    Function

hi def link  xqExistCompression   Function
hi def link  xqExistContentextraction   Function
hi def link  xqExistCounter   Function
hi def link  xqExistDatetime   Function
hi def link  xqExistExamples   Function
hi def link  xqExistFile   Function
hi def link  xqExistHttpclient   Function
hi def link  xqExistImage   Function
hi def link  xqExistInspection   Function
hi def link  xqExistLucene   Function
hi def link  xqExistMail   Function
hi def link  xqExistMath   Function
hi def link  xqExistNgram   Function
hi def link  xqExistProcess   Function
hi def link  xqExistRange   Function
hi def link  xqExistRepo   Function
hi def link  xqExistRequest   Function
hi def link  xqExistResponse   Function
hi def link  xqExistScheduler   Function
hi def link  xqExistSecuritymanager   Function
hi def link  xqExistSession   Function
hi def link  xqExistSort   Function
hi def link  xqExistSql   Function
hi def link  xqExistSystem   Function
hi def link  xqExistTransform   Function
hi def link  xqExistUtil   Function
hi def link  xqExistValidation   Function
hi def link  xqExistXmldb   Function
hi def link  xqExistXmldiff   Function
hi def link  xqExistXqdoc   Function
hi def link  xqExistXslfo   Function
hi def link  xqExpathClient   Function
hi def link  xqExpathZip   Function
hi def link  xqExqueryRequest   Function
hi def link  xqExqueryRestxq   Function
hi def link  xqExqueryExist   Function


"------------------------------------------------------------------------------------------
"              COPY OF old HiLight STUFF                                                  
"------------------------------------------------------------------------------------------
hi def link xqyString           String
hi def link xqyAttrString       String
hi def link xqyStartTag         Question
hi def link jsonProp            Question
hi def link xqyEndTag           Special
hi def link xqyNamespace        Special

hi def link xqyMapArray         Comment
hi def link xqyComment          Comment
hi def link xqyDocComment       Comment
hi def link xqyDocKeyword       SpecialComment
hi def link xqyTodo             Todo

hi def link xqyDecl             Define
hi def link xqyDeclCons         Define
hi def link xqyDeclConsOpt      Define
hi def link xqyDeclFun          Define
hi def link xqyDeclVar          Define
hi def link xqyContext          Define
hi def link xqyOption           Define
hi def link xqyPrologKeyword    PreProc
hi def link xqyTypeSigKeyword   PreProc
hi def link xqyVariableExt      PreProc
hi def link xqyMapArrayType     PreProc

hi def link xqyFLWOR            Keyword
hi def link xqyUpdate           Keyword
hi def link xqyWindow           Keyword
hi def link xqyConstructor      Keyword
hi def link xqyConditional      Conditional

hi def link xqyVariable         Identifier
hi def link xqyAnnotation       Identifier
hi def link xqyMap              Identifier
hi def link xqyType             Type
