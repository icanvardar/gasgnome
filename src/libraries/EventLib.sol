// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

/// NOTE: Anonymous events have x indexed arguments where 0 <= x <= 4.

/// NOTE: Non-anonymous events have x indexed arguments where 0 <= x <= 3.

type EventHash is bytes32;

type EventArgIndexed is bytes32;

type EventArgNonIndexed is bytes32;

library EventLib {
    function getDataLocations(
        EventArgIndexed[] memory indexedArgs,
        EventArgNonIndexed[] memory nonIndexedArgs
    )
        internal
        pure
        returns (bytes32 iStart, bytes32 niStart, bytes32 niSize)
    {
        assembly {
            iStart := add(indexedArgs, 0x20)

            let niLen := mload(nonIndexedArgs)
            if gt(niLen, 0) {
                niStart := add(nonIndexedArgs, 0x20)
                niSize := mul(niLen, 0x20)
            }
        }
    }

    function getDataLocations(EventArgNonIndexed[] memory nonIndexedArgs)
        internal
        pure
        returns (bytes32 niStart, bytes32 niSize)
    {
        assembly {
            let niLen := mload(nonIndexedArgs)
            if gt(niLen, 0) {
                niStart := add(nonIndexedArgs, 0x20)
                niSize := mul(niLen, 0x20)
            }
        }
    }

    /// @dev non-anonymous + non-indexed + no data
    function emitEvent(EventHash eventHash) internal {
        assembly {
            log1(0x00, 0x00, eventHash)
        }
    }

    /// @dev non-anonymous + non-indexed
    function emitEvent(EventHash eventHash, EventArgNonIndexed[] memory nonIndexedArgs) internal {
        (bytes32 niStart, bytes32 niSize) = getDataLocations(nonIndexedArgs);

        assembly {
            log1(niStart, niSize, eventHash)
        }
    }

    /// @dev non-anonymous + indexed(1)
    function emitEvent(
        EventHash eventHash,
        EventArgIndexed[1] memory indexedArgs,
        EventArgNonIndexed[] memory nonIndexedArgs
    )
        internal
    {
        EventArgIndexed[] memory tmp;

        assembly {
            mstore(tmp, 0x1)
            mstore(add(tmp, 0x20), mload(indexedArgs))
        }

        (bytes32 iStart, bytes32 niStart, bytes32 niSize) = getDataLocations(tmp, nonIndexedArgs);

        assembly {
            log2(niStart, niSize, eventHash, mload(iStart))
        }
    }

    /// @dev non-anonymous + indexed(2)
    function emitEvent(
        EventHash eventHash,
        EventArgIndexed[2] memory indexedArgs,
        EventArgNonIndexed[] memory nonIndexedArgs
    )
        internal
    {
        EventArgIndexed[] memory tmp;

        assembly {
            mstore(tmp, 0x1)
            mstore(add(tmp, 0x20), mload(indexedArgs))
            mstore(add(tmp, 0x40), mload(add(indexedArgs, 0x20)))
        }

        (bytes32 iStart, bytes32 niStart, bytes32 niSize) = getDataLocations(tmp, nonIndexedArgs);

        assembly {
            log3(niStart, niSize, eventHash, mload(iStart), mload(add(iStart, 0x20)))
        }
    }

    /// @dev non-anonymous + indexed(3)
    function emitEvent(
        EventHash eventHash,
        EventArgIndexed[3] memory indexedArgs,
        EventArgNonIndexed[] memory nonIndexedArgs
    )
        internal
    {
        EventArgIndexed[] memory tmp;

        assembly {
            mstore(tmp, 0x1)
            mstore(add(tmp, 0x20), mload(indexedArgs))
            mstore(add(tmp, 0x40), mload(add(indexedArgs, 0x20)))
            mstore(add(tmp, 0x60), mload(add(indexedArgs, 0x40)))
        }

        (bytes32 iStart, bytes32 niStart, bytes32 niSize) = getDataLocations(tmp, nonIndexedArgs);

        assembly {
            log4(niStart, niSize, eventHash, mload(iStart), mload(add(iStart, 0x20)), mload(add(iStart, 0x40)))
        }
    }

    function emitEventAnonymous(
        EventArgIndexed[] memory indexedArgs,
        EventArgNonIndexed[] memory nonIndexedArgs
    )
        public
    {
        assembly {
            let iLen := mload(indexedArgs)
            let iStart := add(indexedArgs, 0x20)

            let niLen := mload(nonIndexedArgs)
            let niStart
            let niSize
            if gt(niLen, 0) {
                niStart := add(nonIndexedArgs, 0x20)
                niSize := mul(niLen, 0x20)
            }

            switch iLen
            case 0 { log1(niStart, niSize, 0x0) }
            case 1 { log2(niStart, niSize, 0x0, mload(iStart)) }
            case 2 { log3(niStart, niSize, 0x0, mload(iStart), mload(add(iStart, 0x20))) }
            case 3 { log4(niStart, niSize, 0x0, mload(iStart), mload(add(iStart, 0x20)), mload(add(iStart, 0x40))) }
            case 4 {
                log4(
                    niStart,
                    niSize,
                    mload(iStart),
                    mload(add(iStart, 0x20)),
                    mload(add(iStart, 0x40)),
                    mload(add(iStart, 0x60))
                )
            }
        }
    }
}
