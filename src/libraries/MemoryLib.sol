// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

library MemoryLib {
    function freeMemory() internal pure returns (bytes32 result) {
        assembly {
            result := mload(0x40)
        }
    }

    function nextFreeMemory() internal pure returns (bytes32 result) {
        assembly {
            result := add(mload(0x40), 0x20)
        }
    }

    /// NOTE: This function has to be internal. If it's not internal,
    /// compiler cleans its memory usage up after it's called in
    /// another scope.
    function store(bytes32 data) internal pure returns (bytes32 nextPtr) {
        assembly {
            let freePtr := mload(0x40)

            mstore(freePtr, data)

            nextPtr := add(freePtr, 0x20)
        }
    }

    /// NOTE: Immutability is applicable as long as this library functions
    /// are being used.
    function store(bytes32 data, bool isImmutable) internal pure returns (bytes32 nextPtr) {
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

    function update(bytes32 ptr, bytes32 data) internal pure {
        bytes32 msp = memoryStorageLocation(ptr);
        assembly {
            if eq(mload(msp), 0x1) {
                /// @dev bytes4(keccak256("ImmutableVariable()")) => 0x8e751c05
                mstore(0x80, 0x8e751c05)
                revert(0x9c, 0x04)
            }
        }

        assembly {
            mstore(ptr, data)
        }
    }

    function memoryStorageLocation(bytes32 ptr) public pure returns (bytes32 result) {
        assembly {
            let u := 0x6ffffff
            let r := div(ptr, 0x20)

            result := sub(u, r)
        }
    }
}
