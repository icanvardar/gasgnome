// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import { BitmaskLib } from "../src/libraries/BitmaskLib.sol";
import { Mask } from "../src/types/Mask.sol";
import { Test, console } from "forge-std/Test.sol";

contract BitmaskLibTest is Test {
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

    function test_RevertWhen_MaskLengthIsBigger_Generate() public {
        vm.expectRevert(bytes4(keccak256("WrongParameters()")));
        BitmaskLib.generate(128, 64);
    }
}
