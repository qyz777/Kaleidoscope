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

## 可能遇到的问题

macOS下'wchar.h' File Not Found

参考回答[macOS 'wchar.h' File Not Found](https://stackoverflow.com/questions/26185978/macos-wchar-h-file-not-found)

```shell
open /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg
```

Mojava下安装头文件包即可