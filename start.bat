cd "geth"
start "" cmd /c "geth --datadir "" --dev --http --http.api "web3, eth, net" --http.corsdomain "*" --http.port 8545 --networkid 1337"