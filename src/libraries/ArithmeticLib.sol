// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

library ArithmeticLib {
    function convertWithSize(bytes32 b, uint16 sizeInBytes, uint8 sizeInBits) public pure returns (bytes32 to) {
        assembly {
            /// TODO: add custom error here - sizeInBytes cannot be zero/cannot be bigger than 256 bits
            if or(eq(sizeInBytes, 0), gt(sizeInBytes, 0x100)) { revert(0x00, 0x00) }

            /// TODO: add custom error here - sizeInBytes has to be multiple of eight
            if gt(mod(sizeInBytes, 0x8), 0) { revert(0x00, 0x00) }
        }

        uint8 sizeCap = cap(sizeInBits);

        assembly {
            /// TODO: add custom error here - size cap cannot be bigger than given size in bytes
            if gt(sizeCap, sizeInBytes) { revert(0x00, 0x00) }

            to := b
        }
    }

    /// NOTE: finds the nearest bit cap in multiple of eight
    function cap(uint8 bitSize) public pure returns (uint8 res) {
        assembly {
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
