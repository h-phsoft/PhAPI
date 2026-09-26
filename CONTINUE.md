# Continuation brief

Read this first in a new conversation. It is the state of the port and the
rules that govern it, short enough to read in one go.

`MIGRATION-PLAN.md` is the contract and is authoritative. Where this file and
that one disagree, that one is right and this one is stale.

**Projects**

| | |
|---|---|
| `D:\PhSoft\Projects\NodeJS\PhAPI` | the API being built |
| `D:\PhSoft\Projects\NodeJS\PhApp` | the Next.js client |
| `D:\PhSoft\Projects\Java\21Projects\Final\PhERP\PhsAPI` | the Java original being ported |
| `D:\PhSoft\Projects\Java\21Projects\Final\PhERP\PhsApp` | its client — **the source of all screen metadata** |

---

## Part 1 — The rules

Binding. Breaking one is a defect even when the feature works. Full text in
`MIGRATION-PLAN.md` Part 1.

### Layering — enforced by `tests/layers.test.js`, which fails the build

- **L1** A layer may require only the layer beneath it. `utils` and `models` are
  leaves: anyone may use them, they may require nothing of the project.
- **L2** Only `http/` knows HTTP. No `req`, `res` or status code below it.
- **L3** Only `core/dialects` knows an engine. No `oracle`/`mysql`/`postgres`
  string and no engine-specific SQL function above it.
- **L4** Presentation never runs in the domain. Labels, date formatting and
  envelopes happen in `presentation`, on the way out.
- **L5** A repository handles one entity and knows no rules.
- **L6** Cross-cutting logic is written once.

Order of layers: `http/routes` → `http/middleware` → `http/controllers` →
`http` → `presentation` → `services` → `repository` → `core/query` → `core` →
`core/dialects` → `core/types` → `metadata` / `config` → `models` / `utils`.

### Metadata

- **M1** `resources/modules` is generated from the database and is
  authoritative for what a column is.
- **M2** The generator never rewrites an existing file. `--force` must be asked
  for explicitly.
- **M3** Screen metadata is an overlay, never a copy. If a property can be
  derived from the entity, deriving it is mandatory.
- **M4** One entity per block, not per screen. Master/detail and lookups each
  name their own entity.
- **M5** Metadata is data. Adding a screen is adding a file — never a deploy, a
  build step or a registry edit.

### Data access

- **D1** Values are bound, never concatenated. Includes numbers, dates, IN lists.
- **D2** Identifiers come from metadata, never from a request. An unresolved
  name drops the condition; it is never passed through.
- **D3** Operators come from a closed list. `$$` is never accepted from a client.
- **D4** Dates state their format at both boundaries. The column's declared type
  decides. A date leaves with no timezone attached.
- **D5** A large result streams. *(Done for the report PDF, the one export; measured on NSCC -- see Step 5.)*

### Porting

- **P1** Recover before inventing. The Java system already describes its screens.
- **P2** Port semantics, not implementation.
- **P3** Where the legacy metadata and the schema disagree, the schema wins.
- **P4** Existing screens are not touched by generated ones. A written component
  always takes precedence.
- **P5** Node's advantages come after the feature works.

### Verification

- **V1** A claim about behaviour is measured, not asserted.
- **V2** A migration that rewrites files proves it only changed what it meant to.
- **V3** The suite is green before a step is finished. Not "green except".
- **V4** Layer rules are enforced by a test, not by memory.

---

## Part 2 — Where the stages stand

| Step | State |
|---|---|
| **0 — Boundaries** | done, `b147081` |
| **1 — Condition engine** | done, `ada0cc7` |
| **2 — Screen metadata converter** | done, `a537e39` |
| **3 — Generic renderer** | done, `6b8830d` + `a7c06b3` |
| **4 — Screens** (Table, Query, Daily, Statistic) | all four kinds render, search, save and delete from metadata |
| **5 — Node's advantages** | not started |

