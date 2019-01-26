%{

#include "ast.h"
#include "common.h"
#include "lex.yy.c"

extern int yylex();
void yyerror(const char *msg);
extern int yylineno;
extern bool out;

%}

%union {
    struct ast* type_ast;
    double type_double;
}

/* Tokens */
%token <type_ast> INT FLOAT ID SEMI COMMA
%token <type_ast> ASSIGNOP RELOP PLUS MINUS STAR DIV AND OR NOT
%token <type_ast> DOT TYPE LP RP LB RB LC RC STRUCT RETURN IF ELSE WHILE error

/* High-Level Definitions */
%type <type_ast> Program ExtDefList ExtDef ExtDecList
/* Specifiers */
%type <type_ast> Specifier StructSpecifier OptTag Tag
/* Declarators */
%type <type_ast> VarDec FunDec VarList ParamDec
/* Statements */
%type <type_ast> CompSt StmtList Stmt
/* Loacal Definitions */
%type <type_ast> DefList Def DecList Dec
/* Expressions */
%type <type_ast> Exp Args

/* Priority */
%right ASSIGNOP
%left AND OR
%left RELOP
%left PLUS MINUS
%left STAR DIV
%right NOT
%left LP RP LB RB DOT

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

/* High-lever Definitions */
Program: ExtDefList                             { $$ = astRoot = newAst(TAG_PROGRAM, 1, $1); }
    ;

ExtDefList: ExtDef ExtDefList                   { $$ = newAst(TAG_EXT_DEF_LIST, 2, $1, $2); }
/*  | ExtDef error                              { $$ = newAst(TAG_ERROR, 2, $1, $2); $$->error_type = 9; reportError($$->error_type, yylineno); out = false; }*/
    | /* empty */                               { $$ = newAst(TAG_EMPTY, 0); }
    ;

ExtDef: Specifier ExtDecList SEMI               { $$ = newAst(TAG_EXT_DEF, 3, $1, $2, $3); $$->attr = DEC_LIST; }
    | Specifier SEMI                            { $$ = newAst(TAG_EXT_DEF, 2, $1, $2); $$->attr = VOID_DEC; }
    | Specifier FunDec CompSt                   { $$ = newAst(TAG_EXT_DEF, 3, $1, $2, $3); $$->attr = FUNC_DEF; }
    | Specifier FunDec SEMI                     { $$ = newAst(TAG_EXT_DEF, 3, $1, $2, $3); $$->attr = FUNC_DEC; }
/*  | Specifier FunDec error                    { $$ = newAst(TAG_ERROR, 3, $1, $2, $3); $$->error_type = 5; reportError($$, yylineno); out = false; }*/
    | Specifier ExtDecList error                { $$ = newAst(TAG_ERROR, 3, $1, $2, $3); $$->error_type = 8; /*reportError($$, yylineno);*/ out = false; }
    | error SEMI                                { $$ = newAst(TAG_ERROR, 2, $1, $2); $$->error_type = 10; /*reportError($$, yylineno);*/ out = false; }
    ;

ExtDecList: VarDec                              { $$ = newAst(TAG_EXT_DEC_LIST, 1, $1); }
    | VarDec COMMA ExtDecList                   { $$ = newAst(TAG_EXT_DEC_LIST, 3, $1, $2, $3); }
    ;

/* Specifiers */
Specifier: TYPE                                 { $$ = newAst(TAG_SPEC, 1, $1); $$->attr = BUILT_IN; }
    | StructSpecifier                           { $$ = newAst(TAG_SPEC, 1, $1); $$->attr = TYPE_STRUCT; }
    ;

StructSpecifier: STRUCT OptTag LC DefList RC    { $$ = newAst(TAG_STRUCT_SPEC, 5, $1, $2, $3, $4, $5); $$->attr = STRUCT_DEC; }
    | STRUCT Tag                                { $$ = newAst(TAG_STRUCT_SPEC, 2, $1, $2); $$->attr = STRUCT_REF; }
    ;

