## VideoDurationCalc
这是一个用于计算开了倍速后的视频，需要多久才能播放完的 PowerShell 脚本。
## 食用方法
### PowerShell 控制台
可以使用命令行运行：
```
.\vdc.ps1 <视频时长 HH:mm:ss> <播放倍速>
```
也可以直接运行：
```
.\vdc.ps1
```
### 示例
```
PS > .\vdc.ps1 2:30:00 2.5

以 2.5 倍速播放该时长为 2:30:00 的视频需要 01:00:00。
```
## 命令提示符控制台
使用命令行运行：
```
powershell -ExecutionPolicy Bypass -File vdc.ps1 <视频时长 HH:mm:ss> <播放倍速>
```
直接运行：
```
powershell -ExecutionPolicy Bypass -File vdc.ps1
```
### 示例
```
> powershell -ExecutionPolicy Bypass -File vdc.ps1 2:30:00 2.5

以 2.5 倍速播放该时长为 2:30:00 的视频需要 01:00:00。
```