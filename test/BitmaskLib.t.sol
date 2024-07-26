// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import { BitmaskLib, Mask } from "../src/libraries/BitmaskLib.sol";
import { Test, console } from "forge-std/Test.sol";

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
            Mask m = BitmaskLib.generate((i + 1) * 8);
            assertEq(bytes32(expecteds[i]), Mask.unwrap(m));
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
            Mask m = BitmaskLib.generate((i + 1) * 8, (i + 2) * 8);
            assertEq(bytes32(expecteds[i]), Mask.unwrap(m));
        }
    }

    function test_UpdateDataWith_ForUintN() public {
        uint256 bAndCSlot = referenceSlot + 1;
        uint256 expected_b = 22;
        uint256 expected_c = 33;

        Mask m_b = BitmaskLib.generate(128);
        Mask m_c = BitmaskLib.generate(128, 128);

        m_b.updateDataWith(bytes32(bAndCSlot), expected_b);
        m_c.updateDataWith(bytes32(bAndCSlot), expected_c, 128);

        assertEq(expected_b, b);
        assertEq(expected_c, c);

        uint256 dEFGSlot = referenceSlot + 2;
        uint256 expected_d = 44;
        uint256 expected_e = 55;
        uint256 expected_f = 66;
        uint256 expected_g = 77;

        Mask m_d = BitmaskLib.generate(32); // 32
        Mask m_e = BitmaskLib.generate(64, 32); // 32 + 64
        Mask m_f = BitmaskLib.generate(32, 96); // 32 + 64 + 32
        Mask m_g = BitmaskLib.generate(128, 128); // 32 + 64 + 32 + 128

        m_d.updateDataWith(bytes32(dEFGSlot), expected_d);
        m_e.updateDataWith(bytes32(dEFGSlot), expected_e, 32);
        m_f.updateDataWith(bytes32(dEFGSlot), expected_f, 96);
        m_g.updateDataWith(bytes32(dEFGSlot), expected_g, 128);
    }

    function test_UpdateDataWith_ForIntN() public {
        uint256 xAndYSlot = referenceSlot + 3;
        int256 expected_x = -11;
        int256 expected_y = -22;

        Mask m_x = BitmaskLib.generate(128);
        Mask m_y = BitmaskLib.generate(128, 128);

        m_x.updateDataWith(bytes32(xAndYSlot), expected_x);
        m_y.updateDataWith(bytes32(xAndYSlot), expected_y, 128);

        assertEq(x, expected_x);
        assertEq(y, expected_y);
    }
    function test_RevertWhen_MaskLengthIsBigger_Generate() public {
        vm.expectRevert(bytes4(keccak256("WrongParameters()")));
        BitmaskLib.generate(128, 257);
    }
}
