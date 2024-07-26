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
    function updateLeftPadded(Mask m, bytes32 slot, bytes32 data) public {
        assembly {
            function updateData(old, new, mask) -> res {
                res := and(old, mask)
                res := or(res, new)
            }

            sstore(slot, updateData(sload(slot), data, m))
        }
    }

    function updateLeftPadded(Mask m, bytes32 slot, bytes32 data, uint256 leftShiftLength) public {
        assembly {
            function updateData(old, new, mask, lsl) -> res {
                res := and(old, mask)
                res := or(res, shl(lsl, new))
            }

            sstore(slot, updateData(sload(slot), data, m, leftShiftLength))
        }
    }

    function updateLeftPadded(Mask m, bytes32 slot, uint256 data) public {
        updateLeftPadded(m, slot, bytes32(data));
    }

    function updateLeftPadded(Mask m, bytes32 slot, uint256 data, uint256 leftShiftLength) public {
        updateLeftPadded(m, slot, bytes32(data), leftShiftLength);
    }

    function updateLeftPadded(Mask m, bytes32 slot, int256 data) public {
        bytes32 tmp;
        assembly {
            tmp := data
        }
        updateLeftPadded(m, slot, tmp);
    }

    function updateLeftPadded(Mask m, bytes32 slot, int256 data, uint256 leftShiftLength) public {
        bytes32 tmp;
        assembly {
            tmp := data
        }
        updateLeftPadded(m, slot, tmp, leftShiftLength);
    }

    function updateRightPadded(Mask m, bytes32 slot, bytes32 data, uint256 maskLength) public {
        assembly {
            function updateData(old, new, mask) -> res {
                res := and(old, mask)
                res := or(res, new)
            }

            sstore(slot, updateData(sload(slot), shr(sub(0x100, maskLength), data), m))
        }
    }

    function updateRightPadded(
        Mask m,
        bytes32 slot,
        bytes32 data,
        uint256 maskLength,
        uint256 leftShiftLength
    )
        public
    {
        assembly {
            function updateData(old, new, mask, lsl) -> res {
                res := and(old, mask)
                res := or(res, shl(lsl, new))
            }

            sstore(slot, updateData(sload(slot), shr(sub(0x100, maskLength), data), m, leftShiftLength))
        }
    }

    function getLength(bytes32 v) public pure returns (uint8 len) {
        assembly {
            len := 32
            for { } gt(len, 0) { } {
                if iszero(byte(sub(len, 1), v)) {
                    len := sub(len, 1)
                    continue
                }

                break
            }
        }
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
