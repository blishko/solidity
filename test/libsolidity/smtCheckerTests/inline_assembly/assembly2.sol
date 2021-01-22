pragma experimental SMTChecker;

contract C {
	function f() public pure returns (bool) {
		bool b;
		int x = 42;
		assembly { b := 1 }
		assert(x == 42); // should hold
		assert(b); // should hold, but fails due to overapproximation
		return b;
	}
}
// ----
// Warning 6328: (171-180): CHC: Assertion violation happens here.\nCounterexample:\n\n = false\n\nTransaction trace:\nC.constructor()\nC.f()
