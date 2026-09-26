# PhERP — Migration and Architecture Plan

Porting PhsAPI / PhsApp (Java) to PhAPI / PhApp (Node.js), and improving them
while doing it.

This document is the contract. Where code and this file disagree, one of them is
wrong and the disagreement gets resolved before the work continues — it is not
left standing.

There are no dates or estimates here on purpose. Steps have entry and exit
conditions instead, so a step is finished when it is demonstrably finished.

---

## Part 1 — Rules

These are binding. A rule is not advice; breaking one is a defect even when the
feature works.

### Layering

**L1. Each layer may require only the layer directly beneath it.**
Reaching two layers down is a violation even when it compiles. `utils` is the
single exception: it is a leaf, everyone may use it, and it may require nothing
but Node built-ins.

**L2. Only `http/` knows HTTP.**
No `req`, `res`, status code, header or route string below it. A service that
needs the caller's language receives a value, not a request.

**L3. Only `data/dialects` knows an engine.**
No `oracle`, `mysql` or `postgres` string, and no engine-specific SQL function,
anywhere above it. A layer that needs a date converted asks the query layer; the
query layer asks the dialect.

**L4. Presentation never runs in the domain.**
Translating a label, formatting a date for a client, shaping an envelope — these
happen in `presentation`, on the way out. A service returns domain values.

**L5. A repository handles one entity and knows no rules.**
It reads and writes rows. Validation, audit stamps, autonumbering, child
ordering and transactions belong to the service above it.

**L6. Cross-cutting logic is written once.**
If the same rule appears in two dialects, two services or two controllers, it is
in the wrong place. Move it down until there is one copy.

### Metadata

**M1. `resources/modules` is generated from the database and is authoritative
for what a column is.**
Type, precision, scale, nullability, relations, sequences, children. Nothing
hand-written competes with it. `scripts/generateFromSchema.js` is how it changes.

**M2. The generator never rewrites an existing file.**
Hand-set annotations — `isLabel`, corrected display fields, curated children —
cannot be recovered from a schema. `--force` exists and must be asked for
explicitly.

**M3. Screen metadata is an overlay, never a copy.**
A screen file names an entity and adds only what the schema cannot know: field
order, grid, labels, list columns, which fields are filterable, which operators,
aggregates, expressions, autocomplete source. If a property can be derived from
the entity, deriving it is mandatory.

**M4. One entity per block, not per screen.**
A screen is a composition of blocks. Master/detail, lookups and attachments each
name their own entity. Relations already declared on the entity supply lookups
without the screen mentioning them.

**M5. Metadata is data, not code.**
Adding a screen is adding a file. It must never require a deploy, a build step
or an edit to a registry.

### Data access

**D1. Values are bound, never concatenated.**
No client value reaches SQL text. This includes numbers, dates and IN lists. The
Java original concatenated and escaped quotes; that is not ported.

**D2. Identifiers come from metadata, never from a request.**
A column or table name is resolved against the entity's field list first. An
unresolved name drops the condition and is logged; it is never passed through.

**D3. Operators come from a closed list.**
An operator not on the list is rejected before SQL is built. The `$$` free-SQL
operator is never accepted from a client.

**D4. Dates state their format at both boundaries.**
Never rely on a session's `NLS_DATE_FORMAT` or on a driver's timezone. The
column's declared type decides: `DATE`, `DATETIME`, `TIME`. On the way out a
date is written from its own calendar parts with no timezone attached.

**D5. A large result streams.**
Anything that can return thousands of rows — reports, exports, code tables such
as the 9168-row airport list — streams. It does not accumulate in memory.

### Porting

**P1. Recover before inventing.**
The Java system describes its screens declaratively already. Before designing a
format, find the existing one and read it. Two have been found: 595 query
definitions and per-screen `aFields` / `aQFields`.

**P2. Port semantics, not implementation.**
The operator set, the date formats, the field validation and the `$$` rejection
are the contract and are ported exactly. String concatenation, unbound values
and `UPPER(col) LIKE` on every text search are not.

