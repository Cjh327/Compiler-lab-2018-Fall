#include "semantic.h"
#include <iostream>
using namespace std;

extern vector<Symbol> symbol_list;
extern map<string, Symbol> global_symbol_table;
// extern map<string, Symbol> local_symbol_table;
extern map<string, Type> struct_table;
extern Func curFunc;

// #define SDEBUG

void sdebug(const char* s) {
#ifdef SDEBUG
    printf("%s\n", s);
#endif
}

// TODO: check assert


void semanticParse(Ast program) {
   // assert(program->first_child->tag == TAG_EXT_DEF_LIST);
    parseExtDefList(program->first_child);
    checkFuncTable();
}

void parseExtDefList(Ast extDefList) {
    Ast extDef = extDefList->first_child;
    if (extDef) {
        Ast specifier = extDef->first_child;
        Type type = getSpecifierType(specifier);
        struct ast* sibling = specifier->first_sibling;
        if (sibling->tag == TAG_EXT_DEC_LIST) {
            parseExtDecList(sibling, type);
        } else if (sibling->tag == TAG_FUN_DEC) {
            Symbol symbol = NULL;
            if (sibling->first_sibling->tag == TAG_COMP_ST) {
                // define function
                curFunc = parseFunDec(sibling, type, DEF_FUNC);
                if (curFunc) {
                    map<string, Symbol> local_symbol_table;
                    parseCompSt(sibling->first_sibling, local_symbol_table);
                    /*
                    Ast defList = sibling->first_sibling->first_child->first_sibling;
                    assert(defList->tag == TAG_DEF_LIST || defList->tag == TAG_EMPTY);
                    parseDefList(defList);
                    parseStmtList(defList->first_sibling);
                    */
                }
            }  else if (sibling->first_sibling->tag == TAG_SEMI) {
                // declare function
                parseFunDec(sibling, type, DEC_FUNC);
            }
        } else {
           // assert(sibling->tag == TAG_SEMI);
        }
        curFunc = NULL;
    //     local_symbol_table.clear();
        parseExtDefList(extDef->first_sibling);
    }
}

void parseExtDecList(Ast extDecList, Type type) {
    Ast varDec = extDecList->first_child;
    Symbol symbol = new Symbol_;
    symbol->kind = VAR;
    symbol->u.type = new Type_;
    copyType(symbol->u.type, type);
    symbol->name = parseVarDec(varDec, symbol->u.type);
    Symbol sym = getSymbol(symbol->name);
    Type t = getStruct(symbol->name);
    if (sym || t) {
        reportError(3, varDec->line_no, symbol->name);
    } else {
        global_symbol_table.insert(std::pair<string, Symbol>(symbol->name, symbol));
    }
    if (varDec->first_sibling) {
        parseExtDecList(varDec->first_sibling->first_sibling, type);
    }
}

void parseDefList(Ast defList, map<string, Symbol>& local_symbol_table) {
    Ast def = defList->first_child;
    while (def) {
        Ast specifier = def->first_child;
        Type type = getSpecifierType(specifier, local_symbol_table);
        if (!type) {
            def = def->first_sibling->first_child;
            continue;
        }
        parseDecList(specifier->first_sibling, type, local_symbol_table);
        def = def->first_sibling->first_child;
    }
}

void parseDefList(Ast defList, vector<Field>& fieldList) {
    Ast def = defList->first_child;
    while (def) {
        Ast specifier = def->first_child;
        Type type = getSpecifierType(specifier);
        parseDecList(specifier->first_sibling, type, fieldList);
        def = def->first_sibling->first_child;
        if (fieldList.size() > 0 && !fieldList.back()) {
            return;
        }
    }
}

