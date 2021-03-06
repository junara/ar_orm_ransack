# comments

## Description

コメント

<details>
<summary><strong>Table Definition</strong></summary>

```sql
CREATE TABLE "comments" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "blog_id" integer NOT NULL, "user_id" integer NOT NULL, "document" text NOT NULL, "published_dt" datetime NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL)
```

</details>

## Labels

`document`

## Columns

| Name | Type | Default | Nullable | Children | Parents | Comment |
| ---- | ---- | ------- | -------- | -------- | ------- | ------- |
| id | integer |  | false |  |  |  |
| blog_id | integer |  | false |  | [blogs](blogs.md) | ブログ |
| user_id | integer |  | false |  | [users](users.md) | コメント者 |
| document | text |  | false |  |  | コメント |
| published_dt | datetime |  | false |  |  | コメント日 |
| created_at | datetime(6) |  | false |  |  | 作成日時 |
| updated_at | datetime(6) |  | false |  |  | 更新日時 |

## Constraints

| Name | Type | Definition |
| ---- | ---- | ---------- |
| id | PRIMARY KEY | PRIMARY KEY (id) |

## Indexes

| Name | Definition |
| ---- | ---------- |
| index_comments_on_user_id | CREATE INDEX "index_comments_on_user_id" ON "comments" ("user_id") |
| index_comments_on_blog_id | CREATE INDEX "index_comments_on_blog_id" ON "comments" ("blog_id") |

## Relations

![er](comments.svg)

---

> Generated by [tbls](https://github.com/k1LoW/tbls)
