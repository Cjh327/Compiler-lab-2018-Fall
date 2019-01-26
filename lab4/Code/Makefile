# GNU make手册：http://www.gnu.org/software/make/manual/make.html
# ************ 遇到不明白的地方请google以及阅读手册 *************

# 编译器设定和编译选项
CXX = g++
FLEX = flex
BISON = bison
CPPFLAGS = -std=c++11

# 编译目标：src目录下的所有.c文件
CFILES = $(shell find ./ -name "*.cpp")
OBJS = $(CFILES:.cpp=.o)
LFILE = $(shell find ./ -name "*.l")
YFILE = $(shell find ./ -name "*.y")
LFC = $(shell find ./ -name "*.l" | sed s/[^/]*\\.l/lex.yy.c/)
YFC = $(shell find ./ -name "*.y" | sed s/[^/]*\\.y/syntax.tab.c/)
LFO = $(LFC:.c=.o)
YFO = $(YFC:.c=.o)

parser: syntax $(filter-out $(LFO),$(OBJS))
	$(CXX) $(CPPFLAGS) -o parser $(YFO) $(filter-out $(LFO),$(OBJS)) -ll -ly

syntax: lexical syntax-c
	$(CXX) -c $(YFC) -o $(YFO)

lexical: $(LFILE)
	$(FLEX) -o $(LFC) $(LFILE)

syntax-c: $(YFILE)
	$(BISON) -o $(YFC) -d -v $(YFILE)

-include $(patsubst %.o, %.d, $(OBJS))

# 定义的一些伪目标
.PHONY: clean scanner run debug
scanner:
test:
	./parser ../Test/testA1.cmm ../Oc/testA1.asm
	./parser ../Test/testA2.cmm ../Oc/testA2.asm
	./parser ../Test/testA3.cmm ../Oc/testA3.asm
	./parser ../Test/testA4.cmm ../Oc/testA4.asm
	./parser ../Test/testA5.cmm ../Oc/testA5.asm
	./parser ../Test/testB1.cmm ../Oc/testB1.asm
	./parser ../Test/testB2.cmm ../Oc/testB2.asm
	./parser ../Test/testB3.cmm ../Oc/testB3.asm
	./parser ../Test/testC1.cmm ../Oc/testC1.asm
	./parser ../Test/testC2.cmm ../Oc/testC2.asm
	./parser ../Test/testD1.cmm ../Oc/testD1.asm
	./parser ../Test/testE11.cmm ../Oc/testE11.asm
	./parser ../Test/testE12.cmm ../Oc/testE12.asm
	./parser ../Test/testE13.cmm ../Oc/testE13.asm
	./parser ../Test/testE21.cmm ../Oc/testE21.asm
	./parser ../Test/testE22.cmm ../Oc/testE22.asm
	./parser ../Test/testE23.cmm ../Oc/testE23.asm

debug:
	flex lexical.l
	bison -d -v -t syntax.y
	g++ syntax.tab.cpp ast.cpp main.cpp -ll -ly -o parser -D YY_DEBUG

clean:
	rm -f parser lex.yy.c syntax.tab.c syntax.tab.h syntax.output
	rm -f $(OBJS) $(OBJS:.o=.d)
	rm -f $(LFC) $(YFC) $(YFC:.c=.h)
	rm -f *~
