#include "ast.h"
using namespace std;

extern bool out;
struct ast *astRoot = NULL;


string DICT [] = {
	"TYPE", "STRUCT", "IF", "ELSE",
	"WHILE", "RETURN", "INT", "FLOAT",
	"ID", "SEMI", "COMMA", "ASSIGNOP",
	"RELOP", "PLUS", "MINUS", "STAR",
	"DIV", "AND", "OR", "DOT",
	"NOT", "LP", "RP", "LB", "RB", "LC", "RC",

	"Program", "ExtDefList", "ERROR", "EMPTY",
	"ExtDef", "EXtDecList", "Specifier",
	"StructSpecifier", "OptTag", "Tag",
	"VarDec", "FunDec", "VarList", "ParamDec",
	"CompSt", "StmtList", "Stmt",
	"DefList", "Def", "DecList", "Dec",
	"Exp", "Args"
};

void printError(const char* msg, char type, int lineno) {
    fprintf(stderr, "Error type \033[31m%c\033[0m at Line \033[31m%d\033[0m: %s\033[0m\n", type, lineno, msg);
}

struct ast *newAst(enum Tag tag, int n, ...) {
    va_list valist;
    va_start(valist, n);

    struct ast *root = (struct ast*)malloc(sizeof(struct ast));
    root->tag = tag;
    root->error_type = 0;
    root->attr = DUMMY;
    root->first_child = NULL;
    root->first_sibling = NULL;

    if (n > 0) {
        struct ast *child = va_arg(valist, struct ast*);
        root->line_no = child->line_no;
        root->first_child = child;
        int i = 1;
        for (; i < n; i++) {
            child->first_sibling = va_arg(valist, struct ast*);
            child = child->first_sibling;
        }
    }
    else {
        root->line_no = va_arg(valist, int);
        root->first_child = root->first_sibling = NULL;
    }

    va_end(valist);
    return root;
}

void printAst(struct ast *root, int indent) {
    if (root == NULL)
        return;
    if (root->tag == TAG_EMPTY)
        return;
    for (int i = 0; i < 2*indent; ++i)
        printf(" ");
    printf("%s", outputTag(root->tag).c_str());
    if (root->first_child == NULL) {
        if (root->tag == TAG_ID || root->tag == TAG_TYPE)
            printf(": %s", root->u.str);
        else if (root->tag == TAG_INT)
            printf(": %d", root->u.ival);
        else if (root->tag == TAG_FLOAT)
            printf(": %f", root->u.fval);
        printf("\n");
        return;
    }
    printf(" (%d)\n", root->line_no);
    struct ast *child = root->first_child;
    while (child != NULL) {
        printAst(child, indent + 1);
        child = child->first_sibling;
    }
}

string outputTag(enum Tag tag) {
    return DICT[(int)tag];
}
