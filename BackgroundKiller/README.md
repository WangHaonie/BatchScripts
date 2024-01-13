## BackgroundKiller
该脚本可以防止指定的程序在关闭后仍在后台运行。注意请不要指定系统程序，否则会导致系统崩溃
## 主要原理
1. 从配置文件中读取进程名称，并监视窗口变化
2. 当应用程序在前台运行 (```MainWindowTitle``` 不等于 ```""```) 时，不管，但转入后台运行 (```MainWindowTitle``` 等于 ```""```) 时，直接杀死
## 使用方法
下载 ```BackgroundKiller.ps1``` 和 ```BackgroundKiller.bat```，运行 ```BackgroundKiller.bat``` 即可。
## 更新日志
- 已知的问题<br>1. 当配置文件的进程名称存在 .exe 后缀时，脚本无法正常监视<br>2. 不能显示通配符匹配到的进程
- v2.4<br>1. 支持在配置文件中快捷配置脚本休眠时间<br>2. 调整了代码逻辑和部分样式
- [v2.0](https://github.com/WangHaonie/BatchScripts/tree/main/BackgroundKiller/v2.0)<br>1. 代码逻辑重构，支持实时读取配置文件来更新进程列表<br>2. 修复了当配置文件中存在空行时脚本报错的情况<br>3. 支持读取配置文件的时候自动忽略以 # 开头的所有行<br>4. 支持读取配置文件的时候自动去重<br>5. 支持通配符 * 和 ? (PowerShell 特性)<br>6. 修改了某些样式<br>7. 向生成的配置文件里添加了提示内容
- v1.0 <br>1. 支持从配置文件读取进程列表
