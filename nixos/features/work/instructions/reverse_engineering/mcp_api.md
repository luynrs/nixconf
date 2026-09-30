<live_schema_is_authoritative>

Use the MCP server's current `tools/list` schemas as the authority for names, arguments, required fields, result shapes, and enabled capabilities. The lists below describe the expected capability groups; they do not replace the live schemas.

Before the first call to a tool, inspect its description and input schema. Do not transfer arguments between `idalib-mcp` and `ida-pro-mcp` by assumption. In particular, IDALib-forwarded tools require an explicit `database` session identifier, while direct GUI tools operate on the selected IDA instance.

If a named tool is absent, determine whether the server, profile, extension, or version explains the absence. Use another exposed structured tool when it provides the same evidence. Do not simulate a missing IDA capability with guessed output.

</live_schema_is_authoritative>

<health_and_triage>

- `server_health` checks readiness, analysis state, Hex-Rays availability, caches, and the active database.
- `survey_binary` returns a bounded first-pass view of metadata, segments, entry points, statistics, strings, functions, imports, and a call-graph summary. Use it as the first analysis call after opening and warming a database. Use minimal detail for very large binaries.
- `analyze_function` combines pseudocode, strings, constants, callers, callees, cross-references, and blocks for one function.
- `analyze_component` summarizes a related function set and its internal relationships.
- `analyze_batch` runs bounded analysis over multiple selected functions.
- `func_profile` measures function-level characteristics and sampled details.
- `trace_data_flow` follows cross-reference relationships forward or backward. It is a bounded reference traversal, not symbolic execution and not proof of runtime data flow.

</health_and_triage>

<functions_and_control_flow>

- `list_funcs`, `lookup_funcs`, and `func_query` enumerate or resolve functions.
- `decompile` returns Hex-Rays pseudocode when the processor, function, and license support it.
- `disasm` returns bounded disassembly and supports pagination.
- `basic_blocks` returns control-flow blocks and their edges.
- `callees` returns direct callees of selected functions.
- `callgraph` builds a depth- and size-bounded call graph from explicit roots.
- `insn_query` searches instructions by mnemonic, operands, address scope, and limits.
- `export_funcs` exports selected functions as structured data, declarations, or prototypes.

Prefer `analyze_function` for an initial focused view. Use the lower-level tools to verify or expand individual claims rather than repeating broad queries.

</functions_and_control_flow>

<entities_imports_search_and_xrefs>

- `entity_query` queries typed IDB entities with filters and pagination.
- `list_globals` enumerates globals.
- `imports` and `imports_query` enumerate and filter imports with their modules.
- `xrefs_to`, `xref_query`, and `xrefs_to_field` inspect code, data, and structure-field references.
- `find` searches supported semantic targets such as strings, immediates, and references.
- `find_bytes` searches byte patterns and supports wildcard bytes.
- `find_regex` searches extracted strings with a regular expression.
- `search_text` searches the rendered IDA listing, not merely the strings table.

Respect pagination and truncation fields. An empty bounded page is not evidence that no match exists outside the requested scope.

</entities_imports_search_and_xrefs>

<memory_values_and_structures>

- `get_bytes` reads raw IDB bytes.
- `get_int` reads integers with an explicit width, signedness, and byte order.
- `get_string` reads strings at known addresses.
- `get_global_value` reads compile-time values of globals or named symbols.
- `read_struct` interprets memory using an established structure type.
- `int_convert` converts numeric representations; it does not establish that a number is an address, enum, character, or constant.

Do not reinterpret a value as a pointer, offset, string, or structure solely because the conversion looks plausible. Require supporting references, access patterns, relocation information, or type evidence.

</memory_values_and_structures>

<types_and_stack_frames>

- `search_structs`, `type_query`, and `type_inspect` inspect the local type system.
- `stack_frame` returns established stack variables and frame information.
- `declare_type` adds C declarations to the local type library.
- `enum_upsert` creates or extends enums idempotently.
- `set_type` and `type_apply_batch` apply types to functions, globals, locals, or stack variables.
- `infer_types` applies heuristic type recovery and must be verified afterward.
- `declare_stack` and `delete_stack` modify stack variables.
- `set_op_type` changes operand representation or type at an instruction.

Apply prototypes before drawing conclusions from decompiled arguments or return values. When a type change makes pseudocode worse or contradicts the assembly, inspect and correct the type instead of reasoning from the damaged output.

</types_and_stack_frames>

<annotations_and_database_structure>

- `rename` batch-renames functions, globals, locals, and stack variables and may support dry-run validation.
- `set_comments` replaces comments; `append_comments` preserves existing text and appends evidence.
- `add_bookmark` adds or replaces an IDA bookmark.
- `define_func` establishes a function and optional bounds.
- `define_code` converts bytes into instructions.
- `undefine` returns items to raw bytes.
- `make_data` creates typed data at an address.
- `force_recompile` invalidates cached pseudocode after relevant analysis or type changes.
- `idb_save` persists the database, optionally to a new path.

Treat function bounds, code/data classification, stack layout, and types as analysis state, not cosmetic metadata. Make one evidence-backed change at a time and verify the resulting disassembly, control flow, cross-references, and pseudocode.

</annotations_and_database_structure>

<patching_and_signatures>

- `patch`, `put_int`, and `patch_asm` modify IDB bytes or assembled instructions. They do not prove that a patched program is correct or safe to execute.
- `make_signature`, `make_signature_for_function`, and `make_signature_for_range` create byte signatures with wildcard handling.
- `find_xref_signatures` creates candidate signatures at code locations that reference a target.

Before patching, record the original bytes and instruction boundaries. Patch only the requested database or copy, verify the new bytes and disassembly, and state whether the input file itself was exported or remained unchanged.

</patching_and_signatures>

<gated_capabilities>

`py_eval`, `py_exec_file`, and `diff_before_after` are unsafe capabilities in the current source and may be hidden. Debugger operations belong to the `dbg` extension and may also be unavailable. Treat absence as intentional unless the user explicitly asks to change server configuration.

Prefer a structured tool over arbitrary IDAPython. Use direct Python only when the structured API cannot perform the required operation, after loading the IDAPython instructions and verifying the exact installed API.

</gated_capabilities>
