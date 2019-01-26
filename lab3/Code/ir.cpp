#include "ir.h"
#include "common.h"
#include "semantic.h"
#include "symbol.h"
#include "ast.h"
#include <vector>
#include <iostream>
#include <cstdarg>
#include <cstdio>
#include <map>
#include <fstream>
using namespace std;

//#define IDEBUG
void idebug(const char* s) {
#ifdef IDEBUG
    printf("\033[31m%s\033[0m\n", s);
#endif
}

extern map<string, Symbol> global_symbol_table;
extern map<string, Type> struct_table;

// extern vector<InterCode> codes;
extern map<string, Variable> var_table;

int newTemp() {
    static int tempId = 0;
    return ++tempId;
}

int newVarId() {
    static int varId = 0;
    //varId++;
    return ++varId;
}

int newLabel(){
    static int labelId = 0;
    return ++labelId;
}

InterCodes getIcTail(InterCodes codes) {
    InterCodes tail = codes;
    while (tail->next) {
        tail = tail->next;
    }
    return tail;
}

string getRelop(Ast relop) {
    return relop->u.str;
}

string getOppRelop(Ast relop) {
    string op = relop->u.str;
    if (op == "==") {
        return "!=";
    } else if (op == "!=") {
        return "==";
    } else if (op == ">") {
        return "<=";
    } else if (op == ">=") {
        return "<";
    } else if (op == "<") {
        return ">=";
    } else if (op == "<=") {
        return ">";
    }
    assert(0);
}

InterCodes bindCodes(int cnt, ...) {
    va_list args;
    va_start(args, cnt);
    InterCodes head = new InterCodes_;
    InterCodes tail = head;
    for (int i = 0; i < cnt; i++) {
        InterCodes codes = va_arg(args, InterCodes);
        if (codes) {
            tail->next = codes;
            codes->prev = tail;
            tail = getIcTail(tail);
        }
    }
    va_end(args);
    return head->next;
}


InterCodes translate_Program(Ast program) {
    idebug("translate_Program");
    InterCodes codes = translate_ExtDefList(program->first_child);
}

InterCodes translate_ExtDefList(Ast extDefList) {
    idebug("translate_ExtDefList");
    InterCodes codes = NULL;
    Ast child = extDefList->first_child;
    if (child) {
        InterCodes codes1 = translate_ExtDef(child);
        InterCodes codes2 = translate_ExtDefList(child->first_sibling);
        codes = bindCodes(2, codes1, codes2);
    }
    return codes;
}

InterCodes translate_ExtDef(Ast extDef) {
    idebug("translate_ExtDef");
    InterCodes codes = NULL;
    Ast child = extDef->first_child->first_sibling;
    if (child->tag == TAG_FUN_DEC) {
        InterCodes codes1 = translate_FunDec(child);
        if (child->first_sibling->tag == TAG_COMP_ST) {
            InterCodes codes2 = translate_CompSt(child->first_sibling);
            codes = bindCodes(2, codes1, codes2);
        } else {
            assert(0);
        }
    }
    return codes;
}

InterCodes translate_FunDec(Ast funDec) {
    idebug("translate_FunDec");
    InterCodes codes = new InterCodes_;
    codes->code.kind = IR_FUNC;
    codes->code.result = new Operand_;
    codes->code.result->kind = OP_FUNCTION;
    codes->code.result->name = funDec->first_child->u.str;
    if (funDec->first_child->first_sibling->first_sibling->tag == TAG_VAR_LIST) {
        InterCodes codes1 = translate_VarList(funDec->first_child->first_sibling->first_sibling);
        codes = bindCodes(2, codes, codes1);
    }
    return codes;
}

InterCodes translate_VarList(Ast varList) {
    idebug("translate_VarList");
    InterCodes codes = NULL;
    Ast paramDec = varList->first_child;
    while (paramDec) {
        InterCodes codes1 = translate_ParamDec(paramDec);
        codes = bindCodes(2, codes, codes1);
        if (paramDec->first_sibling) {
            paramDec = paramDec->first_sibling->first_sibling->first_child;
        } else {
            paramDec = NULL;
        }
    }
    return codes;
}

InterCodes translate_ParamDec(Ast paramDec) {
    idebug("translate_ParamDec");
    Ast id = paramDec->first_child->first_sibling->first_child;
    while (id->tag != TAG_ID) {
        id = id->first_child;
    }

    InterCodes codes = new InterCodes_;
    codes->code.kind = IR_PARAM;
    codes->code.result = new Operand_;
    codes->code.result->kind = OP_VARIABLE;
    codes->code.result->val = lookup(id->u.str)->var_no;

    return codes;
}

InterCodes translate_CompSt(Ast compSt) {
    idebug("translate_CompSt");
    InterCodes codes = NULL;
    InterCodes codes1 = translate_DefList(compSt->first_child->first_sibling);
    InterCodes codes2 = translate_StmtList(compSt->first_child->first_sibling->first_sibling);
    codes = bindCodes(2, codes1, codes2);
    return codes;
}

InterCodes translate_DefList(Ast defList) {
    idebug("translate_DefList");
    Ast def = defList->first_child;
    if (!def) {
        /* DefList -> empty */
        return NULL;
    }
    /* DefList -> Def DefList */
    Ast decList = def->first_child->first_sibling;
    InterCodes codes = translate_DecList(decList);
    InterCodes codes1 = translate_DefList(def->first_sibling);
    codes = bindCodes(2, codes, codes1);
    return codes;
}

InterCodes translate_DecList(Ast decList) {
    idebug("translate_DecList");
    Ast dec = decList->first_child;
    InterCodes codes = translate_Dec(dec);
    if (dec->first_sibling) {
        InterCodes codes1 = translate_DecList(dec->first_sibling->first_sibling);
        codes = bindCodes(2, codes, codes1);
    }
    return codes;
}

InterCodes translate_Dec(Ast dec) {
    idebug("translate_Dec");
    InterCodes codes = NULL;
    Ast varDec = dec->first_child;
    Ast id = varDec->first_child;
    while (id->tag != TAG_ID) {
        id = id->first_child;
    }
    Variable var = lookup(id->u.str);
    int var_no = var->var_no;
    if (var->type->kind == ARRAY) {
        codes = new InterCodes_;
        codes->code.kind = IR_DEC;
        codes->code.result = new Operand_(var_no, OP_VARIABLE);
        codes->code.result->name = var->name;
        codes->code.op1 = new Operand_(getTypeSize(var->type), OP_BYTE);
    } else if (var->type->kind == STRUCTURE) {
        codes = new InterCodes_;
        codes->code.kind = IR_DEC;
        codes->code.result = new Operand_(var_no, OP_VARIABLE);
        codes->code.result->name = var->name;
        codes->code.op1 = new Operand_(getTypeSize(var->type), OP_BYTE);
    }
    if (varDec->first_sibling) {
        Ast exp = varDec->first_sibling->first_sibling;
        Operand place_op1 = new Operand_(newTemp());
        InterCodes codes1 = translate_Exp(exp, place_op1);
        InterCodes codes2 = new InterCodes_;
        codes2->code.kind = IR_ASSIGN;
        codes2->code.result = new Operand_(var_no, OP_VARIABLE);
        codes2->code.op1 = place_op1;
        codes = bindCodes(3, codes, codes1, codes2);
    }
    return codes;
}

