# 達人に学ぶDB設計徹底指南書 学習用リポジトリ

## リンク

- https://www.shoeisha.co.jp/book/detail/9784798186627

## 環境構築

### 初回

```bash
# PostgreSQL のコンテナを起動する
docker run --name tatujin-db-playground -e POSTGRES_PASSWORD=password postgres

# コンテナ内の postgres データベースに postgres ユーザーで接続する
docker exec -it tatujin-db-playground psql -U postgres -d postgres

# データベースの作成
CREATE DATABASE playground;

# コンテナ内の playground データベースに postgres ユーザーで接続する
docker exec -it tatujin-db-playground psql -U postgres -d playground
```

### 2 回目以降

```bash
# PostgreSQL のコンテナを再起動する
docker start -ai tatujin-db-playground

# コンテナ内の playground データベースに postgres ユーザーで接続する
docker exec -it tatujin-db-playground psql -U postgres -d playground
```

## フォーマット

```bash
sqlfluff fix practice/foo.sql
```
