---
name: weekly-git-worklog
description: 从本地多个 Git 项目中提取指定作者的提交记录，按上周逐日汇总为简明工作日志，适合周报、日报补录和工作量回顾。
---

# Weekly Git Worklog Skill

## 适用场景

当用户需要基于本地 Git 提交记录整理工作内容时使用本 skill，尤其适合以下场景：

- 总结上周代码工作量
- 按日整理开发内容
- 汇总指定作者在多个仓库中的提交
- 生成适合复制到周报中的简洁文本

## 默认规则

- 默认项目范围：`F:\onelink_*\*`
- 默认只读取实际 Git 子仓库
- 默认作者：`gaojunzhe@zoesoft.com.cn`
- 默认时间范围：以上海时区计算的“上周一 00:00:00 到上周日 23:59:59”
- 默认过滤 `Merge branch ...` 这类合并提交
- 默认保留正常功能提交和 `Revert` 提交
- 默认输出 7 行，每天一行；无提交时输出 `无提交`

## 输出格式

标准输出格式如下：

```text
yyyy-MM-dd <内容>
```

内容部分按天汇总，使用全角分号 `；` 分隔多个主题。对于同一天内重复提交的相同主题，会折叠为次数统计，例如：

```text
2026-05-20 onelink-micro-charge-sh-qpsq 免费号单据结算（2次提交）；onelink-web-outp-sh-qpsq 社区运维-家床系统中临时医嘱无法发送（多人）
```

## 使用方式

优先运行脚本：

`skills/weekly-git-worklog/scripts/summarize-weekly-worklog.ps1`

常见调用示例：

```powershell
./skills/weekly-git-worklog/scripts/summarize-weekly-worklog.ps1
```

```powershell
./skills/weekly-git-worklog/scripts/summarize-weekly-worklog.ps1 -AuthorEmail "gaojunzhe@zoesoft.com.cn"
```

```powershell
./skills/weekly-git-worklog/scripts/summarize-weekly-worklog.ps1 -Since "2026-05-18 00:00:00" -Until "2026-05-24 23:59:59"
```

## 处理口径

1. 先发现 `F:\onelink_*` 根目录
2. 再枚举其下一层目录中的实际 Git 仓库
3. 对每个仓库执行 `git log`
4. 按日期、仓库、提交主题聚合
5. 将重复主题折叠为次数
6. 输出逐日工作内容

## 注意事项

- 该 skill 依赖本机可执行 `git`
- 如果某些仓库采用了不同邮箱提交，需要显式传入新的作者参数
- 如果用户希望保留 merge 提交，可扩展脚本参数，不要修改默认输出口径
