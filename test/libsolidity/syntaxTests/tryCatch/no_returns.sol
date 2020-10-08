contract C {
    function f() public returns (uint, uint) {
        try this.f() {

        } catch {

        }
    }
}
// ----
// Warning 6321: (46-50): Unnamed return parameter can remain uninitialized.
// Warning 6321: (52-56): Unnamed return parameter can remain uninitialized.
