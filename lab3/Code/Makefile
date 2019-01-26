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
	./parser ../Test/test0.cmm test0.ir
	./parser ../Test/test1.cmm test1.ir
	./parser ../Test/test2.cmm test2.ir
	./parser ../Test/test_1.cmm test_1.ir
	./parser ../Test/test_2.cmm test_2.ir
	./parser ../Test/testA1.cmm testA1.ir
	./parser ../Test/testA2.cmm testA2.ir
	./parser ../Test/testA3.cmm testA3.ir
	./parser ../Test/testA4.cmm testA4.ir
	./parser ../Test/testA5.cmm testA5.ir
	./parser ../Test/testB1.cmm testB1.ir
	./parser ../Test/testB2.cmm testB2.ir
	./parser ../Test/testB3.cmm testB3.ir
	./parser ../Test/testC1.cmm testC2.ir
	./parser ../Test/testC2.cmm testC2.ir
	./parser ../Test/testD1.cmm testD1.ir
	./parser ../Test/testE11.cmm testE11.ir
	./parser ../Test/testE12.cmm testE12.ir
	./parser ../Test/testE13.cmm testE13.ir
	./parser ../Test/testE21.cmm testE21.ir
	./parser ../Test/testE22.cmm testE22.ir
	./parser ../Test/testE23.cmm testE23.ir

debug:
	flex lexical.l
	bison -d -v -t syntax.y
	g++ syntax.tab.cpp ast.cpp main.cpp -ll -ly -o parser -D YY_DEBUG

clean:
	rm -f parser lex.yy.c syntax.tab.c syntax.tab.h syntax.output
	rm -f $(OBJS) $(OBJS:.o=.d)
	rm -f $(LFC) $(YFC) $(YFC:.c=.h)
	rm -f *~
