// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

/// @notice Libraries
import "./libraries/ArithmeticLib.sol";
import "./libraries/BitmaskLib.sol";
import "./libraries/ErrorLib.sol";
import "./libraries/EventLib.sol";
import "./libraries/MemoryLib.sol";
import "./libraries/StorageLib.sol";

/// @notice Types
import "./types/Pointer.sol";
import "./types/SignedInt.sol";
import "./types/Slot.sol";
import "./types/UnsignedInt.sol";

library Gasgnome {
    string internal constant AUTHOR = "https://github.com/icanvardar";
}