void parseDecList(Ast decList, Type type, map<string, Symbol>& local_symbol_table) {
    if (!type) {
        return;
    }
    Ast dec = decList->first_child;
    while (1) {
        Ast varDec = dec->first_child;
        Symbol symbol = new Symbol_;
        symbol->kind = VAR;
        symbol->u.type = new Type_;
        copyType(symbol->u.type, type);
        symbol->name = parseVarDec(varDec, symbol->u.type);
        Symbol sym = getSymbol(symbol->name, local_symbol_table);
        Type t = getStruct(symbol->name);
        if (sym || t) {
            reportError(3, varDec->line_no, symbol->name);
        } else {
            local_symbol_table.insert(std::pair<string, Symbol>(symbol->name, symbol));
        }
        // TODO: VarDec ASSIGNOP Exp
        if (dec->first_sibling) {
            dec = dec->first_sibling->first_sibling->first_child;
        } else {
            break;
        }
    }
}

void parseDecList(Ast decList, Type type, vector<Field>& fieldList) {
    Ast dec = decList->first_child;
    while (1) {
        Field field = new Field_;
        Ast varDec = dec->first_child;
        field->type = new Type_;
        copyType(field->type, type);
        field->name = parseVarDec(varDec, field->type);
        vector<Field>::iterator iter = fieldList.begin();
        for (; iter != fieldList.end(); iter++) {
            if ((*iter)->name == field->name) {
                reportError(15, varDec->line_no, field->name);
                //fieldList.push_back(NULL);
                //return;
                break;
            }
        }
        if (iter == fieldList.end()) {
            fieldList.push_back(field);
        }
        if (varDec->first_sibling && varDec->first_sibling->tag == TAG_ASSIGNOP) {
            reportError(15, varDec->line_no, "struct");
        }
        if (dec->first_sibling) {
            dec = dec->first_sibling->first_sibling->first_child;
        } else {
            break;
        }
    }
}

void parseStmtList(Ast stmtList, map<string, Symbol> local_symbol_table) {
    Ast stmt = stmtList->first_child;
    if (stmt) {
        parseStmt(stmt, local_symbol_table);
        parseStmtList(stmt->first_sibling, local_symbol_table);
    }
}

void parseStmt(Ast stmt, map<string, Symbol> local_symbol_table) {
    Ast child = stmt->first_child;
    if (child->tag == TAG_EXP) {
        parseExp(child, local_symbol_table);
    } else if (child->tag == TAG_COMP_ST) {
        parseCompSt(child, local_symbol_table);
    } else if (child->tag == TAG_RETURN) {
        Type ret = parseExp(child->first_sibling, local_symbol_table);
        if (!typeEquiv(curFunc->ret, ret)) {
            reportError(8, child->line_no, "");
            return;
        }
    } else {
        Ast exp = child->first_sibling->first_sibling;
       //  assert(exp->tag == TAG_EXP);
        Type type = parseExp(exp, local_symbol_table);
        // TODO if while
        Ast stmt = exp->first_sibling->first_sibling;
       // assert(stmt->tag == TAG_STMT);
        parseStmt(stmt, local_symbol_table);
        if (stmt->first_sibling) {
            parseStmt(stmt->first_sibling->first_sibling, local_symbol_table);
        }
    }
}

