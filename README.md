## 项目简介
个人自用的 Batch/PowerShell 脚本，虽然将它发布到了 GitHub 上，但初衷并不是让任何人都来使用它，仅作为学习和参考。当然，如果您对它感兴趣，也可以尝试使用。
## 注意事项
1. 此脚本按照我个人的需求和喜好开发的，可能并不适用于所有人。
2. 我并不提供任何技术支持或问题解答。
3. 如果您想使用这个脚本，请确保您具备相关的技术知识和经验，以便自行修改和定制。
4. 欢迎查看代码和学习，但禁止将其用于商业目的或未经授权的用途。
## 各脚本介绍
| 脚本名称 | 主要编程语言 | 最低系统版本要求 | 功能简介 |
|-------|-------|-------|-------|
| [AdminChecker](https://github.com/WangHaonie/BatchScripts/tree/main/AdminChecker) | Batch、PowerShell | Windows 7 | 检查当前账户是否具有管理员权限 |
| [BackgroundKiller](https://github.com/WangHaonie/BatchScripts/tree/main/BackgroundKiller)| PowerShell | Windows 10 | 杀死那些点了退出还在后台运行的程序
| [CompactFileLister](https://github.com/WangHaonie/BatchScripts/tree/main/CompactFileLister) | PowerShell | Windows 10 1803 | 列出磁盘中被压缩存储的文件夹 |
| [JsonParser](https://github.com/WangHaonie/BatchScripts/tree/main/JsonParser) | PowerShell | Windows 7* | 从 URL 解析 Json 并返回指定的值 |
| [ManualCheckWinUpdate](https://github.com/WangHaonie/BatchScripts/tree/main/ManualCheckWinUpdate) | Batch | Windows 10 1511 | 手动运行检查 Windows 更新 |
| [RunAsSYSTEM](https://github.com/WangHaonie/BatchScripts/tree/main/RunAsSYSTEM) | Batch | Windows 7 | 以 SYSTEM 权限执行命令 |
| [SimpleVideoConverter](https://github.com/WangHaonie/BatchScripts/tree/main/SimpleVideoConverter) | Batch | Windows 7 | 快速转换视频格式 |
| [VideoDurationCalc](https://github.com/WangHaonie/BatchScripts/tree/main/VideoDurationCalc) | PowerShell | Windows 7* | 计算倍速后视频播放时间 |
| [WinNtpUpdater](https://github.com/WangHaonie/BatchScripts/tree/main/WinNtpUpdater) | Batch | Windows 7 | 解决系统时间无法同步或不会同步的情况 |
| [XyybsDownloader](https://github.com/WangHaonie/BatchScripts/tree/main/XyybsDownloader) | PowerShell | Windows 7* | 从学英语报社官网下载听力文件 |

标有 * 的说明要安装 [WMF 3.0](https://www.microsoft.com/en-US/download/details.aspx?id=34595) 更新，因为此更新包含了 PowerShell 3.0，某些 PowerShell 脚本 (比如调用 .NET 程序集、Invoke-Webrequest 下载文件等) 需要 3.0 及以上版本才能正常运行。
## 关于下载的部分脚本无法运行的问题
1. GitHub Desktop 貌似会在上传时损坏部分脚本使其丢失几个字节导致即使内容没有改变也不能正常运行。你可以下载仓库里的 [BatchScripts-AllinOne.7z](https://raw.githubusercontent.com/WangHaonie/BatchScripts/main/BatchScripts-AllinOne.7z) 来使用原版脚本避免出现运行错误。
2. 如果你确定脚本没有损坏但依旧无法正常运行，尝试以管理员身份运行，若仍然不行，将 PowerShell 更新到 3.0 及以上，实在不行就直接用 Windows 10 及以上 (PowerShell 5) 的操作系统运行脚本。
3. 不排除脚本自身可能存在 Bug。