OptTag: ID                                      { $$ = newAst(TAG_OPT_TAG, 1, $1); }
    | /*empty*/                                 { $$ = newAst(TAG_EMPTY, 0); }
    ;

Tag: ID                                         { $$ = newAst(TAG_TAG, 1, $1); }
    ;

/* Declarators */
VarDec: ID                                      { $$ = newAst(TAG_VAR_DEC, 1, $1); $$->attr = VAR_DEF; }
    | VarDec LB INT RB                          { $$ = newAst(TAG_VAR_DEC, 4, $1, $2, $3, $4); $$->attr = ARRAY_DEF; }
    ;

FunDec: ID LP VarList RP                        { $$ = newAst(TAG_FUN_DEC, 4, $1, $2, $3, $4); }
    | ID LP RP                                  { $$ = newAst(TAG_FUN_DEC, 3, $1, $2, $3); }
    ;

VarList: ParamDec COMMA VarList                 { $$ = newAst(TAG_VAR_LIST, 3, $1, $2, $3); }
    | ParamDec                                  { $$ = newAst(TAG_VAR_LIST, 1, $1); }
    ;

ParamDec: Specifier VarDec                      { $$ = newAst(TAG_PARAM_DEC, 2, $1, $2); $$->attr = VAR_DEF; }
    ;

/* Statements */
CompSt: LC DefList StmtList RC                  { $$ = newAst(TAG_COMP_ST, 4, $1, $2, $3, $4); }
    | LC DefList StmtList error                 { $$ = newAst(TAG_ERROR, 4, $1, $2, $3, $4); $$->error_type = 7; /*reportError($$, yylineno);*/ out = false; }
    ;

StmtList: Stmt StmtList                         { $$ = newAst(TAG_STMT_LIST, 2, $1, $2); }
/*  | Stmt error                                { $$ = newAst(TAG_ERROR, 2, $1, $2); $$->error_type = 122; reportError($$, yylineno); out = false; }*/
    | /* empty */                               { $$ = newAst(TAG_EMPTY, 0); }
    ;

Stmt: Exp SEMI                                  { $$ = newAst(TAG_STMT, 2, $1, $2); }
    | CompSt                                    { $$ = newAst(TAG_STMT, 1, $1); }
    | RETURN Exp SEMI                           { $$ = newAst(TAG_STMT, 3, $1, $2, $3); }
    | IF LP Exp RP Stmt %prec LOWER_THAN_ELSE	{ $$ = newAst(TAG_STMT, 5, $1, $2, $3, $4, $5); }
    | IF LP Exp RP Stmt ELSE Stmt               { $$ = newAst(TAG_STMT, 7, $1, $2, $3, $4, $5, $6, $7); }
    | WHILE LP Exp RP Stmt                      { $$ = newAst(TAG_STMT, 5, $1, $2, $3, $4, $5); }
/*  | Exp error                                 { $$ = newAst(TAG_ERROR, 2, $1, $2); $$->error_type = 111; reportError($$, yylineno); out = false; } */
    | error SEMI                                { $$ = newAst(TAG_ERROR, 2, $1, $2); $$->error_type = 1; /*reportError($$, yylineno)*/ out = false; }
    | WHILE LP error RP Stmt                    { $$ = newAst(TAG_ERROR, 5, $1, $2, $3, $4, $5); $$->error_type = 3; /*reportError($$, yylineno);*/ out = false; }
    | RETURN error SEMI                         { $$ = newAst(TAG_ERROR, 3, $1, $2, $3); $$->error_type = 14; /*reportError($$, yylineno);*/ out = false; }
    ;

/* Local Definitions */
DefList: Def DefList                            { $$ = newAst(TAG_DEF_LIST, 2, $1, $2); }
    | /* empty */                               { $$ = newAst(TAG_EMPTY, 0); }
    ;

