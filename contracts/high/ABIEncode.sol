//SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IERC20 {
    function transfer(address to, uint256 amount) external;
}

contract Token is IERC20 {
    function transfer(address to, uint256 amount) external {
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "ERC20: transfer amount must be positive");
        payable(to).transfer(amount);
    }
}

contract ABIEncode {
    function encodeWithSignature(address to, uint256 amount) external pure returns (bytes memory) {
        return abi.encodeWithSignature("transfer(address,uint256)", to, amount);
    }

    function encodeWithSelector(address to, uint256 amount) external pure returns (bytes memory) {
        return abi.encodeWithSelector(IERC20.transfer.selector, to, amount);
    }

    function encodeCall(address to, uint256 amount) external pure returns (bytes memory) {
        return abi.encodeCall(IERC20.transfer, (to, amount));
    }

    function test(address _contract, bytes calldata data) external {
        (bool success,) = _contract.call(data);
        require(success, "call failed!");
    }
}