InterCodes translate_StmtList(Ast stmtList) {
    idebug("translate_StmtList");
    InterCodes codes = NULL;
    Ast child = stmtList->first_child;
    if (child) {
        InterCodes codes1 = translate_Stmt(child);
        InterCodes codes2 = translate_StmtList(child->first_sibling);
        codes = bindCodes(2, codes1, codes2);
    }
    return codes;
}

InterCodes translate_Stmt(Ast stmt) {
    idebug("translate_Stmt");
    InterCodes codes = NULL;
    Ast child = stmt->first_child;
    if (child->tag == TAG_EXP) {
        /* Stmt -> Exp SEMI */
        Operand place_op1 = new Operand_(-1);
        codes = translate_Exp(child, place_op1);
    } else if (child->tag == TAG_COMP_ST) {
        /* Stmt -> CompSt */
        codes = translate_CompSt(child);
    } else if (child->tag == TAG_RETURN) {
        /* Stmt -> RETURN Exp SEMI */
        int t1 = newTemp();
        Operand place_op1 = new Operand_(newTemp());
        InterCodes codes1 = translate_Exp(child->first_sibling, place_op1);
        InterCodes codes2 = new InterCodes_;
        codes2->code.kind = IR_RETURN;
        // codes2->code.result = new Operand_(place_op1->val, place_op1->kind);
        codes2->code.result = place_op1;
        codes = bindCodes(2, codes1, codes2);
    } else if (child->tag == TAG_WHILE) {
        /* Stmt -> WHILE LP Exp RP Stmt1 */
        int label1 = newLabel();
        int label2 = newLabel();
        Ast exp = child->first_sibling->first_sibling;
        Ast stmt1 = exp->first_sibling->first_sibling;

        InterCodes codes1 = translate_Cond(exp, -1, label2);
        InterCodes codes2 = translate_Stmt(stmt1);

        InterCodes label1_codes = new InterCodes_;
        label1_codes->code.kind = IR_LABEL;
        label1_codes->code.result = new Operand_(label1, OP_LABEL);

        InterCodes label2_codes = new InterCodes_;
        label2_codes->code.kind = IR_LABEL;
        label2_codes->code.result = new Operand_(label2, OP_LABEL);

        InterCodes goto1_codes = new InterCodes_;
        goto1_codes->code.kind = IR_GOTO;
        goto1_codes->code.result = new Operand_(label1, OP_LABEL);

        codes = bindCodes(5, label1_codes, codes1, codes2, goto1_codes, label2_codes);
    } else {
        Ast exp = stmt->first_child->first_sibling->first_sibling;
        Ast stmt1 = exp->first_sibling->first_sibling;
        if (!stmt1->first_sibling) {
            /* Stmt -> IF LP Exp RP Stmt1 */
            int label2 = newLabel();
            InterCodes codes1 = translate_Cond(exp, -1, label2);
            InterCodes codes2 = translate_Stmt(stmt1);

            InterCodes label2_codes = new InterCodes_;
            label2_codes->code.kind = IR_LABEL;
            label2_codes->code.result = new Operand_(label2, OP_LABEL);

            codes = bindCodes(3, codes1, codes2, label2_codes);
        } else {
            /* Stmt -> IF LP Exp RP Stmt1 ELSE Stmt2 */
            int label2 = newLabel();
            int label3 = newLabel();
            InterCodes codes1 = translate_Cond(exp, -1, label2);
            InterCodes codes2 = translate_Stmt(stmt1);
            InterCodes codes3 = translate_Stmt(stmt1->first_sibling->first_sibling);

            InterCodes label2_codes = new InterCodes_;
            label2_codes->code.kind = IR_LABEL;
            label2_codes->code.result = new Operand_(label2, OP_LABEL);

            InterCodes label3_codes = new InterCodes_;
            label3_codes->code.kind = IR_LABEL;
            label3_codes->code.result = new Operand_(label3, OP_LABEL);

            InterCodes goto3_codes = new InterCodes_;
            goto3_codes->code.kind = IR_GOTO;
            goto3_codes->code.result = new Operand_(label3, OP_LABEL);

            codes = bindCodes(6, codes1, codes2, goto3_codes, label2_codes, codes3, label3_codes);
        }
    }
    return codes;
}

