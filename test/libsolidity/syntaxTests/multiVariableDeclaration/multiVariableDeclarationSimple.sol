contract C {
  function f() internal pure returns (uint, uint, uint, uint) {
    (uint a, uint b,,) = f();
    a; b;
  }
  function g() internal pure {
    (bytes memory a, string storage b) = h();
    a; b;
  }
  function h() internal pure returns (bytes memory, string storage s) { s = s; }
}
// ----
// Warning 6321: (51-55): Unnamed return parameter can remain uninitialized.
// Warning 6321: (57-61): Unnamed return parameter can remain uninitialized.
// Warning 6321: (63-67): Unnamed return parameter can remain uninitialized.
// Warning 6321: (69-73): Unnamed return parameter can remain uninitialized.
// Warning 6321: (250-262): Unnamed return parameter can remain uninitialized.
