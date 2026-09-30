<role>

Use `idalib-mcp` as the headless IDA backend. It manages persistent worker processes and supports independent sessions for multiple binaries without requiring an open IDA window.

Opening a file with IDALib performs static loading and analysis. It does not execute the target. Debugger or Appcall activity is separate and requires explicit authorization.

</role>

<session_lifecycle>

Call `idb_list` before opening a file. It reports sessions already adopted by the supervisor and discoverable GUI or worker instances.

Open a file with `idb_open`. Prefer `prefer_headless` unless another mode is required:

- `prefer_headless` adopts an existing worker for the same path or creates a headless worker.
- `force_headless` never adopts a GUI instance.
- `prefer_gui` adopts a matching GUI when available and otherwise creates a worker.
- `force_gui` may launch IDA and must be used only when a visible GUI is requested.

Enable automatic analysis, cache construction, and Hex-Rays initialization when the task needs them. Preserve the returned `session_id`; every forwarded analysis or mutation call must pass that exact value as `database`. A filename or path is not a session identifier.

Use `server_health(database=...)` after opening and before relying on pseudocode, strings, or analysis-dependent queries. Do not treat a database as ready while automatic analysis is incomplete.

Call `idb_close` when the session is no longer needed. Decide explicitly whether to save. Closing an owned worker frees its slot; closing an adopted instance detaches it rather than killing the external GUI or worker.

</session_lifecycle>

<management_api>

- `idb_open` opens or adopts a database and returns the authoritative session identifier.
- `idb_list` enumerates adopted and discoverable sessions and their backend, process, activity, and analysis state.
- `idb_close` optionally saves, unregisters, and releases a session.
- `idb_save` saves the active database through its worker and can save to a specified path when supported by the live schema.
- `server_health` probes the worker associated with one database.

The supervisor has no implicit current database. Never omit `database` from a forwarded tool call even when only one session is open.

</management_api>

<current_safe_surface>

The normal headless server exposes the shared structured analysis, query, type, annotation, database, patch, and signature tools described in `mcp_api.md`, plus the session-management tools above.

The current safe surface includes these management-independent tool families:

- triage and composite analysis: `survey_binary`, `analyze_function`, `analyze_component`, `analyze_batch`, `func_profile`, `trace_data_flow`;
- functions and flow: `decompile`, `disasm`, `basic_blocks`, `callees`, `callgraph`, `list_funcs`, `lookup_funcs`, `func_query`, `insn_query`, `export_funcs`;
- entities and evidence: `entity_query`, `list_globals`, `imports`, `imports_query`, `xrefs_to`, `xref_query`, `xrefs_to_field`, `find`, `find_bytes`, `find_regex`, `search_text`;
- memory and values: `get_bytes`, `get_int`, `get_string`, `get_global_value`, `read_struct`, `int_convert`;
- types and frames: `search_structs`, `type_query`, `type_inspect`, `declare_type`, `enum_upsert`, `set_type`, `type_apply_batch`, `infer_types`, `stack_frame`, `declare_stack`, `delete_stack`, `set_op_type`;
- annotations and reconstruction: `rename`, `set_comments`, `append_comments`, `add_bookmark`, `define_func`, `define_code`, `undefine`, `make_data`, `force_recompile`;
- patches and signatures: `patch`, `put_int`, `patch_asm`, `make_signature`, `make_signature_for_function`, `make_signature_for_range`, `find_xref_signatures`.

Always use the live tool list rather than relying on this catalog as a fixed count.

</current_safe_surface>

<multi_binary_discipline>

Assign stable, descriptive session identifiers when opening related files. Pass the correct identifier on every call and include it in intermediate notes so evidence from different binaries cannot be mixed.

Use bounded worker counts. Close idle sessions instead of accumulating detached workers. Before reopening a path, call `idb_list`; workers are persistent and can be adopted by a later supervisor.

Do not open the same database in multiple writable headless sessions. When comparing binaries, keep separate session identifiers and record the image base and hashes for each result.

</multi_binary_discipline>

<unsafe_surface>

Do not assume `--unsafe` is enabled. Arbitrary Python, combined mutation helpers, and debugger-extension tools may be absent by design.

Do not request that the server be relaunched with `--unsafe` merely for convenience. Require a concrete operation that cannot be completed by the structured safe surface and explicit authorization for the additional risk.

</unsafe_surface>
