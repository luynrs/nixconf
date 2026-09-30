<when_to_use>

Use direct IDAPython only when a structured MCP tool cannot perform the required IDA operation or when the user explicitly requests an IDAPython script. Prefer the structured MCP API for standard queries and mutations.

Before writing code, verify the exact API against the IDAPython documentation bundled with the installed IDA version or the maintained `ida-pro-mcp` IDAPython reference. Do not invent a function, constant, class, return type, or calling convention from memory.

</when_to_use>

<module_discipline>

Use module-qualified APIs such as `ida_bytes`, `ida_funcs`, `ida_name`, `ida_nalt`, `ida_typeinf`, `ida_xref`, `ida_ua`, `ida_frame`, `ida_auto`, and `ida_hexrays`.

Avoid new code built around generic `idaapi` or legacy `idc` wrappers when a specific modern module exposes the operation. Preserve a legacy API only when the installed IDA version or an existing project explicitly requires it.

In a standalone IDALib process, import `idapro` before importing other IDA modules so the library is initialized first. Inside an already initialized MCP worker or IDA GUI, do not reinitialize IDALib.

</module_discipline>

<analysis_state>

Wait for required automatic analysis with `ida_auto.auto_wait()` before querying analysis-dependent state. If code, function bounds, types, or bytes are changed, schedule the smallest required reanalysis range and wait before validating results.

Check addresses, item boundaries, function ownership, and sentinel return values such as `BADADDR`. Do not treat a failed lookup as address zero or an empty result as a valid object.

Hex-Rays pseudocode and ctree or microcode objects are analysis products. Validate important transformations against instructions and ensure the decompiler is available before calling its APIs.

</analysis_state>

<implementation_rules>

Keep snippets small and single-purpose. Query before mutating. Store original names, types, comments, or bytes when an operation may need to be reversed.

Use IDA's database APIs for IDB state and the appropriate debugger APIs for runtime state. Do not confuse patched database bytes with debuggee memory or the original input file.

Do not create a helper used once for a trivial operation. Do not reproduce an existing MCP tool in Python merely to avoid learning its schema.

Return structured, bounded data. Apply explicit limits to function enumeration, strings, cross-references, instructions, and graph traversal. Avoid printing unbounded pseudocode or entire databases.

</implementation_rules>

<verification>

After executing IDAPython, inspect the affected addresses with structured MCP queries or independent IDAPython reads. Confirm success values and exceptions; absence of an exception is not proof that IDA accepted the intended change.

For a new reusable script, test it against a disposable copy or test binary before applying it to the user's authoritative database. State the installed IDA version and any API assumptions that remain unverified.

</verification>
