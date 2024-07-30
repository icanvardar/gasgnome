// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

/// NOTE: Anonymous events have x indexed arguments where 0 <= x <= 4.

/// NOTE: Non-anonymous events have x indexed arguments where 0 <= x <= 3.

type EventHash is bytes32;

type EventArgIndexed is bytes32;

type EventArgNonIndexed is bytes32;

library EventLib {
    function emitEvent(
        EventHash eventHash,
        EventArgIndexed[] memory indexedArgs,
        EventArgNonIndexed[] memory nonIndexedArgs
    )
        internal
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
            case 0 { log1(niStart, niSize, eventHash) }
            case 1 { log2(niStart, niSize, eventHash, mload(iStart)) }
            case 2 { log3(niStart, niSize, eventHash, mload(iStart), mload(add(iStart, 0x20))) }
            case 3 {
                log4(niStart, niSize, eventHash, mload(iStart), mload(add(iStart, 0x20)), mload(add(iStart, 0x40)))
            }
        }
    }

    function emitEventIndexed(EventHash eventHash, EventArgIndexed[] memory indexedArgs) public { }

    function emitEventNonIndexed(EventHash eventHash, EventArgNonIndexed[] memory nonIndexedArgs) public { }

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

    function emitEventAnonymousIndexed(EventArgIndexed[] memory indexedArgs) public { }

    function emitEventAnonymousNonIndexed(EventArgNonIndexed[] memory nonIndexedArgs) public { }
}
