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
- **D5** A large result streams. *(Not yet done — Step 5.)*

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
locales/{en,ar}.json    2386 column labels, 872 with Arabic
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

### 3. Arabic for the remaining 1,514 labels

872 of 2,386 came from the Java bundle. The rest keep an English default in both
locales.

### 4. Step 5 — Node's advantages

Streaming (D5), shared types between the two projects, parallel reads, worker
threads, hot metadata reload.

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
  which writes `reconcile-missing-Demo.csv`. Needs the database.
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