**P3. Where the legacy metadata and the schema disagree, the schema wins.**
The legacy `dataType` is absent on 64% of fields; `DBType` is generated and
accurate.

**P4. Existing screens are not touched by generated ones.**
A custom component always takes precedence over a screen file. Ejecting a
generated screen to custom code is done by adding the component, and requires no
change to the metadata.

**P5. Node's advantages are taken after the feature works, not instead of it.**
Streaming, worker threads, shared types and concurrency are improvements to
working code.

### Verification

**V1. A claim about behaviour is measured, not asserted.**
"It works" means it was run. A fix to a query path is proven against the
database, inside a transaction, and rolled back.

**V2. A migration that rewrites files proves it only changed what it meant to.**
Hash the tree before, hash it after, and report what moved.

**V3. The test suite is green before a step is called finished.**
Not "green except". A test that cannot pass is either fixed or deleted with a
reason.

**V4. Layer rules are enforced by a test, not by memory.**
See Part 4.

---

## Part 2 — Target layers

Each layer's charter, and the thing it must never do.

| Layer | Does | Must never |
|---|---|---|
| `http/routes` | Path, method, middleware wiring | Contain logic |
| `http/controllers` | Translate HTTP to and from the domain | Build SQL, apply rules |
| `presentation` | Label translation, date formatting, response envelope | Read or write data |
| `domain/services` | Business rules, transactions, validation, autonumber, children | Know HTTP or a dialect |
| `data/repository` | One entity in and out | Know rules or HTTP |
| `data/query` | Dialect-neutral query model: select, insert, update, conditions, dates | Name an engine |
| `data/dialects` | Quoting, placeholders, pagination, date functions | Contain query shape |
| `metadata` | Entity and screen registry, loading and reloading | Depend on anything above it |
| `utils` | Pure leaf helpers | Require any project layer |

A dialect declares four things and nothing more:

```js
{
  quote:       name => `"${name}"`,
  placeholder: index => `:p_${index}`,
  paginate:    (sql, page, size) => `${sql} OFFSET … FETCH NEXT …`,
  toDate:      (placeholder, format) => `TO_DATE(${placeholder}, '${format}')`
}
```

The shape of a SELECT is not a dialect concern. Adding a fourth engine is adding
one such file.

---

## Part 3 — Steps

Ordered. A step starts only when the previous one's exit condition holds.

### Step 0 — Boundaries

Draw the layers before adding anything to them. No behaviour changes.

1. Extract `presentation` from `services`: label translation and date output
   formatting move out of `unifiedService`.
2. Collapse the three SQL builders into one query model plus three dialect
   files. The six build methods are written once.
3. Move the metadata registry out of `config/` into `metadata/`. A registry is
   not configuration.
4. Move SQL dialect adaptation out of the connection pool into `data/dialects`.
5. Break the upward dependencies out of `utils`.

**Entry:** none. **Exit:** the layer test passes, the suite is green, and no
endpoint's output has changed.

**Why first:** the condition engine is the next thing written. Written before
this step it is written three times.

### Step 1 — Condition engine

Port `Condition.java` by its semantics.

1. The seventeen operators, with the SQL each produces, in `data/query`.
2. Values bound. Value type taken from the entity's `DBType`.
3. Field names resolved against the entity; unresolved conditions dropped and
   logged.
4. `$$` rejected from any client-supplied condition.
5. `unifiedService.search` wired to it, replacing the equality-only filter map.
6. Operator allowlist per field kind, derived from `DBType`.

**Entry:** Step 0 complete. **Exit:** every operator proven against the database
with a bound value; a hostile value in each operator proven to stay inside the
bind; the suite green.

### Step 2 — Screen metadata converter

Convert, do not author.

1. Read the recovered query definitions and the legacy per-screen field
   metadata.
2. Emit `resources/screens/`, carrying only what the schema cannot supply.
3. Read both spellings of the aggregate keys.
4. Seed translation keys into the locale files for every emitted label.

**Entry:** Step 1 complete. **Exit:** converted screens validate against the
screen schema; every entity they name resolves; a sample is compared field by
field against its Java original.

### Step 3 — Generic renderer

