// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

type Mask is bytes32;

using BitmaskLib for Mask global;

library BitmaskLib {
    function generate(uint256 maskLength) public pure returns (Mask mask) {
        assembly {
            mask := not(sub(shl(maskLength, 1), 1))
        }
    }

    function generate(uint256 maskLength, uint256 leftShiftLength) public pure returns (Mask mask) {
        assembly {
            /// bytes4(keccak256("WrongParameters()"))
            if gt(leftShiftLength, 0x100) {
                mstore(0x80, 0xbd28cf5f)
                revert(0x9c, 0x04)
            }

            mask := not(shl(leftShiftLength, sub(shl(maskLength, 1), 1)))
        }
    }

    /// @dev Mask functions
    function updateDataWith(Mask m, bytes32 slot, bytes32 data) public {
        assembly {
            function updateData(old, new, mask) -> res {
                res := and(old, mask)
                res := or(res, new)
            }

            sstore(slot, updateData(sload(slot), data, m))
        }
    }

    function updateDataWith(Mask m, bytes32 slot, bytes32 data, uint256 leftShiftLength) public {
        assembly {
            function updateData(old, new, mask, lsl) -> res {
                res := and(old, mask)
                res := or(res, shl(lsl, new))
            }

            sstore(slot, updateData(sload(slot), data, m, leftShiftLength))
        }
    }

    function updateDataWith(Mask m, bytes32 slot, uint256 data) public {
        updateDataWith(m, slot, bytes32(data));
    }

    function updateDataWith(Mask m, bytes32 slot, uint256 data, uint256 leftShiftLength) public {
        updateDataWith(m, slot, bytes32(data), leftShiftLength);
    }

    function updateDataWith(Mask m, bytes32 slot, int256 data) public {
        bytes32 tmp;
        assembly {
            tmp := data
        }
        updateDataWith(m, slot, tmp);
    }

    function updateDataWith(Mask m, bytes32 slot, int256 data, uint256 leftShiftLength) public {
        bytes32 tmp;
        assembly {
            tmp := data
        }
        updateDataWith(m, slot, tmp, leftShiftLength);
    }

    function toMask(bytes32 from) public pure returns (Mask to) {
        assembly {
            to := from
        }
    }

    function toBytes32(Mask from) public pure returns (bytes32 to) {
        assembly {
            to := from
        }
    }
}