Type parseExp(Ast exp, map<string, Symbol> local_symbol_table) {
    Type type = NULL;
    Ast child1 = exp->first_child;
    Ast child2 = child1->first_sibling;
    if (!child2) {
        if (child1->tag == TAG_ID) {
            Symbol symbol = getSymbol(child1->u.str, local_symbol_table);
            if (!symbol) {
                reportError(1, child1->line_no, child1->u.str);
                return NULL;
            }
            type = new Type_;
            copyType(type, symbol->u.type);
        } else if (child1->tag == TAG_INT) {
            // TODO
            type = new Type_(BASIC_INT);
        } else if (child1->tag == TAG_FLOAT) {
            // TODO
            type = new Type_(BASIC_FLOAT);
        } else {
            sdebug("???");
            cout << DICT[child1->tag] <<endl;
           //  assert(0);
        }
    } else if (child1->tag == TAG_EXP && child2->first_sibling && child2->first_sibling->tag == TAG_EXP && child2->tag != TAG_LB) {
        Type type1 = parseExp(child1, local_symbol_table);
        Type type2 = parseExp(child2->first_sibling, local_symbol_table);
        if (!type1 || !type2) {
            return NULL;
        }
        switch(child2->tag) {
            case(TAG_ASSIGNOP): if (!typeEquiv(type1, type2)) { reportError(5, child1->line_no, ""); return NULL; }  if (!isLeft(child1)) { reportError(6, child1->line_no, ""); return NULL; } break;
            case(TAG_AND):      if (!typeEquiv(type1, type2) || type1->kind != BASIC || type1->u.basic != BASIC_INT) { reportError(7, child1->line_no, "variable"); return NULL; } break;
            case(TAG_OR):       if (!typeEquiv(type1, type2) || type1->kind != BASIC || type1->u.basic != BASIC_INT) { reportError(7, child1->line_no, "variable"); return NULL; } break;
            case(TAG_RELOP):    if (!typeEquiv(type1, type2) || type1->kind != BASIC || type1->u.basic != BASIC_INT) { reportError(7, child1->line_no, "variable"); return NULL; } break;
            case(TAG_PLUS):     if (!typeEquiv(type1, type2) || type1->kind != BASIC) { reportError(7, child1->line_no, ""); return NULL; } break;
            case(TAG_MINUS):    if (!typeEquiv(type1, type2) || type1->kind != BASIC) { reportError(7, child1->line_no, ""); return NULL; } break;
            case(TAG_STAR):     if (!typeEquiv(type1, type2) || type1->kind != BASIC) { reportError(7, child1->line_no, ""); return NULL; } break;
            case(TAG_DIV):      if (!typeEquiv(type1, type2) || type1->kind != BASIC) { reportError(7, child1->line_no, ""); return NULL; } break;
            default: break; // assert(0);
        }
        type = type1;
    } else if (child1->tag == TAG_ID) { // function
        Symbol symbol = getSymbol(child1->u.str, local_symbol_table);
        if (!symbol) {
            reportError(2, child1->line_no, child1->u.str);
            return NULL;
        } else if (symbol->kind != DEF_FUNC) {
            reportError(11, child1->line_no, symbol->name);
            return NULL;
        } else {
            // check function
            if (symbol->kind != DEF_FUNC) {
                reportError(20, child1->line_no, "");
                return NULL;
            }
            Ast args = child1->first_sibling->first_sibling;
            vector<Field>::iterator iter = symbol->u.func->argList.begin();
            if (args->tag == TAG_ARGS) {
                Ast exp = args->first_child;
                while (iter != symbol->u.func->argList.end()) {
                    Type argType = parseExp(exp, local_symbol_table);
                    if (!typeEquiv((*iter)->type, argType)) {
                        reportError(9, child1->line_no, symbol->name);
                        return NULL;
                    }
                    iter++;
                    if (exp->first_sibling) {
                        exp = exp->first_sibling->first_sibling->first_child;
                    } else {
                        exp = NULL;
                        break;
                    }
                }
                if ((!exp && iter != symbol->u.func->argList.end()) || (exp && iter == symbol->u.func->argList.end())) {
                    reportError(9, child1->line_no, symbol->name);
                    return NULL;
                }
            } else {
                if (iter != symbol->u.func->argList.end()) {
                    reportError(9, child1->line_no, symbol->name);
                    return NULL;
                }
            }
            type = symbol->u.func->ret;
        }
    } else if (child2->tag == TAG_LB) {
        type = parseExp(child1, local_symbol_table);
        Ast exp2 = child2->first_sibling;
        Type type2 = parseExp(exp2, local_symbol_table);
        if (type2->kind != BASIC || type2->u.basic != BASIC_INT) {
            reportError(12, exp2->line_no, "variale");
            return NULL;
        }
        if (type->dim == 0) {
           // assert(type->kind == BASIC || type->kind == STRUCTURE);
            reportError(10 , child1->line_no, "variable");
            return NULL;
        }
        type->dim--;
        if (type->dim == 0) {
           // assert(type->kind == ARRAY);
            if (type->u.array.elem->kind == BASIC) {
                type->kind = BASIC;
                type->u.basic = type->u.array.elem->u.basic;
            } else if (type->u.array.elem->kind == STRUCTURE) {
                // TODO
                type->kind = STRUCTURE;
                type->u.structure.name = type->u.array.elem->u.structure.name;
                type->u.structure.fieldList = type->u.array.elem->u.structure.fieldList;
            } else {
            //    assert(0);
            }
        }
    } else if (child2->tag == TAG_DOT) {
        // STRUCTURE
        Type t = parseExp(child1, local_symbol_table);
        if (!t) {
            return NULL;
        }
        if (t->kind != STRUCTURE) {
            reportError(13, child1->line_no, ".");
            return NULL;
        }
        Ast id = child2->first_sibling;
        vector<Field>::iterator iter = t->u.structure.fieldList.begin();
        for (; iter != t->u.structure.fieldList.end(); iter++) {
            if ((*iter)->name == id->u.str) {
                type = new Type_;
                copyType(type, (*iter)->type);
                break;
            }
        }
        if (iter == t->u.structure.fieldList.end()) {
            reportError(14, id->line_no, id->u.str);
            return NULL;
        }
    } else if (child2->tag == TAG_EXP) {
        if (child1->tag == TAG_MINUS) {
            type = parseExp(child2, local_symbol_table);
            if (!type) {
                return NULL;
            }
            if (type->kind != BASIC) {
                reportError(7, child2->line_no, "variable");
                return NULL;
            }
        } else if (child1->tag == TAG_NOT) {
            type = parseExp(child2, local_symbol_table);
            if (type->kind != BASIC || type->u.basic != BASIC_INT) {
                reportError(7, child2->line_no, "variable");
                return NULL;
            }
        }
    } else {
        // more exp
        cout << DICT[child1->tag] << " " << DICT[child2->tag] << endl;
       // assert(0);
    }
    return type;
}

