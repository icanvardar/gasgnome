// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import { ArithmeticLib } from "../src/libraries/ArithmeticLib.sol";

import { SignedInt, SignedIntLib } from "../src/types/SignedInt.sol";
import { Test, console } from "forge-std/Test.sol";

contract SignedIntLibTest is Test {
    error Overflow();
    error Underflow();
    error DivisionByZero();
    error NegativeExponent();

    function test_ConvertWithSize() public pure {
        int256 s_int = -1024;
        bytes32 s_int_bytes = toBytes(s_int);

        SignedInt s = SignedInt.wrap(s_int_bytes);

        assertEq(int32(s.convertWithSize(16)), int32(s_int));
    }

    function test_SizeInBits() public pure {
        /// NOTE: The negative number -1024 is 0xfff..c00 in bytes form,
        /// and its size is 12 bits also its upper bound is 16 bits.
        int256 s_int = -1024;
        bytes32 s_int_bytes = toBytes(s_int);
        SignedInt s = SignedInt.wrap(s_int_bytes);

        assertEq(s.sizeInBits(), 12);
    }

    function test_AddUnsignedInt() public pure {
        int256 s_int_1 = -1024;
        bytes32 s_int_1_bytes = toBytes(s_int_1);
        int256 s_int_2 = -2048;
        bytes32 s_int_2_bytes = toBytes(s_int_2);
        bytes32 expected_in_bytes = toBytes(-3072);

        SignedInt expected = SignedInt.wrap(expected_in_bytes);
        SignedInt u_1 = SignedInt.wrap(s_int_1_bytes);
        SignedInt u_2 = SignedInt.wrap(s_int_2_bytes);
        SignedInt result = u_1 + u_2;

        assertEq(SignedInt.unwrap(expected), SignedInt.unwrap(result));
    }

    function test_SubUnsignedInt() public pure {
        int256 s_int_1 = -1024;
        bytes32 s_int_1_bytes = toBytes(s_int_1);
        int256 s_int_2 = -2048;
        bytes32 s_int_2_bytes = toBytes(s_int_2);
        bytes32 expected_in_bytes = toBytes(1024);

        SignedInt expected = SignedInt.wrap(expected_in_bytes);
        SignedInt u_1 = SignedInt.wrap(s_int_1_bytes);
        SignedInt u_2 = SignedInt.wrap(s_int_2_bytes);
        SignedInt result = u_1 - u_2;

        assertEq(SignedInt.unwrap(expected), SignedInt.unwrap(result));
    }

    function test_MulUnsignedInt() public pure {
        int256 s_int_1 = -2048;
        bytes32 s_int_1_bytes = toBytes(s_int_1);
        int256 s_int_2 = -2;
        bytes32 s_int_2_bytes = toBytes(s_int_2);
        bytes32 expected_in_bytes = toBytes(4096);

        SignedInt expected = SignedInt.wrap(expected_in_bytes);
        SignedInt u_1 = SignedInt.wrap(s_int_1_bytes);
        SignedInt u_2 = SignedInt.wrap(s_int_2_bytes);
        SignedInt result = u_1 * u_2;

        assertEq(SignedInt.unwrap(expected), SignedInt.unwrap(result));
    }

    function test_DivUnsignedInt() public pure {
        int256 s_int_1 = -2048;
        bytes32 s_int_1_bytes = toBytes(s_int_1);
        int256 s_int_2 = 2;
        bytes32 s_int_2_bytes = toBytes(s_int_2);
        bytes32 expected_in_bytes = toBytes(-1024);

        SignedInt expected = SignedInt.wrap(expected_in_bytes);
        SignedInt u_1 = SignedInt.wrap(s_int_1_bytes);
        SignedInt u_2 = SignedInt.wrap(s_int_2_bytes);
        SignedInt result = u_1 / u_2;

        assertEq(SignedInt.unwrap(expected), SignedInt.unwrap(result));
    }

    function test_ModUnsignedInt() public pure {
        int256 s_int_1 = -2048;
        bytes32 s_int_1_bytes = toBytes(s_int_1);
        int256 s_int_2 = 2;
        bytes32 s_int_2_bytes = toBytes(s_int_2);
        bytes32 expected_in_bytes = toBytes(-1024);

        SignedInt expected = SignedInt.wrap(expected_in_bytes);
        SignedInt u_1 = SignedInt.wrap(s_int_1_bytes);
        SignedInt u_2 = SignedInt.wrap(s_int_2_bytes);
        SignedInt result = u_1 / u_2;

        assertEq(SignedInt.unwrap(expected), SignedInt.unwrap(result));
    }

    function test_ExpUnsignedInt() public pure {
        int256 s_int_1 = -2;
        bytes32 s_int_1_bytes = toBytes(s_int_1);
        int256 s_int_2 = 8;
        bytes32 s_int_2_bytes = toBytes(s_int_2);
        bytes32 expected_in_bytes = toBytes(-256);

        SignedInt expected = SignedInt.wrap(expected_in_bytes);
        SignedInt u_1 = SignedInt.wrap(s_int_1_bytes);
        SignedInt u_2 = SignedInt.wrap(s_int_2_bytes);
        SignedInt result = u_1 ^ u_2;

        assertEq(SignedInt.unwrap(expected), SignedInt.unwrap(result));
    }

    function test_RevertWhen_DesiredBitsAreZero_ConvertWithSize() public {
        SignedInt s = SignedInt.wrap(0x0);

        vm.expectRevert();
        s.convertWithSize(0);
    }

    function test_RevertWhen_DesiredBitsAreBiggerThan256Bits_ConvertWithSize() public {
        SignedInt s = SignedInt.wrap(0x0);

        vm.expectRevert();
        s.convertWithSize(257);
    }

    function test_RevertWhen_DesiredBitsAreNotMultipleOfEight_ConvertWithSize() public {
        SignedInt s = SignedInt.wrap(0x0);

        vm.expectRevert();
        s.convertWithSize(33);
    }

    function test_RevertWhen_DesiredBitsAreLessThanDataBitSize_ConvertWithSize() public {
        int256 s_int = -1024;
        bytes32 s_int_bytes = toBytes(s_int);
        SignedInt s = SignedInt.wrap(s_int_bytes);

        vm.expectRevert();
        s.convertWithSize(8);
    }

    function test_RevertIf_RightValueIsZero_DivUnsignedInt() public {
        int256 s_int_1 = 1;
        int256 s_int_2 = 0;
        bytes32 s_int_1_bytes = toBytes(s_int_1);
        bytes32 s_int_2_bytes = toBytes(s_int_2);
        SignedInt s_1 = SignedInt.wrap(s_int_1_bytes);
        SignedInt s_2 = SignedInt.wrap(s_int_2_bytes);

        vm.expectRevert(DivisionByZero.selector);
        s_1 / s_2;
    }

    function test_RevertIf_RightValueIsZero_ModUnsignedInt() public {
        int256 s_int_1 = 1;
        int256 s_int_2 = 0;
        bytes32 s_int_1_bytes = toBytes(s_int_1);
        bytes32 s_int_2_bytes = toBytes(s_int_2);
        SignedInt s_1 = SignedInt.wrap(s_int_1_bytes);
        SignedInt s_2 = SignedInt.wrap(s_int_2_bytes);

        vm.expectRevert(DivisionByZero.selector);
        s_1 % s_2;
    }

    function test_RevertIf_RightValueIsNegative_ExpSignedInt() public {
        int256 s_int_1 = 8;
        int256 s_int_2 = -2;
        bytes32 s_int_1_bytes = toBytes(s_int_1);
        bytes32 s_int_2_bytes = toBytes(s_int_2);
        SignedInt s_1 = SignedInt.wrap(s_int_1_bytes);
        SignedInt s_2 = SignedInt.wrap(s_int_2_bytes);

        vm.expectRevert(NegativeExponent.selector);
        s_1 ^ s_2;
    }

    function toBytes(int256 integer) public pure returns (bytes32 result) {
        assembly {
            result := integer
        }
    }
}
