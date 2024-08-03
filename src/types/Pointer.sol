// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import { MemoryLib } from "../libraries/MemoryLib.sol";

type Pointer is bytes32;

using PointerLib for Pointer global;

library PointerLib {
    function load(Pointer ptr) internal pure returns (bytes32 result) {
        assembly {
            result := mload(ptr)
        }
    }

    function next(Pointer ptr) internal pure returns (Pointer result) {
        assembly {
            result := add(ptr, 0x20)
        }
    }

    function store(Pointer ptr, bytes32 data) internal pure returns (Pointer nextPtr) {
        assembly {
            mstore(ptr, data)

            nextPtr := add(ptr, 0x20)
        }
    }

    function store(Pointer ptr, bytes32 data, bool isImmutable) internal pure returns (Pointer nextPtr) {
        assembly {
            mstore(ptr, data)

            nextPtr := add(ptr, 0x20)
        }

        Pointer msp = memoryStorageLocation(ptr);

        assembly {
            if eq(isImmutable, 0x01) { mstore(msp, 0x01) }
        }
    }

    function update(Pointer ptr, bytes32 data) internal pure {
        MemoryLib.update(Pointer.unwrap(ptr), data);
    }

    function memoryStorageLocation(Pointer ptr) internal pure returns (Pointer result) {
        result = Pointer.wrap(MemoryLib.memoryStorageLocation(Pointer.unwrap(ptr)));
    }
}
