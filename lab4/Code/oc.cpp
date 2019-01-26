#include "oc.h"
#include <iostream>
#include <string>
#include <initializer_list>
#include <vector>
#include <map>
#include <stack>
using namespace std;

vector<Reg> t_regs(10);
map<string, LocalVar> lv_table;
int spill_idx = 0;
int lv_offset = 0;
int param_offset = 0;
stack<int> arg_off_st;


inline void odebug(string str) {
    cout << "\033[31m" + str + "\033[0m" << endl;
}

void gen_data_seg(ofstream& ofile) {
    emit_code(ofile, ".data");
    emit_code(ofile, "_prompt: .asciiz \"Enter an integer:\"");
    emit_code(ofile, "_ret: .asciiz \"\\n\"");
}

void gen_global_seg(ofstream& ofile) {
    emit_code(ofile, ".globl main");
}

void gen_read_func(ofstream& ofile) {
    emit_code(ofile, "");
    emit_code(ofile, "read:");
    emit_code(ofile, "li $v0, 4");
    emit_code(ofile, "la $a0, _prompt");
    emit_code(ofile, "syscall");
    emit_code(ofile, "li $v0, 5");
    emit_code(ofile, "syscall");
    emit_code(ofile, "jr $ra");
}

void gen_write_func(ofstream& ofile) {
    emit_code(ofile, "");
    emit_code(ofile, "write:");
    emit_code(ofile, "li $v0, 1");
    emit_code(ofile, "syscall");
    emit_code(ofile, "li $v0, 4");
    emit_code(ofile, "la $a0, _ret");
    emit_code(ofile, "syscall");
    emit_code(ofile, "move $v0, $0");
    emit_code(ofile, "jr $ra");
}

string getOpStr(Operand op) {
    string val;
    if (op->kind == OP_CONSTANT) {
        val = to_string(op->val);
    } else if (op->kind == OP_VARIABLE) {
        val = "v" + to_string(op->val);
    } else if (op->kind == OP_LABEL) {
        val = "label" + to_string(op->val);
    } else if (op->kind == OP_TEMP){
        val = "t" + to_string(op->val);
    } else if (op->kind == OP_FUNCTION) {
        val = op->name;
    } else if (op->kind == OP_BYTE) {
        val = to_string(op->val);
    } else {
        assert(0);
    }
    return val;
}

void init_regs() {
    for (int i = 0; i < 10; i++) {
        t_regs[i] = new Reg_("$t" + to_string(i));
    }
}

Reg get_reg(ofstream& ofile, Operand op, bool content) {
    //odebug("get_reg");
    
    map<string, LocalVar>::iterator iter = lv_table.find(getOpStr(op));
    if (iter != lv_table.end()) {
        //odebug(iter->second->reg->name);
        if (iter->second->reg) {
            Reg reg = iter->second->reg;
            odebug("find reg");
            cout << "reg: " << iter->second->reg->name << endl;
            if (content) {
                if (op->attr == OP_ADDRESS) {
                    cout << reg->lv->name << " " << reg->lv->offset<< endl;
                    emit_code(ofile, "la", {reg->name, to_string(reg->lv->offset) + "($fp)"});
                } else if (op->attr == OP_POINTER) {
                    emit_code(ofile, "lw", {reg->name, to_string(reg->lv->offset) + "($fp)"});
                    emit_code(ofile, "lw", {reg->name, "0(" + reg->name + ")"});
                }
            }
            return iter->second->reg;
        }
    }
    
    Reg reg = NULL;
    int i = 0;
    for (; i < 10; i ++) {
        if (t_regs[i]->avail) {
            /* free reg */
            reg = t_regs[i];
            break;
        }
    }
    if (i == 10) {
        assert(0);
        /* no free reg and spill */
        /*
        int idx = spill_idx + 1;
        while (idx != spill_idx) {
            if (idx >= 10){
                idx = 0;
            }
            if (t_regs[idx]->lock) {
                idx++;
            } else {
                break;
            }
        }
        if (idx == spill_idx) {
            assert(0);
        } else {
            spill_idx = idx;
            reg = t_regs[idx];
            spill_reg(ofile, reg);
        }
        */
    }
    /* allocate reg */
    cout << "allocate reg" << endl;
    reg->avail = false;
    if (op->kind == OP_CONSTANT) {
        emit_code(ofile, "li", {reg->name, to_string(op->val)});
    } else {
        reg->lv = get_lv(ofile, op);
        reg->lv->reg = reg;
        if (content) {
            if (op->attr == OP_ADDRESS) {
                cout << reg->lv->name << " " << reg->lv->offset<< endl;
                emit_code(ofile, "la", {reg->name, to_string(reg->lv->offset) + "($fp)"});
            } else if (op->attr == OP_POINTER) {
                emit_code(ofile, "lw", {reg->name, to_string(reg->lv->offset) + "($fp)"});
                emit_code(ofile, "lw", {reg->name, "0(" + reg->name + ")"});
            } else {
                emit_code(ofile, "lw", {reg->name, to_string(reg->lv->offset) + "($fp)"});
            }
        }
    }
    //odebug("complete get reg");
    assert(reg);
    
    return reg;
}