InterCodes translate_Cond(Ast exp, int label_true, int label_false) {
    idebug("translate_Cond");
    InterCodes codes = NULL;
    Ast child1 = exp->first_child;
    Ast child2 = child1->first_sibling;
    if (child2 && child2->tag == TAG_RELOP) {
        /* Exp -> Exp1 RELOP Exp2 */
        idebug("Exp -> Exp1 RELOP Exp2");
        Operand place_op1 = new Operand_(newTemp());
        Operand place_op2 = new Operand_(newTemp());
        InterCodes codes1 = translate_Exp(child1, place_op1);
        InterCodes codes2 = translate_Exp(child2->first_sibling, place_op2);
        InterCodes codes3 = NULL;
        string op = getRelop(child2);
        if (label_true != -1 && label_false != -1) {
            InterCodes codes31 = new InterCodes_;
            codes31->code.kind = IR_IF;
            codes31->code.result = new Operand_;
            codes31->code.result->kind = OP_RELOP;
            codes31->code.result->name = op;
            codes31->code.op1 = place_op1;
            codes31->code.op2 = place_op2;
            InterCodes codes32 = new InterCodes_;
            codes32->code.kind = IR_GOTO;
            codes32->code.result = new Operand_(label_true, OP_LABEL);
            InterCodes codes_goto = new InterCodes_;
            codes_goto->code.kind = IR_GOTO;
            codes_goto->code.result = new Operand_(label_false, OP_LABEL);
            codes3 = bindCodes(3, codes31, codes32, codes_goto);
        } else if (label_true != -1) {
            InterCodes codes31 = new InterCodes_;
            codes31->code.kind = IR_IF;
            codes31->code.result = new Operand_;
            codes31->code.result->kind = OP_RELOP;
            codes31->code.result->name = op;
            codes31->code.op1 = place_op1;
            codes31->code.op2 = place_op2;
            InterCodes codes32 = new InterCodes_;
            codes32->code.kind = IR_GOTO;
            codes32->code.result = new Operand_(label_true, OP_LABEL);
            codes3 = bindCodes(2, codes31, codes32);
        } else if (label_false != -1) {
            op = getOppRelop(child2);
            InterCodes codes31 = new InterCodes_;
            codes31->code.kind = IR_IF;
            codes31->code.result = new Operand_;
            codes31->code.result->kind = OP_RELOP;
            codes31->code.result->name = op;
            codes31->code.op1 = place_op1;
            codes31->code.op2 = place_op2;
            InterCodes codes32 = new InterCodes_;
            codes32->code.kind = IR_GOTO;
            codes32->code.result = new Operand_(label_false, OP_LABEL);
            codes3 = bindCodes(2, codes31, codes32);
        }
        codes = bindCodes(3, codes1, codes2, codes3);
    } else if (child2 && child2->tag == TAG_AND) {
        /* Exp -> Exp1 AND Exp2 */
        idebug("Exp -> Exp1 AND Exp2");
        int label1;
        if (label_false != -1) {
            label1 = label_false;
        } else {
            label1 = newLabel();
        }
        InterCodes codes1 = translate_Cond(child1, -1, label1);
        InterCodes codes2 = translate_Cond(child2->first_sibling, label_true, label_false);
        if (label_false != -1) {
            codes = bindCodes(2, codes1, codes2);
        } else {
            InterCodes label1_codes = new InterCodes_;
            label1_codes->code.kind = IR_LABEL;
            label1_codes->code.result = new Operand_(label1, OP_LABEL);
            codes = bindCodes(3, codes1, codes2, label1_codes);
        }
    } else if (child2 && child2->tag == TAG_OR) {
        /* Exp -> Exp1 OR Exp2 */
        idebug("Exp -> Exp1 OR Exp2");
        int label1;
        if (label_true != -1) {
            label1 = label_true;
        } else {
            label1 = newLabel();
        }
        InterCodes codes1 = translate_Cond(child1, label1, -1);
        InterCodes codes2 = translate_Cond(child2->first_sibling, label_true, label_false);
        if (label_true != -1) {
            codes = bindCodes(2, codes1, codes2);
        } else {
            InterCodes label1_codes = new InterCodes_;
            label1_codes->code.kind = IR_LABEL;
            label1_codes->code.result = new Operand_(label1, OP_LABEL);
            codes = bindCodes(3, codes1, codes2, label1_codes);
        }
    } else if (child1->tag == TAG_NOT) {
        /* Exp -> NOT Exp1 */
        idebug("Exp -> NOT Exp1");
        codes = translate_Cond(child2, label_false, label_true);
    } else if (child1->tag == TAG_LP) {
        /* Exp -> LP Exp1 RP */
        idebug("Exp -> LP Exp1 RP");
        codes = translate_Cond(child2, label_true, label_false);
    } else {
        /* other cases */
        idebug("other cases");
        Operand place_op1 = new Operand_(newTemp());
        InterCodes codes1 = translate_Exp(exp, place_op1);

        if (label_true != -1 && label_false != -1) {
            InterCodes codes21 = new InterCodes_;
            codes21->code.kind = IR_IF;
            codes21->code.result = new Operand_;
            codes21->code.result->kind = OP_RELOP;
            codes21->code.result->name = "!=";
            codes21->code.op1 = place_op1;
            codes21->code.op2 = new Operand_(0, OP_CONSTANT);
            InterCodes codes22 = new InterCodes_;
            codes22->code.kind = IR_GOTO;
            codes22->code.result = new Operand_(label_true, OP_LABEL);
            InterCodes codes2 = bindCodes(2, codes21, codes22);
            InterCodes codes_goto = new InterCodes_;
            codes_goto->code.kind = IR_GOTO;
            codes_goto->code.result = new Operand_(label_false, OP_LABEL); 
            codes = bindCodes(3, codes1, codes2, codes_goto);
        } else if (label_true != -1) {
            InterCodes codes21 = new InterCodes_;
            codes21->code.kind = IR_IF;
            codes21->code.result = new Operand_;
            codes21->code.result->kind = OP_RELOP;
            codes21->code.result->name = "!=";
            codes21->code.op1 = place_op1;
            codes21->code.op2 = new Operand_(0, OP_CONSTANT);
            InterCodes codes22 = new InterCodes_;
            codes22->code.kind = IR_GOTO;
            codes22->code.result = new Operand_(label_true, OP_LABEL);
            InterCodes codes2 = bindCodes(2, codes21, codes22);
            codes = bindCodes(2, codes1, codes2);
        } else if (label_false != -1) {
            InterCodes codes21 = new InterCodes_;
            codes21->code.kind = IR_IF;
            codes21->code.result = new Operand_;
            codes21->code.result->kind = OP_RELOP;
            codes21->code.result->name = "==";
            codes21->code.op1 = place_op1;
            codes21->code.op2 = new Operand_(0, OP_CONSTANT);
            InterCodes codes22 = new InterCodes_;
            codes22->code.kind = IR_GOTO;
            codes22->code.result = new Operand_(label_false, OP_LABEL);
            InterCodes codes2 = bindCodes(2, codes21, codes22);
            codes = bindCodes(2, codes1, codes2);
        } 
    }
    return codes;
}

