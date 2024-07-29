// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

type Pointer is bytes32;

using PointerLib for Pointer global;

library PointerLib {
    function load(Pointer ptr) public pure returns (bytes32 result) {
        assembly {
            result := mload(ptr)
        }
    }

    function next(Pointer ptr) public pure returns (Pointer result) {
        assembly {
            result := add(ptr, 0x20)
        }
    }

    function store(Pointer ptr, bytes32 data) public pure returns (Pointer nextPtr) {
        assembly {
            mstore(ptr, data)

            nextPtr := add(ptr, 0x20)
        }
    }

    function store(Pointer ptr, bytes32 data, bool isImmutable) public pure returns (Pointer nextPtr) {
        assembly {
            mstore(ptr, data)

            nextPtr := add(ptr, 0x20)
        }

        bytes32 msp = memoryStorageLocation(ptr);

        assembly {
            if eq(isImmutable, 0x1) { mstore(mload(msp), 0x1) }
        }
    }

    function memoryStorageLocation(Pointer ptr) internal pure returns (bytes32 result) {
        assembly {
            let u := 0x6ffffff
            let r := div(ptr, 0x20)

            result := sub(ptr, r)
        }
    }
}
