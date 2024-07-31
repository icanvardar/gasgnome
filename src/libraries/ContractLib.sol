// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

type Contract is address;

type FunctionSignature is bytes4;

type FunctionInput is bytes32;

using ContractLib for Contract global;

/// NOTE: call(`left gas`, `amount in wei`, `calldata input location`, `calldata size`, `location to save output`,
/// `output size`)

library ContractLib {
    /// @dev send ether to contract
    function call(Contract c, uint256 amount) public {
        assembly {
            let success := call(gas(), c, amount, 0x0, 0x0, 0x0, 0x0)

            /// NOTE: Add custom error here - call reverted
            if iszero(success) { revert(0x00, 0x00) }
        }
    }

    /// @dev send ether + call function
    function call(Contract c, uint256 amount, FunctionSignature sig) public {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, sig)

            let success := call(gas(), c, amount, ptr, 0x04, 0x00, 0x00)

            /// NOTE: Add custom error here - call reverted
            if iszero(success) { revert(0x00, 0x00) }
        }
    }

    /// @dev send ether + call function + with input
    function call(Contract c, uint256 amount, FunctionSignature sig, FunctionInput[] memory input) public {
        assembly {
            let inputLen := mload(input)
            let ptr := mload(0x40)
            mstore(ptr, sig)
            let nextPtr := add(ptr, 0x04)

            let i
            for { i := 0 } lt(i, inputLen) { i := add(i, 0x1) } {
                let multiplier := mul(i, 0x20)
                mstore(add(nextPtr, multiplier), mload(add(input, add(multiplier, 0x20))))
            }

            let success := call(gas(), c, amount, ptr, add(0x04, mul(inputLen, 0x20)), 0x00, 0x00)

            /// NOTE: Add custom error here - call reverted
            if iszero(success) { revert(0x00, 0x00) }
        }
    }

    /// @dev send ether + call function + get return value
    function call(
        Contract c,
        uint256 amount,
        FunctionSignature sig,
        uint8 outLen
    )
        internal
        returns (bytes32[] memory output)
    {
        output = new bytes32[](outLen);

        assembly {
            let ptr := mload(0x40)
            mstore(ptr, sig)

            let outPtr := add(output, 0x20)

            let success := call(gas(), c, amount, ptr, 0x04, outPtr, mul(outLen, 0x20))

            if iszero(success) { revert(0x00, 0x00) }
        }
    }

    /// @dev send ether + call function + get return value + with input
    function call(
        Contract c,
        uint256 amount,
        FunctionSignature sig,
        FunctionInput[] memory input,
        uint8 outLen
    )
        internal
        returns (bytes32[] memory output)
    {
        output = new bytes32[](outLen);

        assembly {
            let inputLen := mload(input)
            let ptr := mload(0x40)
            mstore(ptr, sig)
            let nextPtr := add(ptr, 0x04)

            let outPtr := add(output, 0x20)

            let i
            for { i := 0 } lt(i, inputLen) { i := add(i, 0x1) } {
                let multiplier := mul(i, 0x20)
                mstore(add(nextPtr, multiplier), mload(add(input, add(multiplier, 0x20))))
            }

            let success := call(gas(), c, amount, ptr, add(0x04, mul(inputLen, 0x20)), outPtr, mul(outLen, 0x20))

            if iszero(success) { revert(0x00, 0x00) }
        }
    }

    /// @dev call function
    function call(Contract c, FunctionSignature sig) internal {
        call(c, 0x0, sig);
    }

    /// @dev call function + with input
    function call(Contract c, FunctionSignature sig, FunctionInput[] memory input) internal {
        call(c, 0x0, sig, input);
    }

    /// @dev call function + get return value
    function call(Contract c, FunctionSignature sig, uint8 outLen) internal returns (bytes32[] memory output) {
        output = call(c, 0x0, sig, outLen);
    }

    /// @dev call function + get return value + with input
    function call(
        Contract c,
        FunctionSignature sig,
        FunctionInput[] memory input,
        uint8 outLen
    )
        internal
        returns (bytes32[] memory output)
    {
        output = call(c, 0x0, sig, input, outLen);
    }

    function balance(Contract c) public view returns (uint256 result) {
        assembly {
            result := balance(c)
        }
    }

    function toContract(address addr) public view returns (Contract c) {
        bool isCont = isContract(addr);

        assembly {
            switch isCont
            case 0x0 {
                /// NOTE: Add custom error here - address is not contract
                revert(0x00, 0x00)
            }
            default { c := addr }
        }
    }

    function isContract(address addr) internal view returns (bool result) {
        assembly {
            let size := extcodesize(addr)
            switch size
            case 0x0 { result := 0x0 }
            default { result := 0x1 }
        }

        result = true;
    }
}