InterCodes translate_Exp(Ast exp, Operand place_op) {
    idebug("translate_Exp");
    assert(exp->tag == TAG_EXP);
    InterCodes codes = NULL;
    Ast child1 = exp->first_child;
    Ast child2 = child1->first_sibling;
    Variable var = NULL;
    if (!child2) {
        switch (child1->tag) {
            case TAG_ID:
                /* Exp -> ID */
                idebug("Exp -> ID");
                place_op->kind = OP_VARIABLE;
                var = lookup(child1->u.str);
                place_op->val = var->var_no;
                place_op->name = var->name;
                codes = new InterCodes_;
                codes->code.kind = IR_DUMMY;
                break;
            case TAG_INT:
                /* Exp -> INT */
                idebug("Exp -> INT");
                place_op->kind = OP_CONSTANT;
                place_op->val = child1->u.ival;
                codes = new InterCodes_;
                codes->code.kind = IR_DUMMY;
                break;
            case TAG_FLOAT:
                /* Exp -> FLOAT */
                assert(0);
            default:
                assert(0);
        }
    } else if (child1->tag == TAG_EXP && child2->first_sibling && child2->first_sibling->tag == TAG_EXP && child2->tag != TAG_LB) {
        Operand place_op1 = NULL, place_op2 = NULL;
        InterCodes codes1 = NULL, codes2 = NULL, codes3 = NULL, codes4=NULL;
        switch (child2->tag) {
            case TAG_ASSIGNOP:
                /* Exp -> Exp1 ASSIGNOP Exp2 */
                idebug("Exp -> Exp1 ASSIGNOP Exp2");
                place_op1 = new Operand_(newTemp());
                place_op2 = new Operand_(newTemp());
                codes1 = translate_Exp(child1, place_op1);
                codes2 = translate_Exp(child2->first_sibling, place_op2);

                if (place_op2->attr == OP_BASIC && place_op2->kind == OP_TEMP && place_op1->attr == OP_BASIC) {
                    place_op2->attr = place_op1->attr;
                    place_op2->kind = place_op1->kind;
                    place_op2->name = place_op1->name;
                    place_op2->val = place_op1->val;
                } else {
                    codes3 = new InterCodes_;
                    codes3->code.kind = IR_ASSIGN;
                    codes3->code.result = place_op1;
                    codes3->code.op1 = place_op2;
                }
                codes4 = new InterCodes_;
                codes4->code.kind = IR_ASSIGN;
                codes4->code.result = place_op;
                codes4->code.op1 = place_op1;

                codes = bindCodes(4, codes1, codes2, codes3, codes4);
                break;
            case TAG_AND:
                /* Exp -> Exp1 AND Exp2 */
                idebug("Exp -> Exp1 AND Exp2");
                codes = translate_ExpCond(exp, place_op);
                break;
            case TAG_OR:
                /* Exp -> Exp1 OR Exp2 */
                idebug("Exp -> Exp1 OR Exp2");
                codes = translate_ExpCond(exp, place_op);
                break;
            case TAG_PLUS:
                /* Exp -> Exp1 PLUS Exp2 */
                idebug("Exp -> Exp1 PLUS Exp2");
                place_op1 = new Operand_(newTemp());
                place_op2 = new Operand_(newTemp());
                codes1 = translate_Exp(child1, place_op1);
                codes2 = translate_Exp(child2->first_sibling, place_op2);
                if (place_op1->kind == OP_CONSTANT && place_op2->kind == OP_CONSTANT) {
                    /* Z = C1 + C2 */
                    codes = new InterCodes_;
                    codes->code.kind = IR_DUMMY;
                    place_op->kind = OP_CONSTANT;
                    place_op->val = place_op1->val + place_op2->val;
                } else if (place_op2->kind == OP_CONSTANT && place_op2->val == 0) {
                    /* Z = X + 0 */
                    codes3 = new InterCodes_;
                    codes3->code.kind = IR_ASSIGN;
                    codes3->code.result = place_op;
                    codes3->code.op1 = place_op1;
                    codes = bindCodes(2, codes1, codes3);
                } else if (place_op1->kind == OP_CONSTANT && place_op1->val == 0) {
                    /* Z = 0 + X */
                    codes3 = new InterCodes_;
                    codes3->code.kind = IR_ASSIGN;
                    codes3->code.result = place_op;
                    codes3->code.op1 = place_op2;
                    codes = bindCodes(2, codes2, codes3);
                } else {
                    /* Z = X + Y */
                    codes3 = new InterCodes_;
                    codes3->code.kind = IR_ADD;
                    codes3->code.result = place_op;
                    codes3->code.op1 = place_op1;
                    codes3->code.op2 = place_op2;
                    codes = bindCodes(3, codes1, codes2, codes3);
                }
                break;
            case TAG_MINUS:
                /* Exp -> Exp1 MINUS Exp2 */
                idebug("Exp -> Exp1 MINUS Exp2");
                place_op1 = new Operand_(newTemp());
                place_op2 = new Operand_(newTemp());
                codes1 = translate_Exp(child1, place_op1);
                codes2 = translate_Exp(child2->first_sibling, place_op2);
                if (place_op1->kind == OP_CONSTANT && place_op2->kind == OP_CONSTANT) {
                    /* Z  = C1 - C2 */
                    codes = new InterCodes_;
                    codes->code.kind = IR_DUMMY;
                    place_op->kind = OP_CONSTANT;
                    place_op->val = place_op1->val - place_op2->val;
                } else if (place_op2->kind == OP_CONSTANT && place_op2->val == 0) {
                    /* Z = X - 0 */
                    codes3 = new InterCodes_;
                    codes3->code.kind = IR_ASSIGN;
                    codes3->code.result = place_op;
                    codes3->code.op1 = place_op1;
                    codes = bindCodes(2, codes1, codes3);
                } else {
                    /* Z = X - Y */
                    codes3 = new InterCodes_;
                    codes3->code.kind = IR_SUB;
                    codes3->code.result = place_op;
                    codes3->code.op1 = place_op1;
                    codes3->code.op2 = place_op2;
                    codes = bindCodes(3, codes1, codes2, codes3);
                }
                break;
            case TAG_STAR:
                /* Exp -> Exp1 STAR Exp2 */
                idebug("Exp -> Exp1 STAR Exp2");
                place_op1 = new Operand_(newTemp());
                place_op2 = new Operand_(newTemp());
                codes1 = translate_Exp(child1, place_op1);
                codes2 = translate_Exp(child2->first_sibling, place_op2);
                if (place_op1->kind == OP_CONSTANT && place_op2->kind == OP_CONSTANT) {
                    /* Z = C1 * C2 */
                    codes = new InterCodes_;
                    codes->code.kind = IR_DUMMY;
                    place_op->kind = OP_CONSTANT;
                    place_op->val = place_op1->val * place_op2->val;
                } else if (place_op2->kind == OP_CONSTANT && place_op2->val == 1) {
                    /* Z = X * 1 */
                    codes3 = new InterCodes_;
                    codes3->code.kind = IR_ASSIGN;
                    codes3->code.result = place_op;
                    codes3->code.op1 = place_op1;
                    codes = bindCodes(2, codes1, codes3);
                } else if (place_op1->kind == OP_CONSTANT && place_op1->val == 1) {
                    /* Z = 1 * X */
                    codes3 = new InterCodes_;
                    codes3->code.kind = IR_ASSIGN;
                    codes3->code.result = place_op;
                    codes3->code.op1 = place_op2;
                    codes = bindCodes(2, codes2, codes3);
                } else if ((place_op1->kind == OP_CONSTANT && place_op1->val == 0) || (place_op2->kind == OP_CONSTANT && place_op2->val == 0)) {
                    /* Z = 0 * X  or  Z = X * 0 */
                    codes = new InterCodes_;
                    codes->code.kind = IR_DUMMY;
                    place_op->kind = OP_CONSTANT;
                    place_op->val = 0;
                } else {
                    /* Z = X * Y */
                    codes3 = new InterCodes_;
                    codes3->code.kind = IR_MUL;
                    codes3->code.result = place_op;
                    codes3->code.op1 = place_op1;
                    codes3->code.op2 = place_op2;
                    codes = bindCodes(3, codes1, codes2, codes3);
                }
                break;
            case TAG_DIV:
                /* Exp -> Exp1 DIV Exp2 */
                idebug("Exp -> Exp1 DIV Exp2");
                place_op1 = new Operand_(newTemp());
                place_op2 = new Operand_(newTemp());
                codes1 = translate_Exp(child1, place_op1);
                codes2 = translate_Exp(child2->first_sibling, place_op2);
                if (place_op1->kind == OP_CONSTANT && place_op2->kind == OP_CONSTANT) {
                    /* Z = C1 / C2 */
                    codes = new InterCodes_;
                    codes->code.kind = IR_DUMMY;
                    place_op->kind = OP_CONSTANT;
                    assert(place_op2->val != 0);
                    place_op->val = place_op1->val / place_op2->val;
                } else if (place_op2->kind == OP_CONSTANT && place_op2->val == 1) {
                    /* Z = X / 1 */
                    codes3 = new InterCodes_;
                    codes3->code.kind = IR_ASSIGN;
                    codes3->code.result = place_op;
                    codes3->code.op1 = place_op1;
                    codes = bindCodes(2, codes2, codes3);
                } else if (place_op1->kind == OP_CONSTANT && place_op1->val == 0) {
                    /* Z = 0 / C1 */
                    codes = new InterCodes_;
                    codes->code.kind = IR_DUMMY;
                    place_op->kind = OP_CONSTANT;
                    place_op->val = 0;
                } else {
                    /* Z = X / Y */
                    codes3 = new InterCodes_;
                    codes3->code.kind = IR_DIV;
                    codes3->code.result = place_op;
                    codes3->code.op1 = place_op1;
                    codes3->code.op2 = place_op2;
                    codes = bindCodes(3, codes1, codes2, codes3);
                }
                break;
            case TAG_RELOP:
                /* Exp -> Exp1 RELOP Exp2 */
                idebug("Exp -> Exp1 RELOP Exp2");
                codes = translate_ExpCond(exp, place_op);
                break;
            default:
                assert(0);
        }
    } else if (child1->tag == TAG_NOT) {
        /* Exp -> NOT Exp1 */
        idebug("Exp -> NOT Exp1");
        codes = translate_ExpCond(exp, place_op);
    } else if (child1->tag == TAG_MINUS) {
        /* Exp -> MINUS Exp1 */
        idebug("Exp -> MINUS Exp1");
        Operand place_op1 = new Operand_(newTemp());
        InterCodes codes1 = translate_Exp(child2, place_op1);
        if (place_op1->kind == OP_CONSTANT) {
            place_op->kind = OP_CONSTANT;
            place_op->val = -place_op1->val;
            codes = new InterCodes_;
            codes->code.kind = IR_DUMMY;
        } else {
            InterCodes codes2 = new InterCodes_;
            codes2->code.kind = IR_SUB;
            codes2->code.result = place_op;
            codes2->code.op1 = new Operand_(0, OP_CONSTANT);
            codes2->code.op2 = place_op1;
            codes = bindCodes(2, codes1, codes2);
        }
    }
    else if (child2->tag == TAG_LP) { // call function
        string func_name = child1->u.str;
        if (func_name == "read") {
            codes = new InterCodes_;
            codes->code.kind = IR_READ;
            codes->code.result = place_op;
        } else if (func_name == "write") {
            Ast args = child2->first_sibling;
            assert(args->tag == TAG_ARGS);
            Ast exp = args->first_child;
            assert(!exp->first_sibling);
            Operand place_op1 = new Operand_(newTemp());
            InterCodes codes1 = translate_Exp(exp, place_op1);
            codes = new InterCodes_;
            codes->code.kind = IR_WRITE;
            codes->code.result = place_op;
            codes->code.op1 = place_op1;
            codes = bindCodes(2, codes1, codes);
        } else {
            /* Exp -> ID LP Args RP   or   Exp -> ID LP RP */
            idebug("Exp -> ID LP Args RP   or   Exp -> ID LP RP");
            InterCodes codes1 = NULL;

            if (child2->first_sibling->tag == TAG_ARGS) {
                /* ARG xx */
                codes1 = translate_Args(child2->first_sibling);
            }

            /* CALL xx */
            InterCodes codes2 = new InterCodes_;
            codes2->code.kind = IR_CALL;
            codes2->code.result = place_op;
            if (place_op->val == -1) {
                int t1 = newTemp();
                place_op->val = t1;
            }
            codes2->code.op1 = new Operand_;
            codes2->code.op1->kind = OP_FUNCTION;
            codes2->code.op1->name = child1->u.str;
            
            codes = bindCodes(2, codes1, codes2);
        }
    } else if (child1->tag == TAG_LP) {
        /* Exp -> LP Exp1 RP */
        idebug("Exp -> LP Exp1 RP");
        codes = translate_Exp(child2, place_op);
    } else if (child2->tag == TAG_LB) {
        /* Exp -> Exp1 LB Exp2 RB */
        /* Array */
        idebug("Exp -> Exp1 LB Exp2 RB");
        Variable var = lookup(getExpId(child1));
        Operand place_op1 = new Operand_(newTemp());
        Type type = getExpType(exp);
        InterCodes codes1 = getOffset(type, exp, place_op1);
        InterCodes codes2 = new InterCodes_;
        codes2->code.kind = IR_ADD;
        codes2->code.result = new Operand_(place_op->val, place_op->kind);
        if (var->func_param) {
            codes2->code.op1 = new Operand_(var->var_no, OP_VARIABLE);
        } else {
            codes2->code.op1 = new Operand_(var->var_no, OP_VARIABLE, OP_ADDRESS);
        }
        codes2->code.op2 = place_op1;
        if (type->u.array.elem->kind == BASIC) {
            place_op->attr = OP_POINTER;
        }
        codes = bindCodes(2, codes1, codes2);

    } else if (child2->tag == TAG_DOT) {
        /* Exp -> Exp1 DOT ID */
        /* Structure */

        Variable var = lookup(getExpId(child1));
        Operand place_op1 = new Operand_(newTemp());
        Type type = getExpType(exp);
        InterCodes codes1 = getOffset(type, exp, place_op1);
        InterCodes codes2 = new InterCodes_;
        codes2->code.kind = IR_ADD;
        codes2->code.result = new Operand_(place_op->val, place_op->kind);
        if (var->func_param) {
            codes2->code.op1 = new Operand_(var->var_no, OP_VARIABLE);
        } else {
            codes2->code.op1 = new Operand_(var->var_no, OP_VARIABLE, OP_ADDRESS);
        }
        codes2->code.op2 = place_op1;
        // id type
        Type id_type = NULL;
        for (vector<Field>::iterator iter = type->u.structure.fieldList.begin(); iter != type->u.structure.fieldList.end(); iter++) {
            id_type = (*iter)->type;
        }
        assert(id_type);
        if (id_type->kind == BASIC) {
            place_op->attr = OP_POINTER;
        }
        codes = bindCodes(2, codes1, codes2);
    } else {
        /* TODO */
        cout << "More Exp" << endl;
        assert(0);
    }
    assert(codes);
    return codes;
}

