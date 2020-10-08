pragma experimental ABIEncoderV2;

contract C {
    function get() public view returns (uint[][] memory) {}

    function test() public view returns (bool) {
        uint[][] memory x = this.get();
    }
}
// ====
// EVMVersion: >=byzantium
// ----
// Warning 6321: (150-154): Unnamed return parameter can remain uninitialized.
// Warning 2072: (166-183): Unused local variable.
