%option yylineno

%{

#include <string.h>
#include "syntax.tab.h"
#include "common.h"

extern bool out;

//#define LEX_DEBUG
void debug(char *msg) {
#ifdef LEX_DEBUG
    if(strcmp(msg, "annotation") == 0)
        printf("%d: annotation\n", yylineno);
    else
        printf("%d: %s: %s\n", yylineno, msg, yytext);
#endif

}

%}

TYPE        int|float
STRUCT      struct
RETURN      return
IF          if
ELSE        else
WHILE       while

delim       [ \n\t\f\r\v]
ws          {delim}+
digit       [0-9]
digit_8     [0-7]
digit_16    [0-9A-Fa-f]
oct         0{digit_8}+
hex         0[Xx]{digit_16}+
dec         [1-9]{digit}*|0

flo         ({digit}*\.{digit}+)|({digit}+\.{digit}*)
exp         ({flo})[Ee][+\-]?{digit}+

INT         {oct}|{dec}|{hex}
FLOAT       {flo}|{exp}

letter      [_a-zA-Z]

single      \/\/[^\n]*\n
multi       \/\*[^*]*\*+([^*/][^*]*\*+)*\/
anno        {single}|{multi}
leftNoStar  \/\*[^*]*
leftStar    \/\*[^*]*\*+([^*/][^*]*\*+)*([^*/][^*]*)
left        {leftNoStar}|{leftStar}
right       \*\/

ID          {letter}({letter}|{digit})*
SEMI        ;
COMMA       ,
ASSIGNOP    =
RELOP       >|<|>=|<=|==|!=
PLUS        \+
MINUS       -
STAR        \*
DIV         \/
AND         &&
OR          \|\|
DOT         \.
NOT         !
LP          \(
RP          \)
LB          \[
RB          \]
LC          \{
RC          \}

exphd       {dec}|{flo}
wrflo       ({exphd}[Ee]{flo})|({exphd}[Ee][^ \n\t;]*)|([Ee]{flo})
wroct       0{digit_8}*[89]+{digit_8}*
wrhex       0[Xx]{digit_16}*[g-zG-Z]+{digit_16}*
%%

{ws}        { /* take no action */ }

{TYPE}      { debug("TYPE");
              struct ast *leaf = yylval.type_ast = newAst(TAG_TYPE, 0, yylineno);
              strcpy(leaf->u.str, yytext);
              return TYPE;
            }

{STRUCT}    { debug("STRUCT");  yylval.type_ast = newAst(TAG_STRUCT, 0, yylineno);     return STRUCT; }
{IF}        { debug("IF");      yylval.type_ast = newAst(TAG_IF, 0, yylineno);         return IF; }
{ELSE}      { debug("ELSE");    yylval.type_ast = newAst(TAG_ELSE, 0, yylineno);       return ELSE; }
{WHILE}     { debug("WHILE");   yylval.type_ast = newAst(TAG_WHILE, 0, yylineno);      return WHILE; }
{RETURN}    { debug("RETURN");  yylval.type_ast = newAst(TAG_RETURN, 0, yylineno);     return RETURN; }


{INT}       { debug("INT");
              struct ast *leaf = yylval.type_ast = newAst(TAG_INT, 0, yylineno);
              if (yytext[0] == '0' && (yytext[1] == 'x' || yytext[1] == 'X'))
                  sscanf(yytext, "%x", &leaf->u.ival);
              else if (yytext[0] == '0')
                  sscanf(yytext, "%o", &leaf->u.ival);
              else
                  sscanf(yytext, "%d", &leaf->u.ival);
              return INT;
            }

{FLOAT}     { debug("FLOAT");
              struct ast *leaf = yylval.type_ast = newAst(TAG_FLOAT, 0, yylineno);
              leaf->u.fval = atof(yytext);
              return FLOAT;
            }

{ID}        { debug("ID");
              struct ast *leaf = yylval.type_ast = newAst(TAG_ID, 0, yylineno);
              strcpy(leaf->u.str, yytext);
              return ID; }


{SEMI}      { debug("SEMI");    yylval.type_ast = newAst(TAG_SEMI, 0, yylineno);       return SEMI; }
{COMMA}     { debug("COMMA");   yylval.type_ast = newAst(TAG_COMMA, 0, yylineno);      return COMMA; }
{ASSIGNOP}  { debug("ASSIGNOP");yylval.type_ast = newAst(TAG_ASSIGNOP, 0, yylineno);   return ASSIGNOP; }
{RELOP}     { debug("RELOP");   yylval.type_ast = newAst(TAG_RELOP, 0, yylineno);      return RELOP; }
{PLUS}      { debug("PLUS");    yylval.type_ast = newAst(TAG_PLUS, 0, yylineno);       return PLUS; }
{MINUS}     { debug("MINUS");   yylval.type_ast = newAst(TAG_MINUS, 0, yylineno);      return MINUS; }
{STAR}      { debug("STAR");    yylval.type_ast = newAst(TAG_STAR, 0, yylineno);       return STAR; }
{DIV}       { debug("DIV");     yylval.type_ast = newAst(TAG_DIV, 0, yylineno);        return DIV; }
{AND}       { debug("AND");     yylval.type_ast = newAst(TAG_AND, 0, yylineno);        return AND; }
{OR}        { debug("OR");      yylval.type_ast = newAst(TAG_OR, 0, yylineno);         return OR; }
{DOT}       { debug("DOT");     yylval.type_ast = newAst(TAG_DOT, 0, yylineno);        return DOT; }
{NOT}       { debug("NOT");     yylval.type_ast = newAst(TAG_NOT, 0, yylineno);        return NOT; }
{LP}        { debug("LP");      yylval.type_ast = newAst(TAG_LP, 0, yylineno);         return LP; }
{RP}        { debug("RP");      yylval.type_ast = newAst(TAG_RP, 0, yylineno);         return RP; }
{LB}        { debug("LB");      yylval.type_ast = newAst(TAG_LB, 0, yylineno);         return LB; }
{RB}        { debug("RB");      yylval.type_ast = newAst(TAG_RB, 0, yylineno);         return RB; }
{LC}        { debug("LC");      yylval.type_ast = newAst(TAG_LC, 0, yylineno);         return LC; }
{RC}        { debug("RC");      yylval.type_ast = newAst(TAG_RC, 0, yylineno);         return RC; }

{anno}      { debug("annotation"); }
{wrflo}     { printf("Error type \033[31mA\033[0m at line \033[31m%d\033[0m: Illegal float number \'%s\'\n", yylineno, yytext); out = false; }
{wroct}     { printf("Error type \033[31mA\033[0m at line \033[31m%d\033[0m: Illegal octal number \'%s\'\n", yylineno, yytext); out = false;  }
{wrhex}     { printf("Error type \033[31mA\033[0m at line \033[31m%d\033[0m: Illegal hexadecimal number \'%s\'\n", yylineno, yytext); out = false;  }
{left}      { printf("Error type \033[31mA\033[0m at Line \033[31m%d\033[0m: unterminated annotaion \'%s\'", yylineno, yytext); out = false; }
{right}     { printf("Error type \033[31mA\033[0m at Line \033[31m%d\033[0m: alone end of multiline annotation \'%s\'\n", yylineno, yytext); out = false; }
.           { printf("Error type \033[31mA\033[0m at Line \033[31m%d\033[0m: Myterious characters \'%s\'\n", yylineno, yytext); out = false; }

%%