Step 4's exit is per screen, and not all 530 programs have been driven. What was
actually driven against the database is listed under *Proven* below.

### Coverage — active programs in the `Demo` tenant

| Kind | Active | Described |
|---|---|---|
| Daily | 153 | 103 |
| Table | 143 | 93 |
| Query | 146 | 79 |
| Statistic | 73 | 42 |
| other / utility | 47 | 0 (bespoke `/CC/` endpoints) |
| **Total** | **562** | **317** |

PhApp has 19 hand-written screens. They still take precedence (P4).

### What exists now

```
resources/modules/     1215 entity models, generated from the live schema
resources/screens/      548 query definitions   (Pkg/Name)
resources/programs/     383 program screens     (the program's own path)
locales/{en,ar}.json    2385 column labels, 2261 with Arabic
```

- 85 document screens carry 106 line grids and 984 line fields.
- `resources/SCREENS.md` documents both metadata formats.

### Key files

```
metadata/screens.js            the screen registry, indexed by program and report
presentation/screens.js        composes a screen with its entity for a client
http/controllers/screenController.js   GET /UC/Screen/Program/<path>, /Report/<p>/<n>
core/query/conditions.js       the 17 operators; <> is BETWEEN, >< is NOT BETWEEN
core/query/aggregates.js       the 8 aggregate functions, a closed list
scripts/convertPrograms.js     the converter
scripts/lib/javaScreen.js      runs a Java page script in a sandbox to read it

PhApp src/components/screens/
  GenericScreen/   reads kind, sends to one of the two below
  MasterDataScreen/  form + lines + search + list
  QueryScreen/       filter + group + aggregate + results, on demand
  SearchCard/        the filter card, shared by both
  LineGrid/          the editable line grid of a document
```

---

## Part 3 — Running it

```bash
PORT=3011 npm test                                    # 133 tests
PORT=3011 RUN_INTEGRATION_TESTS=1 npm test            # + live reads
PORT=3011 RUN_INTEGRATION_TESTS=1 RUN_WRITE_TESTS=1 npm test   # 153, writes rows
node scripts/manual/sweepWriteTests.js                # must report 0 after a write run
```

`PORT` matters: `tests/suite.test.js` requires `../server`, which calls
`app.listen(PORT)` at module level, so the suite dies with EADDRINUSE while the
dev server holds 3000. **Do not kill whatever holds 3000** — it is usually the
user's own server.

`RUN_WRITE_TESTS=1` **writes to a real tenant** (`TEST_TENANT`, default `Demo`).
It cleans up after itself; the sweep is how you check.

Regenerating the metadata:

```bash
node scripts/convertPrograms.js --from "D:/PhSoft/Projects/Java/21Projects/Final/PhERP/PhsApp/web/assets" --apply
node scripts/importJavaLabels.js --from="<lang>/ar.properties" --section=fields --apply
```

---

## Part 4 — Next steps, in order

### 1. Reconcile the entity models with the live schema — **the blocker**

A queued task chip already describes it. It matters most now because every kind
of screen renders whole entities.

- **133 models describe fewer columns than their table has — 1,579 columns are
  invisible to the API**, because every SELECT and INSERT is built from the
  model's field list. `Emp_Employee` is described with 15 of its 87.
- **133 columns record the wrong nullability** (62 the model calls optional that
  the database requires, 71 the other way).
- At least one model names a column the table does not have: `acc/BankJournal`
  fails on `ORA-00904: "SREM"`.

Must be a **merge, never a regeneration** — M2 stands. Verify per V2: hash
before and after, prove only the intended files changed and that no pre-existing
field entry was modified.

### 2. Verify in a browser

**Nothing has been seen rendering.** Every claim about the screens is from the
API side, because they sit behind a sign-in. This is the gap to close before
trusting any of it. PhApp dev runs on 3030 and talks to PhAPI on 3000.

### 3. Arabic for the last 124 labels -- waiting on their meaning

