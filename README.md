# [bazel-issue-15662](https://github.com/bazelbuild/bazel/issues/15662)

This repository demonstrates an inconsistency in the behavior
of an alias when used with the `rlocation`/`manifest` system
provided by the [bash runfiles in `@bazel_tools`](https://github.com/bazelbuild/bazel/blob/486d153d1981c3f47129f675de20189667667fa7/tools/bash/runfiles/runfiles.bash#L54-L63).

We define a simple `sh_binary` called `\\:foo1`, and create
an alias target `\\:foo2` that refers to `\\:foo1`.  We then
create another `sh_binary` called `\\:bar` that depends on
the foo1 and foo2 target and resolves them using `$(rlocation ...)`.

The desired behavior would be for rlocation calls on both targets
to resolve to the same path, since they represent the same resource.
However, the actual behavior is that true target returns a result,
while the alias is not found.

```bash
$ bazel run //:bar
INFO: Analyzed target //:bar (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
Target //:bar up-to-date:
  bazel-bin/bar
INFO: Elapsed time: 0.113s, Critical Path: 0.00s
INFO: 2 processes: 2 internal.
INFO: Build completed successfully, 2 total actions
INFO: Build completed successfully, 2 total actions
---------------------------------------------------
INFO[runfiles.bash]: rlocation(com_example_bazel/foo1): start
INFO[runfiles.bash]: rlocation(com_example_bazel/foo1): looking in RUNFILES_MANIFEST_FILE (/home/pras/.cache/bazel/_bazel_pras/e1db911261e74a0af01d8103864c3772/execroot/com_example_bazel/bazel-out/k8-fastbuild/bin/bar.runfiles_manifest)
INFO[runfiles.bash]: rlocation(com_example_bazel/foo1): found in manifest as (/home/pras/.cache/bazel/_bazel_pras/e1db911261e74a0af01d8103864c3772/execroot/com_example_bazel/bazel-out/k8-fastbuild/bin/foo1)
---------------------------------------------------
INFO[runfiles.bash]: rlocation(com_example_bazel/foo2): start
INFO[runfiles.bash]: rlocation(com_example_bazel/foo2): looking in RUNFILES_MANIFEST_FILE (/home/pras/.cache/bazel/_bazel_pras/e1db911261e74a0af01d8103864c3772/execroot/com_example_bazel/bazel-out/k8-fastbuild/bin/bar.runfiles_manifest)
INFO[runfiles.bash]: rlocation(com_example_bazel/foo2): not found in manifest
---------------------------------------------------
The following rlocation outputs should be the same:
  '$(rlocation com_example_bazel/foo1)' = /home/pras/.cache/bazel/_bazel_pras/e1db911261e74a0af01d8103864c3772/execroot/com_example_bazel/bazel-out/k8-fastbuild/bin/foo1
  '$(rlocation com_example_bazel/foo2)' = 
```
