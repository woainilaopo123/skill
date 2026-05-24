# Examples And Field Mapping

## Purpose

Use this reference when the task is to explain formulas with examples, map invoice semantics to interface fields, or give product and testing teams a concrete calculation narrative.

## Example 1: Basic Amount Split

Scenario:
- total charge: `100.00`
- one full-self-pay item: `20.00`
- one category-paid item: `16.00`, with `30%` category self-burden
- remaining compliant amount: `64.00`

Calculation:

```text
yibao-fanwei-zonge = 16.00 + 64.00 = 80.00
fenlei-zifu = 16.00 * 30% = 4.80
jiaoyi-zonge = 80.00 - 4.80 = 75.20
fei-yibao-zifei = 20.00
```

Interpretation:
- `80.00` is inside insurance scope
- `4.80` is inside insurance scope but patient-first
- `75.20` is the effective settlement base
- `20.00` is outside insurance scope

## Example 2: National Platform Formula Set

Use when the center returns standardized settlement values.

```text
zong-feiyong = fei-yibao-zonge + yibao-fanwei-zonge
fenlei-zifu = xianxing-zifu
jiaoyi-zonge = yibao-fanwei-zonge - fenlei-zifu
yibao-baoxiao = jijin-zhifu-zonge
geren-zifu-total = jiaoyi-zonge - yibao-baoxiao
geren-zifu = yibao-fanwei-zonge - yibao-baoxiao
geren-zifei = quan-zifei + chao-xianjia-zifei
```

Key explanation:
- many raw fields come directly from interface returns
- HIS should not replace center-returned reimbursement with a locally derived number unless the business explicitly requires a secondary local layer

## Example 3: Shanghai phase-5 Formula Set

The materials describe the returned values like this:

```text
zong-feiyong = fei-yibao-zonge + yibao-fanwei-zonge
fenlei-zifu = yibao-fanwei-zonge - jiaoyi-zonge
yibao-baoxiao =
  qifuduan-account +
  tongchou-account +
  fujia-account +
  tongchou-pay +
  fujia-pay

jiaoyi-zonge =
  qifuduan-account +
  tongchou-account +
  fujia-account +
  qifuduan-cash +
  tongchou-cash +
  fujia-cash +
  tongchou-pay +
  fujia-pay

geren-zifu-total =
  qifuduan-cash +
  tongchou-cash +
  fujia-cash

geren-zifu = yibao-fanwei-zonge - yibao-baoxiao
geren-zifei = fei-yibao-zonge
```

Key explanation:
- phase-5 reimbursement excludes the cash-paid segments
- phase-5 self-pay inside settlement mainly comes from the cash-paid segments

## Example 4: Local Calculation

Illustrative scenario:
- total charge: `1000`
- item-level self-pay ratio yields non-insurance amount `200`
- insurance-scope amount becomes `800`
- fee-category personal ratio is `10%`

Then:

```text
geren-zifu-total = 200 + 800 * 10% = 280
yibao-baoxiao = 1000 - 280 = 720
```

This is an explanatory model, not a guarantee that every local fee category uses this exact rule.

## Example 5: Local Calculation Plus Upload

Pediatric or student insurance pattern:

1. HIS calculates local reimbursement
2. obtain values such as:
   - non-insurance amount
   - insurance-scope amount
   - category self-burden
   - personal payment
   - reimbursement amount
3. upload settlement information through the pediatric or student related real-time interface

## Example 6: Cadre Healthcare Secondary Calculation

Pattern:
1. call Shanghai phase-5 settlement
2. receive phase-5 returned amounts
3. use cadre-healthcare ratio logic for secondary reimbursement
4. combine results into the final settlement outcome

Important caution:
- explicitly separate first-stage center settlement from second-stage local reimbursement logic

## Invoice Or Display Mapping

When the user asks how invoice amounts relate to settlement fields, use this mapping language:

- outside-scope amount corresponds to full self-pay and over-limit self-pay
- insurance-scope total corresponds to compliant-scope amount plus category self-burden
- transaction total is the effective center settlement base
- category self-burden is the difference between scope total and transaction total
- personal outside-scope self-pay is not the same as personal burden after reimbursement

## Testing Checklist

When deriving test cases, cover at least these:

1. only full self-pay items
2. category-paid item with category self-burden
3. over-limit self-pay due to capped price
4. mixed drug and non-drug ratios
5. bundle settlement one-set vs two-set
6. restriction-use flag true vs false
7. high-price-drug quota rule
8. National platform path
9. Shanghai phase-5 path
10. local calculation path
11. local calculation plus upload path
12. phase-5 plus local secondary reimbursement path
