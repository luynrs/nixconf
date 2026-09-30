<role>

Use `ida-pro-mcp` to work through a running IDA Pro GUI instance. It is the preferred backend when the user's current database, cursor, selection, visual state, debugger, or immediately visible IDB changes matter.

Confirm which GUI instance the proxy selected before analysis. Do not assume that the most recently opened file, visible tab, or previous MCP call identifies the intended database.

</role>

<connection_and_state>

Call `server_health` or read IDB metadata before substantive work. Confirm the module, input path, IDB path, image base, automatic-analysis state, Hex-Rays state, and caches where available.

Direct GUI tools operate on the connected IDA instance and normally do not take the IDALib supervisor's `database` argument. Use the live schema; never add or remove `database` by analogy with the other server.

Use the GUI backend when the user refers to the current function, cursor, selection, or visible database. Do not use cursor position as semantic evidence: resolve the containing item and verify its bytes, function, references, and types.

</connection_and_state>

<shared_tools>

The GUI backend provides the structured analysis, query, memory, type, annotation, reconstruction, patch, signature, and save capabilities described in `mcp_api.md`, subject to the tools enabled in the IDA plugin configuration.

Prefer the structured tools for ordinary work. They provide bounded results, typed schemas, synchronization with IDA's main thread, and clearer failure reporting than arbitrary Python.

Changes made through `rename`, comment tools, type tools, stack tools, definition tools, or patch tools affect the active IDB and may become visible immediately. Verify the affected state before continuing and save only when the task requires persistence.

</shared_tools>

<resources>

Use read-only MCP resources when available:

- `ida://idb/metadata` for file, architecture, base, size, and hashes;
- `ida://idb/segments` for segment ranges and permissions;
- `ida://idb/entrypoints` for entry points;
- `ida://cursor` for the current cursor address and containing function;
- `ida://selection` for the current selection;
- `ida://types` and `ida://structs` for local type indexes;
- `ida://struct/{name}` for one structure definition;
- `ida://import/{name}` and `ida://export/{name}` for symbol lookup;
- `ida://xrefs/from/{addr}` for outgoing references.

Resource availability is version- and client-dependent. If the client does not expose resources, use the corresponding structured query tools instead of inventing resource contents.

</resources>

<debugger_extension>

Debugger tools are an optional `dbg` extension and are hidden unless the server and client expose them. The current source defines:

- lifecycle and execution: `dbg_start`, `dbg_status`, `dbg_exit`, `dbg_continue`, `dbg_run_to`, `dbg_step_into`, `dbg_step_over`;
- breakpoints: `dbg_bps`, `dbg_add_bp`, `dbg_delete_bp`, `dbg_toggle_bp`, `dbg_set_bp_condition`;
- registers: `dbg_regs`, `dbg_regs_all`, `dbg_regs_remote`, `dbg_gpregs`, `dbg_gpregs_remote`, `dbg_regs_named`, `dbg_regs_named_remote`;
- runtime state: `dbg_stacktrace`, `dbg_read`, `dbg_write`.

Do not start or continue a target merely because debugger tools are present. Obtain authorization to execute the sample, confirm the debugger backend and containment, place breakpoints before execution when needed, and avoid writing runtime memory unless the requested experiment requires it.

Treat one trace as evidence for the executed path and inputs only. It does not prove that unexecuted branches behave the same way.

</debugger_extension>

<unsafe_python>

`py_eval` and `py_exec_file` execute arbitrary Python inside IDA and may be disabled. Use them only when no structured tool covers the required operation. Load `idapython.md`, keep the code minimal, avoid filesystem or process side effects unrelated to analysis, capture errors, and verify every resulting IDB mutation.

Do not enable unsafe tools or debugger extensions without a concrete need and explicit authorization when the operation can execute a target, write memory, patch code, or run arbitrary Python.

</unsafe_python>
