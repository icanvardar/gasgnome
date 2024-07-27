// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

library ArithmeticLib {
    function convertWithSize(bytes32 b, uint16 desiredBits, uint16 sizeInBits) public pure returns (bytes32 to) {
        assembly {
            /// TODO: add custom error here - desiredBits cannot be zero/cannot be bigger than 256 bits
            if or(eq(desiredBits, 0), gt(desiredBits, 0x100)) { revert(0x00, 0x00) }

            /// TODO: add custom error here - desiredBits has to be multiple of eight
            if gt(mod(desiredBits, 0x8), 0) { revert(0x00, 0x00) }
        }

        uint16 sizeCap = cap(sizeInBits);

        assembly {
            /// TODO: add custom error here - size cap cannot be bigger than given size in bytes
            if gt(sizeCap, desiredBits) { revert(0x00, 0x00) }

            to := b
        }
    }

    /// NOTE: finds the nearest bit cap in multiple of eight
    function cap(uint16 bitSize) public pure returns (uint16 res) {
        assembly {
            /// TODO: add custom error here - bitSize cannot be zero/cannot be bigger than 256 bits
            if or(eq(bitSize, 0), gt(bitSize, 0x100)) { revert(0x00, 0x00) }

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
