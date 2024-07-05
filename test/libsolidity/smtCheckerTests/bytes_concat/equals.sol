contract C {

	function concatCall(bytes8 a) public pure returns (bytes memory) {
		return bytes.concat(a, a);
	}

	function equalArguments1(bytes8 a, bytes8 b, bytes8 c, bytes8 d) public pure {
		require(a == c);
		require(b == d);
		bytes memory concat1 = bytes.concat(a, b);
		bytes memory concat2 = bytes.concat(c, d);
		assert(keccak256(concat1) == keccak256(concat2));
	}

	function equalArguments2(bytes8 a, bytes8 c) public pure {
		require(a == c);
		bytes memory concat1 = bytes.concat(a, concatCall(a));
		bytes memory concat2 = bytes.concat(c, concatCall(c));
		assert(keccak256(concat1) == keccak256(concat2));
	}

	function equalLengthFixedBytes(bytes8 a, bytes8 b) public pure {
		bytes memory concat1 = bytes.concat(a, b);
		bytes memory concat2 = bytes.concat(a, b);
		assert(concat1.length == concat2.length);
	}

	function equalLengthMemoryBytes(bytes memory a, bytes memory b) public pure {
		bytes memory concat1 = bytes.concat(a, b);
		bytes memory concat2 = bytes.concat(a, b);
		assert(concat1.length == concat2.length);
	}

	function equalLengthMixed(bytes memory a, bytes2 b) public pure {
		bytes memory concat1 = bytes.concat(a, b);
		bytes memory concat2 = bytes.concat(a, b);
		assert(concat1.length == concat2.length);
	}

	function equalLengthLiterals() public pure {
		bytes memory a = hex"aa";
		bytes1 b = bytes1(0xbb);
		bytes memory c = "c";
		bytes memory concat1 = bytes.concat(a, b, c);
		bytes memory concat2 = bytes.concat(a, b, c);
		assert(concat1.length == concat2.length);
	}
}
// ====
// SMTEngine: all
// ----
// Warning 6328: (786-826): CHC: Assertion violation might happen here.
// Warning 6328: (1003-1043): CHC: Assertion violation might happen here.
// Warning 6328: (1208-1248): CHC: Assertion violation might happen here.
// Warning 6328: (1477-1517): CHC: Assertion violation might happen here.
// Info 1391: CHC: 2 verification condition(s) proved safe! Enable the model checker option "show proved safe" to see all of them.
// Info 6002: BMC: 4 verification condition(s) proved safe! Enable the model checker option "show proved safe" to see all of them.