872 of 2,385 came from the Java bundle. The rest are drafted a package at a
time, by the screens that show them: a key goes to the package whose screens
use it most, and is read from the column it maps to and the lookup behind it.
English is replaced only while it is still the generated default.

| Package | Drafted | Left for the owner to confirm |
|---|---|---|
| Fre | 250 | `jobEdate` / `jobEnum`, `jobFdate` / `jobFnum`, `jobSdm`, `modeId` / `modeName`, `pshareStatusId` / `pshareStatusName` |
| Emp | 117 | 26, mostly `Emp_Salaries_Calculation_View` (`Sal_Gbtam1`..., `Sal_Cons` / `Sal_Pun`), `codAffId`, `taxpayId`, `tsalId`, `empComputer`. The overtime columns are N = night, D = day, W = weekend, H = holiday (owner) |
| Lrg | 122 | `bstatusId`, `claimCommitId`, `settCommitId`, `settCondId`, `collInterId`, `collRespId`, `mpointerId` / `mpointerName` |
| Stor | 112 | 18: the B / W / BW / CW quantities and `cbamt`, `comaccId`, `itemInsaleId`, `itemMethodId`, `saleName`. The item prices are the owner's: C = current market, N = normal, D = discount, S = sale, W = wholesale, R = retail, H = half-wholesale, M = social media |
| Clnc | 111 | none |
| Proj | 110 | none |
| Fix | 69 | 17: the R account (`Acc_Rid`, beside the D = depreciation expense and F = accumulated depreciation accounts), `Rtot` / `Ramt`, `Sqnt` / `Scqnt` |
| Cash | 70 | 11: the C / O accounts of `Cash_Boxes`, `Dcust`, `Dstatus`, `Ord_Damt` / `Ord_Dcamt`, `Phnby`, `Vhr_Did` |
| Bank | 55 | 7: `Acc_Cid`, `B_Examt` / `B_Excamt`, `Mnum`, `Phnby`, `Tnote` / `Tstatus_Id` |
| Ped | 70 | none |
| Cpy | 60 | 6: `Copy_Tokens` (`Adate`, `Cfront_Id`, `Gid`), `Grp_Wper`, `Iperiod` / `Vperiod` |
| Acc | 47 | none |
| Crm | 32 | `comp`, `frem`, `trepNcomd` |
| Pur | 26 | `insaleId` / `insaleName`, the W quantities (as Stor) |
| Trn | 27 | `forId`, `resId` |
| Sdesk | 17 | `cuserId` / `ruserId` / `suserId`: which roles are C, R and S |
| Sales | 4 | `bcom`, `cmtId`, `cmv` |
| (no screen) | 4 | `ordMdate` / `ordMnum`, `ordTdate` / `ordTnote` / `ordTstatusId` (as Bank) |
| Mng 25, Phs 24, Prd 10, Fund 9, Notif 9, Fin 5, Pms 5 | 87 | none |

Every key with a readable meaning has Arabic now. The 124 left are
abbreviations only the owner can read; each gets its words once answered.
`Proj`'s own `cprice` is the timesheet's cost price, not the item price above.

The flat namespace clashes twice, and the label follows the majority:
`accFname` is the account's full name in most Fix views but the F
(accumulated depreciation) account's name in `Fix_Fixeds_Items_View`, and
`pnum` is a plate number in Trn but `Acc_Account.pNum` elsewhere.

### 4. Step 5 — Node's advantages

**1. Streaming (D5) -- done and measured.**

- `repository.stream()` runs the statement `find()` runs, without its page, and
  hands it to a callback 500 rows at a time (a callback, not an async
  generator: NetBeans 31 cannot parse `async *`): an Oracle result set (`resultSet: true`,
  `getRows`), a MySQL row stream. PostgreSQL still reads whole -- `pg` needs
  `pg-cursor` for a cursor, and no tenant runs on it. The ceiling is in the
  statement (`FETCH NEXT`), and one row past it is asked for so a cut result
  is told apart from one exactly that long.
