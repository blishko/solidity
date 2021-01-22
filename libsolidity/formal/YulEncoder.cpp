/*
	This file is part of solidity.

	solidity is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	solidity is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with solidity.  If not, see <http://www.gnu.org/licenses/>.
*/
// SPDX-License-Identifier: GPL-3.0

#include "YulEncoder.h"

using namespace std;
using namespace solidity;
using namespace solidity::frontend;

namespace
{
	smtutil::Expression boolAs(bool _value, smtutil::Sort const& _sort)
	{
		switch (_sort.kind) {
			case smtutil::Kind::Int:
				return _value ? 1 : 0; // TODO: What is true interpreted as int in Yul?
			case smtutil::Kind::Bool:
				return _value;
			default:
				solAssert(false, "Unexpected situation in analysis of Yul block");
		}
	}

smtutil::Expression numberAs(u256 _value, smtutil::Sort const& _sort)
{
	switch (_sort.kind) {
		case smtutil::Kind::Int:
			return _value;
		case smtutil::Kind::Bool:
			return smtutil::Expression(_value != 0);
		default:
			solAssert(false, "Unexpected situation in analysis of Yul block");
	}
}
}

smtutil::Expression YulEncoder::literalToExpression(yul::Literal const& _literal, smtutil::Sort const& _expectedSort)
{
	switch (_literal.kind) {
		case yul::LiteralKind::Boolean:
			return boolAs(_literal.value.str() == "true", _expectedSort);
		case yul::LiteralKind::Number:
			return numberAs(u256(_literal.value.str()), _expectedSort);
		case yul::LiteralKind::String: // TODO
		default:
			solAssert(false, "");
	}
}
