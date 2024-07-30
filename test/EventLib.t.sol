// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import { EventArgIndexed, EventArgNonIndexed, EventHash, EventLib } from "../src/libraries/EventLib.sol";
import { Test, console } from "forge-std/Test.sol";

contract EventLibTest is Test {
    /// @dev NonAnonymous events
    event NonAnonymousNonIndexedNoData();
    event NonAnonymousNonIndexed(uint256, bytes32);
    event NonAnonymousIndexedOneNoData(uint256 indexed);
    event NonAnonymousIndexedOne(uint256 indexed, bytes32);
    event NonAnonymousIndexedTwoNoData(uint256 indexed, bytes32 indexed);
    event NonAnonymousIndexedTwo(uint256 indexed, bytes32 indexed, uint256, bytes32);
    event NonAnonymousIndexedThreeNoData(uint256 indexed, bytes32 indexed, bytes32 indexed);
    event NonAnonymousIndexedThree(uint256 indexed, bytes32 indexed, bytes32 indexed, uint256, bytes32);
    /// @dev Anonymous events
    event AnonymousNonIndexed(uint256) anonymous;
    event AnonymousIndexedOneNoData(uint256 indexed) anonymous;
    event AnonymousIndexedOne(uint256 indexed, bytes32) anonymous;
    event AnonymousIndexedTwoNoData(uint256 indexed, bytes32 indexed) anonymous;
    event AnonymousIndexedTwo(uint256 indexed, bytes32 indexed, uint256, bytes32) anonymous;
    event AnonymousIndexedThreeNoData(uint256 indexed, bytes32 indexed, bytes32 indexed) anonymous;
    event AnonymousIndexedThree(uint256 indexed, bytes32 indexed, bytes32 indexed, uint256, bytes32) anonymous;
    event AnonymousIndexedFourNoData(uint256 indexed, bytes32 indexed, bool indexed, int256 indexed) anonymous;
    event AnonymousIndexedFour(uint256 indexed, bytes32 indexed, bool indexed, int256 indexed, bool, bytes32) anonymous;

    function test_EmitEvent_NonAnonymousNonIndexedNoData() public {
        vm.expectEmit(true, true, true, true);
        emit NonAnonymousNonIndexedNoData();

        EventLib.emitEvent(EventHash.wrap(NonAnonymousNonIndexedNoData.selector));
    }

    function test_EmitEvent_NonAnonymousNonIndexed() public {
        EventArgNonIndexed[] memory ni = new EventArgNonIndexed[](2);
        ni[0] = (EventArgNonIndexed.wrap(bytes32(uint256(3))));
        ni[1] = (EventArgNonIndexed.wrap(bytes32("hey")));

        vm.expectEmit(true, true, true, true);
        emit NonAnonymousNonIndexed(uint256(3), bytes32("hey"));

        EventLib.emitEvent(EventHash.wrap(NonAnonymousNonIndexed.selector), ni);
    }

    function test_EmitEvent_NonAnonymousIndexedOneNoData() public {
        EventArgIndexed[1] memory i;
        i[0] = (EventArgIndexed.wrap(bytes32(uint256(3))));

        vm.expectEmit(true, true, true, true);
        emit NonAnonymousIndexedOneNoData(uint256(3));

        EventLib.emitEvent(EventHash.wrap(NonAnonymousIndexedOneNoData.selector), i);
    }

    function test_EmitEvent_NonAnonymousIndexedOne() public {
        EventArgNonIndexed[] memory ni = new EventArgNonIndexed[](1);
        ni[0] = (EventArgNonIndexed.wrap(bytes32("hey")));

        EventArgIndexed[1] memory i;
        i[0] = (EventArgIndexed.wrap(bytes32(uint256(3))));

        vm.expectEmit(true, true, true, true);
        emit NonAnonymousIndexedOne(uint256(3), bytes32("hey"));

        EventLib.emitEvent(EventHash.wrap(NonAnonymousIndexedOne.selector), i, ni);
    }

    function test_EmitEvent_NonAnonymousIndexedTwoNoData() public {
        EventArgIndexed[2] memory i;
        i[0] = (EventArgIndexed.wrap(bytes32(uint256(3))));
        i[1] = (EventArgIndexed.wrap(bytes32("hey")));

        vm.expectEmit(true, true, true, true);
        emit NonAnonymousIndexedTwoNoData(uint256(3), bytes32("hey"));

        EventLib.emitEvent(EventHash.wrap(NonAnonymousIndexedTwoNoData.selector), i);
    }

    function test_EmitEvent_NonAnonymousIndexedTwo() public {
        EventArgNonIndexed[] memory ni = new EventArgNonIndexed[](2);
        ni[0] = (EventArgNonIndexed.wrap(bytes32(uint256(1024))));
        ni[1] = (EventArgNonIndexed.wrap(bytes32("there")));

        EventArgIndexed[2] memory i;
        i[0] = (EventArgIndexed.wrap(bytes32(uint256(3))));
        i[1] = (EventArgIndexed.wrap(bytes32(bytes32("hey"))));

        vm.expectEmit(true, true, true, true);
        emit NonAnonymousIndexedTwo(uint256(3), bytes32("hey"), uint256(1024), bytes32("there"));

        EventLib.emitEvent(EventHash.wrap(NonAnonymousIndexedTwo.selector), i, ni);
    }

    function test_EmitEvent_NonAnonymousIndexedThreeNoData() public {
        EventArgIndexed[3] memory i;
        i[0] = (EventArgIndexed.wrap(bytes32(uint256(3))));
        i[1] = (EventArgIndexed.wrap(bytes32("hey")));
        i[2] = (EventArgIndexed.wrap(bytes32("come")));

        vm.expectEmit(true, true, true, true);
        emit NonAnonymousIndexedThreeNoData(uint256(3), bytes32("hey"), bytes32("come"));

        EventLib.emitEvent(EventHash.wrap(NonAnonymousIndexedThreeNoData.selector), i);
    }

    function test_EmitEvent_NonAnonymousIndexedThree() public {
        EventArgNonIndexed[] memory ni = new EventArgNonIndexed[](2);
        ni[0] = (EventArgNonIndexed.wrap(bytes32(uint256(3))));
        ni[1] = (EventArgNonIndexed.wrap(bytes32("hey")));

        EventArgIndexed[3] memory i;
        i[0] = (EventArgIndexed.wrap(bytes32(uint256(3))));
        i[1] = (EventArgIndexed.wrap(bytes32("hey")));
        i[2] = (EventArgIndexed.wrap(bytes32("come")));

        vm.expectEmit(true, true, true, true);
        emit NonAnonymousIndexedThree(uint256(3), bytes32("hey"), bytes32("come"), uint256(3), bytes32("hey"));

        EventLib.emitEvent(EventHash.wrap(NonAnonymousIndexedThree.selector), i, ni);
    }

    /// NOTE: This test is flawed even though the emitted event matches
    /// the expected one.

    // function test_EmitEvent_AnonymousNonIndexed() public {
    //     EventArgNonIndexed[] memory ni = new EventArgNonIndexed[](1);
    //     ni[0] = EventArgNonIndexed.wrap(bytes32(uint256(3)));

    //     vm.expectEmit(true, true, true, true);
    //     emit AnonymousNonIndexed(uint256(3));

    //     EventLib.emitEvent(ni);
    // }

    function test_EmitEvent_AnonymousIndexedOneNoData() public {
        EventArgIndexed[1] memory i;
        i[0] = (EventArgIndexed.wrap(bytes32(uint256(3))));

        vm.expectEmit(true, true, true, true);
        emit AnonymousIndexedOneNoData(uint256(3));

        EventLib.emitEvent(i);
    }

    function test_EmitEvent_AnonymousIndexedOne() public {
        EventArgIndexed[1] memory i;
        i[0] = (EventArgIndexed.wrap(bytes32(uint256(3))));

        EventArgNonIndexed[] memory ni = new EventArgNonIndexed[](1);
        ni[0] = (EventArgNonIndexed.wrap(bytes32("hello")));

        vm.expectEmit(true, true, true, true);
        emit AnonymousIndexedOne(uint256(3), bytes32("hello"));

        EventLib.emitEvent(i, ni);
    }

    function test_EmitEvent_AnonymousIndexedTwoNoData() public {
        EventArgIndexed[2] memory i;
        i[0] = (EventArgIndexed.wrap(bytes32(uint256(3))));
        i[1] = (EventArgIndexed.wrap(bytes32("hello")));

        vm.expectEmit(true, true, true, true);
        emit AnonymousIndexedTwoNoData(uint256(3), bytes32("hello"));

        EventLib.emitEvent(i);
    }

    function test_EmitEvent_AnonymousIndexedTwo() public {
        EventArgIndexed[2] memory i;
        i[0] = (EventArgIndexed.wrap(bytes32(uint256(3))));
        i[1] = (EventArgIndexed.wrap(bytes32("hello")));

        EventArgNonIndexed[] memory ni = new EventArgNonIndexed[](2);
        ni[0] = (EventArgNonIndexed.wrap(bytes32(uint256(1024))));
        ni[1] = (EventArgNonIndexed.wrap(bytes32("man")));

        vm.expectEmit(true, true, true, true);
        emit AnonymousIndexedTwo(uint256(3), bytes32("hello"), uint256(1024), bytes32("man"));

        EventLib.emitEvent(i, ni);
    }

    function test_EmitEvent_AnonymousIndexedThreeNoData() public {
        EventArgIndexed[3] memory i;
        i[0] = (EventArgIndexed.wrap(bytes32(uint256(3))));
        i[1] = (EventArgIndexed.wrap(bytes32("hello")));
        i[2] = (EventArgIndexed.wrap(bytes32("world")));

        vm.expectEmit(true, true, true, true);
        emit AnonymousIndexedThreeNoData(uint256(3), bytes32("hello"), bytes32("world"));

        EventLib.emitEvent(i);
    }

    function test_EmitEvent_AnonymousIndexedThree() public {
        EventArgIndexed[3] memory i;
        i[0] = (EventArgIndexed.wrap(bytes32(uint256(3))));
        i[1] = (EventArgIndexed.wrap(bytes32("hello")));
        i[2] = (EventArgIndexed.wrap(bytes32("world")));

        EventArgNonIndexed[] memory ni = new EventArgNonIndexed[](2);
        ni[0] = (EventArgNonIndexed.wrap(bytes32(uint256(1024))));
        ni[1] = (EventArgNonIndexed.wrap(bytes32("man")));

        vm.expectEmit(true, true, true, true);
        emit AnonymousIndexedThree(uint256(3), bytes32("hello"), bytes32("world"), uint256(1024), bytes32("man"));

        EventLib.emitEvent(i, ni);
    }

    function test_EmitEvent_AnonymousIndexedFourNoData() public {
        EventArgIndexed[4] memory i;
        i[0] = (EventArgIndexed.wrap(bytes32(uint256(3))));
        i[1] = (EventArgIndexed.wrap(bytes32("hello")));
        i[2] = (EventArgIndexed.wrap(bytes32(abi.encode(false))));
        i[3] = (EventArgIndexed.wrap(bytes32(abi.encode(int256(123)))));

        vm.expectEmit(true, true, true, true);
        emit AnonymousIndexedFourNoData(uint256(3), bytes32("hello"), false, 123);

        EventLib.emitEvent(i);
    }

    function test_EmitEvent_AnonymousIndexedFour() public {
        EventArgIndexed[4] memory i;
        i[0] = (EventArgIndexed.wrap(bytes32(uint256(3))));
        i[1] = (EventArgIndexed.wrap(bytes32("hello")));
        i[2] = (EventArgIndexed.wrap(bytes32(abi.encode(false))));
        i[3] = (EventArgIndexed.wrap(bytes32(abi.encode(int256(123)))));

        EventArgNonIndexed[] memory ni = new EventArgNonIndexed[](2);
        ni[0] = (EventArgNonIndexed.wrap(bytes32(abi.encode(true))));
        ni[1] = (EventArgNonIndexed.wrap(bytes32("world")));

        vm.expectEmit(true, true, true, true);
        emit AnonymousIndexedFour(uint256(3), bytes32("hello"), false, 123, true, bytes32("world"));

        EventLib.emitEvent(i, ni);
    }
}
