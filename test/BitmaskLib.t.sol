// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import {BitmaskLib, Mask} from "../src/libraries/BitmaskLib.sol";
import {Test, console} from "forge-std/Test.sol";

contract BitmaskLibTest is Test {
    /// @dev Mock storage variables to test bitmasking utility
    uint256 internal a = 1;
    uint128 internal b = 2;
    uint128 internal c = 3;
    uint32 internal d = 4;
    uint64 internal e = 5;
    uint32 internal f = 6;
    uint128 internal g = 7;

    int128 internal x = -1;
    int128 internal y = -2;

    bytes16 internal j = "a";
    bytes8 internal k = "b";
    bytes8 internal l = "c";

    uint256 internal referenceSlot;

    function setUp() public {
        assembly {
            sstore(referenceSlot.slot, a.slot)
        }
    }

    function test_Generate() public pure {
        uint256[4] memory expecteds = [
            0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00, // 8 bits
            0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000, // 16 bits
            0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000, // 24 bits
            0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000000 // 32 bits
        ];

        uint8 i = 0;
        for (i; i < expecteds.length; i++) {
            bytes32 mask = BitmaskLib.build((i + 1) * 8).value;
            assertEq(bytes32(expecteds[i]), mask);
        }
    }

    function test_Generate_LeftShiftLength() public pure {
        uint256[3] memory expecteds = [
            0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ffff, // 8 bits, 16 bits
            0xffffffffffffffffffffffffffffffffffffffffffffffffffffff0000ffffff, // 16 bits, 24 bits
            0xffffffffffffffffffffffffffffffffffffffffffffffffff000000ffffffff // 24 bits, 32 bits
        ];

        uint8 i = 0;
        for (i; i < expecteds.length; i++) {
            bytes32 mask = BitmaskLib.build((i + 1) * 8, (i + 2) * 8).value;
            assertEq(bytes32(expecteds[i]), mask);
        }
    }

    function test_UpdateLeftPadded_ForUintN() public {
        uint256 bAndCSlot = referenceSlot + 1;
        uint256 expected_b = 22;
        uint256 expected_c = 33;

        Mask memory m_b = BitmaskLib.build(128);
        Mask memory m_c = BitmaskLib.build(128, 128);

        m_b.updateLeftPadded(bytes32(bAndCSlot), expected_b);
        m_c.updateLeftPadded(bytes32(bAndCSlot), expected_c);

        assertEq(expected_b, b);
        assertEq(expected_c, c);

        uint256 dEFGSlot = referenceSlot + 2;
        uint256 expected_d = 44;
        uint256 expected_e = 55;
        uint256 expected_f = 66;
        uint256 expected_g = 77;

        Mask memory m_d = BitmaskLib.build(32); // 32
        Mask memory m_e = BitmaskLib.build(64, 32); // 32 + 64
        Mask memory m_f = BitmaskLib.build(32, 96); // 32 + 64 + 32
        Mask memory m_g = BitmaskLib.build(128, 128); // 32 + 64 + 32 + 128

        m_d.updateLeftPadded(bytes32(dEFGSlot), expected_d);
        m_e.updateLeftPadded(bytes32(dEFGSlot), expected_e);
        m_f.updateLeftPadded(bytes32(dEFGSlot), expected_f);
        m_g.updateLeftPadded(bytes32(dEFGSlot), expected_g);
    }

    function test_UpdateLeftPadded_ForIntN() public {
        uint256 xAndYSlot = referenceSlot + 3;
        int256 expected_x = -11;
        int256 expected_y = -22;

        Mask memory m_x = BitmaskLib.build(128);
        Mask memory m_y = BitmaskLib.build(128, 128);

        m_x.updateLeftPadded(bytes32(xAndYSlot), expected_x);
        m_y.updateLeftPadded(bytes32(xAndYSlot), expected_y);

        assertEq(x, expected_x);
        assertEq(y, expected_y);
    }

    function test_UpdateLeftPadded_ForBytesN() public {
        uint256 jKAndLSlot = referenceSlot + 4;
        bytes16 expected_j = "b";
        bytes8 expected_k = "c";
        bytes8 expected_l = "d";

        Mask memory m_j = BitmaskLib.build(128);
        Mask memory m_k = BitmaskLib.build(64, 128);
        Mask memory m_l = BitmaskLib.build(64, 192);

        m_j.updateRightPadded(bytes32(jKAndLSlot), expected_j);
        m_k.updateRightPadded(bytes32(jKAndLSlot), expected_k);
        m_l.updateRightPadded(bytes32(jKAndLSlot), expected_l);
    }
}
