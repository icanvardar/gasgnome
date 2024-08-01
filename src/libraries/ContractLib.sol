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

            if iszero(success) {
                /// @dev bytes4(keccak256("UnableToCall()")) => 0x09108f6e
                mstore(0x80, 0x09108f6e)
                revert(0x9c, 0x04)
            }
        }
    }

    /// @dev send ether + call function + get return value (optional)
    function call(
        Contract c,
        uint256 amount,
        FunctionSignature sig,
        bool hasOutput
    )
        internal
        returns (bytes memory output)
    {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, sig)

            let outPtr := add(output, 0x20)

            let success := call(gas(), c, amount, ptr, 0x04, 0x00, 0x00)

            if iszero(success) {
                /// @dev bytes4(keccak256("UnableToCall()")) => 0x09108f6e
                mstore(0x80, 0x09108f6e)
                revert(0x9c, 0x04)
            }

            if eq(hasOutput, 0x1) {
                let size := returndatasize()
                mstore(ptr, size)
                returndatacopy(add(ptr, 0x20), 0x0, size)
                mstore(0x40, add(ptr, add(size, 0x20)))

                output := ptr
            }
        }
    }

    /// @dev send ether + call function + get return value (optional) + with input
    function call(
        Contract c,
        uint256 amount,
        FunctionSignature sig,
        FunctionInput[] memory input,
        bool hasOutput
    )
        internal
        returns (bytes memory output)
    {
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

            let success := call(gas(), c, amount, ptr, add(0x04, mul(inputLen, 0x20)), 0x00, 0x00)

            if iszero(success) {
                /// @dev bytes4(keccak256("UnableToCall()")) => 0x09108f6e
                mstore(0x80, 0x09108f6e)
                revert(0x9c, 0x04)
            }

            if eq(hasOutput, 0x1) {
                let size := returndatasize()
                mstore(ptr, size)
                returndatacopy(add(ptr, 0x20), 0x0, size)
                mstore(0x40, add(ptr, add(size, 0x20)))

                output := ptr
            }
        }
    }

    /// @dev call function + get return value (optional)
    function call(Contract c, FunctionSignature sig, bool hasOutput) internal returns (bytes memory output) {
        output = call(c, 0x0, sig, hasOutput);
    }

    /// @dev call function + get return value (optional) + with input
    function call(
        Contract c,
        FunctionSignature sig,
        FunctionInput[] memory input,
        bool hasOutput
    )
        internal
        returns (bytes memory output)
    {
        output = call(c, 0x0, sig, input, hasOutput);
    }

    /// staticcall function + get return value
    function staticcall(Contract c, FunctionSignature sig) internal view returns (bytes memory result) {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, sig)

            let success := staticcall(gas(), c, ptr, 0x04, 0x00, 0x00)

            if iszero(success) {
                /// @dev bytes4(keccak256("UnableToCall()")) => 0x09108f6e
                mstore(0x80, 0x09108f6e)
                revert(0x9c, 0x04)
            }

            let size := returndatasize()
            mstore(ptr, size)
            returndatacopy(add(ptr, 0x20), 0x0, size)
            mstore(0x40, add(ptr, add(size, 0x20)))

            result := ptr
        }
    }

    /// staticcall function + get return value + with input
    function staticcall(
        Contract c,
        FunctionSignature sig,
        FunctionInput[] memory input
    )
        internal
        view
        returns (bytes memory result)
    {
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

            let success := staticcall(gas(), c, ptr, add(0x04, mul(inputLen, 0x20)), 0x00, 0x00)

            if iszero(success) {
                /// @dev bytes4(keccak256("UnableToCall()")) => 0x09108f6e
                mstore(0x80, 0x09108f6e)
                revert(0x9c, 0x04)
            }

            let size := returndatasize()
            mstore(ptr, size)
            returndatacopy(add(ptr, 0x20), 0x0, size)
            mstore(0x40, add(ptr, add(size, 0x20)))

            result := ptr
        }
    }

    /// delegatecall function + get return value
    function delegatecall(
        Contract c,
        FunctionSignature sig,
        bool hasOutput
    )
        internal
        view
        returns (bytes memory result)
    {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, sig)

            let success := staticcall(gas(), c, ptr, 0x04, 0x00, 0x00)

            if iszero(success) {
                /// @dev bytes4(keccak256("UnableToCall()")) => 0x09108f6e
                mstore(0x80, 0x09108f6e)
                revert(0x9c, 0x04)
            }

            if eq(hasOutput, 0x1) {
                let size := returndatasize()
                mstore(ptr, size)
                returndatacopy(add(ptr, 0x20), 0x0, size)
                mstore(0x40, add(ptr, add(size, 0x20)))

                result := ptr
            }
        }
    }

    /// delegatecall function + get return value + with input
    function delegatecall(
        Contract c,
        FunctionSignature sig,
        FunctionInput[] memory input,
        bool hasOutput
    )
        internal
        view
        returns (bytes memory result)
    {
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

            let success := staticcall(gas(), c, ptr, add(0x04, mul(inputLen, 0x20)), 0x00, 0x00)

            if iszero(success) {
                /// @dev bytes4(keccak256("UnableToCall()")) => 0x09108f6e
                mstore(0x80, 0x09108f6e)
                revert(0x9c, 0x04)
            }

            if eq(hasOutput, 0x1) {
                let size := returndatasize()
                mstore(ptr, size)
                returndatacopy(add(ptr, 0x20), 0x0, size)
                mstore(0x40, add(ptr, add(size, 0x20)))

                result := ptr
            }
        }
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
                mstore(0x80, 0x6f7c43f1)
                revert(0x9c, 0x04)
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
    }
}