InterCodes translate_Args(Ast args) {
    idebug("translate_Args");
    InterCodes codes = NULL;
    Ast exp = args->first_child;

    Operand place_op1 = new Operand_(newTemp());
    InterCodes codes1 = translate_Exp(exp, place_op1);
    InterCodes codes2 = new InterCodes_;
    codes2->code.kind = IR_ARG;
    //codes2->code.result = new Operand_(place_op1->val, place_op1->kind);
    codes2->code.result = place_op1;
    if (place_op1->kind == OP_VARIABLE) {
        Variable var = lookup(place_op1->name);
        if (!var->func_param && (var->type->kind == ARRAY || var->type->kind == STRUCTURE)) {
            codes2->code.result->attr = OP_ADDRESS;
        }
    }
    codes = bindCodes(2, codes1, codes2);
    if (exp->first_sibling) {
        InterCodes codes3 = translate_Args(exp->first_sibling->first_sibling);
        codes = bindCodes(2, codes3, codes);
    }
    return codes;
}


InterCodes translate_ExpCond(Ast exp, Operand place_op) {
    idebug("translate_ExpCond");

    int label1 = newLabel();
    int label2 = newLabel();

    InterCodes codes0 = new InterCodes_;
    codes0->code.kind = IR_ASSIGN;
    //codes0->code.result = new Operand_(place_op->val, place_op->kind);
    codes0->code.result = place_op;
    codes0->code.op1 = new Operand_(0, OP_CONSTANT);

    InterCodes codes1 = translate_Cond(exp, label1, label2);
    
    InterCodes label1_codes = new InterCodes_;
    label1_codes->code.kind = IR_LABEL;
    label1_codes->code.result = new Operand_(label1, OP_LABEL);
    
    InterCodes place_codes = new InterCodes_;
    place_codes->code.kind = IR_ASSIGN;
    //place_codes->code.result = new Operand_(place_op->val, place_op->kind);
    place_codes->code.result = place_op;
    place_codes->code.op1 = new Operand_(1, OP_CONSTANT);

    InterCodes codes2 = bindCodes(2, label1_codes, place_codes);

    InterCodes label2_codes = new InterCodes_;
    label2_codes->code.kind = IR_LABEL;
    label2_codes->code.result = new Operand_(label2, OP_LABEL);

    return bindCodes(4, codes0, codes1, codes2, label2_codes);
}
 
