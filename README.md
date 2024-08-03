<div align="center">
  <img src="logo.svg" alt="gasgnome" height="196" />
  <h1>Gasgnome</h1>
  <a href="https://soldeer.xyz">
    <img src="https://img.shields.io/badge/soldeer-v0.0.1-blue">
  </a>
  <a href="https://github.com/icanvardar/gasgnome/actions/workflows/ci.yml">
    <img src="https://img.shields.io/github/actions/workflow/status/icanvardar/gasgnome/ci.yml?branch=main&label=build">
  </a>
  <a href="https://github.com/icanvardar/gasgnome/actions/workflows/ci-all-via-ir.yml">
    <img src="https://img.shields.io/badge/solidity-0.8.26-green">
  </a>
  <br>
</div>

## Overview

Gasgnome is a collection of Solidity libraries in inline assembly. The libraries provided aim to enhance functionality and efficiency in areas such as arithmetic operations, bitmask handling, contract interactions, error handling, event logging, and memory management.

## Libraries

### ArithmeticLib

`ArithmeticLib` provides functions for manipulating and converting data with specific bit sizes. It includes:

- **`convertWithSize(bytes32 b, uint16 desiredBits, uint16 sizeInBits)`**: Converts a `bytes32` value to a desired bit size, with error handling for invalid sizes.
- **`cap(uint16 bitSize)`**: Computes the nearest bit cap in multiples of eight.

#### Example Usage

```solidity
import { ArithmeticLib } from "gasgnome";

contract Example {
    using ArithmeticLib for *;

    function exampleFunction(bytes32 value, uint16 desiredBits) public pure returns (bytes32) {
        return ArithmeticLib.convertWithSize(value, desiredBits, 256);
    }
}
```

### BitmaskLib

`BitmaskLib` provides functionality for working with bitmasks, including building masks and updating data with padding. It includes:

- **`build(uint8 bits)`**: Creates a mask with a specified number of bits.
- **`build(uint8 bits, uint8 leftShiftedBits)`**: Creates a mask with a specified number of bits and left-shifted bits.
- **`updateLeftPadded(Mask memory m, bytes32 slot, bytes32 data)`**: Updates data in storage with left padding.
- **`updateRightPadded(Mask memory m, bytes32 slot, bytes32 data)`**: Updates data in storage with right padding.

#### Example Usage

```solidity
import { BitmaskLib, Mask } from "gasgnome";

contract Example {
    function exampleFunction(Mask memory mask, bytes32 slot, bytes32 data) public {
        mask.updateLeftPadded(slot, data);
    }
}
```

### ContractLib

`ContractLib` provides utilities for interacting with other contracts, including sending ether, calling functions, and handling return values. It includes:

- **`call(Contract c, uint256 amount)`**: Sends ether to a contract.
- **`call(Contract c, uint256 amount, FunctionSignature sig, bool hasOutput)`**: Sends ether, calls a function, and optionally gets return value.
- **`staticcall(Contract c, FunctionSignature sig)`**: Performs a static call to a contract.
- **`delegatecall(Contract c, FunctionSignature sig, bool hasOutput)`**: Performs a delegate call to a contract.
- **`balance(Contract c)`**: Gets the balance of a contract.

#### Example Usage

```solidity
import { Contract, ContractLib } from "gasgnome";

contract Example {
    function exampleFunction(Contract c) public {
        c.call(1 ether);
    }
}
```

### ErrorLib

`ErrorLib` provides functions for handling and reverting with errors. It includes:

- **`toErrorArgs(bytes32[] memory args)`**: Converts an array of error arguments to `ErrorArg[]`.
- **`toErrorSelector(bytes memory ctx)`**: Converts a context to an `ErrorSelector`.
- **`revertError()`**: Reverts with no error data.
- **`revertError(ErrorSelector es)`**: Reverts with an error selector.
- **`revertError(ErrorSelector es, ErrorArg[] memory eas)`**: Reverts with an error selector and arguments.

