# Lab Week03 - 验证实验 Blum’s Book: Sample programs in Chapter 06, 07 

**郑有为 19335286**

如果图片或链接显示异常，请访问 [OSHomework-LabWeek04.md](https://github.com/WondrousWisdomcard/OSHomework/blob/main/LabWeek04/LabWeek04.md) 。我把代码和截图都放在了仓库 [OSHomework](https://github.com/WondrousWisdomcard/OSHomework)。

[toc]

# 实验验证

## 实验验证内容索引

[实验1. 测试jmp - jumptest.s](#ex1)

[实验2. 测试call - calltest.s](#ex2)

[实验3. 测试cmp - cmptest.s](#ex3)

[实验4. 测试奇偶校验 - paritytest.s](#ex4)

[实验5. 测试符号位 - signtest.s](#ex5)

[实验6. 测试loop - loop.s](#ex6)

[实验7. 优化循环指令 - betterloop.s](#ex7)

[实验8. 带符号整数测试 - inttest.s](#ex8)

[实验9. 扩展无符号整数测试 - movzxtest.s](#ex9)

[实验10. 扩展带符号整数测试 - movsxtest.s, movsxtest2.s](#ex10)

[实验11. .quad命令测试 - quadtest.s](#ex11)

[实验12. mmx命令测试 - mmxtest.s](#ex12)

[实验13. sse命令测试 - ssetest.s](#ex13)

[实验14. fbld命令测试 - bcdtest.s](#ex14)

[实验15. 浮点数使用测试 - floattest.s](#ex15)

[实验16. 浮点数预置值使用测试 - fpuvals.s](#ex16)

[实验17. SSE打包单精度浮点数测试 - ssefloat.s](#ex17)

[实验18. SSE2浮点数测试 - sse2float.s实验测试](#ex18)

[实验19. 数据类型转换测试 - convtest.s实验测试](#ex19)

# 技术日志

## 第八章 基本数学功能

### 8.1 整数运算

#### 加法

	1. ADD指令：其中source可以是立即数、内存位置、寄存器，destination可以是寄存器或者内存位置中储存的值，但二者不能同时是内存位置，结果存放在第二个操作数destination中。**必须通过助记符来指定操作数长度（b,w,l)**。
	
		add source, destination
		
	<span id = "ex1"></span>

	add测试 - addtest1.s实验测试：测试指令addb,addw,addl

	实验截图： ![1](./screenshot/LabWeek04_1.png)

	考虑程序本身，程序的结果是 %al = 20 + 10 = 30, %bx = 0 + 30, %edx = 100 + 100 = 200, %eax = 40 + 30 = 70, data = 40 + 70 = 110，通过gdb调试查看其结果，与理论上一致。
		
	<span id = "ex2"></span>

	add测试 - addtest2.s实验测试：测试带符号数加法

	实验截图： ![1](./screenshot/LabWeek04_2.png)

	考虑程序本身，程序的结果是 %eax = -10 + -40 + 80 + -200 = -170, data = -40 + -170 + 210 = 0，通过gdb调试查看其结果，与理论上一致。

	2. 检测进位与溢出：通过eflags寄存器的进位标志和溢出标志。

	<span id = "ex3"></span>

	add测试 - addtest3.s实验测试：测试进位加法

	实验截图： ![1](./screenshot/LabWeek04_3.png)

	考虑程序本身，%bl发生了进位，进位标志被设置为1,通过jc指令跳转到了over，最后程序返回0，表示正确检测到进位。
	
	改动寄存器%al的值，可以看到不再发生进位,最后程序返回200。
	
	实验截图： ![1](./screenshot/LabWeek04_4.png)

	**对于无符号整数，如果不能确定输入值的长度，在执行加法时，总应该检查进位标志（jc）。**（对于带符号数应该检查溢出标志）

	<span id = "ex4"></span>

	add测试 - addtest4.s实验测试：测试溢出加法

	实验截图： ![1](./screenshot/LabWeek04_5.png)

	在上面这种情况下，计算结果发生了溢出，于是结果输出0，考虑修改数据的值，可以看到不再发生溢出，并输出了正确结果。
	
	实验截图： ![1](./screenshot/LabWeek04_6.png)
	
	3. ADC指令
	
	使用adc指令，实现两个无符号整数或者带符号整数值的加法，并且把前一个add指令产生的进位标志值包含在其中，实现了多组字节的加法操作。
	
	<span id = "ex5"></span>

	adc测试 - adctest.s实验测试：四字加法

	实验截图： ![1](./screenshot/LabWeek04_7.png)
	
	其中，printf使用了%qd参数来显示64位整数值，并pushl两次将四字入栈，还要注意入栈顺序是先高位后低位，因为小端存储的缘故。
	
#### 减法 

	1. SUB指令：与ADD类似，从destination的值中减去source的值并存在destination中。
	
	<span id = "ex6"></span>

	sub测试 - subtest1.s实验测试：减法

	实验截图： ![1](./screenshot/LabWeek04_8.png)
	
	考虑程序本身，data = 40 - -30 = 70，得到正确结果。
	
	2. 减法操作中的进位和溢出：对于无符号整数，例如 2 - 5 会发出进位;对于有符号整数，负值减去一个很大的正值会发生溢出。
	
	<span id = "ex7"></span>

	sub测试 - subtest2.s实验测试：减法进位

	实验截图： ![1](./screenshot/LabWeek04_9.png)
	
	<span id = "ex8"></span>

	sub测试 - subtest3.s实验测试：减法溢出

	实验截图： ![1](./screenshot/LabWeek04_10.png)
	
	我们可以看到，负数减去很大的正数会发生溢出，而负数减去负数则不会。
	
	3. SBB指令：原理与ADD相同，借位操作。
	
	<span id = "ex9"></span>

	sbb测试 - sbbtest.s实验测试：四字减法

	实验截图： ![1](./screenshot/LabWeek04_11.png)
	
	可以看到得到了正确结果。
	
#### 递增和递减

	使用dec（递减）和inc（递增）指令，其结果不会影响任何标志位。
	
#### 乘法


	
# 问题和解决

## 问题1：
