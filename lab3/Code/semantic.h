#ifndef __SEMANTIC_H__
#define __SEMANTIC_H__

#include "common.h"
#include "ast.h"
#include "symbol.h"

void semanticParse(Ast);
void parseExtDefList(Ast);
void parseExtDecList(Ast, Type);
Func parseFunDec(Ast, Type, SKind);
void parseDefList(Ast, std::map<std::string, Symbol>&);
void parseDefList(Ast, std::vector<Field>&);
void parseDecList(Ast, Type, std::map<std::string, Symbol>&);
void parseDecList(Ast, Type, std::vector<Field>&);
void parseCompSt(Ast, std::map<std::string, Symbol>);
void parseStmtList(Ast, std::map<std::string, Symbol>);
void parseStmt(Ast, std::map<std::string, Symbol>);
Type parseExp(Ast, std::map<std::string, Symbol>);
std::string parseVarDec(Ast, Type);

Type getSpecifierType(Ast a, std::map<std::string, Symbol> m = std::map<std::string, Symbol>());
Type getStructType(Ast, std::map<std::string, Symbol>);
Type buildStruct(Ast, std::map<std::string, Symbol>);
Symbol buildFunc(Ast, Type, SKind);

bool compareFunDec(Ast, Type, Symbol);
bool typeEquiv(Type, Type);
bool isLeft(Ast);
void copyType(Type, Type);
bool checkFuncSymbol(std::string);
Symbol getFuncSym(std::string);
Symbol getSymbol(std::string s, std::map<std::string, Symbol> m = std::map<std::string, Symbol>());
Type getStruct(std::string);

void checkFuncTable();
void reportError(int, int ,std::string);

#endif
