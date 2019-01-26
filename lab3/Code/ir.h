#ifndef __IR_H__
#define __IR_H__

#include "common.h"
#include "ast.h"
#include "symbol.h"
#include "semantic.h"
#include <fstream>

typedef struct Operand_* Operand;
typedef struct InterCode_* InterCode;
typedef struct InterCodes_* InterCodes;
typedef struct Variable_* Variable;

enum IR_kind{
    IR_DUMMY,
    IR_ASSIGN,
    IR_ADD,
    IR_SUB,
    IR_MUL,
    IR_DIV,
    IR_FUNC,
    IR_PARAM,
    IR_READ,
    IR_WRITE,
    IR_ARG,
    IR_CALL,
    IR_RETURN,
    IR_LABEL,
    IR_GOTO,
    IR_IF,
    IR_DEC
};

enum OP_kind {
    OP_TEMP,
    OP_VARIABLE,
    OP_CONSTANT,
    OP_FUNCTION,
    OP_LABEL,
    OP_RELOP,
    OP_BYTE
};

enum OP_Attr {
    OP_BASIC,
    OP_ADDRESS,
    OP_POINTER,
};

struct Operand_ {
    OP_Attr attr;
    OP_kind kind;
    int val;
    std::string name;

    Operand_(int v = 0, OP_kind k = OP_TEMP, OP_Attr a = OP_BASIC): kind(k), val(v), attr(a) {}
};

struct InterCode_ {
    IR_kind kind;
    Operand result, op1, op2;

    InterCode_(Operand r = NULL, Operand p1 = NULL, Operand p2 = NULL):result(r), op1(p1), op2(p2) {}
};

struct InterCodes_ { 
    InterCode_ code; 
    InterCodes prev, next; 

    InterCodes_(InterCodes p = NULL, InterCodes n = NULL): prev(p), next(n) {}
};

struct Variable_ {
    bool func_param;
    int var_no;
    std::string name;
    Type type;
    
    Variable_(int v = 0, std::string s = "", Type t = NULL, bool f = false): var_no(v), name(s), type(t), func_param(f) {}
};

void gen_ir(Ast, std::string);

InterCodes translate_Program(Ast);
InterCodes translate_ExtDefList(Ast);
InterCodes translate_ExtDef(Ast);
// InterCodes translate_ExtDecList(Ast);
InterCodes translate_FunDec(Ast);
InterCodes translate_CompSt(Ast);
InterCodes translate_VarList(Ast);
InterCodes translate_ParamDec(Ast);
InterCodes translate_DefList(Ast);
InterCodes translate_DecList(Ast);
InterCodes translate_Dec(Ast);
InterCodes translate_StmtList(Ast);
InterCodes translate_Stmt(Ast);
InterCodes translate_Exp(Ast, Operand);
InterCodes translate_Cond(Ast, int, int);
InterCodes translate_ExpCond(Ast, Operand);
InterCodes translate_Args(Ast);

InterCodes bindCodes(int, ...);
int newTemp();
int newVarId();
int newLabel();
Variable lookup(std::string);
std::string getRelop(Ast);
std::string getOppRelop(Ast);
std::string getOpVal(Operand);
std::string getExpId(Ast);
Type getExpType(Ast);
InterCodes getOffset(Type, Ast, Operand);
int getTypeSize(Type);

#endif