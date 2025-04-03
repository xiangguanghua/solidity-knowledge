// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract LogicV1 {
    // note: storage layout must be the same as contract A
    uint256 public num;
    address public sender;
    uint256 public value;

    function setVars(uint256 _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract Proxy {
    uint256 public num;
    address public sender;
    uint256 public value;

    address public implementation;
    address public admin;
    bytes public data;

    constructor(address _impl) {
        admin = msg.sender;
        implementation = _impl;
    }

    function upgradeTo(address _newImpl) external {
        require(msg.sender == admin, "Not admin");
        implementation = _newImpl;
    }

    function delegatecall(address _impl, bytes calldata _data) external {
        data = _data;
        implementation = _impl;
        _delegatecall();
    }

    function _delegatecall() internal {
        if (data.length == 0) data = msg.data;
        (bool success, bytes memory _data) = implementation.delegatecall(data);
        if (!success) {
            assembly {
                revert(add(_data, 32), mload(_data))
            }
        }
        require(success, "Delegatecall failed");
    }

    fallback() external payable {
        _delegatecall();
    }

    receive() external payable {
        _delegatecall();
    }
}
