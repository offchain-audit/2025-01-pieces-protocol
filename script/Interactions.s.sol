//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {TokenDivider} from "src/TokenDivider.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";




contract DivideNft is Script {

     function run(address nftAddress, uint256 tokenId, uint256 amount) public {
        address mostRecentDelployment = DevOpsTools.get_most_recent_deployment("TokenDivider", block.chainid);
        divideNft(mostRecentDelployment, nftAddress, tokenId, amount);
       
     }


     function divideNft(address mostRecentDeployment, address nftAddress, uint256 tokenId, uint256 amount) public {
         vm.startBroadcast(msg.sender);
         IERC721(nftAddress).approve(mostRecentDeployment, tokenId);
         vm.stopBroadcast();
         TokenDivider(mostRecentDeployment).divideNft(nftAddress, tokenId, amount);

     
     }
}

contract ClaimNft is Script {

     function run(address nftAddress) public {
        address mostRecentDelployment = DevOpsTools.get_most_recent_deployment("TokenDivider", block.chainid);
        claimNft(mostRecentDelployment, nftAddress);
     }


     function claimNft(address mostRecentDeployment, address nftAddress) public {
        address erc20 = TokenDivider(mostRecentDeployment).getErc20InfoFromNft(nftAddress).erc20Address;
        uint256 totalErc20MintedAmount =  TokenDivider(mostRecentDeployment).getErc20TotalMintedAmount(erc20);
        vm.startBroadcast(msg.sender);
        IERC20(erc20).approve(mostRecentDeployment, totalErc20MintedAmount);
        TokenDivider(mostRecentDeployment).claimNft(nftAddress);
        vm.stopBroadcast();

       
     }
}


contract TransferErc20 is Script {
       function run(address nftAddress, address to, uint256 amount) public {
        address mostRecentDelployment = DevOpsTools.get_most_recent_deployment("TokenDivider", block.chainid);
        transferErc20(mostRecentDelployment, nftAddress, to, amount);
     }


     function transferErc20(address mostRecentDeployment, address nftAddress, address to, uint256 amount) public {
        address erc20 = TokenDivider(mostRecentDeployment).getErc20InfoFromNft(nftAddress).erc20Address;

        vm.startBroadcast(msg.sender);
        IERC20(erc20).approve(mostRecentDeployment, amount);
        TokenDivider(mostRecentDeployment).transferErcTokens(nftAddress, to, amount);
        vm.stopBroadcast();


       
     }
}


contract SellErc20 is Script {
       function run(address nftAddress, uint256 price, uint256 amount) public {
        address mostRecentDelployment = DevOpsTools.get_most_recent_deployment("TokenDivider", block.chainid);
        sellErc20(mostRecentDelployment, nftAddress, price, amount);
     }


     function sellErc20(address mostRecentDeployment, address nftAddress, uint256 price, uint256 amount) public {
        address erc20 = TokenDivider(mostRecentDeployment).getErc20InfoFromNft(nftAddress).erc20Address;

        vm.startBroadcast(msg.sender);
        IERC20(erc20).approve(mostRecentDeployment, amount);
        TokenDivider(mostRecentDeployment).sellErc20(nftAddress, price, amount);
        vm.stopBroadcast();


       
     }
}

contract BuyErc20 is Script {
       function run(uint256 orderIndex, address seller) public {
        address mostRecentDelployment = DevOpsTools.get_most_recent_deployment("TokenDivider", block.chainid);
        buyErc20(mostRecentDelployment, orderIndex, seller);
     }


     function buyErc20(address mostRecentDeployment, uint256 orderIndex ,address seller) public {
        vm.startBroadcast(msg.sender);
        TokenDivider(mostRecentDeployment).buyOrder{value: TokenDivider(mostRecentDeployment).getOrderPrice(seller, orderIndex) + ((TokenDivider(mostRecentDeployment).getOrderPrice(seller, orderIndex) / 100) / 2)}(orderIndex, seller);
        vm.stopBroadcast();


       
     }
}