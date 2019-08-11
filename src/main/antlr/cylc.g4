/**
 * Cylc parsec grammar.
 * Some rules were adapted from the Python3 grammar created by Bart Kiers (thanks).
 */

grammar cylc;

file: (ini)+
    ;

ini : sections (sections | option)*
    ;

sections : section;

section: SECTION_TEXT;

option : TEXT '=' STRING
       ;

COMMENT : '#'  ~[\r\n]* -> skip ;
WS      : [ \t\n\r]+ -> skip ;

LBRACKETS: L_SQUARE_BRACKET+;
L_SQUARE_BRACKET: '[';
RBRACKETS: R_SQUARE_BACKET+;
R_SQUARE_BACKET: ']';

TEXT: [a-zA-Z0-9_ ]+;

SECTION_TEXT: LBRACKETS TEXT RBRACKETS;

STRING
 : ( SHORT_STRING | LONG_STRING )
 ;

SECTION
    :  L_SQUARE_BRACKET* TEXT R_SQUARE_BACKET*
    ;

NEWLINE
 : ( '\r'? '\n' | '\r' | '\f' ) SPACES?
 ;

/*
 * Fragments. These will not be tokens.
 */

/// shortstring     ::=  "'" shortstringitem* "'" | '"' shortstringitem* '"'
/// shortstringitem ::=  shortstringchar | stringescapeseq
/// shortstringchar ::=  <any source character except "\" or newline or the quote>
fragment SHORT_STRING
 : '\'' ( STRING_ESCAPE_SEQ | ~[\\\r\n\f'] )* '\''
 | '"' ( STRING_ESCAPE_SEQ | ~[\\\r\n\f"] )* '"'
 ;
/// longstring      ::=  "'''" longstringitem* "'''" | '"""' longstringitem* '"""'
fragment LONG_STRING
 : '\'\'\'' LONG_STRING_ITEM*? '\'\'\''
 | '"""' LONG_STRING_ITEM*? '"""'
 ;

/// longstringitem  ::=  longstringchar | stringescapeseq
fragment LONG_STRING_ITEM
 : LONG_STRING_CHAR
 | STRING_ESCAPE_SEQ
 ;

/// longstringchar  ::=  <any source character except "\">
fragment LONG_STRING_CHAR
 : ~'\\'
 ;

/// stringescapeseq ::=  "\" <any source character>
fragment STRING_ESCAPE_SEQ
 : '\\' .
 | '\\' NEWLINE
 ;

fragment SPACES
 : [ \t]+
 ;

fragment LINE_JOINING
 : '\\' SPACES? ( '\r'? '\n' | '\r' | '\f')
 ;
