********************************
Solidity ir Breaking Changes
********************************

This section highlights the main breaking changes introduced in Solidity after
releasing ir as a default codegen, along with the reasoning behind the changes and how to update
affected code.

Semantic Only Changes
=====================

This section lists the changes that are semantic-only, thus potentially
hiding new and different behavior in existing code.

 * When deleting storage struct, if struct occupies less than one slot, whole slot will be cleared.
 It is dangerous to use reminder of a slot for storing any other data as it is going to be set to zero after delete.

 ::

 contract C {
     struct S {
         uint64 y;
         uint64 z;
     }
     S s;
     function f() public {
         // ...
         delete s;
         uint256 slotValue;
         assembly {
            slotValue := sload(s.slot)
         }
         // slotValue is zero here, even though s occupies only half of the slot
     }
 }