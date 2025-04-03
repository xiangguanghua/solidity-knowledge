//SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test, console2} from "forge-std/Test.sol";
import {ABIEncode, IERC20, Token} from "high/ABIEncode.sol";

contract ABIEncodeTest is Test {
    ABIEncode abiEncode;
    Token token;

    address user = makeAddr("user");

    function setUp() public {
        abiEncode = new ABIEncode();
        token = new Token();

        vm.deal(user, 100 ether);
        vm.deal(address(token), 100 ether);
    }

    function test_encodeWithSignature() public {
        bytes memory data = abiEncode.encodeWithSignature(user, 1 ether);
        abiEncode.test(address(token), data);

        assertEq(user.balance, 101 ether);
        assertEq(address(token).balance, 99 ether);
    }

    function test_encodeWithSelector() public {
        bytes memory data = abiEncode.encodeWithSelector(user, 1 ether);
        abiEncode.test(address(token), data);

        assertEq(user.balance, 101 ether);
        assertEq(address(token).balance, 99 ether);
    }

    function test_encodeCall() public {
        bytes memory data = abiEncode.encodeCall(user, 1 ether);
        abiEncode.test(address(token), data);

        assertEq(user.balance, 101 ether);
        assertEq(address(token).balance, 99 ether);
    }
}
