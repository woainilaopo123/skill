# Configurations And Special Rules

## Purpose

Use this reference when the task is to explain what must be configured before settlement, or when the user asks about business rules that affect amount calculation and upload fields.

## Core Configuration Items

### Self-pay ratio and category-self-burden flags

Common fields:
- outpatient self-pay flag
- outpatient self-pay ratio
- outpatient category-self-burden flag
- inpatient self-pay flag
- inpatient self-pay ratio
- inpatient category-self-burden flag

Use:
- local calculation
- phase-5 upload amount calculation
- insurance-scope and non-scope split

### Fixed upper limit

Use for items such as:
- registration fee
- bed fee
- artificial lens

Rule:
- amount within limit can participate according to policy
- amount above limit becomes self-pay or category-self-burden depending on the rule

### Fixed upper limit plus fixed ratio

Use for some pilot-drug payment-standard scenarios.

Rule:
- within capped standard: settle by ratio
- above standard: excess becomes category self-burden or self-pay according to policy

### Quota self-burden or high-price-drug rule

Rule:
- amount within quota can be reimbursable
- amount outside quota becomes self-pay

Additional note:
- these drugs often require special markers
- outpatient charging may require separate settlement
- some work-injury inpatient scenarios also require separate settlement

### Bundle settlement or group code

Use when multiple materials belong to one policy bundle, such as artificial-joint scenarios.

Rule:
- multiple material records share one bundle identifier
- reimbursement is controlled by the policy cap for the bundle
- one-set and two-set cases may use different bundle codes and limits

Implementation note:
- National-platform upload may require the bundle number
- local and phase-5 logic may need to determine one-set vs two-set before upload

### Restriction-use flag

Rule:
- if the restriction condition is met, settle by insurance rules
- if not met, settle as self-pay

System note:
- prescribing workflow may need a prompt for the doctor
- National detail upload may use the doctor's choice in `hosp_appr_flag`
- phase-5 or local calculation must also use this choice to compute amounts

### Unit conversion factor

Typical use:
- uploading Chinese herbal medicine quantity and unit price by gram
- splitting quota-drug quantities
- pilot-drug payment-standard calculation

### Dual-voucher ratio configuration

Use for pediatric and student dual-voucher scenarios where the same drug or item is paid differently by each branch.

### Special ratio configuration

Use when:
- the same item has different self-pay ratios by insurance type or fee category
- different effective dates apply
- segmented or all-history execution rules exist

Historical-rule note:
- if a ratio changes during a long stay, the system may need segmented application or full recalculation by the latest rule

## Platform-Visible Special Flags

### Reduction or relief flag

Used for severe-disease reduction or special relief scenarios, such as:
- uremic dialysis reduction
- anti-rejection therapy after renal transplant
- psychiatric expense reduction

These may map to:
- National detail-upload extension bits
- phase-5 reduction-related indicators

### High-price-drug indicator

Needed when an item falls into special high-price-drug handling.

### Bundle number

Needed where policy requires group-settlement identification.

### Single-herb vs compound-herb indicator

Needed in some Chinese-herb scenarios where reimbursement depends on whether the prescription is single-herb or compound-herb.

## Local Calculation Model

The source materials describe a two-layer local calculation idea:

1. split detail amounts into:
   - non-insurance amount
   - insurance-scope amount
   - category self-burden
   - transaction amount

2. apply fee-category reimbursement rules:
   - by lower limit and upper limit
   - by drug vs non-drug ratios
   - by segmented bands
   - by special override rules

Settlement formulas may be based on:
- insurance-scope total amount
- transaction amount

Typical distinction:
- use insurance-scope total when there is no settlement cap
- use transaction amount when the rule has a single-settlement cap, such as some pediatric single-disease scenarios

## Priority Rules

When multiple ratio sources exist, explain the priority explicitly. The source materials imply patterns such as:
- patient-specific special ratio overrides general fee-category ratio
- cadre-patient special item ratio may override generic cadre ratio
- dual-voucher scenarios may require separate student and pediatric runs, then capped aggregation

## Operational Requirements

The source materials repeatedly imply these system capabilities:
- maintain effective-date history
- prevent overlapping active records for the same rule dimension
- support enable or disable instead of destructive deletion
- support query and audit log
- support segmented execution or full execution after rule changes
