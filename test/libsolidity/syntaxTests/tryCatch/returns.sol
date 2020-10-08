contract C {
    function f() public returns (uint, uint) {
        try this.f() returns (uint a, uint b) {
            a = 1;
            b = 2;
        } catch {

        }
    }
}
// ----
// Warning 6321: (46-50): Unnamed return parameter can remain uninitialized.
// Warning 6321: (52-56): Unnamed return parameter can remain uninitialized.