#### Example Usage

```solidity
import { ErrorLib, ErrorSelector } from "gasgnome";

contract Example {
    function exampleFunction() public pure {
        ErrorSelector(0x12345678).revertError();
    }
}
```

### EventLib

`EventLib` provides functionality for emitting events with various configurations. It includes:

- **`emitEvent(EventHash eventHash)`**: Emits a non-anonymous event with no data.
- **`emitEvent(EventHash eventHash, EventArgNonIndexed[] memory nonIndexedArgs)`**: Emits a non-anonymous event with non-indexed arguments.
- **`emitEvent(EventHash eventHash, EventArgIndexed[1] memory indexedArgs)`**: Emits a non-anonymous event with one indexed argument.
- **`emitEvent(EventHash eventHash, EventArgIndexed[1] memory indexedArgs, EventArgNonIndexed[] memory nonIndexedArgs)`**: Emits a non-anonymous event with one indexed and non-indexed arguments.

#### Example Usage

```solidity
import { EventLib } from "gasgnome";

contract Example {
    event ExampleEvent(address indexed sender, uint256 value);

    function exampleFunction() public {
        EventLib.emitEvent(keccak256("ExampleEvent(address,uint256)"), [bytes32(uint256(uint160(msg.sender)))], [bytes32(uint256(42))]);
    }
}
```

### MemoryLib

`MemoryLib` provides functions for managing and manipulating memory. It includes:

- **`freeMemory()`**: Returns the current free memory pointer.
- **`nextFreeMemory()`**: Returns the next free memory pointer.
- **`store(bytes32 data)`**: Stores `data` in memory and returns the next free memory pointer.
- **`store(bytes32 data, bool isImmutable)`**: Stores `data` in memory with optional immutability and returns the next free memory pointer.
- **`update(bytes32 ptr, bytes32 data)`**: Updates the data at the specified memory pointer.
- **`memoryStorageLocation(bytes32 ptr)`**: Computes the storage location of a given memory pointer.

#### Example Usage

```solidity
import { MemoryLib } from "gasgnome";

contract Example {
    function exampleFunction(bytes32 data) public pure returns (bytes32) {
        bytes32 ptr = MemoryLib.store(data);
        MemoryLib.update(ptr, data);
        return MemoryLib.nextFreeMemory();
    }
}
```

### PointerLib

`PointerLib` provides utilities for managing memory pointers. It includes:

- **`load(Pointer ptr)`**: Loads data from a memory pointer.
- **`next(Pointer ptr)`**: Returns the next memory pointer.
- **`store(Pointer ptr, bytes32 data)`**: Stores data at a memory pointer and returns the next pointer.
- **`store(Pointer ptr, bytes32 data, bool isImmutable)`**: Stores data at a memory pointer with immutability flag and returns the next pointer.
- **`update(Pointer ptr, bytes32 data)`**: Updates data at a memory pointer.
- **`memoryStorageLocation(Pointer ptr)`**: Retrieves the memory storage location for a pointer.

#### Example Usage

```solidity
import { Pointer, PointerLib } from "gasgnome";

contract Example {
    function exampleFunction(Pointer ptr, bytes32 data) public pure {
        ptr.store(data);
    }
}
```

### StorageLib

`StorageLib` provides functions for accessing storage slots in different formats. It includes:

- **`getSlot(address slot)`**: Gets a storage slot from an `address`.
- **`getSlot(int256 slot)`**: Gets a storage slot from an `int256`.
- **`getSlot(uint256 slot)`**: Gets a storage slot from a `uint256`.
- **`getSlot(bytes32 slot)`**: Gets a storage slot from a `bytes32`.
- **`getSlot(bytes storage ptr)`**: Gets a storage slot from a `bytes` storage pointer.
- **`getSlot(string storage ptr)`**: Gets a storage slot from a `string` storage pointer.

#### Example Usage

```solidity
import { Slot, StorageLib } from "gasgnome";

contract Example {
    function exampleFunction(address slot) public pure returns (Slot storage s) {
        return StorageLib.getSlot(slot);
    }
}
```