void parseCompSt(Ast compSt, map<string, Symbol> local_symbol_table) {
    Ast defList = compSt->first_child->first_sibling;
   // assert(defList->tag == TAG_DEF_LIST || defList->tag == TAG_EMPTY);
    if (defList->tag == TAG_DEF_LIST) {
        parseDefList(defList, local_symbol_table);
    }
    parseStmtList(defList->first_sibling, local_symbol_table);
}


string parseVarDec(Ast varDec, Type type) {
    Ast child = varDec->first_child;
    while (child->tag != TAG_ID) {
        if (type->kind != ARRAY) {
            type->u.array.elem = new Type_;
            copyType(type->u.array.elem, type);
            type->kind = ARRAY;
        }
        type->dim++;
        child = child->first_child;
    }
    return child->u.str;
}

Symbol buildFunc(Ast funDec, Type type, SKind kind) {
    Symbol symbol = new Symbol_;
    symbol->kind = kind;
    symbol->u.func = new Func_;
    symbol->u.func->ret = new Type_;
    symbol->line_no = funDec->line_no;
    copyType(symbol->u.func->ret, type);
    Ast id = funDec->first_child;
    symbol->name = id->u.str;
    Ast sibling = id->first_sibling->first_sibling;
    if (sibling->tag == TAG_VAR_LIST) {
        Ast paramDec = sibling->first_child;
        while (1) {
            Ast specifier = paramDec->first_child;
            Type paramType = getSpecifierType(specifier);
            Ast varDec = specifier->first_sibling;
            Ast child = varDec->first_child;
            Field arg = new Field_;
            arg->type = new Type_;
            copyType(arg->type, paramType);
            arg->name = parseVarDec(varDec, arg->type);
            symbol->u.func->argList.push_back(arg);
            if (paramDec->first_sibling) {
                paramDec = paramDec->first_sibling->first_sibling->first_child;
            } else {
                break;
            }
        }
    }
    else {
       // assert(symbol->u.func->argList.size() == 0);
    }
    global_symbol_table.insert(std::pair<string, Symbol>(symbol->name, symbol));
    return symbol;
}


