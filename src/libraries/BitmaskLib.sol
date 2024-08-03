// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

struct Mask {
    bytes32 value;
    uint8 bits;
    uint8 leftShiftedBits;
}

using BitmaskLib for Mask global;

library BitmaskLib {
    function build(uint8 bits) public pure returns (Mask memory mask) {
        assembly {
            mstore(mask, not(sub(shl(bits, 0x01), 0x01)))
            mstore(add(mask, 0x20), bits)
        }
    }

    function build(uint8 bits, uint8 leftShiftedBits) public pure returns (Mask memory mask) {
        assembly {
            mstore(mask, not(shl(leftShiftedBits, sub(shl(bits, 0x01), 0x01))))
            mstore(add(mask, 0x20), bits)
            mstore(add(mask, 0x40), leftShiftedBits)
        }
    }

    /// @dev Mask functions
    function updateLeftPadded(Mask memory m, bytes32 slot, bytes32 data) public {
        assembly {
            function updateData(old, new, mask, lsl) -> res {
                res := and(old, mask)
                res := or(res, shl(lsl, new))
            }

            sstore(slot, updateData(sload(slot), data, mload(m), mload(add(m, 0x40))))
        }
    }

    function updateLeftPadded(Mask memory m, bytes32 slot, uint256 data) public {
        updateLeftPadded(m, slot, bytes32(data));
    }

    function updateLeftPadded(Mask memory m, bytes32 slot, int256 data) public {
        bytes32 tmp;
        assembly {
            tmp := data
        }
        updateLeftPadded(m, slot, tmp);
    }

    function updateRightPadded(Mask memory m, bytes32 slot, bytes32 data) public {
        assembly {
            function updateData(old, new, mask, lsl) -> res {
                res := and(old, mask)
                res := or(res, shl(lsl, new))
            }

            sstore(
                slot, updateData(sload(slot), shr(sub(0x100, mload(add(m, 0x20))), data), mload(m), mload(add(m, 0x40)))
            )
        }
    }
}
