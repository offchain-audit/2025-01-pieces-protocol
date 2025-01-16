-include .env
.PHONY: all test clean deploy fund help install snapshot format anvil 

install:
	@forge install OpenZeppelin/openzeppelin-contracts --no-commit
	@forge install foundry-rs/forge-std --no-commit
	@forge install Cyfrin/foundry-devops --no-commit
