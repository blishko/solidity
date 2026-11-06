pragma abicoder               v2;

abstract contract C {
	struct S {
		uint256 x;
		string y;
	}

	function f() external virtual returns (uint256, string memory);
}
contract D is C {
	S public override f;
}
// ----
// TypeError 4822: (184-203): Overriding public state variable return types differ.
