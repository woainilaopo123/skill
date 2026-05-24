# Settlement Modes

## Purpose

Use this reference when the task is to classify settlement paths, explain which route a patient follows, or compare National platform, Shanghai phase-5, and local calculation.

## Five Main Modes

### 1. National platform real-time settlement

Definition:
- HIS uploads registration, admission, detail, and settlement requests.
- The insurance center calculates and returns reimbursement results.

Typical use:
- urban employees
- urban-rural residents
- cross-region settlement
- other mainstream insured groups not diverted to Shanghai phase-5

Key point:
- HIS usually does not rely on local reimbursement-ratio configuration for the final reimbursement amount.
- HIS still needs to upload required flags and compliant detail data.

### 2. Shanghai phase-5 real-time settlement

Definition:
- HIS first computes upload-related amounts according to local rules.
- HIS calls phase-5 detail-upload and charge or confirm interfaces.
- The phase-5 center returns reimbursement and patient-borne amounts.

Typical use:
- mutual-aid hardship assistance
- civil-affairs hardship assistance
- work injury
- some cadre-healthcare-related groups
- some online or internet-hospital transactions

Key point:
- HIS has stronger pre-upload calculation responsibility than in National platform mode.

### 3. HIS local calculation

Definition:
- HIS calculates settlement amounts by local rules without relying on the center for reimbursement computation.

Typical use:
- family-planning categories
- retired special groups
- local legacy categories

Key point:
- local configuration correctness is critical
- historical rule changes may require recalculation policy

### 4. Shanghai phase-5 plus local secondary calculation

Definition:
- first complete Shanghai phase-5 settlement
- then perform a second local reimbursement calculation on top of the returned phase-5 results

Typical use:
- cadre healthcare scenarios in the source materials

Key point:
- this is a layered reimbursement path, not a mutually exclusive path choice

### 5. Local calculation plus real-time upload

Definition:
- HIS completes local calculation first
- then uploads settlement information through a designated interface

Typical use:
- pediatric insurance
- student insurance
- pediatric and student dual-voucher inpatient scenarios

Key point:
- reimbursement calculation is local-first and upload-second

## Routing Questions

When explaining a patient's settlement path, answer these in order:

1. Is this patient center-calculated or locally calculated?
2. If center-calculated, is the path National platform or Shanghai phase-5?
3. Is there a second-stage local calculation afterward?
4. Is there a post-settlement upload requirement?

## Special Cases

### Dual voucher

For pediatric and student dual-voucher scenarios:
- calculate student branch once
- calculate pediatric branch once
- combine the two reimbursement amounts
- cap the result so the total reimbursement does not exceed the insurance-scope amount

### Emergency fallback

The source materials describe an emergency rule:
- if the National platform is unavailable, categories that normally use National interfaces may be switched to Shanghai phase-5 based on center instructions

Mention this when discussing contingency design or fault handling.

## Suggested Answer Pattern

```text
insured type or scenario
-> settlement mode
-> what HIS calculates locally
-> what HIS uploads
-> what the center returns
-> whether a second calculation or second upload follows
```
