# Screen metadata

Two trees, because two different questions are being asked and one file cannot
answer both.

| Tree | One file per | Keyed by | Answers |
|---|---|---|---|
| `resources/programs/` | program | the program's own path | what this screen is |
| `resources/screens/` | query definition | `Pkg/Name` | what may be searched on an entity |

`clnc/mng/Doctors.json` under `programs/` serves the program `clnc/mng/Doctors`.
`Clnc/AppointmentView.json` under `screens/` is what
`/UC/Clnc/AppointmentView/Query` runs. Several programs share one query
definition — `clnc/qry/Treatments` and `clnc/qry/s/Treatments` are the same
report asked two ways — which is why the second is not keyed by program and the
first is not keyed by entity.

Both are data. **Adding a screen is adding a file.** Nothing is a list of known
screens; no deploy, build step or registry edit stands between a new file and a
client rendering it.

---

## The rule the format exists for

**A screen file is an overlay. It never restates what the schema already knows.**

A field's type, precision, nullability, default, lookup relation and display
column are in the generated entity model, which is built from the live database.
Putting any of them in a screen file creates a second source of truth, and two
sources of truth is how they start disagreeing. `tests/programs.test.js` fails
the build on a screen that carries one.

So a screen file says only what a schema cannot:

- which fields, and in what order
- what to call each one
- whether a reference is picked from a list or searched for
- which comparisons a search offers
- what may be grouped, aggregated or sorted

Everything else is filled in by `presentation/screens.js` on the way out.

---

## A program screen

```json
{
  "version": "1.0",
  "kind": "form",
  "program": "clnc/mng/Doctors",
  "entity": "Clnc/Doctors",
  "form":   { "fields": [ … ] },
  "search": { "fields": [ … ] }
}
```

| Key | Meaning |
|---|---|
| `kind` | `form` — an entry form with its rows listed beneath. `query` — a search with results. |
| `program` | The path in Phs_MPrg. Must match the file's own path. |
| `entity` | `Pkg/Model`, naming a file in `resources/modules`. |
| `form.fields` | The entry form, in order. |
| `search.fields` | What the screen may be searched by. |

A field:

| Key | When present |
|---|---|
| `name` | Always. The column as PhAPI aliases it — `statusId`, not `Status_Id`. |
| `labelKey` | A key into `locales/*.json`. Absent means the field is submitted but never shown. |
| `input` | **Only when the entity cannot imply it.** See below. |
| `endpoint` | An autocomplete's search path, where it is not the referenced table's own. |
| `operators` | Search only. A subset of what the column's type permits. |
| `width` | The list column's width, as the Java screen set it. |
| `hidden` | Submitted with its default, never rendered. |
| `readOnly` | Shown, not editable. |

### `input` is derived, not declared

`presentation/screens.js` decides:

```
relation present            -> select
DBType DATE / DATETIME / TIME -> date / datetime / time
DBType numeric              -> number
otherwise                   -> text
```

A screen file overrides this only where the schema genuinely cannot answer:

- **`autocomplete`** — the reference is too large to list. `Clnc_Specials` has
  twelve rows and is a select; `Copy_Users` has thousands and is searched.
  Nothing in the schema distinguishes them.
- **a stated component** — the Java page declared `PhFC_Text` on a column whose
  type suggests otherwise. A declaration outranks an inference.

An `options` array is deliberately *not* read as a signal. Pages carry
`options: []` as boilerplate on free-text columns — `Fre_Lfr_SalesContracts.descr`
and `.rem` both do, while declaring the same columns `PhFC_Text` in their search
card — and a real options array is a runtime lookup that is empty at conversion
time too. The two are indistinguishable by value, and reading them turned 123
text columns into selects with no source.

---

## A query definition

```json
{
  "version": "1.0",
  "kind": "query",
  "entity": "Clnc/AppointmentView",
  "screen": "Clnc/AppointmentView",
  "order": "To_Date(To_Char(Ddate,'DD-MM-YYYY'),'DD-MM-YYYY') DESC",
  "fields": [
    { "name": "clinicId", "labelKey": "clinicId",
      "filter": true, "display": true, "group": true, "sort": true,
      "operators": ["=", "!=", ">", ">=", "<", "<=", "<>", "><"],
      "autocomplete": "Clnc_Clinic" }
  ]
}
```

`filter`, `display`, `group` and `sort` are independent: a column can be shown
without being searchable. `aggregate` lists the functions offered; `expression`
carries a computed column.

---

## Operators

The seventeen tokens of `Condition.java`, ported by their semantics. Two read as
comparisons and are not:

```
<>  is BETWEEN
><  is NOT BETWEEN
```

Getting either backwards silently inverts every range filter in the system.
`tests/conditions.test.js` fails if one is negated.

`$$` spliced raw SQL in the Java original. It is never accepted from a client
and never appears in a screen file; both are enforced by tests.

Every operator a screen offers is narrowed to what the column's `DBType`
permits, so a screen cannot offer `starts with` on a number however it was
written.

---

## What is served

Not the file. `GET /UC/Screen/Program/<path>` answers with the file composed
against its entity: labels translated into the caller's language, `input`,
`required`, `defaultValue`, `lookup` and `displayField` filled in. The client
has nothing left to infer and never needs the entity model.

```
GET /UC/Screen/Program/clnc/mng/Doctors
GET /UC/Screen/Report/Clnc/AppointmentView
```

Both sit behind the same authentication and the same `mprgid` permission check
as the data they describe: a screen's description names its table and every
column on it, so it is not more public than the rows.

A composed screen also carries `dropped` — fields it named that its entity no
longer has. It is empty for a screen that has not drifted, and it is how far it
has drifted for one that has.

---

## Regenerating

Both trees are converted from the Java system, not authored:

```bash
node scripts/convertScreens.js  --recover <git-ref> --from <dir> --apply
node scripts/convertPrograms.js --from <PhsApp/web/assets> --apply
```

The second runs each page script in a sandbox and records what its widget was
handed, rather than matching patterns against the source: the field lists are
object literals holding `getLabel()` calls, references to lookup arrays and
string concatenation, and a regular expression reads none of that correctly.
See `scripts/lib/javaScreen.js`.