One renderer in PhApp, built from PhApp's existing components. No new UI
library.

1. Fetch the screen file through the existing proxy, with session and program
   id.
2. Render search, list and form from it.
3. Fall back to it only when the registry has no component for the program.

**Entry:** Step 2 complete. **Exit:** one existing screen rendered from metadata
matches its hand-written version field for field, and the hand-written one still
takes precedence when present.

**Note on the metadata this needed.** Step 2 converted the first of the two
declarative sources P1 names — the 595 query definitions, which describe what
may be *searched* on an entity. The entry forms are the second, `aFields` and
`aQFields`, and they are a different fact: `Clnc/Doctors.json` lists twenty
searchable columns including the audit stamps, while the Doctors *screen* is
sixteen fields in a particular order with Speciality as a select and User as an
autocomplete. Step 3 therefore recovered that second source before it could
render anything. See `resources/SCREENS.md`.

### Step 4 — Screens

In order of how uniform they are: Table, then Query, then Daily, then Statistic.

**Entry:** Step 3 complete. **Exit:** per screen — it renders, searches, saves
and deletes against the real database.

**Measured coverage**, active programs in the `Demo` tenant:

| Kind | Active | Described | With a form |
|---|---|---|---|
| Table | 143 | 93 | 93 |
| Daily | 153 | 103 | 103 |
| Query + Statistic | 219 | 121 | — |

**Line grids**, recovered from the same page scripts:

| | |
|---|---|
| Pages declaring a `phTable` | 254 |
| Whose grid was captured | 104 |
| Screens emitting lines | 85 |
| Line grids / line fields | 106 / 984 |

A grid is paired with the child entity it writes to by evidence, not by
position: each declared child is scored on how many of the grid's columns are
real columns of it. The two lists usually align — `crm/mng/Contacts` has three
grids and three children — but a grid paired with the wrong child would write
line items into another table.

Query and Statistic were 24 until three things were fixed, and each was costing
most of the rest:

- A query page addresses a **query definition**, not a table. `/UC/Fix/Inbound`
  is the definition `Fix/Inbound`, whose entity is the view `Fix/InboundView`.
  Both the converter and `reportService.resolve` looked only in the entity
  registry, so 60 of the 548 definitions were unreachable and answered "Report
  metadata not found" for a file that is on disk. A form page must NOT resolve
  this way: `/UC/Emp/Deduction` is both a table and a definition over its view,
  and pointing an entry screen at the view costs it 190 fields.
- `PHS_QRY_CARD_CONDITIONS` is declared at the top of **PhsQuery.js**, not
  PhConst.js, so in the extraction sandbox a card's `cardType === 1` compared a
  stub against a number and every condition card read as empty.
- A condition card spells its component `componentType`; `aQFields` spells the
  same thing `component`. Reading one left the other to be derived, and a select
  over a view's reference column — which has no relation to derive from — came
  out as a plain number input.

**One correction to the order.** The report path has to be wired to the
condition engine between Table and Query. `reportService.query` reads
`params.filters` and answers `{name, title, data, count}`; the client sends
`{conditions, group, aggregate, order}` and reads `data.report.rows`. So every
condition a `/Query` or `/Statistics` caller sets is discarded and the response
shape does not match. Step 1 wired the engine into `unifiedService.search` and
never into the report path, and 219 screens depend on it.

**Daily needs a capability, not a field list.** Its 103 described screens are
master/detail — a form over a transaction with a grid of its lines — and
`MasterDataScreen` has no child grid. That is why the plan puts Daily third and
it stays third.

### Step 5 — Node's advantages

1. Stream report and export responses. *Done for the report PDF -- the one
   export -- through `repository.stream()`. Measured on NSCC's
   Acc/VoucherView, 100524 rows: whole, 723 MB of heap and 2453 ms to the
   first row; streamed, 91 MB and 65 ms, same total time.*
2. Share entity types between PhAPI and PhApp instead of hand-writing them
   twice.
