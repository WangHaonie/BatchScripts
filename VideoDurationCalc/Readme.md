## VideoDurationCalc
这是一个用于计算开了倍速后的视频，需要多久才能播放完的 PowerShell 脚本。
## 食用方法
### 运行 vdc.bat
```
vdc <视频时长 HH:mm:ss> <播放倍速>
```
### 运行 VideoDurationCalc.ps1
```
powershell -ExecutionPolicy Bypass -File .\VideoDurationCalc.ps1 <视频时长 HH:mm:ss> <播放倍速>
```
### 示例
```
> powershell -ExecutionPolicy Bypass -File .\VideoDurationCalc.ps1 2:30:00 2.5

以 2.5 倍速播放该时长为 2:30:00 的视频需要 01:00:00。
```