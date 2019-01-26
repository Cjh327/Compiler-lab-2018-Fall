#include "ast.h"
#include "common.h"

extern FILE* yyin;
extern int yylval;
#ifdef YY_DEBUG
extern int yydebug;
#endif

extern int yylex();
extern int yyparse();
extern int yyrestart(FILE *);
extern bool out;

int main(int argc , char **argv) {
    out = true;
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
    if(out)
        printAst(astRoot, 0);
    return 0;
}
