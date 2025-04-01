//SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test, console2} from "forge-std/Test.sol";
import {LogicV1, Proxy} from "../contracts/Delegatecall.sol";

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

    function test_LogicV1_Delegatecall() public {
        vm.prank(admin);
        LogicV1(address(proxy)).setVars{value: 1 ether}(100);

        assertEq(proxy.num(), 100);
        assertEq(proxy.sender(), admin);
        assertEq(proxy.value(), 1 ether);
    }
}
