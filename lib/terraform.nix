_:
let
  tf-interpolate = identifier: string: "\${${identifier}.${string}}";
  tfvar = tf-interpolate "var";
  tfdata = tf-interpolate "data";
in { inherit tfdata tfvar tf-interpolate; }