void spill_reg(ofstream& ofile, Reg reg) {
    //odebug("spill reg");
    assert(reg);
    if (reg->lv) {
        int offset = reg->lv->offset;
        emit_code(ofile, "sw", {reg->name, to_string(reg->lv->offset) + "($fp)"});
        free_reg(reg);
    }
    //odebug("complete spilling");
}

void free_reg(Reg reg) {
    if (reg->lv) {
        reg->lv->reg = NULL;
    }
    reg->avail = true;
    reg->lv = NULL;
}

LocalVar get_lv(std::ofstream& ofile, Operand op) {
    string name = getOpStr(op);
    map<string, LocalVar>::iterator iter = lv_table.find(name);
    if (iter == lv_table.end()) {
        return new_lv(ofile, op);
    } else {
        return iter->second;
    }
}

LocalVar new_lv(ofstream& ofile, Operand op) {
    LV_kind kind;
    if (op->kind == OP_TEMP) {
        kind = LV_TEMP;
    } else if (op->kind == OP_VARIABLE) {
        kind = LV_VARIABLE;
    } else {
        assert(0);
    }
    LocalVar lv = new LocalVar_(kind, getOpStr(op));
    lv->offset = (lv_offset -= 4);
    lv_table.insert(pair<string, LocalVar>(lv->name, lv));
    emit_code(ofile, "addi $sp, $sp, -4"); // allocate
    return lv;
}

void dec_lv(ofstream& ofile, Operand op, int size) {
    LV_kind kind;
    if (op->kind == OP_TEMP) {
        kind = LV_TEMP;
    } else if (op->kind == OP_VARIABLE) {
        kind = LV_VARIABLE;
    } else {
        assert(0);
    }
    LocalVar lv = new LocalVar_(kind, getOpStr(op));
    lv->offset = (lv_offset -= size);
    lv_table.insert(pair<string, LocalVar>(lv->name, lv));
    emit_code(ofile, "addi $sp, $sp, -" + to_string(size)); // allocate
}

void param_lv(Operand op) {
    LV_kind kind;
    if (op->kind == OP_TEMP) {
        kind = LV_TEMP;
    } else if (op->kind == OP_VARIABLE) {
        kind = LV_VARIABLE;
    } else {
        assert(0);
    }
    LocalVar lv = new LocalVar_(kind, getOpStr(op));
    lv->offset = (param_offset += 4);
    lv_table.insert(pair<string, LocalVar>(lv->name, lv));
}

void emit_code(ofstream& ofile, string str) {
    cout << str << endl;
    ofile << str << endl;
}

void emit_code(ofstream& ofile, string instr, initializer_list<string> s_list) {
    cout << instr << " ";
    ofile << instr << " ";
    initializer_list<string>::iterator iter = s_list.begin();
    cout << *iter;
    ofile << *iter;
    iter++;
    for(; iter != s_list.end(); iter++) {
        cout << ", " << *iter;
        ofile << ", " << *iter;
    }
    cout << endl;
    ofile << endl;
}

bool is_var(Operand op) {
    return (op->kind == OP_TEMP || op->kind == OP_VARIABLE);
}

