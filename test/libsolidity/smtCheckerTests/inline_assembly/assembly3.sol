pragma experimental SMTChecker;

contract C {
    function f() public pure returns (bool) {
        bool b;
        bool c = true;
        assembly { b := c }
        assert(c); // should hold, c is not assigned in the assembly
        assert(b); // should hold, but fails currently because of overapproximation
        return b;
    }
}
// ----
// Warning 6328: (236-245): CHC: Assertion violation happens here.\nCounterexample:\n\n = false\n\nTransaction trace:\nC.constructor()\nC.f()
