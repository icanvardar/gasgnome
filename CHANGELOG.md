# Changelog

All notable changes to this project will be documented in this file.

## [unreleased]

### 🚀 Features

- *(ContractLib)* Implement staticcall
- *(ContractLib)* Implement delegatecall
- *(Slot)* Add transient storage operations

### 🐛 Bug Fixes

- *(ContractLibLogic)* Update wrong slots
- *(ContractLib)* Update staticcall to delegatecall
- *(Slot)* Update wrong parameter type
- Update Deploy.s.sol

### 🚜 Refactor

- *(ContractLib)* Merge call functions
- Add mock contract
- *(ContractLib.t.sol)* Implement mock contract
- Add Base.t.sol contact to test files
- Update types
- Update library files

### 📚 Documentation

- Add API references

### 🎨 Styling

- Update Deploy.s.sol

### 🧪 Testing

- *(ContractLib)* Add staticcall test cases
- *(ContractLib)* Test new call functions
- *(ContractLib)* Add mock proxy and logic
- *(ContractLib)* Add delegatecall test cases
- *(ContractLib)* Add revert cases of delegatecall
- Create Variables.sol mock contract
- *(SlotLib)* Import Variables mock contract
- *(SlotLib)* Add transient storage test cases
- *(Base)* Add base contract for test suites

### ⚙️ Miscellaneous Tasks

- Update CHANGELOG.md
- *(ContractLibProxy)* Add logic slots
- *(ContractLibProxy)* Add delegatecall with wrong function signature
- Update CHANGELOG.md
- Update foundry.toml
- Update CHANGELOG.md
- Update README.md
- Update Gasgnome.sol
- Update foundry.toml
- Add soldeer package url
- Update CHANGELOG.md
- Update remappings.txt

## [0.2.0] - 2024-08-01

### 🚀 Features

- *(MemoryLib)* Add functions
- *(Pointer)* Add custom type and its functions
- *(ErrorLib)* Add library functions
- *(EventLib)* Add untested library functions
- *(EventLib)* Duplicate functions by their parameters
- *(EventLib)* Add anonymous event emitters
- *(ContractLib)* Add library functions
- *(ContractLib)* Add missing function bodies

### 🐛 Bug Fixes

- *(MemoryLib)* Update `memoryStorageLocation`
- *(MemoryLib)* Fix `update` function bug
- *(PointerLib)* Fix `update` function bug
- *(EventLib)* Update anonymous emitters
- *(ContractLib)* Remove redundant overwrite

### 🚜 Refactor

- *(MemoryLib)* Update function visibility
- *(Pointer)* Update function visibility
- *(MemoryLib)* Add custom error
- Update maximum memory location
- *(EventLib)* Remove `getDataLocations` function
- *(ContractLib)* Update function parameters
- *(ContractLib)* Update signature parameter name
- *(ContractLib)* Partially broken code
- *(ContractLib)* Add custom errors
- *(ContractLib)* Add custom error

### 🎨 Styling

- *(MemoryLib.t.sol)* Remove redundant lines
- *(EventLib)* Update comment

### 🧪 Testing

- *(MemoryLib)* Add test suite
- *(PointerLib)* Add test suite
- *(MemoryLib)* Update test cases
- *(MemoryLib)* Update test cases
- *(PointerLib)* Add test cases
- *(ErrorLib)* Update test cases
- *(EventLib)* Add test cases
- *(EventLib)* Update test cases
- *(ContractLib)* Add test cases
- *(ContractLib)* Update test storage values
- *(ContactLib)* Finish positive cases
- *(ContractLib)* Update test cases
- *(ContractLib)* Update test cases

### ⚙️ Miscellaneous Tasks

- Update Gasgnome.sol
- Update CHANGELOG.md
- Update foundry.toml
- Update ci.yml
- Update Gasgnome.sol
- Update Gasgnome.sol
- Update CHANGELOG.md
- Update Gasgnome.sol
- Update CHANGELOG.md

## [0.1.0] - 2024-07-28

### 🚀 Features

- *(core)* Add Storage library
- *(Slot)* Add asString function
- *(Slot)* Add asBytes function
- *(Storage)* Add new getSlot types
- Add BitmaskLib.sol
- *(Mask)* Add Mask custom type and its library
- *(BitmaskLib)* Implement updateDataWith
- Add ArithmeticLib library
- *(SignedInt)* Add custom type
- *(UnsignedInt)* Add custom type
- *(UnsignedInt)* Add UnsignedLib
- *(ArithmeticLib)* Add functions
- *(SignedInt)* Add functions

### 🐛 Bug Fixes

- *(ci)* Update ci-all-via-ir.yml
- Change `bitSize` parameter type as uint16
- *(UnsignedInt)* Fix wrong conditions
- *(SignedInt)* Fix wrong conditions
- *(SignedInt)* Update `divSignedInt` function
- *(SignedInt)* Update `modSignedInt` function
- *(SignedInt)* Update `expSignedInt` function

### 🚜 Refactor

- *(Slot)* Update asInt256 and asUint256
- *(Slot)* Update asAddress function
- Rename Storage to StorageLib
- *(BItmaskLib)* Update `updateLeftPadded` function
- *(BitmaskLib)* Update Mask custom type
- *(BitmaskLib)* Update `build` function params
- *(BitmaskLib)* Remove `getLength` function
- *(UnsignedInt)* Update functions
- Update Gasgnome.sol
- Change `sizeInBytes` into `desiredBits`
- *(ArithmeticLib)* Add missing custom errors
- *(UnsignedInt)* Add custom errors

### 📚 Documentation

- Update README.md
- Update README.md

### 🎨 Styling

- *(SlotLib)* Update setUp function
- Move Mask to BitmaskLib
- *(BitmaskLib)* Rename updateDataWith as updateLeftPadded
- Format BitmaskLib.t.sol
- *(SignedInt)* Format operation functions' bodies

### 🧪 Testing

- *(SlotLib)* Add test suite
- *(SlotLib)* Add asBytes test cases
- *(Storage)* Add test suite
- *(Bitmask)* Add test suite
- *(BitmaskLib)* Update test suite
- *(ArithmeticLib)* Update test cases
- *(SignedIntLibTest)* Create test suite
- *(UnsignedIntLibTest)* Create test suite
- *(UnsignedIntLib)* Update test cases
- *(UnsignedIntLib)* Update test suite
- *(SignedIntLib)* Update test cases

### ⚙️ Miscellaneous Tasks

- Add ci-all-via-ir.yml
- Add logo.svg
- Update logo.svg
- *(types)* Add slot type and its library
- Remove redundant contracts
- Update Gasgnome.sol
- Add CHANGELOG.md
- Update CHANGELOG.md
- Update Gasgnome.sol
- Update CHANGELOG.md
- Update CHANGELOG.md

<!-- generated by git-cliff -->
