// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

struct Slot {
    bytes32 value;
}

using SlotLib for Slot global;

library SlotLib {
    function asAddress(Slot storage s) internal view returns (address result) {
        assembly {
            let data := sload(s.slot)
            let bytesToBeRemoved := sub(0x20, add(s.offset, 0x14))
            let extractedRes := shl(mul(bytesToBeRemoved, 0x08), data)
            result := shr(mul(0x0c, 0x08), extractedRes)
        }
    }

    function asBoolean(Slot storage s) internal view returns (bool result) {
        assembly {
            result := sload(s.slot)
        }
    }

    function asBytes32(Slot storage s) internal view returns (bytes32 result) {
        assembly {
            result := sload(s.slot)
        }
    }

    function asInt256(Slot storage s) internal view returns (int256 result) {
        assembly {
            let data := sload(s.slot)
            let bytesToBeRemoved := sub(0x20, add(s.offset, 0x01))
            let extractedRes := shl(mul(bytesToBeRemoved, 0x08), data)
            result := sar(mul(0x1f, 0x08), extractedRes)
        }
    }

    function asUint256(Slot storage s) internal view returns (uint256 result) {
        assembly {
            let data := sload(s.slot)
            let bytesToBeRemoved := sub(0x20, add(s.offset, 0x01))
            let extractedRes := shl(mul(bytesToBeRemoved, 0x08), data)
            result := shr(mul(0x1f, 0x08), extractedRes)
        }
    }

    function asBytes(Slot storage s) internal view returns (bytes memory result) {
        assembly {
            let slot := s.slot
            let value := sload(slot)
            let rawLength := and(value, 0xffff)
            let length := div(rawLength, 0x02)

            if lt(length, 0x20) {
                result := mload(0x40)
                mstore(result, length)
                mstore(add(result, 0x20), value)
                mstore(0x40, add(result, and(add(add(0x20, length), 0x1f), not(0x1f))))
            }

            if iszero(lt(length, 0x20)) {
                // @dev This calculation is not needed because solidity rounds decimals.
                // So that, length variable's first assigned value is OK!
                // length := div(sub(rawLength, 1), 2)
                result := mload(0x40)
                mstore(result, length)

                for { let i := 0x00 } lt(i, length) { i := add(i, 0x20) } {
                    mstore(add(result, add(0x20, i)), sload(add(keccak256(slot, 0x20), div(i, 0x20))))
                }

                mstore(0x40, add(add(result, 0x20), length))
            }
        }
    }

    function asString(Slot storage s) internal view returns (string memory result) {
        result = string(asBytes(s));
    }

    /// NOTE: starting transient storage operations
    type AddressSlot is bytes32;

    function asAddressSlot(bytes32 slot) internal pure returns (AddressSlot result) {
        assembly {
            result := slot
        }
    }

    function tstore(AddressSlot s, address val) internal {
        assembly {
            tstore(s, val)
        }
    }

    function tload(AddressSlot s) internal view returns (address result) {
        assembly {
            result := tload(s)
        }
    }

    type BooleanSlot is bytes32;

    function asBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot result) {
        assembly {
            result := slot
        }
    }

    function tstore(BooleanSlot s, bool val) internal {
        assembly {
            tstore(s, val)
        }
    }

    function tload(BooleanSlot s) internal view returns (bool result) {
        assembly {
            result := tload(s)
        }
    }

    type Bytes32Slot is bytes32;

    function asBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot result) {
        assembly {
            result := slot
        }
    }

    function tstore(Bytes32Slot s, bytes32 val) internal {
        assembly {
            tstore(s, val)
        }
    }

    function tload(Bytes32Slot s) internal view returns (bytes32 result) {
        assembly {
            result := tload(s)
        }
    }

    type Int256Slot is bytes32;

    function asInt256Slot(bytes32 slot) internal pure returns (Int256Slot result) {
        assembly {
            result := slot
        }
    }

    function tstore(Int256Slot s, int256 val) internal {
        assembly {
            tstore(s, val)
        }
    }

    function tload(Int256Slot s) internal view returns (int256 result) {
        assembly {
            result := tload(s)
        }
    }

    type Uint256Slot is bytes32;

    function asUint256Slot(bytes32 slot) internal pure returns (Uint256Slot result) {
        assembly {
            result := slot
        }
    }

    function tstore(Uint256Slot s, uint256 val) internal {
        assembly {
            tstore(s, val)
        }
    }

    function tload(Uint256Slot s) internal view returns (uint256 result) {
        assembly {
            result := tload(s)
        }
    }
}
