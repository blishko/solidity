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
/**
 * Encodes Yul into SMT
 */

#pragma once

#include <libsolidity/formal/SMTEncoder.h>
#include <libsolidity/ast/AST.h>

#include <libyul/AST.h>
#include <libyul/optimiser/Semantics.h>

#include <map>
#include <set>
#include <variant>

namespace solidity::frontend
{


struct AssignedExternalsCollector: public yul::ASTWalker
{
	using ExternalReferences = std::map<yul::Identifier const*, InlineAssemblyAnnotation::ExternalIdentifierInfo>;
	AssignedExternalsCollector(ExternalReferences const& _externalReferences):
		externalReferences(_externalReferences)
	{}

	ExternalReferences const& externalReferences;
	std::set<VariableDeclaration const*> assignedVars;

	using yul::ASTWalker::operator();
	void operator()(yul::Assignment const& _assignment)
	{
		auto const& vars = _assignment.variableNames;
		for (auto const& identifier: vars)
			if (auto it = externalReferences.find(&identifier); it != externalReferences.end())
				if (auto declaration = dynamic_cast<VariableDeclaration const*>(it->second.declaration))
					assignedVars.insert(declaration);
	}
};



class YulEncoder: public yul::ASTWalker
{
	using ExternalReferences = std::map<yul::Identifier const*, InlineAssemblyAnnotation::ExternalIdentifierInfo>;
public:
	YulEncoder(InlineAssembly const& _inlineAsm, smt::EncodingContext& _context):
		externalReferences(_inlineAsm.annotation().externalReferences),
		context(_context)
	{
		this->operator()(_inlineAsm.operations());
	}
private:

	ExternalReferences const& externalReferences;
	smt::EncodingContext& context;
	std::set<VariableDeclaration const*> assignedVars;

	using yul::ASTWalker::operator();
	void operator()(yul::Assignment const& _assignment)
	{
		auto toExternalDeclaration = [&](yul::Identifier const* _name) -> VariableDeclaration const* {
			if (auto it = externalReferences.find(_name); it != externalReferences.end())
				return dynamic_cast<VariableDeclaration const*>(it->second.declaration);
			return nullptr;
		};

		auto const& vars = _assignment.variableNames;
		auto const& value = *_assignment.value;
		bool assigned = false;
		if (vars.size() == 1) {
			if (auto declaration = toExternalDeclaration(&vars.front())) {
				if (auto const * literal = std::get_if<yul::Literal>(&value))
				{
					context.addAssertion(context.variable(*declaration)->increaseIndex() == literalToExpression(*literal, *context.variable(*declaration)->sort()));
					assigned = true;
				}
				if (auto const * identifier = std::get_if<yul::Identifier>(&value)) {
					if (auto other = toExternalDeclaration(identifier))
					{
						auto newVal = context.variable(*other)->currentValue(declaration->type());
						context.addAssertion(context.variable(*declaration)->increaseIndex() = newVal);
						assigned = true;
					}
				}
			}
		}
		if (assigned)
			return;

		for (auto const& identifier: vars)
			if (auto declaration = toExternalDeclaration(&identifier))
				context.resetVariable(*declaration);
	}

	void operator()(yul::If const& _if)
	{
		resetAllAssigned(_if);
	}

	void operator()(yul::Switch const& _switch)
	{
		resetAllAssigned(_switch);
	}

	void operator()(yul::ForLoop const& _for)
	{
		resetAllAssigned(_for);
	}

	void operator()(yul::FunctionCall const& _call)
	{
		resetAllAssigned(_call);
	}

	template<class T>
	void resetAllAssigned(T const& yulStatement)
	{
		AssignedExternalsCollector collector(externalReferences);
		collector(yulStatement);
		for (auto var: collector.assignedVars)
		{
			if (var)
				context.resetVariable(*var);
		}
	}

	smtutil::Expression literalToExpression(yul::Literal const& _literal, smtutil::Sort const& _expectedSort);
};
}


