# Kaleidoscope

参考[My First Language Frontend with LLVM Tutorial](http://llvm.org/docs/tutorial/MyFirstLanguageFrontend/index.html)的C++代码实现的swift版Kaleidoscope，目前正在coding中。

Kaleidoscope是LLVM教程中实现的demo语言，以下是它的介绍

```
This tutorial introduces the simple “Kaleidoscope” language, building it iteratively over the course of several chapters, showing how it is built over time. This lets us cover a range of language design and LLVM-specific ideas, showing and explaining the code for it all along the way, and reduces the overwhelming amount of details up front. We strongly encourage that you work with this code - make a copy and hack it up and experiment.
```

## TODO

[Chapter #7](http://llvm.org/docs/tutorial/MyFirstLanguageFrontend/LangImpl07.html)

[Chapter #8](http://llvm.org/docs/tutorial/MyFirstLanguageFrontend/LangImpl08.html)

[Chapter #9](http://llvm.org/docs/tutorial/MyFirstLanguageFrontend/LangImpl09.html)

[Chapter #10](http://llvm.org/docs/tutorial/MyFirstLanguageFrontend/LangImpl10.html)

完善工程代码

## 运行工程的必要配置

### 下载llvm和pkg-config

```shell
brew install llvm
brew install pkg-config
```

### 工程配置

```shell
# 来自LLVMSwift的脚本
swift utils/make-pkgconfig.swift
# 编译工程
swift build
```

## 测试

```shell
swift run
./Examples/test.k
```