Variable lookup(string name) {
    map<string, Variable>::iterator iter = var_table.find(name);
    if (iter == var_table.end()) {
        assert(0);
        return NULL;
    } else {
        return iter->second;
    }
}

string getExpId(Ast exp) {
    Ast child = exp->first_child;
    Ast sibling = child->first_sibling;
    if (!sibling && child->tag == TAG_ID) {
        return child->u.str;
    }
    if (child->tag == TAG_LP) {
        return getExpId(sibling);
    }
    if (sibling) {
       if (sibling->tag == TAG_LB) {
           return getExpId(child);
       } else if (sibling->tag == TAG_DOT) {
           return getExpId(child);
       }
    }
    assert(0);
}

string getExpId(Ast exp, vector<string>& v) {
    Ast child = exp->first_child;
    Ast sibling = child->first_sibling;
    if (!sibling && child->tag == TAG_ID) {
        v.push_back("0");
        return child->u.str;
    }
    if (child->tag == TAG_LP) {
        return getExpId(sibling, v);
    }
    if (sibling) {
       if (sibling->tag == TAG_LB) {
           v.push_back("[]");
           return getExpId(child, v);
       } else if (sibling->tag == TAG_DOT) {
           v.push_back(sibling->first_sibling->u.str);
           return getExpId(child, v);
       }
    }
    assert(0);
}

int getTypeSize(Type type){
    if (type->kind == BASIC) {
        if (type->u.basic == BASIC_INT) {
            return 4;
        } else {
            assert(0);
        }
    } else if (type->kind == ARRAY){
        int size = getTypeSize(type->u.array.elem);
        for (vector<int>::iterator iter = type->u.array.size_list.begin(); iter != type->u.array.size_list.end(); iter++) {
            size *= *iter;
        }
        return size;
    } else if (type->kind == STRUCTURE) {
        int size = 0;
        for (vector<Field>::iterator iter = type->u.structure.fieldList.begin(); iter != type->u.structure.fieldList.end(); iter++) {
            size += getTypeSize((*iter)->type);
        }
        return size;
    } 
    else {
        assert(0);
    }
}

void  copyElemType(Type dest, Type src) {
    assert(src->dim > 0);
    int dim = src->dim - 1;
    if (dim == 0) {
        copyType(dest, src->u.array.elem);
    } else {
        copyType(dest, src);
        dest->dim--;
        //dest->u.array.size_list.erase(dest->u.array.size_list.begin());
    }
}

Type getExpType(Ast exp) {
    idebug("getExpType");
    vector<string> v;
    Variable var = lookup(getExpId(exp, v));
    Type type = var->type;
    Type ret = var->type;
    for (int i = v.size() - 1; i >= 0; i--) {
        if (i == 0 && v[i] == "[]") {
            ret = type;
        }
        if (v[i] != "[]" && v[i] != "0") {
            assert(type->kind == STRUCTURE || type->kind == ARRAY);
            if (type->kind == ARRAY) {
                type = type->u.array.elem;
            }
            ret = type;
            for (vector<Field>::iterator iter = type->u.structure.fieldList.begin(); iter != type->u.structure.fieldList.end(); iter++) {
                if ((*iter)->name == v[i]) {
                    type = (*iter)->type;
                    break;
                }
            }
        }
    }
    return ret;
}

