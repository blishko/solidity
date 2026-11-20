contract C {
    struct T { uint[2] x; }
    struct S { uint a; bytes b; uint[] c; T t; }
    S public s;
    mapping(uint key => S value) public m;
}
// ----
//     :C
// [
//   {
//     "inputs": [
//       {
//         "internalType": "uint256",
//         "name": "key",
//         "type": "uint256"
//       }
//     ],
//     "name": "m",
//     "outputs": [
//       {
//         "internalType": "uint256",
//         "name": "a",
//         "type": "uint256"
//       },
//       {
//         "internalType": "bytes",
//         "name": "b",
//         "type": "bytes"
//       },
//       {
//         "components": [
//           {
//             "internalType": "uint256[2]",
//             "name": "x",
//             "type": "uint256[2]"
//           }
//         ],
//         "internalType": "struct C.T",
//         "name": "t",
//         "type": "tuple"
//       }
//     ],
//     "stateMutability": "view",
//     "type": "function"
//   },
//   {
//     "inputs": [],
//     "name": "s",
//     "outputs": [
//       {
//         "internalType": "uint256",
//         "name": "a",
//         "type": "uint256"
//       },
//       {
//         "internalType": "bytes",
//         "name": "b",
//         "type": "bytes"
//       },
//       {
//         "components": [
//           {
//             "internalType": "uint256[2]",
//             "name": "x",
//             "type": "uint256[2]"
//           }
//         ],
//         "internalType": "struct C.T",
//         "name": "t",
//         "type": "tuple"
//       }
//     ],
//     "stateMutability": "view",
//     "type": "function"
//   }
// ]
