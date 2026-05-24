# Upload Methods And Data Synchronization

## Purpose

Use this reference when the task is to explain upload methods, interface timing, directory import, code maintenance, or the difference between settlement upload and catalog synchronization.

## Upload Has Multiple Meanings

In this domain, `upload` may refer to:

1. real-time settlement interface calls
2. post-settlement result upload
3. front-machine shared-directory or FTP file import
4. website-announcement-driven Excel import
5. DBF export to a front machine
6. database polling synchronization to a front-machine database

Always clarify which one the user means.

## Settlement Transaction Upload

### National Healthcare Security Platform

Typical interface stages from the source materials:
- outpatient registration `2201`
- inpatient admission `2401`
- detail upload `2301` or `2204`
- settlement or confirmation interfaces

Important characteristics:
- registration or admission generates `mdtrt_id`
- in Shanghai scenarios, settlement requests may need to use the `mdtrt_id` from registration or admission
- special flags must still be uploaded even when the center performs final reimbursement calculation

Common uploaded fields or flags:
- reduction or relief flags
- high-price-drug indicators
- approval or restriction result flags such as `hosp_appr_flag`
- bundle number or group-settlement code
- single-herb vs compound-herb indicator where required

### Shanghai phase-5

Typical flow:
1. HIS reads local configuration
2. HIS computes upload-related amounts such as:
   - transaction amount
   - insurance-scope amount
   - non-insurance-scope amount
   - quota-payment or reduction flags
   - bundle code
3. HIS uploads fee details
4. HIS calls outpatient charge or inpatient charge plus confirmation interfaces
5. center returns reimbursement and patient-borne results

Important characteristic:
- phase-5 upload depends heavily on HIS-side pre-calculation

### Pediatric or student insurance

Typical flow:
1. HIS performs local calculation
2. HIS obtains local reimbursement result
3. HIS calls the pediatric-fund or related upload interface
4. settlement information is uploaded in real time

Important characteristic:
- reimbursement calculation is local-first, upload-second

### Cadre healthcare

Two patterns are described in the source:

#### Phase 1

- export daily data in the required DBF format
- upload through the cadre front machine

#### Phase 2

- after a transaction occurs, synchronize data to the cadre front-machine database within about 10 minutes
- the existing implementation described in the source uses scheduled database polling

## Catalog And Base-Data Synchronization

### Western and Chinese medicine catalogs

Source:
- insurance front machine
- shared directory or FTP

Format:
- txt files

Flow:
1. files are pushed to a designated front-machine directory
2. hospital staff or system imports the txt files
3. the system parses the files
4. parsed data is stored in the local database
5. settlement configuration is updated from parsed rules where needed

These files may include:
- drug base information
- price rules
- procurement rules
- distributor data
- reimbursement conditions
- reimbursement-ratio rules
- high-price-drug rules
- national-code mapping
- catalog-rule data

### Diagnosis and treatment item catalog, material catalog

Source:
- Shanghai insurance settlement item information website

Format:
- usually Excel or website-issued announcements

Flow:
1. operations staff gets the update notice
2. obtains the Excel or announcement content
3. imports via management page or maintains manually

### Physician catalog

Flow:
1. register or file physician information on the insurance website
2. obtain center physician code
3. import by Excel or maintain manually in the local system

### Department catalog

Characteristics:
- usually fixed catalog
- often distributed with interface documents
- may be imported by Excel or entered manually

### Shanghai code and national code

Important distinction:
- diagnosis and treatment items may have both Shanghai code and national code
- physician records may also need both Shanghai code and national code
- the data model should support one local record mapping to multiple insurance-side codes by time range

## Reconciliation Notes

The source materials mention daily reconciliation:
- compare daily totals
- if totals are imbalanced, fetch center details and compare with local details
- for extra local records, perform account correction
- phase-5 may require correction-application printing
- National-platform cases may require reversal handling

Mention these when the user asks about operations or after-settlement exception flows.