InterCodes getOffset(Type type, Ast exp, Operand place_op) {
    InterCodes codes = NULL;
    if (type->kind == BASIC) {
        assert(0);
    } else if (type->kind == ARRAY) {
        /* Exp -> Exp1 LB Exp2 RB */
        idebug("getOffset: ARRAY");
        Ast exp1 = exp->first_child;
        Ast exp2 = exp1->first_sibling->first_sibling;
        Operand place_op0 = NULL;
        InterCodes codes0 = NULL;
        if (exp1->first_child->tag == TAG_ID) {
            place_op0 = new Operand_(0, OP_CONSTANT);
        }
        else if (exp1->first_child->first_sibling->tag == TAG_DOT) {
            place_op0 = new Operand_(newTemp());
            codes0 = getOffset(getExpType(exp1), exp1, place_op0);
        } else {
            Type t = new Type_;
            copyType(t, type);
            t->dim--;
            place_op0 = new Operand_(newTemp());
            codes0 = getOffset(t, exp1, place_op0);
        }


        int total_size = getTypeSize(type->u.array.elem);
        for (int i = type->dim; i < type->u.array.size_list.size(); i++) {
            total_size *= type->u.array.size_list[i - type->dim];
        }

        Operand place_op1 = new Operand_(newTemp());
        InterCodes codes1 = translate_Exp(exp2, place_op1);
        if (place_op1->kind == OP_CONSTANT && place_op0->kind == OP_CONSTANT) {
            place_op->val = place_op1->val * total_size + place_op0->val;
            place_op->kind = OP_CONSTANT;
        } else if (place_op0->kind == OP_CONSTANT) {
            int val = place_op0->val;
            if (val == 0) {
                InterCodes codes2 = new InterCodes_;
                codes2->code.kind = IR_MUL;
                codes2->code.result = new Operand_(place_op->val, place_op->kind);
                codes2->code.op1 = place_op1;
                codes2->code.op2 = new Operand_(total_size, OP_CONSTANT);           
                codes = bindCodes(3, codes0, codes1, codes2);
            } else {
                InterCodes codes2 = new InterCodes_;
                codes2->code.kind = IR_MUL;
                Operand place_op2 = new Operand_(newTemp());
                codes2->code.result = new Operand_(place_op2->val, place_op2->kind);
                codes2->code.op1 = place_op1;
                codes2->code.op2 = new Operand_(total_size, OP_CONSTANT);       
                
                InterCodes codes3 = new InterCodes_;
                codes3->code.kind = IR_ADD; 
                codes3->code.result = new Operand_(place_op->val, place_op->kind);
                codes3->code.op1 = new Operand_(val, OP_CONSTANT);
                // codes3->code.op2 = new Operand_(place_op2->val, place_op2->kind);
                codes3->code.op2 = place_op2;
                codes = bindCodes(4, codes0, codes1, codes2, codes3);
            }
        } else if (place_op1->kind == OP_CONSTANT) {
            place_op1->val *= total_size;
            InterCodes codes3 = new InterCodes_;
            codes3->code.kind = IR_ADD; 
            codes3->code.result = new Operand_(place_op->val, place_op->kind);
            codes3->code.op1 = new Operand_(place_op0->val, place_op0->kind);
            codes3->code.op2 = new Operand_(place_op1->val, place_op1->kind);
            codes = bindCodes(3, codes0, codes1, codes3);
        } else {
            InterCodes codes2 = new InterCodes_;
            codes2->code.kind = IR_MUL;
            Operand place_op2 = new Operand_(newTemp());
            codes2->code.result = new Operand_(place_op2->val, place_op2->kind);
            //codes2->code.op1 = new Operand_(place_op1->val, place_op1->kind);
            codes2->code.op1 = place_op1;
            codes2->code.op2 = new Operand_(total_size, OP_CONSTANT);       
            InterCodes codes3 = new InterCodes_;
            codes3->code.kind = IR_ADD; 
            codes3->code.result = new Operand_(place_op->val, place_op->kind);
            codes3->code.op1 = new Operand_(place_op0->val, place_op0->kind);
            codes3->code.op2 = new Operand_(place_op2->val, place_op2->kind);
            codes = bindCodes(4, codes0, codes1, codes2, codes3);
        }
    } else if (type->kind == STRUCTURE) {
        /* Exp -> Exp1 DOT ID */
        idebug("getOffset: STRUCT");
        Ast exp1 = exp->first_child;
        Ast id = exp1->first_sibling->first_sibling;
        string name = id->u.str;
        int offset = 0;
        for (vector<Field>::iterator iter = type->u.structure.fieldList.begin(); iter != type->u.structure.fieldList.end(); iter++) {
            if ((*iter)->name == name) {
                break;
            } else {
                offset += getTypeSize((*iter)->type);
            }
        }
        if (exp1->first_child->tag == TAG_ID) {
            place_op->kind = OP_CONSTANT;
            place_op->val = offset;
            return NULL;
        }
        Operand place_op0 = new Operand_(newTemp());
        InterCodes codes0 = getOffset(getExpType(exp1), exp1, place_op0);
        if (place_op0->kind == OP_CONSTANT) {
            place_op->kind = OP_CONSTANT;
            place_op->val = offset + place_op0->val;
        } else {
            codes = new InterCodes_;
            codes->code.kind = IR_ADD;
            codes->code.result = new Operand_(place_op->val, place_op->kind);
            codes->code.op1 = new Operand_(place_op0->val, place_op0->kind);
            codes->code.op2 = new Operand_(offset, OP_CONSTANT);
            codes = bindCodes(2, codes0, codes);
        }
    } else {
        assert(0);
    }
    return codes;
}


InterCodes getOffset(Type type, Ast exp, Operand place_op, float x) {
    idebug("getOffset");
    InterCodes codes = NULL;

    if (type->kind == ARRAY) {
        /* Exp -> Exp1 LB Exp2 RB */
        int total_size = getTypeSize(type->u.array.elem);
        Ast exp1 = exp->first_child;
        vector<int>::iterator iter = type->u.array.size_list.begin();
        while (exp1->tag != TAG_ID) {
            Ast exp2 = exp1->first_sibling->first_sibling;
            if (exp1->first_child->tag == TAG_LP) {
                exp1 = exp1->first_child->first_sibling->first_child;
                continue;
            }
            Operand place_op1 = new Operand_(newTemp());
            InterCodes codes1 = translate_Exp(exp2, place_op1);
            if (place_op1->kind == OP_CONSTANT && place_op->kind == OP_CONSTANT) {
                place_op->val = place_op1->val * total_size + place_op->val;
            } else if (place_op->kind == OP_CONSTANT) {
                int val = place_op->val;
                place_op->val = newTemp();
                place_op->kind = OP_TEMP;
                if (val == 0) {
                    InterCodes codes2 = new InterCodes_;
                    codes2->code.kind = IR_MUL;
                    codes2->code.result = new Operand_(place_op->val, place_op->kind);
                    //codes2->code.op1 = new Operand_(place_op1->val, place_op1->kind);
                    codes2->code.op1 = place_op1;
                    codes2->code.op2 = new Operand_(total_size, OP_CONSTANT);           
                    codes = bindCodes(3, codes, codes1, codes2);
                } else {
                    InterCodes codes2 = new InterCodes_;
                    codes2->code.kind = IR_MUL;
                    Operand place_op2 = new Operand_(newTemp());
                    codes2->code.result = new Operand_(place_op2->val, place_op2->kind);
                    // codes2->code.op1 = new Operand_(place_op1->val, place_op1->kind);
                    codes2->code.op1 = place_op1;
                    codes2->code.op2 = new Operand_(total_size, OP_CONSTANT);       
                    InterCodes codes3 = new InterCodes_;
                    codes3->code.kind = IR_ADD; 
                    codes3->code.result = new Operand_(place_op->val, place_op->kind);
                    codes3->code.op1 = new Operand_(val, OP_CONSTANT);
                    // codes3->code.op2 = new Operand_(place_op2->val, place_op2->kind);
                    codes3->code.op2 = place_op2;
                    codes = bindCodes(4, codes, codes1, codes2, codes3);
                }
            } else if (place_op1->kind == OP_CONSTANT) {
                place_op1->val *= total_size;
                InterCodes codes3 = new InterCodes_;
                codes3->code.kind = IR_ADD; 
                codes3->code.result = new Operand_(place_op->val, place_op->kind);
                codes3->code.op1 = new Operand_(place_op->val, place_op->kind);
                codes3->code.op2 = new Operand_(place_op1->val, place_op1->kind);
                codes = bindCodes(3, codes, codes1, codes3);
            } else {
                InterCodes codes2 = new InterCodes_;
                codes2->code.kind = IR_MUL;
                Operand place_op2 = new Operand_(newTemp());
                codes2->code.result = new Operand_(place_op2->val, place_op2->kind);
                //codes2->code.op1 = new Operand_(place_op1->val, place_op1->kind);
                codes2->code.op1 = place_op1;
                codes2->code.op2 = new Operand_(total_size, OP_CONSTANT);       
                InterCodes codes3 = new InterCodes_;
                codes3->code.kind = IR_ADD; 
                codes3->code.result = new Operand_(place_op->val, place_op->kind);
                codes3->code.op1 = new Operand_(place_op->val, place_op->kind);
                codes3->code.op2 = new Operand_(place_op2->val, place_op2->kind);
                codes = bindCodes(4, codes, codes1, codes2, codes3);
            }
            exp1 = exp1->first_child;
            total_size *= *iter;
            iter++;
        }

    } else if (type->kind == STRUCTURE) {
        string name = exp->first_child->first_sibling->first_sibling->u.str;
        for (vector<Field>::iterator iter = type->u.structure.fieldList.begin(); iter != type->u.structure.fieldList.begin(); iter++) {
            if ((*iter)->name == name) {
                assert(place_op->kind == OP_CONSTANT);
                return codes;
            } else {
                assert(place_op->kind == OP_CONSTANT);
                place_op->val += getTypeSize((*iter)->type);
            }
        }
    } else {
        assert(0);
    }
    return codes;
}