### SignedIntLib

`SignedIntLib` provides arithmetic functions for signed integers and includes:

- **`addSignedInt(SignedInt left, SignedInt right)`**: Adds two signed integers.
- **`subSignedInt(SignedInt left, SignedInt right)`**: Subtracts one signed integer from another.
- **`mulSignedInt(SignedInt left, SignedInt right)`**: Multiplies two signed integers.
- **`divSignedInt(SignedInt left, SignedInt right)`**: Divides one signed integer by another.
- **`modSignedInt(SignedInt left, SignedInt right)`**: Computes the modulus of two signed integers.
- **`expSignedInt(SignedInt left, SignedInt right)`**: Computes the exponentiation of two signed integers.
- **`convertWithSize(SignedInt u, uint16 desiredBits)`**: Converts a signed integer to a desired bit size.
- **`sizeInBits(SignedInt s)`**: Computes the bit size of a signed integer.

#### Example Usage

```solidity
import { SignedInt, SignedIntLib } from "gasgnome";

contract Example {
    function exampleFunction(SignedInt a, SignedInt b) public pure returns (SignedInt) {
        return a + b;
    }
}
```

### SlotLib

`SlotLib` provides utilities for interacting with storage slots. It includes:

- **`asAddress(Slot storage s)`**: Retrieves an address from a storage slot.
- **`asBoolean(Slot storage s)`**: Retrieves a boolean from a storage slot.
- **`asBytes32(Slot storage s)`**: Retrieves a `bytes32` value from a storage slot.
- **`asInt256(Slot storage s)`**: Retrieves an `int256` value from a storage slot.
- **`asUint256(Slot storage s)`**: Retrieves a `uint256` value from a storage slot.
- **`asBytes(Slot storage s)`**: Retrieves a `bytes` value from a storage slot.
- **`asString(Slot storage s)`**: Retrieves a `string` from a storage slot.
- **`AddressSlot`, `BooleanSlot`, `Bytes32Slot`, `Int256Slot`, and `Uint256Slot`**: Types for handling different slot types with transient storage operations.

#### Example Usage

```solidity
import { Slot } from "gasgnome";

contract Example {
    Slot private mySlot;

    function exampleFunction() public view returns (address) {
        return mySlot.asAddress();
    }
}
```

### UnsignedIntLib

`UnsignedIntLib` provides arithmetic functions for unsigned integers and includes:

- **`addUnsignedInt(UnsignedInt left, UnsignedInt right)`**: Adds two unsigned integers.
- **`subUnsignedInt(UnsignedInt left, UnsignedInt right)`**: Subtracts one unsigned integer from another.
- **`mulUnsignedInt(UnsignedInt left, UnsignedInt right)`**: Multiplies two unsigned integers.
- **`divUnsignedInt(UnsignedInt left, UnsignedInt right)`**: Divides one unsigned integer by another.
- **`modUnsignedInt(UnsignedInt left, UnsignedInt right)`**: Computes the modulus of two unsigned integers.
- **`expUnsignedInt(UnsignedInt left, UnsignedInt right)`**: Computes the exponentiation of two unsigned integers.
- **`convertWithSize(UnsignedInt u, uint16 desiredBits)`**: Converts an unsigned integer to a desired bit size.
- **`sizeInBits(UnsignedInt u

)`**: Computes the bit size of an unsigned integer.

#### Example Usage

```solidity
import { UnsignedInt } from "gasgnome";

contract Example {
    function exampleFunction(UnsignedInt a, UnsignedInt b) public pure returns (UnsignedInt) {
        return a + b;
    }
}
```

## Installation

To use these libraries in your project, import the required library file into your Solidity contract.

## Contributing

Feel free to contribute to the Gasgnome project by submitting issues or pull requests on GitHub. Your contributions and feedback are greatly appreciated.

## License

This project is licensed under the [MIT](LICENSE) license.
