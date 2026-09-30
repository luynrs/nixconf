<evidence_model>

Separate observations from interpretations.

An observation is directly supported by bytes, an instruction, a reference, a segment property, an import, a runtime event, or another reproducible artifact. An interpretation assigns meaning such as "decryptor", "packet parser", "vtable", or "authentication check".

Attach addresses and the shortest relevant evidence to important claims. State uncertainty when multiple interpretations remain possible. Do not convert a hypothesis into a function name, type, or comment merely because it fits the surrounding pseudocode.

</evidence_model>

<initial_triage>

Establish the input path, hashes, format, architecture, image base, entry points, segments, and analysis readiness. Record whether the IDB is new, existing, headless, or GUI-owned.

Run one bounded survey. Use its imports, strings, functions, and graph summary to select analysis targets. Do not enumerate the same whole-database datasets again unless the survey was truncated or a narrower filter is required.

Prioritize externally reachable code, entry points, unusual imports, high-reference strings, dispatchers, parsers, allocators, crypto-adjacent code, and functions that connect otherwise separate components. Treat heuristic classifications only as navigation hints.

</initial_triage>

<function_analysis>

For each target function:

1. Confirm its boundaries and chunks.
2. Read bounded disassembly and pseudocode.
3. Inspect callers, callees, cross-references, strings, constants, stack variables, and relevant globals.
4. Recover prototypes and data types from call sites and access patterns.
5. Rename or comment only after evidence is sufficient.
6. Re-decompile and verify that the reconstructed types improve rather than distort the result.

Trace outward from a concrete question. Stop expanding the graph when additional nodes do not affect the requested conclusion.

</function_analysis>

<decompiler_failures>

When pseudocode fails or looks structurally wrong, inspect the assembly before forcing a conclusion. Check:

- function start, end, chunks, shared tails, and incorrectly applied `noreturn` behavior;
- stack-pointer changes, calling convention, purged bytes, saved registers, and frame layout;
- direct and indirect call targets and their prototypes;
- code/data boundaries, switch tables, offsets, and missing cross-references;
- stale decompiler output after type or analysis changes.

Correct the underlying IDB fact, reanalyze the smallest affected range, invalidate cached pseudocode when necessary, and verify again. Do not patch code merely to make the decompiler accept it.

</decompiler_failures>

<types_and_cpp_recovery>

Infer structures from repeated field offsets, access widths, construction patterns, call sites, RTTI, vtables, and related functions. One offset access is not enough to establish a complete structure.

For indirect calls, identify the assignment or load that produced the target, then recover the callable type. Distinguish vtable dispatch, callback tables, compiler register reuse, imports, jump tables, and obfuscation before applying a type.

Apply the smallest established structure or prototype first. Expand it as new evidence appears. Preserve external ABI, SDK, compiler, and game naming when it is genuinely identified.

</types_and_cpp_recovery>

<strings_hashes_and_decoders>

For a suspected string decoder, identify the decoder function, its call sites, argument sources, output buffer, termination behavior, and whether initialization occurs at runtime. Decode or emulate one representative call before processing every reference.

For API hashes, identify or test the hash algorithm and module scope before applying names. Multiple candidate matches require analyst resolution. Do not assign the first plausible API name without collision and call-site checks.

Treat tool output from string extraction, emulation, or hash databases as candidates. Validate candidates with cross-references, arguments, and subsequent use.

</strings_hashes_and_decoders>

<packing_obfuscation_and_dynamic_work>

Static absence of behavior is not proof when the sample is packed, encrypted, virtualized, self-modifying, or dynamically resolves APIs. Record the limitation and identify the unpacking or initialization boundary.

Do not execute an unknown sample implicitly. Dynamic analysis requires explicit authorization, an appropriate debugger or emulator, and containment suitable for the target. A trace proves only the observed execution under the supplied state.

When flattening, opaque predicates, indirect jumps, or anti-disassembly corrupt the CFG, preserve the original database and make reversible corrections in a copy. Experimental deobfuscation output must be verified against raw instructions and runtime behavior where available.

</packing_obfuscation_and_dynamic_work>

<mutations_and_reporting>

Prefer read-only evidence collection until a mutation will improve analysis. Use dry-run modes when available. Apply renames, types, comments, function boundaries, and code/data definitions in small batches, then verify each batch.

Before byte or assembly patches, capture original bytes and instruction boundaries. Distinguish an IDB patch from a changed input file and from a runtime memory write.

Report conclusions with addresses, evidence, confidence, and unresolved alternatives. Report failed queries, truncated results, disabled capabilities, and analysis gaps. Never state that generated analysis is perfect or complete.

</mutations_and_reporting>