3. Parallelise independent reads that are sequential today. *Done: a
   record's child grids, a package's code tables and the user profile read
   side by side through `utils/parallel.js`, at most `PARALLEL_READS` (4) at
   once. Measured on NSCC with the database on the same machine: 37 code
   tables 8.3 -> 4.2 ms, the profile 3.8 -> 3.5 ms; the saving is the round
   trip, so it grows with the distance to the database.*
4. Move export generation and report aggregation to worker threads. *Done
   for the PDF export, the one export: laid out on a worker thread, at most
   `EXPORT_WORKERS` at once. Measured on NSCC's Acc/VoucherView, two
   50000-row exports at once: 31.9 s -> 15.2 s, and the server's thread held
   at most 33 ms at a stretch instead of 512. Report aggregation reads at most 500 rows and stays
   where it is.*
5. Reload metadata without a restart. *Done: `services/metadataReload.js`
   watches the metadata trees and reloads in 150-250 ms, keeping any part
   whose files do not read cleanly; SIGHUP reloads where watching cannot.*

**Entry:** the feature the improvement applies to works. **Exit:** measured
before and after.

---

## Part 4 — Enforcement

Separation decays quietly. Someone needs a translation inside a repository,
imports it, and the boundary is gone in one line. Memory does not prevent this.

**A layer test runs in the suite.** It walks every `require`, maps each file to
its layer, and fails on:

- a layer requiring anything but the layer directly beneath it,
- any file below `http/` naming `req`, `res` or a status code,
- any file above `data/dialects` naming an engine,
- `utils` requiring a project layer.

A violation fails the build. That is what makes this decision irreversible: it
stops being an agreement and becomes a condition.

---

## Appendix — Measured facts

Recorded so the rules above are traceable to evidence rather than taste.

**Scope**

| | |
|---|---|
| Active programs in the menu | 530 |
| Screens built in PhApp | 19 |
| Daily / Query / Table / Statistic | 153 / 146 / 143 / 73 |
| Programs declaring their table (`MPrg_RelTable`) | 72 |

**Metadata**

| | |
|---|---|
| Entity models in `resources/modules` | 1215 |
| Tables and views read from the live schema | 935 |
| Models declaring children (master/detail) | 147 |
| Models declaring relations (lookups) | 846 |
| Models that are pre-joined views | 233 |
| Autocomplete templates | 488 |

**Recovered program screens** — from the Java client's page scripts

| | |
|---|---|
| Page scripts read | 543 |
| Declaring a screen a widget could be handed | 461 |
| Converted (their entity is described here) | 273 |
| Naming a `/CC/` endpoint or an unregistered entity | 122 |
| Form fields / search fields carried | 2663 / 2356 |
| Fields dropped — column not on the entity | 600 |
| Fields stating an input the schema cannot imply | 927 of 5019 (18%) |

**Labels, before the lookup read both sections**

Step 2 seeded 2386 keys into `locales/*.json` under `fields`, one per column
name with a readable default — `clinicName` becomes "Clinic Name".
`translateLabel` looked in `labels` alone, so none of them was ever read and a
converted query screen's columns came back as their own names. It now searches
`labels` first, so a hand-written translation always beats a generated one, then
`fields`.

872 of those 2386 keys carry the Java bundle's own vocabulary now, in both
languages, imported through `scripts/importJavaLabels.js --section=fields`. The
bundle is keyed by word rather than by column — `Acc_Num`, not
`Acc_Master.Acc_Num` — so a column name is matched through its plausible
spellings: `accNum`, `acc num`, `accnum`, `Acc.Num`, `Acc_Num`.

English takes the same words, so the two languages say the same thing. That is
also the larger improvement: 805 of the 872 differ from the generated default,
and almost all of them are a real label where there was an abbreviation —
`accnum` was "Accnum" and is "Account Number", `admAuthresp` was "Adm Authresp"
and is "Authoriztion and Responsibility".

The flat namespace has one cost worth knowing: a word means whatever the screen
that first used it meant, so `App_Id` carries the bundle's English "Count" and
is now the label for every `appId` column. The remaining 1514 keys kept their
generated readable default in both languages; they are being drafted a package
at a time, 1390 keys in both languages; the 124 left are abbreviations waiting
on the owner's reading.