bool compareFunDec(Ast funDec, Type type, Symbol funcSym) {
    Func func = funcSym->u.func;
    // assert(funDec->first_child->u.str == funcSym->name);
    if (!typeEquiv(type, func->ret)) {
        return false;
    }
    Ast varList = funDec->first_child->first_sibling->first_sibling;
    if (varList->tag == TAG_VAR_LIST) {
        Ast paramDec = varList->first_child;
        vector<Field>::iterator iter = func->argList.begin();
        while (paramDec) {
            Ast specifier = paramDec->first_child;
            Type paramType = getSpecifierType(specifier);
            Ast varDec = specifier->first_sibling;
            Ast child = varDec->first_child;
            Type t = new Type_;
            copyType(t, paramType);
            parseVarDec(varDec, t);
            if (iter == func->argList.end() || !typeEquiv(t, (*iter)->type)) {
                return false;
            }
            if (paramDec->first_sibling) {
                paramDec = paramDec->first_sibling->first_sibling->first_child;
            } else {
                paramDec = NULL;
            }
            iter++;
        }
        if (iter != func->argList.end()) {
            return false;
        }
    } else {
        if (func->argList.size() > 0) {
            return false;
        }
    }
    return true;
}

Func parseFunDec(Ast funDec, Type type, SKind kind) {
   // assert(kind != VAR);
    Ast id = funDec->first_child;
    Symbol funcSym = getFuncSym(id->u.str);
    if (!funcSym) {
        Symbol symbol = buildFunc(funDec, type, kind);
        if (kind == DEF_FUNC) {
            return symbol->u.func;
        }
        return NULL;
    }
    if (funcSym->kind == DEC_FUNC) {
        if (!compareFunDec(funDec, type, funcSym)) {
            reportError(19, funDec->line_no, id->u.str);
            return NULL;
        }
        if (kind == DEF_FUNC) {
            funcSym->kind = DEF_FUNC;
        }
    } else {
        // assert(funcSym->kind == DEF_FUNC);
        if (kind == DEF_FUNC) {
            reportError(4, funDec->line_no, id->u.str);
            return NULL;
        } else {
         //   assert(kind == DEC_FUNC);
            if (!compareFunDec(funDec, type, funcSym)) {
                reportError(19, funDec->line_no, id->u.str);
                return NULL;
            }
        }
    }
    return NULL;
   //symbol_table.insert(std::pair<string, Symbol>(symbol->name, symbol));
    //curFunc = symbol->u.func;
}

Type getSpecifierType(struct ast* specifier, map<string, Symbol> local_symbol_table) {
    sdebug("get Specifier Type: ");
    Type type = NULL;
    if (specifier->first_child->tag == TAG_TYPE) {
        type = new Type_;
        type->kind = BASIC;
        type->dim = 0;
        string type_name = specifier->first_child->u.str;
        if (type_name == "int") {
            type->u.basic = BASIC_INT;
            sdebug("INT\n");
        } else {
            type->u.basic = BASIC_FLOAT;
            sdebug("FLOAT\n");
        }
    } else {
        sdebug("STRUCT\n");
        struct ast* structSpecifier = specifier->first_child;
       // assert(structSpecifier->tag == TAG_STRUCT_SPEC);
        type = getStructType(structSpecifier, local_symbol_table);
    }
    return type;
}

