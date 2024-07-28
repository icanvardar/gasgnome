// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

library ArithmeticLib {
    function convertWithSize(bytes32 b, uint16 desiredBits, uint16 sizeInBits) public pure returns (bytes32 to) {
        assembly {
            if eq(desiredBits, 0) {
                /// @dev bytes4(keccak256("CannotBeZero(uint256)")) => 0xfef3c17b
                mstore(0x80, 0xfef3c17b)
                mstore(0xa0, desiredBits)
                revert(0x9c, 0x24)
            }

            if gt(desiredBits, 0x100) {
                /// @dev bytes4(keccak256("ExceedsTheBound(uint256)")) => 0x95646250
                mstore(0x80, 0x95646250)
                mstore(0xa0, desiredBits)
                revert(0x9c, 0x24)
            }

            if gt(mod(desiredBits, 0x8), 0) {
                /// @dev bytes4(keccak256("MustBeAMultipleOfEight(uint256)")) => 0x36780089
                mstore(0x80, 0x36780089)
                mstore(0xa0, desiredBits)
                revert(0x9c, 0x24)
            }
        }

        uint16 sizeCap = cap(sizeInBits);

        assembly {
            if lt(desiredBits, sizeCap) {
                /// @dev bytes4(keccak256("MismatchedSizes(uint256,uint256)")) => 0x01e8c4a5
                mstore(0x80, 0x01e8c4a5)
                mstore(0xa0, desiredBits)
                mstore(0xc0, sizeCap)
                revert(0x9c, 0x44)
            }

            to := b
        }
    }

    /// NOTE: finds the nearest bit cap in multiple of eight
    function cap(uint16 bitSize) public pure returns (uint16 res) {
        assembly {
            if eq(bitSize, 0) {
                /// @dev bytes4(keccak256("CannotBeZero(uint256)")) => 0xfef3c17b
                mstore(0x80, 0xfef3c17b)
                mstore(0xa0, bitSize)
                revert(0x9c, 0x24)
            }

            if gt(bitSize, 0x100) {
                /// @dev bytes4(keccak256("ExceedsTheBound(uint256)")) => 0x95646250
                mstore(0x80, 0x95646250)
                mstore(0xa0, bitSize)
                revert(0x9c, 0x24)
            }

            for { let i := 0x0 } lt(i, 0x21) { i := add(i, 1) } {
                let tmp := mul(add(i, 1), 8)
                if or(gt(tmp, bitSize), eq(tmp, bitSize)) {
                    res := tmp
                    break
                }
            }
        }
    }
}
