from flask import render_template, Flask, request
import requests
import pandas as pd
from register import app

@app.route("/", methods=("GET", "POST"))

def index():
    return render_template("index.html", pageTitle="LoyalFi")

@app.route("/claim", methods=["GET", "POST"])
def claim():
    if request.method == "POST":
        wallet_address = request.form['wallet_address']
        address_list = get_address_list()

        if wallet_address.lower() in address_list:
            result = "Your wallet is eligible."
        else:
            result = "Your wallet is not eligible."

        return render_template("claim.html", pageTitle="Claim", result=result)
    else:
        return render_template("claim.html", pageTitle="Claim")

def get_address_list():

    url = "https://api.thegraph.com/subgraphs/name/uniswap/uniswap-v2"
    pair = "0xae461ca67b15dc8dc81ce7615e0320da1a9ab8d5"

    query_LP_tokens = f"""
    {{
    liquidityPositions(
        first: 200,
        where: {{
        liquidityTokenBalance_gt: 0,
        pair: "{pair}"
        }},
        orderBy: liquidityTokenBalance,
        orderDirection: desc
    ) {{
        user {{
        id
        }}
        liquidityTokenBalance
        pair {{
        id
        token0 {{
            id
            symbol
        }}
        token1 {{
            id
            symbol
        }}
        }}
    }}
    }}
    """

    r = requests.post(url, json={"query": query_LP_tokens})
    r_data = r.json()

    # Extract the liquidityPositions data from the response JSON
    positions_data = r_data["data"]["liquidityPositions"]

    # Normalize the nested JSON data and convert to a DF
    df = pd.json_normalize(positions_data)

    # Rename columns
    df.columns = [
        "liquidity_token_balance",
        "user_id",
        "pair_id",
        "token0_id",
        "token0_symbol",
        "token1_id",
        "token1_symbol",
    ]

    address_list = df["user_id"].to_list()
    print(address_list)
    return address_list

if __name__ == '__main__':
    app.run()

def check_eligibility():
    wallet_address = request.form['wallet_address']
    address_list = get_address_list()

    if wallet_address.lower() in address_list:
        result = "Your wallet is eligible."
    else:
        result = "Your wallet is not eligible."

    return result

@app.route("/ranking", methods=["GET"])
def ranking():
    return render_template("ranking.html", pageTitle="Ranking")

@app.route("/snapshot", methods=["GET"])
def snapshot():
    return render_template("snapshot.html", pageTitle="Snapshot")