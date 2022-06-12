#!/bin/bash

# --- begin runfiles.bash initialization v2 ---
# Copy-pasted from the Bazel Bash runfiles library v2.
set -uo pipefail; f=bazel_tools/tools/bash/runfiles/runfiles.bash
source "${RUNFILES_DIR:-/dev/null}/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "${RUNFILES_MANIFEST_FILE:-/dev/null}" | cut -f2- -d' ')" 2>/dev/null || \
  source "$0.runfiles/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "$0.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "$0.exe.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  { echo>&2 "ERROR: cannot find $f"; exit 1; }; f=; set -e
# --- end runfiles.bash initialization v2 ---

export RUNFILES_LIB_DEBUG=1

echo "---------------------------------------------------"
foo1_rlocation="$(rlocation com_example_bazel/foo1)"
echo "---------------------------------------------------"
foo2_rlocation="$(rlocation com_example_bazel/foo2)"
echo "---------------------------------------------------"
echo "The following rlocation outputs should be the same:"
echo "  '\$(rlocation com_example_bazel/foo1)' = $foo1_rlocation"
echo "  '\$(rlocation com_example_bazel/foo2)' = $foo2_rlocation"
