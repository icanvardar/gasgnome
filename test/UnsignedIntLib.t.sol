// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import { ArithmeticLib } from "../src/libraries/ArithmeticLib.sol";

import { UnsignedInt, UnsignedIntLib } from "../src/types/UnsignedInt.sol";
import { Test, console } from "forge-std/Test.sol";

contract UnsignedIntLibTest is Test {
    error Overflow();
    error Underflow();
    error DivisionByZero();

    function test_ConvertWithSize() public pure {
        uint256 u_int = 1024;
        UnsignedInt u = UnsignedInt.wrap(bytes32(u_int));

        assertEq(uint32(u.convertWithSize(16)), uint32(u_int));
    }

    function test_SizeInBits() public pure {
        /// NOTE: The number 1024 is 0x400 in bytes form,
        /// and its size is 12 bits also its upper bound is 16 bits.
        uint256 u_int = 1024;
        UnsignedInt u = UnsignedInt.wrap(bytes32(u_int));

        assertEq(u.sizeInBits(), 12);
    }

    function test_AddUnsignedInt() public pure {
        uint256 u_int_1 = 1024;
        uint256 u_int_2 = 2048;
        UnsignedInt expected = UnsignedInt.wrap(bytes32(uint256(3072)));
        UnsignedInt u_1 = UnsignedInt.wrap(bytes32(u_int_1));
        UnsignedInt u_2 = UnsignedInt.wrap(bytes32(u_int_2));
        UnsignedInt result = u_1 + u_2;

        assertEq(UnsignedInt.unwrap(expected), UnsignedInt.unwrap(result));
    }

    function test_SubUnsignedInt() public pure {
        uint256 u_int_1 = 2048;
        uint256 u_int_2 = 1024;
        UnsignedInt expected = UnsignedInt.wrap(bytes32(uint256(1024)));
        UnsignedInt u_1 = UnsignedInt.wrap(bytes32(u_int_1));
        UnsignedInt u_2 = UnsignedInt.wrap(bytes32(u_int_2));
        UnsignedInt result = u_1 - u_2;

        assertEq(UnsignedInt.unwrap(expected), UnsignedInt.unwrap(result));
    }

    function test_MulUnsignedInt() public pure {
        uint256 u_int_1 = 2048;
        uint256 u_int_2 = 2;
        UnsignedInt expected = UnsignedInt.wrap(bytes32(uint256(4096)));
        UnsignedInt u_1 = UnsignedInt.wrap(bytes32(u_int_1));
        UnsignedInt u_2 = UnsignedInt.wrap(bytes32(u_int_2));
        UnsignedInt result = u_1 * u_2;

        assertEq(UnsignedInt.unwrap(expected), UnsignedInt.unwrap(result));
    }

    function test_DivUnsignedInt() public pure {
        uint256 u_int_1 = 2048;
        uint256 u_int_2 = 1024;
        UnsignedInt expected = UnsignedInt.wrap(bytes32(uint256(2)));
        UnsignedInt u_1 = UnsignedInt.wrap(bytes32(u_int_1));
        UnsignedInt u_2 = UnsignedInt.wrap(bytes32(u_int_2));
        UnsignedInt result = u_1 / u_2;

        assertEq(UnsignedInt.unwrap(expected), UnsignedInt.unwrap(result));
    }

    function test_ModUnsignedInt() public pure {
        uint256 u_int_1 = 2048;
        uint256 u_int_2 = 8;
        UnsignedInt expected = UnsignedInt.wrap(0x00);
        UnsignedInt u_1 = UnsignedInt.wrap(bytes32(u_int_1));
        UnsignedInt u_2 = UnsignedInt.wrap(bytes32(u_int_2));
        UnsignedInt result = u_1 % u_2;

        assertEq(UnsignedInt.unwrap(expected), UnsignedInt.unwrap(result));
    }

    function test_ExpUnsignedInt() public pure {
        uint256 u_int_1 = 4;
        uint256 u_int_2 = 2;
        UnsignedInt expected = UnsignedInt.wrap(bytes32(uint256(16)));
        UnsignedInt u_1 = UnsignedInt.wrap(bytes32(u_int_1));
        UnsignedInt u_2 = UnsignedInt.wrap(bytes32(u_int_2));
        UnsignedInt result = u_1 ^ u_2;

        assertEq(UnsignedInt.unwrap(expected), UnsignedInt.unwrap(result));
    }

    function test_RevertWhen_DesiredBitsAreZero_ConvertWithSize() public {
        UnsignedInt u = UnsignedInt.wrap(0x0);

        vm.expectRevert();
        u.convertWithSize(0);
    }

    function test_RevertWhen_DesiredBitsAreBiggerThan256Bits_ConvertWithSize() public {
        UnsignedInt u = UnsignedInt.wrap(0x0);

        vm.expectRevert();
        u.convertWithSize(257);
    }

    function test_RevertWhen_DesiredBitsAreNotMultipleOfEight_ConvertWithSize() public {
        UnsignedInt u = UnsignedInt.wrap(0x0);

        vm.expectRevert();
        u.convertWithSize(33);
    }

    function test_RevertWhen_DesiredBitsAreLessThanDataBitSize_ConvertWithSize() public {
        uint256 u_int = 1024;
        UnsignedInt u = UnsignedInt.wrap(bytes32(u_int));

        vm.expectRevert();
        u.convertWithSize(8);
    }

    function test_RevertWhen_ResultOverflows_AddUnsignedInt() public {
        uint256 u_int_1 = UINT256_MAX;
        uint256 u_int_2 = 1;
        UnsignedInt u_1 = UnsignedInt.wrap(bytes32(u_int_1));
        UnsignedInt u_2 = UnsignedInt.wrap(bytes32(u_int_2));

        vm.expectRevert(Overflow.selector);
        u_1 + u_2;
    }

    function test_RevertWhen_ResultUnderflows_SubUnsignedInt() public {
        uint256 u_int_1 = 1;
        uint256 u_int_2 = 2;
        UnsignedInt u_1 = UnsignedInt.wrap(bytes32(u_int_1));
        UnsignedInt u_2 = UnsignedInt.wrap(bytes32(u_int_2));

        vm.expectRevert(Underflow.selector);
        u_1 - u_2;
    }

    function test_RevertIf_RightValueIsZero_DivUnsignedInt() public {
        uint256 u_int_1 = 1;
        uint256 u_int_2 = 0;
        UnsignedInt u_1 = UnsignedInt.wrap(bytes32(u_int_1));
        UnsignedInt u_2 = UnsignedInt.wrap(bytes32(u_int_2));

        vm.expectRevert(DivisionByZero.selector);
        u_1 / u_2;
    }

    function test_RevertIf_RightValueIsZero_ModUnsignedInt() public {
        uint256 u_int_1 = 1;
        uint256 u_int_2 = 0;
        UnsignedInt u_1 = UnsignedInt.wrap(bytes32(u_int_1));
        UnsignedInt u_2 = UnsignedInt.wrap(bytes32(u_int_2));

        vm.expectRevert(DivisionByZero.selector);
        u_1 % u_2;
    }
}
