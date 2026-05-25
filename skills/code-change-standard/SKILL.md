---
name: code-change-standard
description: Use when agent is asked to modify code and must follow a strict change-control workflow with mandatory pre-checks, requirement-id confirmation, project skill reading, archive lookup and writeback, UTF-8 safety, minimal-diff editing, post-change code review, and risk reporting. Trigger this skill for code fixes, feature changes, refactors, or any request that edits source code under a project.
---

# Code Change Standard

## Overview

Apply a strict workflow before, during, and after any code change.
Prefer completeness of process over speed. If mandatory inputs are missing, stop and ask once before reading code or editing files.

## Required Workflow

Follow this sequence for every code change request:

1. Confirm whether the task will modify code.
2. Collect mandatory inputs.
3. Run `git pull` before reading code deeply or editing files.
4. If `git pull` conflicts, stop immediately and report the conflict locations to the user.
5. Read project-specific skills under `project/.skill/`.
6. Read the archive file `F:/arch/projectName.md` if it exists.
7. Only after all required information is present, inspect code and make the smallest safe change.
8. After editing, report changed file ranges, risk assessment, code review, and archive updates.

## Before Editing

Treat the following items as mandatory gates:

1. Ask for the requirement ID if the user did not provide one. Do not proceed without it.
2. If the task is backend Java code, ask for:
   - an input JSON example
   - the current response JSON
   - optionally propose the expected response JSON after the change
3. Read any project skills under `project/.skill/`.
4. Check whether `F:/arch/projectName.md` exists. If it exists, read it before code inspection.
5. Keep all file edits in UTF-8 and avoid introducing encoding corruption.
6. If any mandatory information is missing, ask for all missing items in one message, then wait.

Run `git pull` before code modification:

- If it succeeds, continue.
- If it conflicts, stop and do not continue with any later step.
- Tell the user there is a conflict.
- Report each conflicted file and the start and end line numbers of the conflict block if they can be determined from the merge markers.
- If exact line numbers cannot be derived safely, say that clearly and report the conflicted files at minimum.

## During Editing

Follow these editing rules:

1. Apply the minimum-change principle. Preserve surrounding logic and style.
2. If code needs to be removed, comment it out instead of deleting it, unless the user explicitly requires deletion.
3. If you detect uncertainty, stop and ask the user before editing.
4. Always evaluate modification risk, even if the user already provided the implementation direction.
5. Skip extra questions only when all of these are true:
   - confidence is high
   - modification risk is low
   - the user already answered the relevant questions
   - the context is unambiguous
6. Add concise comments only where they improve comprehension.
7. Add appropriate logs such as `console.log()` or `log.info()` when they help observability and fit the codebase.

## After Editing

Always finish with these outputs:

1. Tell the user which files changed and the start and end line numbers of the changed regions.
2. Classify any remaining code issues or concerns as high, medium, or low risk.
3. Perform an automatic code review after the change.
4. If a design pattern could improve the area, provide a short optional redesign direction.

## Archive Rules

Write archives after the change:

1. Ensure the archive root `F:/arch` exists. Create it if needed.
2. Write the main archive file as `F:/arch/<requirement-id>-Archive.md`.
3. If the user reports a follow-up problem for a previous requirement and supplies a new requirement ID, write the file as `F:/arch/<old-requirement-id>-<new-requirement-id>-Archive.md`.
4. Archive enough detail that the next agent can recover context quickly.

Use this structure for requirement archives:

```md
# 序号 - 日期 - 需求号

## 当前问题

## 修改目标

## 修改内容

## 代码逻辑
```

When the user verifies the change is successful, update the archive with a concise summary of the key information learned during the conversation.

If you discover reusable project-level knowledge, also write or update `F:/arch/projectName.md` with this structure:

```md
# 序号 - 日期

## 通用知识
```

## Missing-Information Message

When required information is missing, ask once and list everything missing in a single message. Use a compact format such as:

```text
开始修改前还缺少以下信息：
1. 需求号
2. Java 入参 JSON
3. 当前响应 JSON
4. 项目名（用于检查 F:/arch/projectName.md）

这些信息补齐后，我再开始读取项目代码和修改。
```

## Decision Boundary

Do not read code deeply, edit files, or continue past the gate if any mandatory requirement is missing.
Do not guess requirement IDs, archive names, project names, JSON examples, or intended behavior.
When a project-specific skill conflicts with this skill, follow the stricter rule and surface the conflict to the user.