Type getStructType(Ast structSpecifier, map<string, Symbol> local_symbol_table) {
    Ast sibling  = structSpecifier->first_child->first_sibling;
    Type type = NULL;
    if (sibling->tag == TAG_OPT_TAG) {
        // build struct
        type = buildStruct(structSpecifier, local_symbol_table);
   } else {
      //  assert(sibling->tag == TAG_TAG);
        // check struct
        string name = sibling->first_child->u.str;
    //    Symbol sym = getSymbol(name, local_struct_table);
        type = getStruct(name);
        /*
        map<string, Type>::iterator iter = struct_table.find(name);
        if (iter == struct_table.end()) {
            reportError(17, sibling->line_no, name);
            return NULL;
        }
        type = iter->second;
        */
        if (!type) {
            reportError(17, sibling->line_no, name);
            return NULL;
        }
    }
    return type;
}

Type buildStruct(Ast structSpecifier, map<string, Symbol> local_symbol_table) {
    sdebug("build struct");
    Ast sibling = structSpecifier->first_child->first_sibling;
    Type type = new Type_;
    type->kind = STRUCTURE;
    type->dim = 0;
    Ast id = sibling->first_child;
    if (id) {
        Type t = getStruct(id->u.str);
        Symbol sym = getSymbol(id->u.str, local_symbol_table);
        if (t || sym) {
            reportError(16, id->line_no, id->u.str);
            return NULL;
        }
        type->u.structure.name = id->u.str;
    } else {
        type->u.structure.name = "UNNAMED" + to_string(struct_table.size());
    }
    Ast defList = sibling->first_sibling->first_sibling;
    parseDefList(defList, type->u.structure.fieldList);
    //if (type->u.structure.fieldList.size() > 0 && !type->u.structure.fieldList.back()) {
    //    return NULL;
    //}
    struct_table.insert(std::pair<string, Type>(type->u.structure.name, type));
    return type;
}

void copyType(Type dest, Type src) {
    dest->kind = src->kind;
    dest->dim = src->dim;
    switch (src->kind) {
        case BASIC:     dest->u.basic = src->u.basic;
                        break;
        case ARRAY:     dest->u.array.elem = new Type_();
                        copyType(dest->u.array.elem, src->u.array.elem);
                        // dest->u.array.elem = src->u.array.elem;
                        break;
        case STRUCTURE: dest->u.structure.name = src->u.structure.name;
                        dest->u.structure.fieldList.insert(dest->u.structure.fieldList.end(), src->u.structure.fieldList.begin(), src->u.structure.fieldList.end());
                        break;
        default: break;// assert(0);
    }
}

bool typeEquiv(Type type1, Type type2) {
    if (!type1 || !type2) {
        return false;
    }
    if (type1->kind != type2->kind) {
        return false;
    }
    if (type1->kind == BASIC) {
        if (type1->u.basic != type2->u.basic) {
            return false;
        }
    } else if (type1->kind == ARRAY) {
        if (type1->dim != type2->dim) {
            return false;
        }
        return typeEquiv(type1->u.array.elem, type2->u.array.elem);
    } else {
        if (type1->u.structure.fieldList.size() != type2->u.structure.fieldList.size()) {
            return false;
        }
        vector<Field>::iterator iter1 = type1->u.structure.fieldList.begin();
        vector<Field>::iterator iter2 = type2->u.structure.fieldList.begin();
        int size =  type1->u.structure.fieldList.size();
        while (iter1 != type1->u.structure.fieldList.end() && iter2 != type2->u.structure.fieldList.end()) {
            if (!typeEquiv((*iter1)->type, (*iter2)->type)) {
                return false;
            }
            iter1++;
            iter2++;
        }
       // assert(iter1 == type1->u.structure.fieldList.end() && iter2 == type2->u.structure.fieldList.end());
    }
    return true;
}

