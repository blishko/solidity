contract C {
    struct gas { uint a; }
    function f() public returns (uint, uint) {
        try this.f() {
            gas memory x;
        } catch Error(string memory) {

        }
    }
}
// ====
// EVMVersion: >=byzantium
// ----
// Warning 6321: (73-77): Unnamed return parameter can remain uninitialized.
// Warning 6321: (79-83): Unnamed return parameter can remain uninitialized.
// Warning 2072: (122-134): Unused local variable.
