pragma experimental SMTChecker;

contract C
{
    uint[] s;
	function f() public {
		uint[3] memory a = [uint(1), 2, 3];
		s = a;
		assert(s.length == a.length);
		assert(s[0] == a[0]);
		assert(s[1] == a[1]);
		assert(s[2] != a[2]); // fails
	}
}
// ----
// Warning 6328: (212-232): CHC: Assertion violation happens here.
