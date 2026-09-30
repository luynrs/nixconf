<scope>

Apply these instructions to reverse engineering, binary triage, disassembly, decompilation, IDA database work, type recovery, cross-reference analysis, binary diffing, patch analysis, and debugger-assisted investigation.

Treat this file as the router for the reverse-engineering instruction set. Resolve every referenced path from `<instruction_root>`, even when this file is loaded through a copied `AGENTS.md`, `CLAUDE.md`, or another bootstrap.

</scope>

<required_references>

Before analyzing a binary, read these files completely:

- `<instruction_root>/reverse_engineering/workflow.md`
- `<instruction_root>/reverse_engineering/mcp_api.md`

When using `idalib-mcp`, also read `<instruction_root>/reverse_engineering/idalib_mcp.md` completely.

When using `ida-pro-mcp` or relying on a running IDA GUI instance, also read `<instruction_root>/reverse_engineering/ida_pro_mcp.md` completely.

When constructing MCP calls or a repeatable MCP analysis sequence, also read `<instruction_root>/reverse_engineering/mcp_examples.md` completely.

When direct IDAPython is necessary, including through `py_eval` or `py_exec_file`, also read `<instruction_root>/reverse_engineering/idapython.md` and `<instruction_root>/reverse_engineering/idapython_examples.md` completely.

When selecting a training binary, benchmark, implementation reference, or supporting repository, also read `<instruction_root>/reverse_engineering/case_corpus.md` completely.

Do not load an unrelated reference merely because it exists. When a new specialized reverse-engineering reference is added, add one explicit routing sentence here that states exactly when it must be read.

</required_references>

<server_selection>

Prefer `idalib-mcp` for headless analysis, automation, independent or multiple binaries, and work that does not depend on the analyst's current GUI state.

Prefer `ida-pro-mcp` when the user is actively working in IDA, when the current cursor or selection matters, when changes must be visible immediately in the GUI, or when an interactive debugger is required.

If both servers are available, choose one authoritative writable session for a database. Do not modify the same IDB concurrently through independent GUI and headless sessions. Use IDALib adoption modes only after confirming which existing instance owns the file.

Verify the selected server and its live tool list before depending on a capability. Tool availability can be restricted by profiles, extension flags, unsafe-tool settings, IDA edition, decompiler availability, processor support, and server version. Never invent a missing tool, parameter, return field, or resource URI.

</server_selection>

<operating_contract>

Begin read-only. Establish the file identity, architecture, image base, segments, entry points, analysis status, and relevant functions before changing the database.

Treat pseudocode, inferred types, automatically generated names, classifications, and reconstructed control flow as hypotheses. Validate important conclusions against disassembly, bytes, cross-references, callers, callees, and observed data use.

Do not invent semantics. A plausible name is not evidence. Rename, type, or comment an entity only when the binary provides enough evidence, and preserve uncertainty in the name or comment when the conclusion is not proven.

Keep every operation bounded. Use filters, pagination, function scopes, depth limits, and result limits. Do not request a whole-program dump when a focused query can answer the question.

Do not execute an unknown target, start a debugger, write debuggee memory, patch bytes, or save destructive database changes unless the user's request authorizes that action. Static IDALib loading and analysis do not authorize target execution.

After any mutation, query the affected address or function again and verify the result. Report the evidence, addresses, assumptions, and remaining uncertainty instead of claiming that the reconstruction is perfect.

</operating_contract>
