<scope>

Universal baseline standards for all source code across any programming language. Language-specific rule files extend or specialize these defaults.

</scope>

<language_routing>

When working with a specific language, also read its dedicated rule file:
- C++: `<instruction_root>/languages/cpp.md`

</language_routing>

<naming_conventions>

1. Respect Ecosystem Idioms:
Follow canonical naming and casing standards of the target language (e.g., `snake_case` in C++/Python/Rust, `camelCase` and `PascalCase` in TypeScript/Go/C#). Never impose alien naming paradigms on a language ecosystem.

2. Descriptive Identifiers:
Prohibit cryptic abbreviations (e.g., use `buffer_size` instead of `buf_sz`, `callback` instead of `cb`, `destination` instead of `dst`).

3. Single-Character Name Ban:
Single-character variable names are strictly prohibited for pointers, data structures, and objects. They are permitted solely as standard integer loop indices (`i`, `j`, `k`).

4. External Interface Integrity:
Preserve names, signatures, and casing mandated by external SDKs, engines, operating systems, or third-party APIs. Never rename external contracts.

</naming_conventions>

<code_and_variable_economy>

Before emitting code in any language, evaluate every line against three questions:
1. "Do I need this line?"
2. "What are the consequences of removing this line?"
3. "Does it follow the active language and styling rules?"

- If removing a line does not cause a compile failure, crash, or broken program behavior under known runtime conditions, omit it.
- Never justify keeping an unnecessary line solely because removing it causes a crash in downstream code: if the underlying state or mechanism is redundant, eliminate the entire construct at the root.

1. Eliminate Redundant Intermediates:
Do not declare local variables solely to name obvious one-line computations, trivial accessors, or simple boolean conditions. Compute expressions directly at their point of use.
A local variable is permitted ONLY if:
- Re-evaluating it has observable side effects, allocations, or non-trivial performance cost.
- It holds state mutated across subsequent statements.
- Its address or reference is required by an external API or caller contract.
- Inlining creates deeply nested, sprawling, or unreadable expressions.

2. Inline Single-Use Helpers:
Never author private helper functions, single-use lambdas, or wrapper utilities for straightforward logic used only once. Keep the implementation at the call site unless required by an external API or callback signature.

3. No Speculative Abstractions:
Prohibit wrapper classes, factory patterns, or premature generalizations for single-implementation use cases.

4. Eliminate Dead Defensive Code:
Never write defensive checks, null fallbacks, or unreachable guards for states already guaranteed by upstream invariants or caller contracts.

</code_and_variable_economy>

<commenting_discipline>

1. Zero Narrative Comments:
Never write comments that narrate, summarize, or restate code logic. Code must be self-explanatory through precise naming and structure.

2. Preserve Existing Comments:
Do not delete, edit, or comment on pre-existing comments in the codebase that were not introduced by your change.

</commenting_discipline>
