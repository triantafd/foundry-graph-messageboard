# Smart Contract + Graph Indexing (Quick Guide)

## Requirements
- [Foundry](https://getfoundry.sh/)
- [Docker](https://docs.docker.com/get-docker/) & Docker Compose
- [Node.js](https://nodejs.org/)
- [The Graph CLI](https://thegraph.com/docs/en/developer/quick-start/)
- Install The Graph CLI globally:
  ```bash
  npm install -g @graphprotocol/graph-cli
  ```

## .env Setup

Create a `.env` file in your project root with the following content:

```env
RPC_URL=http://127.0.0.1:8545
PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

- `RPC_URL` — The URL of your local Ethereum node (Anvil)
- `PRIVATE_KEY` — The private key of the account used for deploying and sending transactions (the first account of anvil)

## Project Structure

- `foundry-message/` - Foundry smart contract project
- `graph-local/` - Graph subgraph for indexing contract events

## Smart Contract Details

The `MessageBoard.sol` contract has one function:
- `postMessage(string calldata message)` - Posts a message and emits a `NewMessage` event

## Graph Subgraph Details

The subgraph indexes `NewMessage` events and stores:
- `id` - Transaction hash
- `sender` - Address that posted the message
- `message` - The message content
- `timestamp` - Block timestamp

## Development Workflow

1. Make changes to smart contract
2. Redeploy contract
3. Update contract address in subgraph.yaml
4. Redeploy subgraph
5. Test with new messages
6. Query updated data

## 1. Start Local Blockchain
```bash
anvil
```

## 2. Deploy Contract (Foundry)
```bash
source .env
forge create src/MessageBoard.sol:MessageBoard --rpc-url http://localhost:8545 --private-key $PRIVATE_KEY --broadcast
```
- Copy the deployed contract address for the next step.

## 3. Update Subgraph
- Edit `graph-local/subgraph.yaml` and set the new contract address.

## 4. Start Graph Node
```bash
cd graph-local
npm install
docker-compose up -d
```

## 5. Deploy Subgraph
```bash
graph codegen
graph build
graph create --node http://localhost:8020/ local/messageboard
graph deploy --node http://localhost:8020/ --ipfs http://localhost:5001 local/messageboard
```

## 6. Post a Message
```bash
cast send --rpc-url http://localhost:8545 --private-key $PRIVATE_KEY [CONTRACT_ADDRESS] "postMessage(string)" "Hello World!"
```

## 7. Query the Graph

Visit `http://localhost:8000/graphql` or use curl:

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  --data '{"query":"{messages(first:10,orderBy:timestamp,orderDirection:desc){id sender message timestamp}}"}' \
  http://localhost:8000/graphql
```

### GraphQL Query Examples

#### Get all messages
```graphql
{
  messages(first: 10, orderBy: timestamp, orderDirection: desc) {
    id
    sender
    message
    timestamp
  }
}
```

## 8. View Messages in Postgres (Docker)
```bash
docker exec -it graph-local-postgres-1 psql -U graph-node -d graph-node
\dn
SET search_path TO sgd1;
\dt
SELECT * FROM message LIMIT 5;
```






