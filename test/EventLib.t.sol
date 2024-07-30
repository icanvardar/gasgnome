// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import { EventArgIndexed, EventArgNonIndexed, EventHash, EventLib } from "../src/libraries/EventLib.sol";
import { Test, console } from "forge-std/Test.sol";

contract EventLibTest is Test {
    event NonAnonymousNonIndexedNoData();
    event NonAnonymousNonIndexed(uint256, bytes32);
    event NonAnonymousIndexedOneNoData(uint256 indexed);
    event NonAnonymousIndexedOne(uint256 indexed, bytes32);
    event NonAnonymousIndexedTwoNoData(uint256 indexed, bytes32 indexed);
    event NonAnonymousIndexedTwo(uint256 indexed, bytes32 indexed, uint256, bytes32);
    event NonAnonymousIndexedThreeNoData(uint256 indexed, bytes32 indexed, bytes32 indexed);
    event NonAnonymousIndexedThree(uint256 indexed, bytes32 indexed, bytes32 indexed, uint256, bytes32);

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
}
