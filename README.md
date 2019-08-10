# Kaleidoscope

参考[My First Language Frontend with LLVM Tutorial](http://llvm.org/docs/tutorial/MyFirstLanguageFrontend/index.html)的C++代码实现的swift版Kaleidoscope。

Kaleidoscope是LLVM教程中实现的demo语言，以下是它的介绍:

*This tutorial introduces the simple “Kaleidoscope” language, building it iteratively over the course of several chapters, showing how it is built over time. This lets us cover a range of language design and LLVM-specific ideas, showing and explaining the code for it all along the way, and reduces the overwhelming amount of details up front. We strongly encourage that you work with this code - make a copy and hack it up and experiment.*

## 运行工程的必要配置

### 下载llvm和pkg-config

``` shell
brew install llvm
brew install pkg-config
# 在.bash_profile下配置llvm命令行，具体情况根据你所安装的llvm版本不同
export PATH=/usr/local/Cellar/llvm/8.0.0_1/bin:$PATH;
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

## 开发教程

[教你使用swift写编译器玩具（0）](./doc/第0章.md)

[教你使用swift写编译器玩具（1）](./doc/第1章.md)

[教你使用swift写编译器玩具（2）](./doc/第2章.md)

[教你使用swift写编译器玩具（3）](./doc/第3章.md)

[教你使用swift写编译器玩具（4）](./doc/第4章.md)

[教你使用swift写编译器玩具（5）](./doc/第5章.md)

[教你使用swift写编译器玩具（6）](./doc/第6章.md)

[教你使用swift写编译器玩具（7）](./doc/第7章.md)

[教你使用swift写编译器玩具（8）](./doc/第8章.md)

