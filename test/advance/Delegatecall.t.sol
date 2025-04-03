//SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test, console2} from "forge-std/Test.sol";
import {LogicV1, Proxy} from "advance/Delegatecall.sol";

contract DelegatecallTest is Test {
    LogicV1 logicV1;
    Proxy proxy;

    address admin = makeAddr("admin");

    function setUp() public {
        logicV1 = new LogicV1();
        vm.prank(admin);
        proxy = new Proxy(address(logicV1));

        vm.deal(admin, 2 ether);
    }

    function test_LogicV1_internal_Delegatecall() public {
        vm.prank(admin);
        LogicV1(address(proxy)).setVars{value: 1 ether}(100);

        assertEq(proxy.num(), 100);
        assertEq(proxy.sender(), admin);
        assertEq(proxy.value(), 1 ether);
        assertEq(address(proxy).balance, 1 ether);
        assertEq(address(logicV1).balance, 0 ether);
    }

    function test_LogicV1_public_Delegatecall() public {
        vm.prank(admin);
        proxy.delegatecall(address(logicV1), abi.encodeWithSelector(LogicV1.setVars.selector, 100));
        // msg.value = 0 ; 无法转发ether

        assertEq(proxy.num(), 100);
        assertEq(proxy.sender(), admin);
    }
}
