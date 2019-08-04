# 编译

查看可以选择的CPU和Features

```shell
llvm-as < /dev/null | llc -march=x86 -mattr=help
```

我选了x86-64

## 运行

```shell
clang++ main.cpp output.o -o main
./main
```

还可以用下面命令看一下目标文件是否生成了符号表

```shell
objdump -t output.o
```

会输出类似的以下信息

```
output.o:	file format Mach-O 64-bit x86-64

SYMBOL TABLE:
0000000000000000 g     F __TEXT,__text	_average
```

## 可能遇到的问题

macOS下'wchar.h' File Not Found

参考回答[macOS 'wchar.h' File Not Found](https://stackoverflow.com/questions/26185978/macos-wchar-h-file-not-found)

```shell
open /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg
```

Mojava下安装头文件包即可