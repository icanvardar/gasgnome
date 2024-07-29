// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

library MemoryLib {
    function load() public pure returns (bytes32 result) {
        assembly {
            result := mload(0x40)
        }
    }

    function next() public pure returns (bytes32 result) {
        assembly {
            result := add(mload(0x40), 0x20)
        }
    }

    function store(bytes32 data) public pure returns (bytes32 nextPtr) {
        assembly {
            let freePtr := mload(0x40)

            mstore(freePtr, data)

            nextPtr := add(freePtr, 0x20)
        }
    }

    function store(bytes32 data, bool isImmutable) public pure returns (bytes32 nextPtr) {
        bytes32 freePtr;
        assembly {
            freePtr := mload(0x40)

            mstore(freePtr, data)

            nextPtr := add(freePtr, 0x20)
        }

        bytes32 msp = memoryStorageLocation(freePtr);
        assembly {
            if eq(isImmutable, 0x1) { mstore(mload(msp), 0x1) }
        }
    }

    function memoryStorageLocation(bytes32 ptr) internal pure returns (bytes32 result) {
        assembly {
            let u := 0x6ffffff
            let r := div(ptr, 0x20)

            result := sub(u, r)
        }
    }
}
