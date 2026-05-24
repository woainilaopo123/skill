---
name: ccswitch-skill-sync
description: 当需要把本地 `D:/skills` 下的 skill 新增或更新到 `C:/Users/Administrator/.cc-switch/skills` 时使用。用于同步单个 skill 或批量同步全部本地 skill，确保 cc-switch 侧技能目录和本地技能目录保持一致。适用于本地 skill 刚修改完成、需要发布到 cc-switch、或需要补齐 cc-switch 缺失 skill 的场景。
---

# CC Switch Skill Sync

## 概述

使用这个 skill 把本地 skill 同步到 cc-switch 的 skill 目录。
优先使用内置脚本 `scripts/sync-ccswitch-skill.ps1`，不要手工逐个复制文件，避免漏同步或残留旧文件。

## 默认目录

- 本地 skill 根目录：`D:/skills`
- cc-switch skill 根目录：`C:/Users/Administrator/.cc-switch/skills`

如果用户提供了其他目录，按用户指定目录执行。

## 使用方式

同步单个 skill：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\sync-ccswitch-skill.ps1 -SkillName code-change-standard
```

批量同步全部本地 skill：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\sync-ccswitch-skill.ps1 -All
```

仅预览、不实际写入：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\sync-ccswitch-skill.ps1 -SkillName code-change-standard -DryRun
```

## 同步规则

1. 源目录中的 skill 必须存在，并且必须包含 `SKILL.md`。
2. 默认使用镜像同步，目标目录中本地已删除的文件也会被清理。
3. 排除 `.git`、`.idea` 等不应进入 skill 发布目录的内容。
4. 同步完成后，向用户汇报：
   - 同步了哪个 skill
   - 是新增还是更新
   - 源目录和目标目录
   - 是否使用了 `DryRun`
5. 如果用户没有明确要求批量同步，默认只同步单个 skill。

## 边界规则

1. 不要猜测 skill 名称。
2. 如果源 skill 缺少 `SKILL.md`，立即报错并停止。
3. 如果用户只想同步某一个 skill，不要顺手同步其他 skill。
4. 如果用户要求同步后还要做验证，可以额外检查目标目录下的关键文件是否已存在。
