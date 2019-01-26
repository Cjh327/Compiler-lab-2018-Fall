#ifndef __AST_H__
#define __AST_H__

#include "common.h"

enum Attribute {
    DUMMY,

    BUILT_IN,
    TYPE_STRUCT,

    STRUCT_DEC,
    FUNC_DEC,

    VAR_DEF,
    STRUCT_DEF,
    ARRAY_DEF,
    FUNC_DEF,

    VAR_REF,
    STRUCT_REF,
    ARRAY_REF,
    FUNC_REF,

    DEC_LIST,
    VOID_DEC
};

enum Tag {
    TAG_TYPE, TAG_STRUCT, TAG_IF, TAG_ELSE,
    TAG_WHILE, TAG_RETURN, TAG_INT, TAG_FLOAT,
    TAG_ID, TAG_SEMI, TAG_COMMA, TAG_ASSIGNOP,
    TAG_RELOP, TAG_PLUS, TAG_MINUS, TAG_STAR,
    TAG_DIV, TAG_AND, TAG_OR, TAG_DOT,
    TAG_NOT, TAG_LP, TAG_RP, TAG_LB, TAG_RB,
    TAG_LC, TAG_RC,

    TAG_PROGRAM, TAG_EXT_DEF_LIST, TAG_ERROR, TAG_EMPTY,
    TAG_EXT_DEF, TAG_EXT_DEC_LIST, TAG_SPEC,
    TAG_STRUCT_SPEC, TAG_OPT_TAG, TAG_TAG,
    TAG_VAR_DEC, TAG_FUN_DEC, TAG_VAR_LIST, TAG_PARAM_DEC,
    TAG_COMP_ST, TAG_STMT_LIST, TAG_STMT,
    TAG_DEF_LIST, TAG_DEF, TAG_DEC_LIST,
    TAG_DEC, TAG_EXP, TAG_ARGS
};

typedef char* string;

extern string DICT[];

struct ast {
    int line_no;                    // line number
    enum Tag tag;                   // tag of node (e.g. TAG_INT, TAG_FLOAT, TAG_STRUCT)
    union {
        char str[STRING_LENGTH];
        int ival;
        float fval;
    } u;                            // value of node (if exists)
    enum Attribute attr;            // attribute of node
    int error_type;                 // error type of node (if there is error)
    struct ast* first_child;        // first child of node
    struct ast* first_sibling;      // first right sibling of node
};

extern struct ast *astRoot;

struct ast *newAst(enum Tag , int, ...);
void printAst(struct ast*, int);
//void reportError(struct ast*, int);
char *outputTag(enum Tag tag);
#endif
