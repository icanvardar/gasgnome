// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

abstract contract Variables {
    struct Slots {
        bytes32 longString;
        bytes32 shortString;
        bytes32 boolean;
        bytes32 bytes32Example;
        bytes32 int256Example;
        bytes32 uint256Example;
        bytes32 addr;
    }

    string public longString = "abcabcabcabcabcabcabcabcabcabcabc";
    string public shortString = "abc";
    bool public boolean = true;
    bytes32 public bytes32Example = "abc";
    int256 public int256Example = -1;
    uint256 public uint256Example = 1;
    address public addr = address(1);

    function getSlots() public pure returns (Slots memory ms) {
        assembly {
            mstore(ms, longString.slot)
            mstore(add(ms, 0x20), shortString.slot)
            mstore(add(ms, 0x40), boolean.slot)
            mstore(add(ms, 0x60), bytes32Example.slot)
            mstore(add(ms, 0x80), int256Example.slot)
            mstore(add(ms, 0xa0), uint256Example.slot)
            mstore(add(ms, 0xc0), addr.slot)
        }
    }
}
