//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {StdInvariant} from 'forge-std/StdInvariant.sol';
import {Test} from 'forge-std/Test.sol';
import {ERC20Mock} from '@openzeppelin/contracts/mocks/token/ERC20Mock.sol';
import {ERC721Mock} from '../mocks/ERC721Mock.sol';
import {IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {TokenDivider} from 'src/TokenDivider.sol';
import {DeployTokenDivider} from 'script/DeployTokenDivider.s.sol';


contract TokenDividerInvariantTest is StdInvariant, Test {
    DeployTokenDivider deployer;
    ERC20Mock erc20;
    ERC721Mock erc721;
    TokenDivider tokenDivider;

    uint256 public constant AMOUNT = 10e18;
    function setUp() public{

        deployer = new DeployTokenDivider();
        tokenDivider = deployer.run();

        erc721 = new ERC721Mock();
        erc20 = new ERC20Mock();


        erc20.mint(address(tokenDivider), AMOUNT);
        erc721.mint(msg.sender);

        vm.prank(msg.sender);
        erc721.approve(address(tokenDivider), 0);


        targetContract(address(tokenDivider));
    }

    function invariant__allErc20TokensShouldAlwaysBeEqualToTheTotalSupplyOfThem() public view {
        uint256 totalERC20Minted= erc20.totalSupply();

        assertEq(totalERC20Minted, AMOUNT);
    }

    function invariant__gettersShouldNeverRevert() public view {
        tokenDivider.getBalanceOf(msg.sender, address(erc20));
        tokenDivider.getErc20TotalMintedAmount(address(erc20));
    }
}