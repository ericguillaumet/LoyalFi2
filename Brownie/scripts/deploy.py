from brownie import NFTContract, network, config, accounts, interface
from scripts.scoring import get_full_list

LOCAL_NETWOKRS = ["development", "mainnet-fork"]


def deploy():
    account = get_account()
    NFTContract.deploy(
        {"from": account}, publish_source=config["networks"][network.show_active]
    )


def main():
    deploy(get_gold_list(), get_silver_list(), get_bronze_list())


wallet_list = get_full_list
length = len(wallet_list)
one_third = int(round(length / 3, 0))
gold_end = one_third
silver_end = gold_end + one_third


def get_gold_list():
    return wallet_list[0:gold_end]


def get_silver_list():
    return wallet_list[gold_end:silver_end]


def get_bronze_list():
    return wallet_list[silver_end:]


def get_account():
    if network.show_active() in LOCAL_NETWOKRS:
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"])
