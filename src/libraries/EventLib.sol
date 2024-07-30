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

    /// @dev anonymous + non-indexed
    function emitEvent(EventArgNonIndexed[] memory nonIndexedArgs) internal {
        emitEvent(EventHash.wrap(0x00), nonIndexedArgs);
    }

    /// @dev anonymous + indexed(1) + no data
    function emitEvent(EventArgIndexed[1] memory indexedArgs) internal {
        emitEvent(EventHash.wrap(0x00), indexedArgs);
    }

    /// @dev anonymous + indexed(1)
    function emitEvent(EventArgIndexed[1] memory indexedArgs, EventArgNonIndexed[] memory nonIndexedArgs) internal {
        emitEvent(EventHash.wrap(0x00), indexedArgs, nonIndexedArgs);
    }

    /// @dev anonymous + indexed(2) + no data
    function emitEvent(EventArgIndexed[2] memory indexedArgs) internal {
        emitEvent(EventHash.wrap(0x00), indexedArgs);
    }

    /// @dev anonymous + indexed(2)
    function emitEvent(EventArgIndexed[2] memory indexedArgs, EventArgNonIndexed[] memory nonIndexedArgs) internal {
        emitEvent(EventHash.wrap(0x00), indexedArgs, nonIndexedArgs);
    }

    /// @dev anonymous + indexed(3) + no data
    function emitEvent(EventArgIndexed[3] memory indexedArgs) internal {
        emitEvent(EventHash.wrap(0x00), indexedArgs);
    }

    /// @dev anonymous + indexed(3)
    function emitEvent(EventArgIndexed[3] memory indexedArgs, EventArgNonIndexed[] memory nonIndexedArgs) internal {
        emitEvent(EventHash.wrap(0x00), indexedArgs, nonIndexedArgs);
    }

    /// @dev anonymous + indexed(4) + no data
    function emitEvent(EventArgIndexed[4] memory indexedArgs) internal {
        EventArgIndexed[3] memory tmp = [indexedArgs[1], indexedArgs[2], indexedArgs[3]];

        emitEvent(EventHash.wrap(EventArgIndexed.unwrap(indexedArgs[0])), tmp);
    }

    /// @dev anonymous + indexed(4)
    function emitEvent(EventArgIndexed[4] memory indexedArgs, EventArgNonIndexed[] memory nonIndexedArgs) internal {
        EventArgIndexed[3] memory tmp = [indexedArgs[1], indexedArgs[2], indexedArgs[3]];

        emitEvent(EventHash.wrap(EventArgIndexed.unwrap(indexedArgs[0])), tmp, nonIndexedArgs);
    }
}