- The report PDF reads through it. It used to print the first page of the
  query -- 500 rows by default, 1000 at most -- whatever the query matched; it
  now prints the whole result up to `EXPORT_MAX_ROWS` (default 50000) and says
  so when it stops there. It waits on a slow client instead of queueing the
  document in memory, and a client that disconnects stops the query. The first
  batch is read before a byte is sent, so a failing query (an ORA-00904) still
  answers as a JSON error rather than a broken download.
- `tests/streaming.test.js` pins that down against a stand-in pool: 11 tests,
  and the slow-client one fails with the wait removed (40 of 40 batches read
  for a client that took none, against 2).
- **To measure** (V1): `node scripts/measureStreaming.js --copy=Demo
  --report=Fre/CodeAirports` reads the same rows whole and streamed, each in
  its own process, and prints time to first row, total time and peak memory.

  Measured on Demo, Fre/CodeAirports (9168 rows, the whole table):

  | | first row | total | peak RSS | peak heap |
  |---|---|---|---|---|
  | whole | 54 ms | 54 ms | 109 MB | 33 MB |
  | streamed | 6 ms | 34 ms | 111 MB | 34 MB |

  And Acc/VoucherView, which on Demo is 1892 rows:

  | | first row | total | peak RSS | peak heap |
  |---|---|---|---|---|
  | whole | 67 ms | 67 ms | 124 MB | 46 MB |
  | streamed | 33 ms | 67 ms | 119 MB | 36 MB |

  Demo's results are too small to show memory: a few thousand rows are a few
  MB against a process that holds 2430 entity models. NSCC's voucher view is
  not -- 100524 rows:

  | | first row | total | peak RSS | peak heap |
  |---|---|---|---|---|
  | whole | 2453 ms | 2453 ms | 887 MB | 723 MB |
  | streamed | 65 ms | 2393 ms | 214 MB | 91 MB |

  Reading it whole takes 723 MB of heap and nothing arrives for 2.5 s;
  streamed, the heap stays at 91 MB -- about the process's own size -- and
  the first rows arrive in 65 ms, for the same total. That is the before and
  after Step 5.1's exit asks for, so **5.1 is done** (V1).

**5. Hot metadata reload -- done.**

- A running server picks up edits to `resources/modules`, `resources/screens`,
  `resources/programs`, `locales/` and `resources/autocomplete` without a
  restart. `services/metadataReload.js` watches those trees
  (`METADATA_WATCH`, on by default outside production) and reloads once the
  changes have been quiet for 500 ms, so a script rewriting 500 files costs
  one reload. Where the watcher cannot see changes (some Docker bind mounts),
  `kill -HUP <pid>` reloads.
- Each of the four -- entities, screens, labels, autocomplete -- is rebuilt
  beside the one in use and swapped in whole. A file that cannot be read (a
  save caught half-written, a stray comma) keeps that part as it was and is
  logged; the others still reload. Entities are new objects after a reload,
  and what is cached per entity sits in WeakMaps keyed on the object, so
  nothing stale survives.
- Measured: a full reload of the 2430 models and 931 screens takes 150-250 ms,
  and the heap is flat across five in a row (105 MB). Against the running
  server, a model dropped into a new package folder appeared in `/health`
  within two seconds and was gone two seconds after it was deleted -- no
  restart. `tests/reload.test.js` (6) covers edit, half-written file, delete,
  each tree, a broken locale beside a good model, and one reload for a burst
  of writes.

**3. Parallel reads -- done; measure on the database.**

