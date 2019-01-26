#include "ast.h"
#include "common.h"
#include "semantic.h"
#include "symbol.h"
#include <iostream>
using namespace std;

extern FILE* yyin;
extern int yylval;
#ifdef YY_DEBUG
extern int yydebug;
#endif

extern int yylex();
extern int yyparse();
extern int yyrestart(FILE *);

bool out;
vector<Symbol> symbol_list;
map<string, Symbol> global_symbol_table;
// map<string, Symbol> local_symbol_table;
map<string, Type> struct_table;
Func curFunc;

int main(int argc , char **argv) {
    out = true;
    curFunc = NULL;
    if(argc <= 1)
        return 1;
    FILE *f = fopen(argv[1], "r");
    if(f == NULL) {
        perror(argv[1]);
        return 1;
    }
    yyrestart(f);
#ifdef YY_DEBUG
    yydebug = 1;
#endif
    yyparse();
    if(out) {
    //    printAst(astRoot, 0);
        semanticParse(astRoot);
    //    printSymbolTable();
    //    printStructTable();
    }
    return 0;
}