string getOpVal(Operand op) {
    string val;
    if (op->attr == OP_ADDRESS) {
        val = "&";
    } else if (op->attr == OP_POINTER) {
        val = "*";
    }
    if (op->kind == OP_CONSTANT) {
        val += "#" + to_string(op->val);
    } else if (op->kind == OP_VARIABLE) {
    //    assert(op->val != -1);
        val += "v" + to_string(op->val);
    } else if (op->kind == OP_LABEL) {
        val += "label" + to_string(op->val);
    } else if (op->kind == OP_TEMP){
        val += "t" + to_string(op->val);
    } else if (op->kind == OP_FUNCTION) {
        val += op->name;
    } else if (op->kind == OP_BYTE) {
        val += to_string(op->val);
    } else {
        assert(0);
    }
    return val;
}


void gen_ir(Ast program, string filepath) {
    ofstream ofile;
    ofile.open(filepath);
    InterCodes codes = translate_Program(program);
    InterCodes p = codes;
    while (p) {
        switch (p->code.kind) {
            case IR_DUMMY:
                break;
            case IR_FUNC:
                cout << "FUNCTION " << getOpVal(p->code.result) << " :" << endl; 
                ofile << "FUNCTION " << getOpVal(p->code.result) << " :" << endl; 
                break;
            case IR_PARAM:
                cout << "PARAM " << getOpVal(p->code.result) << endl; 
                ofile << "PARAM " << getOpVal(p->code.result) << endl; 
                break;
            case IR_ASSIGN:
                if (p->code.result->val != -1) { cout << getOpVal(p->code.result) << " := " << getOpVal(p->code.op1) << endl; ofile << getOpVal(p->code.result) << " := " << getOpVal(p->code.op1) << endl; }
                break;
            case IR_READ:
                cout << "READ " << getOpVal(p->code.result) << endl; 
                ofile << "READ " << getOpVal(p->code.result) << endl; 
                break;
            case IR_WRITE:
                if (p->code.result->val == -1) { cout << "WRITE " << getOpVal(p->code.op1) << endl; ofile << "WRITE " << getOpVal(p->code.op1) << endl; }
                else { cout << getOpVal(p->code.result) << " := WRITE " << getOpVal(p->code.op1) << endl; ofile << getOpVal(p->code.result) << " := WRITE " << getOpVal(p->code.op1) << endl; }
                break;
            case IR_RETURN:
                cout << "RETURN " << getOpVal(p->code.result) << endl;
                ofile << "RETURN " << getOpVal(p->code.result) << endl;
                break;
            case IR_LABEL:
                cout << "LABEL " << getOpVal(p->code.result) << " :" << endl;
                ofile << "LABEL " << getOpVal(p->code.result) << " :" << endl;
                break;
            case IR_GOTO:
                cout << "GOTO " << getOpVal(p->code.result) << endl;
                ofile << "GOTO " << getOpVal(p->code.result) << endl;
                break;
            case IR_IF:
                cout << "IF " << getOpVal(p->code.op1) << " " << p->code.result->name << " " << getOpVal(p->code.op2);
                ofile << "IF " << getOpVal(p->code.op1) << " " << p->code.result->name << " " << getOpVal(p->code.op2);
                p = p->next;
                assert(p->code.kind == IR_GOTO);
                cout << " GOTO " << getOpVal(p->code.result) << endl;
                ofile << " GOTO " << getOpVal(p->code.result) << endl;
                break;
            case IR_ADD:
                cout << getOpVal(p->code.result) << " := " << getOpVal(p->code.op1) << " + " << getOpVal(p->code.op2) << endl;    
                ofile << getOpVal(p->code.result) << " := " << getOpVal(p->code.op1) << " + " << getOpVal(p->code.op2) << endl;
                break;
            case IR_SUB:
                cout << getOpVal(p->code.result) << " := " << getOpVal(p->code.op1) << " - " << getOpVal(p->code.op2) << endl;
                ofile << getOpVal(p->code.result) << " := " << getOpVal(p->code.op1) << " - " << getOpVal(p->code.op2) << endl;
                break;
            case IR_MUL:
                cout << getOpVal(p->code.result) << " := " << getOpVal(p->code.op1) << " * " << getOpVal(p->code.op2) << endl;
                ofile << getOpVal(p->code.result) << " := " << getOpVal(p->code.op1) << " * " << getOpVal(p->code.op2) << endl;
                break;
            case IR_DIV:
                cout << getOpVal(p->code.result) << " := " << getOpVal(p->code.op1) << " / " << getOpVal(p->code.op2) << endl;
                ofile << getOpVal(p->code.result) << " := " << getOpVal(p->code.op1) << " / " << getOpVal(p->code.op2) << endl;
                break;
            case IR_CALL:
                cout << getOpVal(p->code.result) << " := CALL " << getOpVal(p->code.op1) << endl;
                ofile << getOpVal(p->code.result) << " := CALL " << getOpVal(p->code.op1) << endl;
                break;
            case IR_ARG:
                cout << "ARG " << getOpVal(p->code.result) << endl;
                ofile << "ARG " << getOpVal(p->code.result) << endl;
                break;
            case IR_DEC:
                cout << "DEC " << getOpVal(p->code.result) << " " << getOpVal(p->code.op1) << endl;
                ofile << "DEC " << getOpVal(p->code.result) << " " << getOpVal(p->code.op1) << endl;
                break;
            default:
                assert(0);
                break;
        }
        p = p->next;
    }
    ofile.close();
}