- Three places read things none of which needs another, and waited for each
  before asking for the next. They now run side by side, each on its own
  pooled connection, through `utils/parallel.js` `mapLimit()`: at most
  `PARALLEL_READS` at once (default 4, well under `DB_POOL_LIMIT` 10), results
  in the original order, the first failure fails the whole.
  - **Opening a record** (`UnifiedService.get`): its child grids. 35 masters
    have 3 or more -- `Fre/JobFreight` 10, `Lrg/Products` 13.
  - **A package's code tables** (`getCodes`): `Lrg` has 80.
  - **The user profile** (`getUserProfile`, loaded after sign-in): the user
    row, the menus and the periods together, then the group and its
    programs. Five statements one after another become two rounds. It used
    one connection for all five; one connection runs one statement at a time,
    so each read now takes its own.
- `PARALLEL_READS=1` reads exactly as before -- the way back if a database
  objects.
- `tests/parallel.test.js` (12), on a stand-in pool: how many reads are in
  flight, the limit, same result either way, connections always returned.
  Three of them fail on the old code.
- Measure with `node scripts/measureParallel.js --copy=NSCC --user=1
  --record --codes`: median of one-by-one against
  side-by-side, alternating in one process. On a stand-in pool at 20 ms a
  statement: profile 102 -> 41 ms, 4 code tables 81 -> 21 ms. **Not yet run
  against Oracle.**
- `authService.js` and `unifiedService.js` had their brace-less `if`s braced
  (CLAUDE.md); nothing else in them changed.

**2, 4.** Shared types between the two projects, worker threads -- not
started.

---

## Part 5 — Known defects, recorded and not fixed

- **No two columns of an entity share an API name any more**, ignoring case.
  The 18 left after the audit change were settled by renaming, never dropping:
  `Loan_Type_Id` is `loanTypeRefId` in the 15 Lrg views, `Cont_Rid` /
  `Cont_Rnum` are `contRecvId` / `contRecvNum` in Fre, and the second `Cont_Id`
  entry (precision 4) left `Stor/ExecuteOutboundMaster`.
- **No two lookups of an entity share a display name.** 42 did -- `Curn_Fid`
  and `Curn_Tid` both said `curnName`, so a screen drew one currency name for
  both. The first keeps the name; the others take their own
  (`curnTidName`, `deptRidName`, `isDaySunName`). A display name that is the
  view's own column (`Status_Id` beside `Status_Name`) is how a view shows its
  lookup and is left alone. Nothing selects a display name in SQL today -- no
  service passes joins -- so this is what a client is told to draw, not what a
  row carries. Both rules are now tests in `tests/screens.test.js`.
- **The columns a model names and its table lacks are listed by**
  `node scripts/reconcileSchema.js --tenant Demo --missing --compare NSCC`,
  which writes `reconcile-missing-Demo.csv`. Needs the database. Measured on
  Demo: 124 across 32 models. The 69 neither copy has are gone. After that run
  55 remained: 10 NSCC has, and 45 in models whose table NSCC lacks. Of those,
  `Fre/LfrDbcrDocumentsView`'s `Job_Id` / `Job_Num` / `Job_Date` were renames
  (the view spells them `Jf_Job_*`) and moved; **the other 42 are kept by
  Haytham's decision** (`Ped/TestKeyView`, `Ped/LecturerProgram`,
  `Proj/FollowupView`, `Prd/OrderExecutionStage`) -- another copy may have
  them. Reading those four in Demo still fails with ORA-00904.
- **A query screen whose model names a missing column now fails the suite**
  (`No query screen names a column its view does not have`), apart from the
  six models kept by decision, listed in the test.
