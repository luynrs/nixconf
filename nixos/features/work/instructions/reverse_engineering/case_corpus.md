<selection_rule>

Choose repositories by the evidence they provide: maintained API source, executable test, source-to-binary pair, expected report, or implementation of a specific technique. Popularity is not proof of correctness. Record the repository URL, commit, relative artifact path, file hash, architecture, and the exact question the artifact is meant to answer.

Do not combine every repository into one workflow. Select the smallest source that directly supports the current task.

</selection_rule>

<mcp_reversing_dataset>

Repository: `https://github.com/mrexodia/mcp-reversing-dataset`

This is the primary MCP case corpus because each case includes a prompt and analysis history or report next to the binary. Use the histories as comparison material, not ground truth; independently reproduce important claims.

- `crackme03/crackme03.elf` — 16,136-byte ELF64, SHA-256 `39a5d93c220cf5188cac3fe43108353e96d180b6f6a1997ac1a28879a48919a1`. Task: recover the six-byte password and explain the validator. Verified anchors: `main` `0x123e`, `check_pw` `0x11a9`, call `0x12d3`, password `nDoEiA`.
- `mcp-job-security/transformed.elf` — 16,224-byte ELF64, SHA-256 `f7f1b2717754d80a6c2b9e897cdb3cc8f85a74ac22c21b2ea45b571b49f8272e`. Task: distinguish actual validation from misleading symbols and embedded prompt-like strings. Verified anchor: validator `0x1240`; accepted input `CTF{r3vers3_3ngin33ring_cha11enge}`.
- `VEHMeme/VEHMeme.exe` — 90,112-byte PE64, SHA-256 `c3499f66bf7e97d6a56de40637e3eeebedad94f700c23d30d3f89136cbf8102d`. Task: recover vectored-exception control flow and resource-backed executable code. Verified anchors: `Handler` `0x1400010b0`, TLS callback `0x1400012c0`, `main` `0x140001320`.

All three cases are suitable for static IDALib analysis. Their presence in a training repository is not permission to execute them on the host.

</mcp_reversing_dataset>

<official_ida_sources>

- `https://github.com/HexRaysSA/ida-sdk` — authoritative SDK source and 132 IDAPython example scripts under `src/plugins/idapython/examples`. Use it for real API usage, debugger/Appcall examples, processor modules, loaders, and plugins. Example binary: `src/plugins/idapython/examples/debugger/appcall/test_programs/simple_appcall/simple_appcall_win64.exe`, 9,728 bytes, SHA-256 `15cab95d6f07e753851209625e89c1e505ea81d2d6c8d18440e54f872c1e89b5`.
- `https://github.com/HexRaysSA/ida-domain` — official higher-level Python API for functions, types, and cross-references; it complements rather than replaces IDAPython and requires IDA 9.1 or later. Use it when building maintainable automation beyond one-off MCP calls.
- `https://github.com/mrexodia/ida-pro-mcp` — implementation authority for the current MCP tool schemas, safety gates, IDALib supervisor, GUI proxy, and bundled IDAPython module summaries. Inspect source and live schemas before documenting a capability.

</official_ida_sources>

<focused_technique_repositories>

- `https://github.com/KasperskyLab/hrtng` — concrete Hex-Rays/IDA implementations for string decryption, stack strings, API-hash scanning, microcode optimization, unflattening, type recovery, and pattern generation. Read the feature-specific document and implementation; do not import the plugin's entire behavior into an unrelated analysis.
- `https://github.com/mandiant/flare-emu` — Unicorn-backed function/range emulation with IDA integration and tests. Use when a decoder or small routine needs controlled emulation. Test binary: `tests/flare_emu_winhooks_test_x86.exe`, 46,592 bytes, SHA-256 `92e47d4ec401445a4af6ffc7d70d36c098f1ab749f105d677058df1bffa3bed8`.
- `https://github.com/mandiant/flare-floss` — implementations and theory for static, stack, tight, and decoded string recovery. Use its output as candidates to trace back into code.
- `https://github.com/mandiant/capa` — capability rules and feature extraction. Use it to generate behavior hypotheses and rule-driven leads, then verify the matched functions and features in IDA.
- `https://github.com/joxeankoret/diaphora` — IDA database diffing and function matching. Use for before/after binaries, patches, and version comparison; manually verify decisive matches and changed instructions.
- `https://github.com/OALabs/hashdb-ida` — API hash lookup and IDA annotation. Use only after identifying the algorithm, module scope, and collision handling from code or surrounding call sites.
- `https://github.com/gaasedelen/lighthouse` — code-coverage exploration. Bundled target: `testcase/boombox.exe`, 26,624 bytes, SHA-256 `d5449807ef9ba3d06663d4e8b8857bc876b387088733e059cc3bd351c1e77738`.
- `https://github.com/gaasedelen/tenet` — execution-trace exploration and trace-format examples. Use when a recorded path is available; do not generalize one trace to unexecuted paths.
- `https://github.com/illera88/Ponce` — IDA-integrated Triton symbolic execution and taint analysis with crackme examples. Use for path constraints and input influence when simpler static reasoning is insufficient.

</focused_technique_repositories>

<windows_training_artifacts>

- `https://github.com/mandiant/flare-learning-hub` — guided Windows AMD64 training with lab binaries, databases, scripts, and detailed course material. Use for structured assembly, malware-analysis, Go, and Time Travel Debugging exercises. Follow its isolation warning even for demonstration binaries.
- `https://github.com/hasherezade/malware_training_vol1` — source, binaries, exercises, and solutions for PE structure, patching, processes, shellcode, and Windows malware concepts. Small patching target: `exercises/module1/lesson1_compilation/patching/task2/expired_flag.exe`, 81,408 bytes, SHA-256 `8156a0b0757f43f91927d20c1363ebb631adef64ee63f08329d341c69477ca8f`.

</windows_training_artifacts>

<case_record>

For every worked case, record:

```text
repository: {URL}
commit: {full commit}
artifact: {repository-relative path}
sha256: {hash}
analysis mode: static | emulated | debugged
question: {one concrete question}
anchors: {addresses, symbols, imports, strings, or bytes}
result: {claim with confidence}
reproduction: {minimal ordered calls or script}
limitations: {unread code, truncated queries, unexecuted paths, missing symbols}
```

This record separates reproducible evidence from narrative and makes the corpus extendable without expanding the always-loaded workflow.

</case_record>
