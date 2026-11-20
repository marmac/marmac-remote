"""
Patches dropdown_menu.dart in the installed Flutter SDK.
Applies the enableFilter fix without relying on git apply or line numbers.
Usage: python patch_flutter_dropdown.py <path_to_dropdown_menu.dart>
"""
import pathlib, sys

if len(sys.argv) != 2:
    print(f"Usage: {sys.argv[0]} <dropdown_menu.dart>", file=sys.stderr)
    sys.exit(1)

target = pathlib.Path(sys.argv[1])
if not target.exists():
    sys.exit(f"Not found: {target}")

src = target.read_text(encoding="utf-8")
original = src

# Already patched?
if "bool _enableFilter = false;" in src:
    print("Already patched, skipping.")
    sys.exit(0)

# Hunk 1: late bool -> initialised bool
src = src.replace(
    "  late bool _enableFilter;",
    "  bool _enableFilter = false;",
    1)

# Hunk 2: enableFilter reset in didUpdateWidget
old2 = "    if (oldWidget.enableSearch != widget.enableSearch) {"
new2 = (
    "    if (oldWidget.enableFilter != widget.enableFilter) {\n"
    "      if (!widget.enableFilter) {\n"
    "        _enableFilter = false;\n"
    "      }\n"
    "    }\n"
    "    if (oldWidget.enableSearch != widget.enableSearch) {"
)
if old2 not in src:
    sys.exit("Hunk 2 anchor not found")
src = src.replace(old2, new2, 1)

# Hunk 3: reset _enableFilter after onSelected
old3 = (
    "              widget.onSelected?.call(entry.value);\n"
    "            }\n"
    "          : null,"
)
new3 = (
    "              widget.onSelected?.call(entry.value);\n"
    "              _enableFilter = false;\n"
    "            }\n"
    "          : null,"
)
if old3 not in src:
    sys.exit("Hunk 3 anchor not found")
src = src.replace(old3, new3, 1)

# Hunk 4: else branch for filteredEntries
old4 = (
    "    if (_enableFilter) {\n"
    "      filteredEntries = widget.filterCallback?.call(filteredEntries, _localTextEditingController!.text)\n"
    "        ?? filter(widget.dropdownMenuEntries, _localTextEditingController!);\n"
    "    }\n"
)
new4 = (
    "    if (_enableFilter) {\n"
    "      filteredEntries = widget.filterCallback?.call(filteredEntries, _localTextEditingController!.text)\n"
    "        ?? filter(widget.dropdownMenuEntries, _localTextEditingController!);\n"
    "    } else {\n"
    "      filteredEntries = widget.dropdownMenuEntries;\n"
    "    }\n"
)
if old4 not in src:
    sys.exit("Hunk 4 anchor not found")
src = src.replace(old4, new4, 1)

if src == original:
    sys.exit("No changes made — check anchor strings")

target.write_text(src, encoding="utf-8")
print(f"OK: patched {target}")
