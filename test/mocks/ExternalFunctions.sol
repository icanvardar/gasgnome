// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

contract ExternalFunctions {
    uint256 public x;
    uint256 public y;
    bytes32 public z;

    function a() external payable {
        x = x + 1;
    }

    function b(uint256 incCount) external payable {
        y += incCount;
    }

    function c() external payable returns (uint256 result_1, bytes32 result_2) {
        result_1 = 1024;
        result_2 = "i know";
    }

    function d(uint256 incCount, bytes32 text) external payable returns (uint256 result_1, bytes32 result_2) {
        result_1 = incCount;
        result_2 = text;
    }

    function i() external {
        z = "hey, there";
    }

    function j(uint256 num) external {
        x = num;
    }

    function k() external pure returns (bytes32 result) {
        result = "oui";
    }

    function l(uint256 num, bytes32 text) external returns (bool result, bytes32 ctx) {
        x = num;
        z = text;

        result = true;
        ctx = "this is result";
    }

    function o(bool change) external pure returns (string memory result_1, uint256[] memory result_2) {
        if (change == true) {
            uint256[] memory tmp = new uint256[](3);
            tmp[0] = 1;
            tmp[1] = 2;
            tmp[2] = 3;
            result_2 = tmp;
        } else {
            uint256[] memory tmp = new uint256[](3);
            tmp[0] = 11;
            tmp[1] = 22;
            tmp[2] = 33;
            result_2 = tmp;
        }
        result_1 = "hello there";
    }

    receive() external payable { }

    fallback() external payable { }
}
