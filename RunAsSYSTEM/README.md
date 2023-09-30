## RunAsSYSTEM
以 NT AUTHORITY\SYSTEM 身份运行某命令
## 主要原理
- 调用 PowerShell 执行命令 ```Invoke-WebRequest -UseBasicParsing -Uri <url>``` 从 https://live.sysinternals.com/PsExec.exe 下载 PsExec.exe
- 运行 ```PsExec.exe -accepteula -nobanner -i -d -s cmd.exe /c <命令>``` 来实现提权的目的<br>
- 注意：如果当前账户不具有管理员权限，那么你可能需要手动选择以管理员身份运行来确保后期可以进一步提权到 SYSTEM<br>
## 使用方法
下载 ```sysrun.bat```，通过命令行运行命令
```shell
sysrun <命令>
```
比如 ```sysrun cmd```，将以 SYSTEM 权限运行 ```cmd.exe```，你可以通过命令 ```whoami``` 来验证是否具有 SYSTEM 权限
```
Microsoft Windows [Version 10.0.22631.2338]
(c) Microsoft Corporation. All rights reserved.

C:\Windows\System32>whoami
nt authority\system

C:\Windows\System32>
```
## 更新日志
- v1.0 <br> [+] 脚本以由微软 Sysinternals 提供的 PsExec 来实现提权
