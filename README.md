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
