// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

struct Slot {
    bytes32 value;
}

using SlotLib for Slot global;

library SlotLib {
    function asAddress(Slot storage s) internal view returns (address result) {
        assembly {
            result := sload(s.slot)
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
            let length := div(rawLength, 2)

            if lt(length, 32) {
                result := mload(0x40)
                mstore(result, length)
                mstore(add(result, 0x20), value)
                mstore(0x40, add(result, and(add(add(0x20, length), 31), not(31))))
            }

            if iszero(lt(length, 32)) {
                // @dev This calculation is not needed because solidity rounds decimals.
                // So that, length variable's first assigned value is OK!
                // length := div(sub(rawLength, 1), 2)
                result := mload(0x40)
                mstore(result, length)

                for { let i := 0 } lt(i, length) { i := add(i, 0x20) } {
                    mstore(add(result, add(0x20, i)), sload(add(keccak256(slot, 0x20), div(i, 32))))
                }

                mstore(0x40, add(add(result, 0x20), length))
            }
        }
    }

    function asString(Slot storage s) internal view returns (string memory result) {
        result = string(asBytes(s));
    }
}
