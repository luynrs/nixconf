<source_policy>

Start from tested examples, then reduce them to the required operation. The primary example sources are:

- `https://github.com/HexRaysSA/ida-sdk/tree/master/src/plugins/idapython/examples` for official module-qualified IDAPython examples and their test requirement;
- `https://github.com/mrexodia/ida-pro-mcp/tree/main/skills/idapython` for searchable module summaries matched to the MCP implementation;
- `https://github.com/mandiant/flare-emu/blob/master/tests/test_flare_emu_idalib.py` for real standalone `idapro.open_database(...)` usage.

Verify the installed version because IDAPython signatures change. Do not copy legacy `idc` or umbrella `idaapi` usage into new code when a current module-qualified API exists.

</source_policy>

<tested_standalone_example>

This script was executed with IDA Professional 9.3 IDALib against a disposable copy of `crackme03.elf`:

```python
from __future__ import annotations

import sys
from pathlib import Path

import idapro

import ida_auto
import ida_funcs
import ida_hexrays
import ida_idaapi
import ida_name
import ida_xref


binary = Path(sys.argv[1]).resolve()
status = idapro.open_database(str(binary), run_auto_analysis=True)
if status != 0:
    raise RuntimeError(f"open_database failed: {status}")

try:
    if not ida_auto.auto_wait():
        raise RuntimeError("auto-analysis did not complete")

    ea = ida_name.get_name_ea(ida_idaapi.BADADDR, "check_pw")
    if ea == ida_idaapi.BADADDR:
        raise RuntimeError("check_pw was not found")

    function = ida_funcs.get_func(ea)
    if function is None:
        raise RuntimeError("check_pw is not a function")

    references = list(ida_xref.xrefblk_t().crefs_to(ea))
    pseudocode = str(ida_hexrays.decompile(ea))

    print(f"check_pw={ea:#x}")
    print(f"size={function.end_ea - function.start_ea}")
    print("code_refs=" + ",".join(f"{ref:#x}" for ref in references))
    print("has_failure_return=" + str("return 0" in pseudocode))
finally:
    idapro.close_database(save=False)
```

Expected output for the corpus binary:

```text
check_pw=0x11a9
size=149
code_refs=0x12d3
has_failure_return=True
```

The important API detail is that `ida_xref.xrefblk_t().crefs_to(ea)` iterates integer source addresses. It does not yield objects with a `.frm` field. This was verified by execution, not inferred from naming.

</tested_standalone_example>

<gui_cursor_example>

Use GUI state only when the request explicitly refers to it:

```python
import ida_funcs
import ida_kernwin


ea = ida_kernwin.get_screen_ea()
function = ida_funcs.get_func(ea)
if function is None:
    print(f"{ea:#x} is not inside a function")
else:
    print(
        f"{ida_funcs.get_func_name(function.start_ea)} "
        f"{function.start_ea:#x}:{function.end_ea:#x}"
    )
```

The cursor selects an address; it does not prove that the current item is the semantic target. Resolve the containing function and then inspect its bytes and references.

</gui_cursor_example>

<bounded_function_inventory>

Enumerate functions without printing an entire large database:

```python
import ida_funcs
import ida_ida


limit = 200
count = 0
minimum_ea = ida_ida.inf_get_min_ea()
function = ida_funcs.get_func(minimum_ea)
if function is None:
    function = ida_funcs.get_next_func(minimum_ea)
while function is not None and count < limit:
    print(f"{function.start_ea:#x} {ida_funcs.get_func_name(function.start_ea)}")
    function = ida_funcs.get_next_func(function.start_ea)
    count += 1

if function is not None:
    print(f"truncated after {limit} functions")
```

Prefer an MCP entity or function query when it already exposes the required filters and pagination. Use this pattern when direct IDAPython is the requested deliverable or a structured query cannot express the selection.

</bounded_function_inventory>

<mutation_pattern>

Keep the original state, check every return value, and verify by reading it back:

```python
import ida_name


ea = 0x11A9
old_name = ida_name.get_name(ea)
new_name = "check_password_relation"

if not ida_name.set_name(ea, new_name, ida_name.SN_CHECK):
    raise RuntimeError(f"rename failed at {ea:#x}")
if ida_name.get_name(ea) != new_name:
    raise RuntimeError(f"rename verification failed at {ea:#x}")

print(f"renamed {old_name!r} to {new_name!r} at {ea:#x}")
```

Run mutations only on the intended IDB. For reusable scripts, test against a copy first and keep save behavior outside the helper so the caller decides whether changes persist.

</mutation_pattern>
