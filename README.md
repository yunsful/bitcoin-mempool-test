# Bitcoin Core + Knots (Docker)

여러 버전/구현체를 동시에 띄울 수 있도록 Docker Compose 구성을 제공합니다.
공식 릴리스 tarball을 내려받아 실행합니다.

## 포함된 구현체

- Bitcoin Core: 30.2, 29.2, 29.0, 28.1, 27.1, 27.0, 26.0, 25.1
- Bitcoin Knots: 29.2.knots20251110, 29.1.knots20250903, 28.1.knots20250305

> NOTE: Core 30.0.0 tarball은 bitcoincore.org에 없어서 30.2로 대체했습니다.
> 30.0.0이 꼭 필요하면 소스 빌드 구성을 추가해야 합니다.

## 사용 방법

1) `.env` 확인

```bash
# 필요하면 다시 생성
cp .env.example .env
```

`.env`에는 각 릴리스 tarball URL과 SHA256이 이미 들어 있습니다.
LND 버전은 `LND_VERSION`으로 관리합니다.

2) 빌드 및 실행

```bash
# 전체 빌드

docker compose build

# 원하는 서비스만 실행

docker compose up -d core-30-2 core-29-2 core-29-0 knots-29-2-20251110
```

LND도 함께 실행하려면:

```bash
docker compose up -d lnd-core-30-2 lnd-core-29-2 lnd-knots-29-1-20250903
```

3) 동작 확인 (예시)

```bash
# Core 30.2

docker compose exec core-30-2 bitcoin-cli -regtest -rpcuser=bitcoin -rpcpassword=bitcoin -rpcport=18465 getblockchaininfo

# Knots 29.2

docker compose exec knots-29-2-20251110 bitcoin-cli -regtest -rpcuser=bitcoin -rpcpassword=bitcoin -rpcport=18459 getblockchaininfo
```

LND 확인 (컨테이너 내부에서 실행):

```bash
docker compose exec lnd-core-30-2 lncli --network=regtest getinfo
docker compose exec lnd-core-29-2 lncli --network=regtest getinfo
docker compose exec lnd-knots-29-1-20250903 lncli --network=regtest getinfo
```

## 포트 매핑

- core-30-2: RPC 18465 / P2P 18466
- core-29-2: RPC 18445 / P2P 18446
- core-29-0: RPC 18447 / P2P 18448
- core-28-1: RPC 18449 / P2P 18450
- core-27-1: RPC 18451 / P2P 18452
- core-27-0: RPC 18453 / P2P 18454
- core-26-0: RPC 18455 / P2P 18456
- core-25-1: RPC 18457 / P2P 18458
- knots-29-2-20251110: RPC 18459 / P2P 18460
- knots-29-1-20250903: RPC 18461 / P2P 18462
- knots-28-1-20250305: RPC 18463 / P2P 18464

## LND 포트 매핑

- lnd-core-30-2: gRPC 10009 / REST 8080 / P2P 9735
- lnd-core-29-2: gRPC 11009 / REST 18080 / P2P 19735
- lnd-knots-29-1-20250903: gRPC 12009 / REST 28080 / P2P 29735

> NOTE: 현재 `.env`는 LND 최신 릴리스(v0.20.1-beta.rc1)를 사용합니다.
> 안정 버전을 원하면 `LND_VERSION`을 다른 태그로 바꿔 주세요.

## 설정

- `config/core/bitcoin.conf`
- `config/knots/bitcoin.conf`

두 파일은 공통 설정만 담고, 포트/피어 연결은 서비스별 `BITCOIN_ARGS`로 설정합니다.