void peephole(InterCodes& p, ofstream& ofile) {
    Reg reg = NULL, reg1 = NULL, reg2 = NULL;
    string instr;
    string relop;
    int cnt, arg_n, offset;
    stack<int> st;
    map<string, Symbol> m;
    switch (p->code.kind) {
        case IR_DUMMY:
            break;
        case IR_FUNC:
            odebug("FUNC");
            emit_code(ofile, "");
            emit_code(ofile, getOpStr(p->code.result) + ":");
            //clear_lv();
            lv_table.clear();
            lv_offset = 0;
            param_offset = 4;
            gen_prologue(ofile); 
            break;
        case IR_PARAM:
            odebug("PARAM");
            param_lv(p->code.result);
            break;
        case IR_ASSIGN:
            if (p->code.result->val != -1) {
                odebug("ASSIGN");
                if(p->code.op1->kind == OP_CONSTANT) {
                    //reg->lock = true;
                    if (p->code.result->attr == OP_POINTER) {
                        reg1 = get_reg(ofile, p->code.op1, true);
                        reg = get_reg(ofile, p->code.result, false);
                        emit_code(ofile, "lw", {reg->name, to_string(reg->lv->offset) + "($fp)"});
                        emit_code(ofile, "sw", {reg1->name, "0(" + reg->name +")"});
                        spill_reg(ofile, reg);
                        free_reg(reg1);
                    } else {
                        reg = get_reg(ofile, p->code.result, false);
                        assert(p->code.result->attr == OP_BASIC);
                        emit_code(ofile, "li", {reg->name, to_string(p->code.op1->val)});
                        spill_reg(ofile, reg);
                    }
                } else if (is_var(p->code.op1)) {
                    reg1 = get_reg(ofile, p->code.op1, true);
                    odebug("reg1 over");
                    //reg1->lock = true;
                    reg = get_reg(ofile, p->code.result, false);
                    odebug("reg over");
                    //reg->lock = true;
                    if (p->code.result->attr == OP_POINTER) {
                        emit_code(ofile, "lw", {reg->name, to_string(reg->lv->offset) + "($fp)"});
                        emit_code(ofile, "sw", {reg1->name, "0(" + reg->name +")"});
                    } else {
                        assert(p->code.result->attr == OP_BASIC);
                        emit_code(ofile, "move", {reg->name, reg1->name});
                    }
                    //reg1->lock = false;
                    spill_reg(ofile, reg);
                    free_reg(reg1);
                } else {
                    assert(0);
                }
                //reg->lock = false;
            }
            break;
        case IR_READ:
            odebug("READ");
            reg = get_reg(ofile, p->code.result, false);
            emit_code(ofile, "addi $sp, $sp, -4");
            emit_code(ofile, "sw $ra, 0($sp)");
            emit_code(ofile, "jal read");
            emit_code(ofile, "lw $ra, 0($sp)");
            emit_code(ofile, "addi $sp, $sp, 4");
            emit_code(ofile, "move", {reg->name, "$v0"});
            spill_reg(ofile, reg);
            break;
        case IR_WRITE:
            odebug("WRITE");
            reg = get_reg(ofile, p->code.op1, true);
            emit_code(ofile, "move", {"$a0", reg->name});
            free_reg(reg);
            emit_code(ofile, "addi $sp, $sp, -4");
            emit_code(ofile, "sw $ra, 0($sp)");
            emit_code(ofile, "jal write");
            emit_code(ofile, "lw $ra, 0($sp)");
            emit_code(ofile, "addi $sp, $sp, 4");
            break;
        case IR_RETURN:
            odebug("RETURN");
            reg = get_reg(ofile, p->code.result, true);
            emit_code(ofile, "move", {"$v0", reg->name});
            // invoke gen_epilogue() after get_reg(...)
            // avoid to reset $fp early
            gen_epilogue(ofile);
            emit_code(ofile, "jr $ra");
            free_reg(reg);
            break;
        case IR_LABEL:
            odebug("LABEL");
            emit_code(ofile, getOpStr(p->code.result) + ":");
            break;
        case IR_GOTO:
            odebug("GOTO");
            emit_code(ofile, "j " + getOpStr(p->code.result));
            break;
        case IR_IF:
            odebug("IF");
            relop = p->code.result->name;
            if (relop == "==") {
                instr = "beq";
            } else if (relop == "!=") {
                instr = "bne";
            } else if (relop == ">") {
                instr = "bgt";
            } else if (relop == "<") {
                instr = "blt";
            } else if (relop == ">=") {
                instr = "bge";
            } else if (relop == "<=") {
                instr = "ble";
            } else {
                assert(0);
            }
            reg1 = get_reg(ofile, p->code.op1, true);
            //reg1->lock = true;
            reg2 = get_reg(ofile, p->code.op2, true);
            //reg2->lock = true;
            p = p->next;
            assert(p->code.kind == IR_GOTO);
            emit_code(ofile, instr, {reg1->name, reg2->name, getOpStr(p->code.result)});
            //reg1->lock = false;
            //reg2->lock = false;
            free_reg(reg1);
            free_reg(reg2);
            break;
        case IR_ADD:
            odebug("ADD");
            if (p->code.op1->kind == OP_CONSTANT && is_var(p->code.op2)) { 
                reg2 = get_reg(ofile, p->code.op2, true); 
                //reg2->lock = true; 
                reg = get_reg(ofile, p->code.result, false); 
                //reg->lock = true; 
                if (p->code.result->attr == OP_POINTER) {
                    emit_code(ofile, "lw", {reg->name, to_string(reg->lv->offset) + "($fp)"});
                    emit_code(ofile, "addi", { reg2->name, reg2->name, to_string(p->code.op1->val) }); 
                    emit_code(ofile, "sw", {reg2->name, "0(" + reg->name +")"});
                } else {
                    assert(p->code.result->attr == OP_BASIC);
                    emit_code(ofile, "addi", { reg->name, reg2->name, to_string(p->code.op1->val) }); 
                }
                //reg2->lock = false; 
                spill_reg(ofile, reg); 
                free_reg(reg2); 
                //reg->lock = false; 
            } else if (is_var(p->code.op1) && p->code.op2->kind == OP_CONSTANT) { 
                reg1 = get_reg(ofile, p->code.op1, true); 
                //reg1->lock = true; 
                reg = get_reg(ofile, p->code.result, false); 
                //reg->lock = true;  
                if (p->code.result->attr == OP_POINTER) {
                    emit_code(ofile, "lw", {reg->name, to_string(reg->lv->offset) + "($fp)"});
                    emit_code(ofile, "addi", { reg1->name, reg1->name, to_string(p->code.op2->val) }); 
                    emit_code(ofile, "sw", {reg1->name, "0(" + reg->name +")"});
                } else {
                    assert(p->code.result->attr == OP_BASIC);
                    emit_code(ofile, "addi", { reg->name, reg1->name, to_string(p->code.op2->val) });
                }
                //reg1->lock = false; 
                spill_reg(ofile, reg); 
                free_reg(reg1); 
                //reg->lock = false; 
            } else if (is_var(p->code.op1) && is_var(p->code.op2)) { 
                reg1 = get_reg(ofile, p->code.op1, true); 
                //cout << "reg1 over" << endl;
                //reg1->lock = true; 
                reg2 = get_reg(ofile, p->code.op2, true); 
                //cout << "reg2 over" << endl;
                reg = get_reg(ofile, p->code.result, false); 
               // cout << "reg over" << endl;
                //reg->lock = true; reg2->lock = true; 
                if (p->code.result->attr == OP_POINTER) {
                    emit_code(ofile, "lw", {reg->name, to_string(reg->lv->offset) + "($fp)"});
                    emit_code(ofile, "add", { reg1->name, reg1->name, reg2->name }); 
                    emit_code(ofile, "sw", {reg1->name, "0(" + reg->name +")"});
                } else {
                    assert(p->code.result->attr == OP_BASIC);
                    emit_code(ofile, "add", { reg->name, reg1->name, reg2->name }); 
                }
                //reg1->lock = reg2->lock = false; 
                spill_reg(ofile, reg); 
                free_reg(reg1); 
                free_reg(reg2); 
                //reg->lock = false; 
            } else { 
                reg = get_reg(ofile, p->code.result, false); 
                //reg->lock = true; 
                if (p->code.result->attr == OP_POINTER) {
                    emit_code(ofile, "lw", {reg->name, to_string(reg->lv->offset) + "($fp)"});
                    emit_code(ofile, "sw", {to_string(p->code.op1->val + p->code.op2->val), "0(" + reg->name +")"});
                } else {
                    assert(p->code.result->attr == OP_BASIC);
                    emit_code(ofile, "li", { reg->name, to_string(p->code.op1->val + p->code.op2->val) });  
                }
                spill_reg(ofile, reg); 
            }
            //odebug("comp add");
            break;
        case IR_SUB:
            odebug("SUB");
            if (p->code.op1->kind == OP_CONSTANT && is_var(p->code.op2)) { 
                reg1 = get_reg(ofile, p->code.op1, true); 
                //reg1->lock = true; 
                reg2 = get_reg(ofile, p->code.op2, true); 
                //reg2->lock = true; 
                reg = get_reg(ofile, p->code.result, false); 
                //reg->lock = true;  
                if (p->code.result->attr == OP_POINTER) {
                    emit_code(ofile, "lw", {reg->name, to_string(reg->lv->offset) + "($fp)"});
                    emit_code(ofile, "sub", {reg1->name, reg1->name, reg2->name});
                    emit_code(ofile, "sw", {reg1->name, "0(" + reg->name +")"});
                } else {
                    assert(p->code.result->attr == OP_BASIC);
                    emit_code(ofile, "sw", {reg1->name, "0(" + reg->name +")"});
                }
                //reg1->lock = reg2->lock = false; 
                spill_reg(ofile, reg); 
                free_reg(reg1); 
                free_reg(reg2); 
                //reg->lock = false; 
            } else if (is_var(p->code.op1) && p->code.op2->kind == OP_CONSTANT) { 
                reg1 = get_reg(ofile, p->code.op1, true); 
                //reg1->lock = true; 
                reg = get_reg(ofile, p->code.result, false); 
                //reg->lock = true; 
                if (p->code.result->attr == OP_POINTER) {
                    emit_code(ofile, "lw", {reg->name, to_string(reg->lv->offset) + "($fp)"});
                    emit_code(ofile, "addi", {reg1->name, reg1->name, "-" + to_string(p->code.op2->val)}); 
                    emit_code(ofile, "sw", {reg1->name, "0(" + reg->name +")"});
                } else {
                    assert(p->code.result->attr == OP_BASIC);
                    emit_code(ofile, "addi", {reg->name, reg1->name, "-" + to_string(p->code.op2->val)}); 
                }
                //reg1->lock = false; 
                spill_reg(ofile, reg); 
                free_reg(reg1); 
                //reg->lock = false; 
            } else if (is_var(p->code.op1) && is_var(p->code.op2)) { 
                reg1 = get_reg(ofile, p->code.op1, true); 
                //reg1->lock = true; 
                reg2 = get_reg(ofile, p->code.op2, true); 
                //reg2->lock = true; 
                reg = get_reg(ofile, p->code.result, false); 
                //reg->lock = true; 
                if (p->code.result->attr == OP_POINTER) {
                    emit_code(ofile, "lw", {reg->name, to_string(reg->lv->offset) + "($fp)"});
                    emit_code(ofile, "sub", {reg1->name, reg1->name, reg2->name});
                    emit_code(ofile, "sw", {reg1->name, "0(" + reg->name +")"});
                } else {
                    assert(p->code.result->attr == OP_BASIC);
                    emit_code(ofile, "sub", {reg->name, reg1->name, reg2->name});
                }
                //reg1->lock = reg2->lock = false; 
                spill_reg(ofile, reg); 
                free_reg(reg1); 
                free_reg(reg2); 
                //reg->lock = false; 
            } else { 
                reg = get_reg(ofile, p->code.result, false); 
                //reg->lock = true; 
                if (p->code.result->attr == OP_POINTER) {
                    emit_code(ofile, "lw", {reg->name, to_string(reg->lv->offset) + "($fp)"});
                    emit_code(ofile, "sw", {to_string(p->code.op1->val - p->code.op2->val), "0(" + reg->name +")"});
                } else {
                    assert(p->code.result->attr == OP_BASIC);
                    emit_code(ofile, "li", {reg->name, to_string(p->code.op1->val - p->code.op2->val)});
                }
                spill_reg(ofile, reg); 
                //reg->lock = false; 
            }
            break;
        case IR_MUL:
            odebug("MUL");
            reg1 = get_reg(ofile, p->code.op1, true);
            //reg1->lock = true;
            reg2 = get_reg(ofile, p->code.op2, true);
            //reg2->lock = true;
            reg = get_reg(ofile, p->code.result, false);
            //reg->lock = true; 
            if (p->code.result->attr == OP_POINTER) {
                emit_code(ofile, "lw", {reg->name, to_string(reg->lv->offset) + "($fp)"});
                emit_code(ofile, "mul", {reg1->name, reg1->name, reg2->name});
                emit_code(ofile, "sw", {reg1->name, "0(" + reg->name +")"});
            } else {
                assert(p->code.result->attr == OP_BASIC);
                emit_code(ofile, "mul", {reg->name, reg1->name, reg2->name});
            }
            //reg->lock = reg1->lock = reg2->lock = false;
            spill_reg(ofile, reg);
            free_reg(reg1);
            free_reg(reg2);
            break;
        case IR_DIV:
            odebug("DIV");
            reg1 = get_reg(ofile, p->code.op1, true);
            //reg1->lock = true;
            reg2 = get_reg(ofile, p->code.op2, true);
            //reg1->lock = true;
            emit_code(ofile, "div", {reg1->name, reg2->name});
            reg = get_reg(ofile, p->code.result, false);
            //reg->lock = true;
            if (p->code.result->attr == OP_POINTER) {
                emit_code(ofile, "lw", {reg->name, to_string(reg->lv->offset) + "($fp)"});
                emit_code(ofile, "mflo " + reg1->name);
                emit_code(ofile, "sw", {reg1->name, "0(" + reg->name +")"});
            } else {
                assert(p->code.result->attr == OP_BASIC);
                emit_code(ofile, "mflo " + reg->name);
            }
            //reg->lock = reg1->lock = reg2->lock = false;
            spill_reg(ofile, reg);
            free_reg(reg1);
            free_reg(reg2);
            break;
        case IR_CALL:
            odebug("CALL");
            cnt = 0;
            assert(st.empty());
            arg_n = getSymbol(p->code.op1->name, m)->u.func->argList.size();
            while (cnt < arg_n && !arg_off_st.empty()) {
                int offset = arg_off_st.top();
                arg_off_st.pop();
                st.push(offset);
                cnt++;
            }
            if (cnt == arg_n) {
                while (!st.empty()) {
                    emit_code(ofile, "addi $sp, $sp, -4");
                    emit_code(ofile, "lw $t9, " + to_string(st.top()) + "($fp)");
                    emit_code(ofile, "sw $t9, 0($sp)");
                    st.pop();
                }
            } else if (arg_off_st.empty()) {
                assert(0);
            }
            emit_code(ofile, "addi $sp, $sp, -4");
            emit_code(ofile, "sw $ra, 0($sp)");
            emit_code(ofile, "jal", {getOpStr(p->code.op1)});
            emit_code(ofile, "lw $ra, 0($sp)");
            emit_code(ofile, "addi $sp, $sp, 4");
            // don't invoke get_reg(...) before 'jal ...'
            // avoid to allocate stack between ARG... and CALL...

            reg = get_reg(ofile, p->code.result, false);
            if (p->code.result->attr == OP_POINTER) {
                emit_code(ofile, "lw", {reg->name, to_string(reg->lv->offset) + "($fp)"});
                emit_code(ofile, "sw", {"$v0", "0(" + reg->name +")"});
            } else {
                assert(p->code.result->attr == OP_BASIC);
                emit_code(ofile, "move", {reg->name, "$v0"});
            }
            spill_reg(ofile, reg);
            break;
        case IR_ARG:
            odebug("ARG");
            // put all args on stack
            reg = get_reg(ofile, p->code.result, true);
            //emit_code(ofile, "addi $sp, $sp, -4");
            //emit_code(ofile, "sw", {reg->name, "0($sp)"});
            offset = (lv_offset -= 4);
            emit_code(ofile, "addi $sp, $sp, -4"); // allocate
            emit_code(ofile, "sw", {reg->name, to_string(offset) + "($fp)"});
            arg_off_st.push(offset);
            free_reg(reg);
        /*
            cout << "ARG " << getOpStr(p->code.result) << endl;
            ofile << "ARG " << getOpStr(p->code.result) << endl;
        */
            break;
        case IR_DEC:
            odebug("DEC");
            dec_lv(ofile, p->code.result, p->code.op1->val);
            break;
        default:
            //assert(0);
            break;
    }
    reg = reg1 = reg2 = NULL;
    p = p->next;
}

void gen_text_seg(ofstream& ofile, InterCodes codes) {
    emit_code(ofile, "");
    emit_code(ofile, ".text");
    gen_read_func(ofile);
    gen_write_func(ofile);
    InterCodes p = codes;
    while (p) {
        peephole(p, ofile);
    }
}

void gen_prologue(ofstream& ofile) {
    emit_code(ofile, "addi $sp, $sp, -4");
    emit_code(ofile, "sw $fp, 0($sp)");
    emit_code(ofile, "move $fp, $sp");
    emit_code(ofile, "addi, $sp, $sp, -40");
}

void gen_epilogue(ofstream& ofile) {
    emit_code(ofile, "move $sp, $fp");
    emit_code(ofile, "lw $fp, 0($sp)");
    emit_code(ofile, "addi $sp, $sp, 4");
}

void gen_oc(InterCodes codes, string filepath) {
    ofstream ofile;
    ofile.open(filepath);
    init_regs();
    gen_data_seg(ofile);
    gen_global_seg(ofile);
    gen_text_seg(ofile, codes);
    
    ofile.close();
}