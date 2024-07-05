contract C {

	uint s = 1;

	function decrement() private returns (uint) {
		return --s;
	}

	function increment() private returns (uint) {
		return ++s;
	}

	function f(uint x) public returns (uint) {
		require(s > 0 && s < 10);
		uint olds = s;
		uint ret = x < 1 ? increment() : decrement();
		assert(s != olds);
		return ret;
	}
}
// ====
// SMTEngine: chc
// ----
// Warning 6328: (297-314): CHC: Assertion violation might happen here.
// Info 1391: CHC: 2 verification condition(s) proved safe! Enable the model checker option "show proved safe" to see all of them.
