#include "symbol.h"
#include <iostream>

using namespace std;

extern map<string, Symbol> global_symbol_table;
extern map<string, Type> struct_table;

void printType(Type type) {
    if (!type){
        cout << "NULL";
        return;
    }
    switch (type->kind) {
        case BASIC: if (type->u.basic == BASIC_INT) cout << "INT";
                    else cout << "FLOAT";
                    break;
        case ARRAY: cout << "ARRAY(";
                    if (type->u.array.elem->kind == BASIC) {
                        if (type->u.array.elem->u.basic == BASIC_INT) cout << "INT";
                        else cout << "FLOAT,";
                    } else {
                        assert(type->u.array.elem->kind == STRUCTURE);
                        cout << "STRUCTURE,";
                    }
                    cout << " size:" << type->dim << ")";
                    break;
        case STRUCTURE: cout << "STRUCTURE "; printStruct(type); break;
        default: break;
    }
}

void printStruct(Type type) {
    cout << type->u.structure.name << " ";
    for (vector<Field>::iterator iter = type->u.structure.fieldList.begin(); iter != type->u.structure.fieldList.end(); iter++) {
        cout << (*iter)->name << ":";
        printType((*iter)->type);
        cout << ",";
    }
    // cout << endl;
}


void printFunc(Func func) {
    cout << "ret: ";
    printType(func->ret);
    cout << "   args: ";
    for (vector<Field>::iterator iter = func->argList.begin(); iter != func->argList.end(); iter++) {
        Field arg = *iter;
        cout << arg->name << ": ";
        printType(arg->type);
        cout << "  ";
    }
}

void printSymbol(Symbol symbol) {
    cout << symbol->name << " : ";
    switch (symbol->kind) {
        case VAR:       cout << "VAR: ";
                        printType(symbol->u.type);
                        break;
        case DEF_FUNC:  cout << "DEF_FUNC: ";
                        printFunc(symbol->u.func);
                        break;
        case DEC_FUNC:  cout << "DEC_FUNC: ";
                        printFunc(symbol->u.func);
                        break;
        default: break;
    }
    cout << endl;
}

void printSymbolTable() {
    map<string, Symbol>::iterator iter;
    for (iter = global_symbol_table.begin(); iter != global_symbol_table.end(); iter++) {
        printSymbol(iter->second);
    }
}

void printSymbolTable(map<string, Symbol> m) {
    map<string, Symbol>::iterator iter;
    for (iter = m.begin(); iter != m.end(); iter++) {
        printSymbol(iter->second);
    }
}


void printStructTable() {
    map<string, Type>::iterator iter;
    for (iter = struct_table.begin(); iter != struct_table.end(); iter++) {
        printStruct(iter->second);
        cout << endl;
    }
}
