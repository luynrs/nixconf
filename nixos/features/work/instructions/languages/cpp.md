<scope>

Follow these rules for project-owned C++ code. Extends `<instruction_root>/languages/index.md`.

</scope>

<formatting>

Use this brace layout:

```cpp
if (condition) {
}
else if (other_condition) {
}
else {
}
```

Write pointer and reference types with `*` and `&` on the left: `const char* value`, `int* value`, and `const std::string& ref`, never `const char *value` or `const std::string &ref`.

Initialize empty pointers and zero-initialized structs with braces:

```cpp
int* ptr{};
type_t state{};
```

Empty brace initialization `{}` is permitted only for empty pointers and zero-initializing structs. Initializing non-pointer scalar types with empty braces (such as `int value{};` or `bool flag{};`) is strictly prohibited. Where a default value can be declared for a scalar type, always use explicit assignment:

```cpp
bool statement = false;
int integer = 0;
```

Prefer `if (!ptr)` over `if (ptr == nullptr)`.

Prefer `index++` over `++index` when possible.

Keep the complete argument list of every function call on one physical line. Never wrap function-call arguments across multiple lines, regardless of line length. Inline lambdas passed as arguments are exempt: format multi-statement lambda bodies across multiple lines for readability.

Never qualify C runtime functions with `std::`. Call them from the global namespace: use `memcpy(...)`, not `std::memcpy(...)`. Apply this consistently to all CRT functions.

</formatting>

<naming>

Use `snake_case` for project-owned names. Classes use the `c_` prefix, types (structs, type aliases, enums) use the `_t` suffix, and private data members of classes use the `m_` prefix. Public class and struct fields do not use `m_`.

```cpp
class c_class {
private:
    int m_member = 0;

public:
    int public_field = 0;
    c_class() = default;
};

struct type_t {
    int value = 0;
};

enum class mode_t {
    first,
    second
};
```

</naming>

<building>

Build and validate C or C++ projects only through `%USERPROFILE%\.zed-scripts\cmake_build.ps1`. Never invoke CMake, Ninja, MSBuild, `clang++`, or another compiler directly, and never reproduce the script's configure or build commands manually.

Pass the absolute worktree root through the required `-Root` argument:

```powershell
& "$env:USERPROFILE\.zed-scripts\cmake_build.ps1" -Root "<absolute-worktree-root>"
```

The script builds `Release` by default. Pass `-Config` only when another configuration is required. Pass `-Run` only when the produced executable must be launched after a successful build.

</building>

<readability_and_structure>

Multiline formatting and explicit scoping are justified only when they provide distinct structural clarity. Do not spread code across lines needlessly, but preserve formatting in these specific cases:

1. Lifecycle and Immediate-Mode Scope Blocks:
Preserve standalone `{ ... }` scope blocks placed between paired lifecycle or immediate-mode API calls (such as `begin()` / `end()`, `clip_rect()` / `pop_clip_rect()`, or `new_frame()` / `render()`). These blocks delineate intentional visual hierarchy and lifetime boundaries; never flatten or remove them.

2. Complex Geometry and Aggregate Declarations:
Do not collapse multi-component coordinate pairs, bounding boxes, or complex color/geometry structs (such as `rect_t`) onto a single crowded line. Format distinct coordinate boundaries across separate lines for visual clarity:

```cpp
const rect_t rect = {
    os.gui.pos(),
    os.gui.pos() + size
};
```

Outside of these structural cases and non-trivial lambdas, prefer compact, direct formatting.

</readability_and_structure>
