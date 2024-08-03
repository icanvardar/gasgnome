// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import { ArithmeticLib } from "../src/libraries/ArithmeticLib.sol";
import { Base_Test } from "./Base.t.sol";

import { SignedInt, SignedIntLib } from "../src/types/SignedInt.sol";
import { UnsignedInt, UnsignedIntLib } from "../src/types/UnsignedInt.sol";

contract ArithmeticLibTest is Base_Test {
    error CannotBeZero(uint256);
    error ExceedsTheBound(uint256);
    error MustBeAMultipleOfEight(uint256);
    error MismatchedSizes(uint256, uint256);

    function test_ConvertWithSize_Uint() public pure {
        uint256[3][3] memory cases = [
            [uint256(12), uint256(64), uint256(8)],
            [uint256(257), uint256(32), uint256(16)],
            [uint256(UINT256_MAX), uint256(256), uint256(256)]
        ];

        uint8 i;
        for (i; i < cases.length; i++) {
            uint256 v = cases[i][0];
            assertEq(ArithmeticLib.convertWithSize(bytes32(v), uint16(cases[i][1]), uint16(cases[i][2])), bytes32(v));
        }
    }

    function test_ConvertWithSize_Int() public pure {
        int256[4] memory values = [int256(-1), 256, 0, int256(-257)];

        uint256[2][4] memory cases = [
            [uint256(64), uint256(8)],
            [uint256(32), uint256(16)],
            [uint256(256), uint256(8)],
            [uint256(128), uint256(16)]
        ];

        uint8 i;
        for (i; i < cases.length; i++) {
            int256 v = values[i];
            bytes32 tmp;

            assembly {
                tmp := v
            }

            assertEq(ArithmeticLib.convertWithSize(tmp, uint16(cases[i][0]), uint16(cases[i][1])), tmp);
        }
    }

    function test_Cap() public pure {
        uint16[2][12] memory cases = [
            [uint16(256), uint16(256)],
            [uint16(242), uint16(248)],
            [uint16(186), uint16(192)],
            [uint16(146), uint16(152)],
            [uint16(140), uint16(144)],
            [uint16(102), uint16(104)],
            [uint16(92), uint16(96)],
            [uint16(64), uint16(64)],
            [uint16(48), uint16(48)],
            [uint16(28), uint16(32)],
            [uint16(16), uint16(16)],
            [uint16(4), uint16(8)]
        ];

        uint8 i;
        for (i; i < cases.length; i++) {
            assertEq(ArithmeticLib.cap(cases[i][0]), ArithmeticLib.cap(cases[i][1]));
        }
    }

    function test_RevertIf_DesiredBitsIsEqualToZero_ConvertWithSize() public {
        vm.expectRevert(abi.encodeWithSelector(CannotBeZero.selector, 0));
        ArithmeticLib.convertWithSize(bytes32(uint256(1)), 0, 8);
    }

    function test_RevertIf_DesiredBitsIsBiggerThan256Bits_ConvertWithSize() public {
        vm.expectRevert(abi.encodeWithSelector(ExceedsTheBound.selector, 257));
        ArithmeticLib.convertWithSize(bytes32(uint256(1)), 257, 8);
    }

    function test_RevertIf_DesiredBitsIsNotDivisibleToEight_ConvertWithSize() public {
        vm.expectRevert(abi.encodeWithSelector(MustBeAMultipleOfEight.selector, 107));
        ArithmeticLib.convertWithSize(bytes32(uint256(1)), 107, 8);
    }

    function test_RevertWhen_DesiredBitsIsBiggerThanSizeCap_ConvertWithSize() public {
        vm.expectRevert(abi.encodeWithSelector(MismatchedSizes.selector, 32, 64));
        ArithmeticLib.convertWithSize(bytes32(uint256(1)), 32, 64);
    }

    function test_RevertIf_BitSizeIsEqualToZero_Cap() public {
        vm.expectRevert(abi.encodeWithSelector(CannotBeZero.selector, 0));
        ArithmeticLib.cap(0);
    }

    function test_RevertIf_BitSizeIsBiggerThan256Bits_Cap() public {
        vm.expectRevert(abi.encodeWithSelector(ExceedsTheBound.selector, 257));
        ArithmeticLib.cap(257);
    }
}