**Saving a document, before `update` knew about children**

| | |
|---|---|
| Child collections `update` handled | none |
| Columns required on create AND refused on create | 10 |
| Columns NOT NULL with a database default the validator still demanded | 366 |

`create` handled children, `get` returned them and `delete` cascaded them; only
`update` did not. It validated a payload allowed to carry them and handed it to
a repository that builds its SET from the entity's own columns, so a child array
was silently dropped — every line a user changed on a document screen was
discarded while the save reported success.

The validator refused two kinds of payload no client could form. A column that
is NOT NULL with no default and `insert: false` was required and refused at
once, which is why `pur/Purchase`, `pur/Returns` and `sales/Sales` could not be
saved at all. And a NOT NULL column with a database default was demanded from
the client, which is what PhApp's `blankValue` exists to work around: sending
the default back by hand.

**Saving, before the key was assigned**

| | |
|---|---|
| Primary-key fields naming a sequence | 950 |
| Already flagged `isAutonumber: true` | 529 |
| Flagged false beside the sequence they name | 421 |
| Table screens that could not save a row | 45 of 93 |
| Of the 421 sequences, present in the `Demo` schema | 160 |

The generator writes an `Autonumber` block naming the table's sequence onto
every column -- 18935 of them, which makes the block itself no signal -- and on
the primary key it writes that block *and* `isAutonumber: false` beside it. So
`create` sent whatever the client held for the key, which is 0 from an entry
form, and the insert failed on a NULL or a duplicate. On the primary key the
named sequence now wins; on any other column the block stays boilerplate and
the flag stands. A copy that lacks the sequence falls back to MAX + 1, which is
what the same rule already says (`Aggr: 'Max'`).

| | |
|---|---|
| Visible form fields across the 199 described screens | 1899 |
| On a column the server refuses to insert | 15 |
| On a column the server refuses to update | 4 |

Nineteen fields, across fifteen screens, collected a value the save would be
rejected for. A composed field now carries `noInsert` / `noUpdate`, so a
renderer shows the column without collecting into it.

**Row keys, before the repository was made metadata-aware**

| | |
|---|---|
| Fields across every entity | 24553 |
| Whose alias the row mapper changed | 18157 (74%) |
| Date and time columns | 3168 |
| Whose value was therefore never shaped on the way out | 2508 (79%) |
| Columns marked `isLabel` | 125 |
| Which were therefore never translated | 9 |

`mapToCamelCase` lower-cased every key and camel-cased back across the
underscores. Right for `SPECIAL_ID`; destructive for `specialId`, which has no
underscore left to camel-case across and arrived as `specialid`. Two things
above the repository read a row by the name the entity declares and so found
nothing: `shapeDates`, which is why a DATE reached a client as
`1995-08-31T21:00:00.000Z` with a timezone the column never had, and
`presentation/labels`, which is why `isLabel` did nothing on a view's
`statusName`. The entity now settles the spelling (M1).

This changes what 74% of fields are keyed by in every response. PhApp was
already reading case-insensitively and documented why; the Java client reads the
camelCase name and had been finding nothing.

**Metadata against the live schema** — `Demo`, 935 tables, before and after
`scripts/reconcileSchema.js`

| | Before | After |
|---|---|---|
| Models describing **fewer** columns than the table has | 133 (1579 columns) | **0** |
| Columns whose nullability disagrees | 133 | **0** |
| Columns with no `Default` where the database has one | 367 | **0** |
| Models describing **more** columns than the table has | 33 | 33 |

A column no model describes is never read or written: every SELECT and INSERT
is built from the model's field list. The worst were
`Fre_Lfr_Dbcr_Documents_View` (43 of 249), `Ped_Appointments` (25 of 103) and
`Emp_Employee` (15 of 87).

Repaired as a merge, never a regeneration — M2 stands. 295 files changed: 1672
columns added, 133 nullability corrections, 367 defaults filled. Nothing
existing was overwritten, and a `Default` already written was left alone: 130
fields carry one the database does not have and 29 carry a different one, and a
schema cannot tell a deliberate default from a gap.