- **Audit columns are always `insUser`, `insDate`, `updUser`, `updDate`**,
  however the table spells them (`toFieldName`). The 10 Bank/Cash order tables
  that had both `Insdate` and `Ins_Date` now expose `Insdate` as `insDate`;
  `Ins_Date` left those models and their screens (Haytham's decision).
- **`AuthError` collapses every status to 401.** The per-case codes were
  provably dead and were removed; restoring the distinction is deferred.
- **The Java client's report table shape is not built.** Its `renderTable` reads
  `report.header[].cells[]` and `report.Footers[]`, which the Java API rendered
  server-side. Its searches and reports now filter correctly but it cannot draw
  the result.
- **`App_Id` carries the bundle's English "Count"** and is the label on every
  `appId` column. The bundle is keyed by word, not by column; it is their word,
  not an invention.
- 47 programs call hand-written `/CC/` endpoints and have no generic equivalent.

---

## Part 6 — Standing decisions

Haytham's, given during the work. They are settled; do not reopen them.

- **Layer separation is irreversible.** "كل طبقة مسؤولة عن عملها ولا تداخل
  بينه" — each layer is responsible for its own work and they do not overlap.
  This is why the layer test fails the build rather than warning.
- **Two languages only: Arabic and English.** No French, and no third language.
- **Keep the current UI.** Screens described in JSON, rendered with the
  components PhApp already has. No new UI library.
- **The JSON is what counts.** "لا يهمني في اوراكل المهم الموجود في الملف
  json — لماذا طريقتنا اسمها meta driven؟" — what a particular engine can do is
  not the question; what the metadata declares is. That is what M1 and D4 are
  for.
- **Entry screens are drawn ready; queries are drawn on demand.** "واجهات
  الإدخال مرسوكة جاهزة أما الاستعلامات ترسم عند الطلب". A report must not run
  because someone opened its menu entry.
- **Nothing in a screen talks to the database.** It calls the backend, and
  `/UC/` does the rest.
- **A tenant chooses from the structure, it does not change it.** "المستأجر لا
  يغير في البنية لكنه يمكن ان يختار منها فقط".
- **Do not touch the airports, countries or cities tables.** "المطارات
  والبلدان والمدن لا تغيرها".
- **Naming rule for generated models:** `Clnc_Code_Vat` → `Clnc/CodeVat.json`.
  Only `copy_` maps to `cpy_` — "فقط copy_ تصبح cpy_".

**He commits his own work.** Commits titled "By Haytham" are his. Nothing has
been pushed in this line of work — pushing is his call, and has not been asked
for.

---

## Part 7 — The environment

- **Oracle, one schema per tenant.** `Phs_Cpy` in the admin schema maps a copy
  to its user. `Demo` and `NSCC` are reachable; **`Clinic` is not** — its
  credentials fail with ORA-01017.
- `Demo` is the full ERP, 562 active programs, and is what everything here was
  measured against. Set `TEST_TENANT` to change it.
- **There are no test login credentials.** `.env` has no `TEST_LOGIN_USER` /
  `TEST_LOGIN_PASS`, so signing in to PhApp is not possible from this side.
  That is why nothing has been verified in a browser. Do not go looking for
  credentials — ask.
- The API integration tests mint their own JWT with `env.jwtSecret`, which is
  how they authenticate without a password. That works for API calls only.
- `.env` goes stale after merges and blocks startup; re-check it first when the
  server will not boot.

---

## Part 8 — Things that cost time, worth not repeating

- **A query page addresses a query definition, not a table.** `/UC/Fix/Inbound`
  is the definition `Fix/Inbound` over the view `Fix/InboundView`. A **form**
  page must NOT resolve this way — `/UC/Emp/Deduction` is both a table and a
  definition over its view, and pointing an entry screen at the view cost 190
  fields.
- **Two spellings of everything.** `Aggregate`/`Agregate`,
  `component`/`componentType`, `field`/`fieldName`. Read both; reading one
  silently loses a third to a half of the data.
- **`PHS_QRY_CARD_*` is in PhsQuery.js, not PhConst.js.** Seed only that file's
  head into the sandbox: seeding `PhForm.js` defines the real widget over the
  recorder and 383 screens become 63.
- **Windows paths.** `split(/[\/]/)` does not split a Windows path. Use
  `modelNameOf`.
- **Shell escaping.** CRLF breaks `\n` sed patterns; `$$` and backticks are eaten
  in heredocs; `&&` chains skip later commands when an earlier one fails. Write
  a patch script to a file and run it rather than fighting a heredoc.
