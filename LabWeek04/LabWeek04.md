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

1. 使用mul进行无符号乘法：目标操作数是隐藏的，目标位置总是使用eax寄存器的某种形式，如al, ax, eax;于此同时，mul指令的目标位置必须是操作数长度的两倍，结果存放形式： ax（16位），dx:ax （32位），edx:eax（64位）。

	mul source


<span id = "ex10"></span>

mul测试 - multest.s实验测试：乘法

实验截图： ![1](./screenshot/LabWeek04_12.png)

可以看到得到了正确结果52245741648，并且保存在了result中。

2. 使用IMUL进行带符号整数乘法，需要小心结果不使用目标寄存器的最高有效位作为符号位，有三种指令格式：

	imul source
	imul source, destination #destination必须是寄存器
	imul multiplier, source, destination #multipler是一个立即数，destination = multipler * source

<span id = "ex11"></span>

imul测试 - imultest.s实验测试：乘法

实验截图： ![1](./screenshot/LabWeek04_13.png)

可以看到ecx = 10 * -35 = -350, eax = 2 * 400 = 800，实验输出与理论结果相符。

3. 检查溢出：总是需要检查结果中的溢出，可以通过jo指令检查溢出。 


<span id = "ex12"></span>

imul测试 - imultest2.s实验测试：溢出检查乘法

实验截图： ![1](./screenshot/LabWeek04_14.png)

可以看由于结果发生了溢出，jo指令跳转到了over，最终带有结果代码1。

#### 除法：成生商和余数两部分。

1. 无符号除法：DIV，其中divisor是隐含的被除数要除以的值。在计算之前，被除数必须先被保存到AX、DX:AX、EDX:EAX、寄存器对中。

	div divisor

下表是商和余数被储存的地方：****在除法操作完成时，会丢失被除数，如果需要需提前保存到别的地方。

|被除数|被除数长度|商|余数|
|AX|16|AL|AH|
|DX:AX|32|AX|DX|
|EDX:EAX|64|EAX|EDX|


<span id = "ex13"></span>

div测试 - divtest.s实验测试：除法

实验截图： ![1](./screenshot/LabWeek04_15.png)

由程序可以看到，程序先将64字的四字整数加载到edx:eax中，计算结果分别存到内存位置中。

2. 带符号除法：IDIV，格式与div相同，需要记住的是被除数必须是除数长达的两倍，计算是需要适当第扩展数据长度。

3. 检查除法错误：例如除数为零，系统会产生中断。

### 8.2 移位指令

1. 移位乘法：SAL，SHL，前者是算数左移，后者是逻辑左移（实际上对于左移他们的操作是一样的）。同样需要助记符声明操作数长度。**会影响进位标志**。

	sal destination
	sal %cl destination #左移指定cl位
	sal shifter, destination #左移指定立即数位。



<span id = "ex14"></span>

sal测试 - saltest.s实验测试：左移

实验截图： ![1](./screenshot/LabWeek04_16.png)

可以看到第三行sall是的ebx从10变成了20，第五行使ebx左移两位，从20变成了80,第六行又左移两位，ebx的值变成了320。

2. 移位除法：SHR，SAR，右移，前者是逻辑右移后者是算术右移。对于算术右移，负数补1,正数补0，**进位标志被设置成移出的位**。

3. 循环移位：ROL-向左循环移位，ROR-向右循环移位，RCL-向左循环移位，包含进位标志，RCR-向右循环移位，包含进位标志。

### 8.3 BCD码运算

**不打包一个数字1个字节，打包一个数字半个字节**

1. 不打包BCD的运算

	AAA, AAS, AAM, AAD #分别调整加减乘除法操作的结果，一般与无符号整数计算指令组合使用。**这些指令有隐藏的操作数，AL寄存器，AAA等指令都会假设操作结果放在AL里。**

<span id = "ex15"></span>

aaa测试 - aaatest.s实验测试：不打包BCD运算

实验截图： ![1](./screenshot/LabWeek04_17.png)

可以看到程序实现了将多为BCD码相加得到结果81058 = 28125 + 52933。

2. 打包BCD的运算

	DAA，DAS #调整ADD，ADC/SUB，SBB指令的结果。
	
例子：打包BCD值52933按照小尾数格式0x332905加载到内存中，并减去BCD值28125（0x258102)。打包格式的结果是0x084802。


<span id = "ex16"></span>

aaa测试 - dastest.s实验测试：打包BCD运算

实验截图： ![1](./screenshot/LabWeek04_18.png)

可以看到程序在第一个减法操作后，eax的值为14,执行DAS调整后，eax的值变成了8，他表示结果的第一个十进制位。

### 8.4 逻辑操作

1. 布尔运算：and, or, not, xor，计算结果保留在第二个操作数（destination）里。

2. 位测试：检查某确定值内的一位是否为1,常用与检查eflags寄存器。

**test指令**,执行按位与操作，并且相应地设置符号，零，奇偶校验标志，并且不修改目标值。


<span id = "ex17"></span>

test测试 - cpuidtest.s实验测试：使用test指令

实验截图： ![1](./screenshot/LabWeek04_19.png)

为测试是否成功设置了ID标志，首先拷贝eflags寄存器到edx中，然后设置edx的id位为1（借助立即数movl），最后使用test指令查看ID标志位是否改变了。

## 第十章 处理字符串

### 10.1 传送字符串

1. MOVS指令 - 为了向程序员提供把字符串从一个位置传送到另一个位置的简单途径。

	movsb,movsw,movsl #传送单个字节/字/双字
	
MOVS指令使用隐含的源和目的操作数：**源操作数是ESI寄存器**，指向源字符串的内存位置，**目标操作数是EDI寄存器**，指向字符串要被复制到的内存地址。

加载ESI，EDI的值的方式：**间接寻址-movl $output, %edi;使用LEA指令-leal output, %edi。**

<span id = "ex18"></span>

movs测试 - movstest1.s实验测试：字符串传送

实验截图： ![1](./screenshot/LabWeek04_20.png)

可以看到在movs助记符不同的情况下，movs进来的字符串长度是不一样的。

在每次执行MOVS指令时，数据传送后，ESI和EDI寄存器的内容会自动改变，而递增还是递减取决于EFLAGS寄存器中的DF标志：DF为零递增，否则递减。

我们可以使用CLD和STD指令来改变DF标志的值，其中前者清零后者置1。

<span id = "ex19"></span>

movs测试 - movstest2.s实验测试：字符串传送

实验截图： ![1](./screenshot/LabWeek04_21.png)

ESI和EDI寄存器都指向了相应内存位置的尾部，使用STD命令让寄存器递减。即字符串从后往前读入。

<span id = "ex20"></span>

movs测试 - movstest2.s实验测试：字符串传送

实验截图： ![1](./screenshot/LabWeek04_22.png)

在整个动态过程是一个循环中，字符串是从后面开始一个一个字节传输的。

# 问题和解决

## 问题1：
