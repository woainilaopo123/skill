---
name: medical-insurance-settlement
description: Comprehensive medical insurance settlement knowledge and implementation guide focused on Shanghai HIS scenarios, including settlement concepts, amount formulas, National Healthcare Security Platform workflows, Shanghai phase-5 workflows, local-calculation workflows, pediatric and student insurance upload flows, cadre healthcare secondary-settlement logic, catalog maintenance, field mapping, and special settlement flags. Use when Codex needs to read or explain medical-insurance documents, sort business rules, design or review HIS medical-insurance modules, summarize settlement formulas, explain upload methods, map reimbursement fields, or turn domain knowledge into product, development, testing, or implementation guidance.
---

# Medical Insurance Settlement

## Overview

Use this skill to analyze, explain, and structure Chinese medical-insurance settlement knowledge, especially Shanghai hospital information system scenarios. Focus on turning scattered rules, formulas, interface behaviors, and configuration items into clear business explanations and implementation-ready outputs.

## Workflow

1. Identify the user's goal.
   Common goals include:
   - explain concepts and formulas
   - summarize a policy or product document
   - compare National Healthcare Security Platform, Shanghai phase-5, and local settlement
   - clarify how settlement data is uploaded
   - derive product requirements, design notes, test cases, or implementation rules

2. Identify the scope.
   Decide whether the request is mainly about:
   - core settlement concepts
   - settlement formulas
   - settlement modes and patient-type routing
   - upload interfaces and upload timing
   - base catalog import and code mapping
   - special rules such as bundle settlement, quota self-pay, restriction flags, dual vouchers, or cadre healthcare

3. Load only the needed references.
   Reference map:
   - Core concepts and common formulas: `references/core-concepts.md`
   - Settlement modes and routing rules: `references/settlement-modes.md`
   - Upload methods, interfaces, and catalog synchronization: `references/upload-and-sync.md`
   - Configuration items and special settlement rules: `references/configurations-and-special-rules.md`
   - Worked examples and field mapping: `references/examples-and-mapping.md`

4. Normalize terminology before answering.
   Keep the following distinctions explicit:
   - `geren-zifei` / personal self-pay outside insurance scope: usually full self-pay or over-limit self-pay
   - `fenlei-zifu` / category self-burden: inside insurance scope but paid first by the patient according to category rules
   - `geren-zifu` / personal burden after reimbursement: inside settlement scope after fund reimbursement
   - `geren-zifu-total` / personal self-pay in insurance path: usually `geren-zifu + fenlei-zifu`
   - `geren-xianjin-zhifu` / actual out-of-pocket cash: usually `geren-zifu-total + geren-zifei`
   - `yibao-jiesuan-fanwei-feiyong-zonge` is not the same as `jiaoyi-feiyong-zonge`

5. State the settlement path clearly.
   When explaining a scenario, always classify it into one of these paths:
   - National platform real-time settlement
   - Shanghai phase-5 real-time settlement
   - HIS local calculation
   - Shanghai phase-5 plus local secondary calculation
   - local calculation plus real-time upload

6. Make implementation boundaries explicit.
   When the user is asking from a product or development angle, separate:
   - what HIS calculates locally
   - what HIS uploads
   - what the insurance center calculates and returns
   - what configuration data must exist before settlement

## Output Rules

When answering, prefer this order unless the user asks otherwise:

1. settlement mode or business background
2. key concepts
3. formulas
4. upload or interface flow
5. special rules or exceptions
6. risks, ambiguities, or items that depend on local policy configuration

If the user asks for a document summary, produce:
- a terminology section
- a formula section
- a workflow section
- a configuration section
- an implementation or testing checklist when helpful

If the user asks for system design or code guidance, produce:
- upstream inputs
- calculation steps
- outbound interface fields
- return-field interpretation
- rollback, retry, and reconciliation concerns

## Practical Guidance

- Prefer Chinese business meaning in the explanation, but use stable ASCII aliases in the skill text when needed.
- If both business and system meanings exist, explain both.
- If formulas differ between National platform and Shanghai phase-5, show them separately.
- For local-calculation scenarios, state that the exact final rule depends on fee-category configuration, ratio configuration, upper-limit rules, and special flags.
- For pediatric or student insurance, explicitly mention that settlement may be local-first and upload-later.
- For cadre healthcare, explicitly mention secondary calculation on top of phase-5 results where applicable.
- If the request references invoice amounts, distinguish displayed invoice semantics from raw interface fields.

## Cautions

- Do not assume all insurance types use the same formula source. Some are center-calculated, some are locally calculated, and some are hybrid.
- Do not merge `jiaoyi-feiyong-zonge`, `yibao-jiesuan-fanwei-feiyong-zonge`, and `geren-zifei` into a single concept.
- Do not describe upload as only "calling an interface". In this domain, upload may also mean front-end manual import, pre-machine file distribution, FTP or shared-directory sync, DBF export, or database polling synchronization.
- Treat examples in the references as explanatory models unless the user confirms they are the production rule set.
