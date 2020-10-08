contract C {
    function f() public returns (uint[] memory, uint) {
        try this.f() returns (uint[] memory x, uint y) {
            return (x, y);
        } catch {

        }
    }
}
// ====
// EVMVersion: >=byzantium
// ----
// Warning 6321: (46-59): Unnamed return parameter can remain uninitialized.
// Warning 6321: (61-65): Unnamed return parameter can remain uninitialized.
