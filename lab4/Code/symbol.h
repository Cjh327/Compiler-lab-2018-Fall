#ifndef __SYMBOL_H__
#define __SYMBOL_H__

#include "common.h"

extern int typeNum;

typedef struct Type_* Type;
typedef struct Field_* Field;
typedef struct Func_* Func;
typedef struct Symbol_* Symbol;

enum TKind { BASIC, ARRAY, STRUCTURE };
enum Basic { BASIC_INT, BASIC_FLOAT };
enum SKind { VAR, DEF_FUNC, DEC_FUNC };

struct Type_ {
    TKind kind;
    int dim;
    struct {
        Basic basic;    // BASIC
        struct {        // ARRAY
            Type elem;
            std::vector<int> size_list;
        } array;
        struct {        //STRUCTURE
            std::string name;
            std::vector<Field> fieldList;
        } structure;
    } u;

    Type_() {
        this->dim = 0;
    }
    Type_(Basic b) {
        this->kind = BASIC;
        this->dim = 0;
        this->u.basic = b;
    }
};

struct Field_ {
    std::string name;
    Type type;
 
    Field_() {}
    Field_(std::string n, Type t) {
        this->name = n;
        this->type = t;
    }
};

struct Func_ {
    Type ret;
    std::vector<Field> argList;
};

struct Symbol_ {
    SKind kind;
    std::string name;
    int line_no;
    union {
        Type type;
        Func func;
    } u;

    Symbol_() {}
    Symbol_(std::string s, Type t) {
        this->line_no = 0;
        this->kind = VAR;
        this->name = s;
        this->u.type = t;
    }
    Symbol_(std::string s, Func f) {
        this->line_no = 0;
        this->kind = DEF_FUNC;
        this->name = s;
        this->u.func = f;
    }
};

void printType(Type);
void printStruct(Type);
void printSymbol(Symbol);
void printSymbolTable();
void printSymbolTable(std::map<std::string, Symbol>);
void printStructTable();


#endif
