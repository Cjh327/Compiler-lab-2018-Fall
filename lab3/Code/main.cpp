#include "ast.h"
#include "common.h"
#include "semantic.h"
#include "symbol.h"
#include "ir.h"
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
map<string, Symbol> global_symbol_table;
map<string, Type> struct_table;
Func curFunc;
map<string, Variable> var_table;

void initSymTable() {
    Type type_int = new Type_(BASIC_INT);

    Func func_read = new Func_;
    func_read->ret = type_int;
    Symbol sym_read = new Symbol_("read", func_read);
    global_symbol_table.insert(pair<string, Symbol>("read", sym_read));

    Func func_write = new Func_;
    func_write->ret = type_int;
    Field field = new Field_("s", type_int);
    func_write->argList.push_back(field);
    Symbol sym_wrtie = new Symbol_("write", func_write);
    global_symbol_table.insert(pair<string, Symbol>("write", sym_wrtie));   
}

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
        initSymTable();
        semanticParse(astRoot);
        string filename = argv[2];
        string filepath = "../Ir/" + filename;
        gen_ir(astRoot, filepath);
    //    printSymbolTable();
    //    printStructTable();
    }
    return 0;
}