bool isLeft(Ast exp) {
    Ast child = exp->first_child;
    Ast sibling = child->first_sibling;
    if (!sibling && child->tag == TAG_ID) {
        return true;
    }
    if (child->tag == TAG_LP) {
        return isLeft(sibling);
    }
    if (sibling) {
        if (sibling->tag == TAG_LB || sibling->tag == TAG_DOT) {
            return true;
        }
    }
    /*
    return ((child->tag == TAG_ID) ||
            (child->tag == TAG_EXP && child->first_sibling && child->first_sibling->tag == TAG_LB) ||
            (child->tag == TAG_EXP && child->first_sibling && child->first_sibling->tag == TAG_DOT));
    */
    return false;
}

Symbol getSymbol(string name, map<string, Symbol> local_symbol_table) {
    if (curFunc) {
        //Field arg = curFunc->args;
        for (vector<Field>::iterator iter = curFunc->argList.begin(); iter != curFunc->argList.end(); iter++) {
            Field arg = *iter;
            if (arg->name == name) {
                Symbol symbol = new Symbol_(name, arg->type);
                return symbol;
            }
        }
    }
    map<string, Symbol>::iterator iter = global_symbol_table.find(name);
    if (iter != global_symbol_table.end()) {
        return iter->second;
    }
    iter = local_symbol_table.find(name);
    if (iter != local_symbol_table.end()) {
        return iter->second;
    }
    return NULL;
}

Type getStruct(string name) {
    map<string, Type>::iterator iter = struct_table.find(name);
    if (iter != struct_table.end()) {
        return iter->second;
    }

    return NULL;
}

bool checkFuncSymbol(string name) {
    map<string, Symbol>::iterator iter = global_symbol_table.find(name);
    return iter != global_symbol_table.end();
}

void checkFuncTable() {
    for (map<string, Symbol>::iterator iter = global_symbol_table.begin(); iter != global_symbol_table.end(); iter++) {
        Symbol symbol = iter->second;
        if (symbol->kind == DEC_FUNC) {
            reportError(18, symbol->line_no, symbol->name);
        }
    }
}

Symbol getFuncSym(string name) {
    map<string, Symbol>::iterator iter = global_symbol_table.find(name);
    if (iter == global_symbol_table.end()) {
        return NULL;
    }
    return iter->second;
}

void reportError(int error_type, int line_no, string str) {
    cout << "Error type \033[31m" << error_type << "\033[0m at line \033[31m" << line_no <<"\033[0m: ";
    switch(error_type) {
        case 1: cout << "Undefined variable " << "\"" << str << "\"."; break;
        case 2: cout << "Undefined function " << "\"" << str << "\"."; break;
        case 3: cout << "Redefined variable " << "\"" << str << "\"."; break;
        case 4: cout << "Redefined function " << "\"" << str << "\"."; break;
        case 5: cout << "Type mismatched for assignment."; break;
        case 6: cout << "The left-hand side of an assignment must be a variable."; break;
        case 7: cout << "Type mismatched for operands."; break;
        case 8: cout << "Type mismathced for return."; break;
        case 9: cout << "Function " << "\"" << str << "\"" << " is not applicable for arguments."; break;
        case 10: cout << str << " is not an array."; break;
        case 11: cout << "\"" << str << "\"" << " is not a function."; break;
        case 12: cout << str << " is not an integer."; break;
        case 13: cout << "Illegal use of " << "\"" << str << "\"."; break;
        case 14: cout << "Non-existent field " << "\"" << str << "\"."; break;
        case 15: if (str != "struct") cout << "Redefined field " << "\"" << str << "\"."; else cout << "Initialize a field of structure."; break;
        case 16: cout << "Duplicated name " << "\"" << str << "\"."; break;
        case 17: cout << "Undefined structure " << "\"" << str << "\"."; break;
        case 18: cout << "Undefined function " << "\"" << str << "\"."; break;
        case 19: cout << "Inconsistent declaration of function " << "\"" << str << "\"."; break;
        case 20: cout << "Called object is not a function."; break;
        default: break;
    }
    cout << endl;
}
