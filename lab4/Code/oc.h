#ifndef __OC_H__
#define __OC_H__

#include "common.h"
#include "ir.h"
#include "symbol.h"
#include "semantic.h"
#include <iostream>
#include <string>
#include <initializer_list>

typedef struct LocalVar_* LocalVar;
typedef struct Reg_* Reg;

enum LV_kind { LV_TEMP, LV_VARIABLE };

struct LocalVar_ {
    LV_kind kind;
    Reg reg;
    std::string name;
    int offset;
    LocalVar_(LV_kind k, std::string s) :kind(k), name(s){ reg = NULL; offset = 0; }
};

struct Reg_ {
    std::string name;
    //bool lock;
    LocalVar lv;
    bool avail;
    Reg_(std::string s) { name = s; lv = NULL; avail = true; }
};

void init_regs();
void gen_data_seg(std::ofstream&);
void gen_global_seg(std::ofstream&);
void gen_read_func(std::ofstream&);
void gen_write_func(std::ofstream&);
void gen_oc(InterCodes, std::string);
Reg get_reg(std::ofstream&, Operand, bool);
void emit_code(std::ofstream&, std::string);
void emit_code(std::ofstream&, std::string, std::initializer_list<std::string>);
void gen_prologue(std::ofstream&);
void gen_epilogue(std::ofstream&);
void spill_reg(std::ofstream&, Reg);
void free_reg(Reg);

LocalVar get_lv(std::ofstream&, Operand);
LocalVar new_lv(std::ofstream&, Operand);
void dec_lv(std::ofstream&, Operand, int);
void param_lv(Operand);
std::string getOpStr(Operand);

#endif