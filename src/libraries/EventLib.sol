// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

/// NOTE: Anonymous events have x indexed arguments where 0 <= x <= 4.

/// NOTE: Non-anonymous events have x indexed arguments where 0 <= x <= 3.

type EventHash is bytes32;

type EventArgIndexed is bytes32;

type EventArgNonIndexed is bytes32;

library EventLib {
    /// @dev non-anonymous + non-indexed + no data
    function emitEvent(EventHash eventHash) internal {
        assembly {
            log1(0x00, 0x00, eventHash)
        }
    }

    /// @dev non-anonymous + non-indexed
    function emitEvent(EventHash eventHash, EventArgNonIndexed[] memory nonIndexedArgs) internal {
        assembly {
            log1(add(nonIndexedArgs, 0x20), mul(mload(nonIndexedArgs), 0x20), eventHash)
        }
    }

    /// @dev non-anonymous + indexed(1) + no data
    function emitEvent(EventHash eventHash, EventArgIndexed[1] memory indexedArgs) internal {
        assembly {
            log2(0x00, 0x00, eventHash, mload(indexedArgs))
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
        assembly {
            log2(add(nonIndexedArgs, 0x20), mul(mload(nonIndexedArgs), 0x20), eventHash, mload(indexedArgs))
        }
    }

    /// @dev non-anonymous + indexed(2) + no data
    function emitEvent(EventHash eventHash, EventArgIndexed[2] memory indexedArgs) internal {
        assembly {
            log3(0x00, 0x00, eventHash, mload(indexedArgs), mload(add(indexedArgs, 0x20)))
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
        assembly {
            log3(
                add(nonIndexedArgs, 0x20),
                mul(mload(nonIndexedArgs), 0x20),
                eventHash,
                mload(indexedArgs),
                mload(add(indexedArgs, 0x20))
            )
        }
    }

    /// @dev non-anonymous + indexed(3) + no data
    function emitEvent(EventHash eventHash, EventArgIndexed[3] memory indexedArgs) internal {
        assembly {
            log4(
                0x00, 0x00, eventHash, mload(indexedArgs), mload(add(indexedArgs, 0x20)), mload(add(indexedArgs, 0x40))
            )
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
        assembly {
            log4(
                add(nonIndexedArgs, 0x20),
                mul(mload(nonIndexedArgs), 0x20),
                eventHash,
                mload(indexedArgs),
                mload(add(indexedArgs, 0x20)),
                mload(add(indexedArgs, 0x40))
            )
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