Def: Specifier DecList SEMI                     { $$ = newAst(TAG_DEF, 3, $1, $2, $3); }
    | Specifier error SEMI                      { $$ = newAst(TAG_ERROR, 3, $1, $2, $3); $$->error_type = 4; /*reportError($$, yylineno);*/ out = false; }
    | Specifier DecList error                   { $$ = newAst(TAG_ERROR, 3, $1, $2, $3); $$->error_type = 2; /*reportError($$, yylineno);*/ out = false; }
    | Specifier Dec error                       { $$ = newAst(TAG_ERROR, 3, $1, $2, $3); $$->error_type = 11;/*reportError($$, yylineno);*/ out = false; }
    ;

DecList: Dec                                    { $$ = newAst(TAG_DEC_LIST, 1, $1); }
    | Dec COMMA DecList                         { $$ = newAst(TAG_DEC_LIST, 3, $1, $2, $3); }
    ;

Dec:  VarDec                                    { $$ = newAst(TAG_DEC, 1, $1); }
    | VarDec ASSIGNOP Exp                       { $$ = newAst(TAG_DEC, 3, $1, $2, $3); }
    ;

/* Expressions */
Exp:  Exp ASSIGNOP Exp                          { $$ = newAst(TAG_EXP, 3, $1, $2, $3); }
    | Exp AND Exp                               { $$ = newAst(TAG_EXP, 3, $1, $2, $3); }
    | Exp OR Exp                                { $$ = newAst(TAG_EXP, 3, $1, $2, $3); }
    | Exp RELOP Exp                             { $$ = newAst(TAG_EXP, 3, $1, $2, $3); }
    | Exp PLUS Exp                              { $$ = newAst(TAG_EXP, 3, $1, $2, $3); }
    | Exp MINUS Exp                             { $$ = newAst(TAG_EXP, 3, $1, $2, $3); }
    | Exp STAR Exp                              { $$ = newAst(TAG_EXP, 3, $1, $2, $3); }
    | Exp DIV Exp                               { $$ = newAst(TAG_EXP, 3, $1, $2, $3); }
    | LP Exp RP                                 { $$ = newAst(TAG_EXP, 3, $1, $2, $3); }
    | MINUS Exp                                 { $$ = newAst(TAG_EXP, 2, $1, $2); }
    | NOT Exp                                   { $$ = newAst(TAG_EXP, 2, $1, $2); }
    | ID LP Args RP                             { $$ = newAst(TAG_EXP, 4, $1, $2, $3, $4); $$->attr = FUNC_REF; }
    | ID LP RP                                  { $$ = newAst(TAG_EXP, 3, $1, $2, $3); $$->attr = FUNC_REF; }
    | Exp LB Exp RB                             { $$ = newAst(TAG_EXP, 4, $1, $2, $3, $4); $$->attr = ARRAY_REF; }
    | Exp DOT ID                                { $$ = newAst(TAG_EXP, 3, $1, $2, $3); $$->attr = STRUCT_REF; }
    | ID                                        { $$ = newAst(TAG_EXP, 1, $1); }
    | INT                                       { $$ = newAst(TAG_EXP, 1, $1); }
    | FLOAT                                     { $$ = newAst(TAG_EXP, 1, $1); }
    | ID LP error RP                            { $$ = newAst(TAG_ERROR, 4, $1, $2, $3, $4); $$->error_type = 10; /*reportError($$, yylineno);*/ out = false; }
    | Exp LB error RB                           { $$ = newAst(TAG_ERROR, 4, $1, $2, $3, $4); $$->error_type = 6; /*reportError($$, yylineno);*/ out = false; }
    ;

Args: Exp COMMA Args                            { $$ = newAst(TAG_ARGS, 3, $1, $2, $3); }
    | Exp                                       { $$ = newAst(TAG_ARGS, 1, $1); }
    ;

%%

#define reportError(type, lineno, format, ...) \
    printf("Error type \033[31m%s\033[0m at Line \033[31m%d\033[0m: " format "\n", type, lineno, ## __VA_ARGS__); \

void yyerror(const char *msg) {
    reportError("B", yylineno, "%s", msg);
}
