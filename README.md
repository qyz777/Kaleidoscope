# Kaleidoscope

coding中...

## 运行工程的必要配置

### 下载llvm和pkg-config

```shell
brew install llvm
brew install pkg-config
```

安装完llvm出现下列信息

```
==> llvm
To use the bundled libc++ please add the following LDFLAGS:
  LDFLAGS="-L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib"

llvm is keg-only, which means it was not symlinked into /usr/local,
because macOS already provides this software and installing another version in
parallel can cause all kinds of trouble.

If you need to have llvm first in your PATH run:
  echo 'export PATH="/usr/local/opt/llvm/bin:$PATH"' >> ~/.bash_profile

For compilers to find llvm you may need to set:
  export LDFLAGS="-L/usr/local/opt/llvm/lib"
  export CPPFLAGS="-I/usr/local/opt/llvm/include"
```

### 设置环境

```shell
export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"
```

### 工程配置

```shell
# 来自LLVMSwift的脚本
swift utils/make-pkgconfig.swift
# 编译工程
swift build
```