Two columns were **declined**: `Jf_Contr_Id` and `Jf_Contr_Num` on
`Fre_Lfr_Dbcr_Documents_View` both reduce to an API name the view already uses,
and a row is keyed by that name, so adding them would have shadowed a working
column. Case collisions stayed at 28.

**Still open — 32 models name 124 columns their table does not have.** Every
SELECT over those entities fails with ORA-00904, which breaks reading, writing
and deleting alike; `acc/BankJournal` is the visible case. Nothing was removed,
because the models are shared by 21 copies. Checked against a second copy:

| | |
|---|---|
| Present in `NSCC` too — a real per-copy difference, keep | 10 |
| In neither copy — almost certainly stale | 69 |
| `NSCC` lacks the table, so cannot tell | 45 |

Whether those 69 leave the models or join the tables is a decision about the
schema, not one a reconciliation can make.

**The 69 left the models.** 26 models and 17 screens changed. Twelve of them
were not stale but renamed: `Mng_Contact_View` now spells its own columns
`Cont_Id`, `Cont_Name` and so on, so its screen and primary key moved to those
rather than losing them. `Phs/Menus` and `Phs/SpecialPrivileges` have no
`Ins_User` / `Ins_Date`, so those two drop `createdBy` / `createdAt` from
`auditFields`. The 10 present in `NSCC` stay. The 45 whose table `NSCC` lacks
-- `Ped/TestKeyView` (28), `Ped/LecturerProgram` (10), `Fre/LfrDbcrDocumentsView`
(3), `Proj/FollowupView` (3), `Prd/OrderExecutionStage` (1) -- are still open.

**Recovered query definitions**

| | |
|---|---|
| Definitions | 595 |
| Fields across them | 16775 |
| Whose table is described today | 547 / 595 |
| Filterable / groupable / aggregatable fields | 16678 / 16506 / 993 |
| Fields with a computed expression | 883 |
| Fields with autocomplete | 963 |
| Fields whose `dataType` is absent | 10815 (64%) |
| Misspelled `Agregate` / `isAgregate` keys | 3926 / 2785 |

**The operator contract** — from `PhSoft/src/com/phsoft/web/commom/Condition.java`

| Token | Meaning | SQL |
|---|---|---|
| `=` `!=` `>` `>=` `<` `<=` | comparison | `name <op> :p` |
| `<>` | **between** | `name BETWEEN :p1 AND :p2` |
| `><` | **not between** | `name NOT BETWEEN :p1 AND :p2` |
| `[%` / `![%` | starts with / not | `UPPER(name) [NOT] LIKE UPPER(:p‖'%')` |
| `%]` / `!%]` | ends with / not | `UPPER(name) [NOT] LIKE UPPER('%'‖:p)` |
| `%` / `!%` | contains / not | `UPPER(name) [NOT] LIKE UPPER('%'‖:p‖'%')` |
| `IN` / `!IN` | in list | `name [NOT] IN (:p1, :p2, …)` |
| `$$` | free SQL | rejected from client input |

`<>` and `><` are between and not-between, not inequality. Guessing this wrong
silently changes every range filter in the system.

**Date formats** — from `PhSoft/src/com/phsoft/tools/PhU.java`

```
Ph_DATE_SQL     = "DD-MM-YYYY"
Ph_DATETIME_SQL = "DD-MM-YYYY HH24:mi:ss"
Ph_TIME_SQL     = "HH24:mi:ss"
```

**Legacy field kinds** — `Condition.PHFC_*`, which is what the query
definitions' `dataType` refers to

```
0 TEXT · 1 SELECT · 2 NUMBER · 3 DATEPICKER
4 AUTOCOMPLETE · 5 CHECKBOX · 6 RADIO · 7 EMPTY · 8 DATETIMEPICKER
```

**Current layering**

| | |
|---|---|
| Upward dependencies | 4 (3 of them `utils`) |
| Lines across the three dialect builders | 495 |
| Build methods duplicated per dialect | 6 |
| Largest service | `unifiedService.js`, 792 lines |
