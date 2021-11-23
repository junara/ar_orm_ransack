# README

「RansackのDSLはけっこうActiveRecordのORMでかけるよ」

## Database

`dbdoc/README.md`をご覧ください。

## Set up

模擬データ作成できます。

```shell
rails db:seed
```

## 比較

RansackのDSLをActiveRecordで書きます。 Ransack→ActiveRecordの順です。

### 紹介するDSL

* `*_eq`
* `*_not_eq`
* `*_in`
* `*_lt`
* `*_lteq`
* `*_gt`
* `*_gteq`
* `*_null`
* おまけ1 `*_gteq` and `*_lteq` (`BETWEEN`)
* おまけ2 enumフィールドの検索
### `*_eq`

等しいレコードを検索します。一番オーソドックスなものです。

* Ransack

```ruby
User.ransack(name_eq: 'Yajirobe').result
#=>  User Load (0.2ms)  SELECT "users".* FROM "users" WHERE "users"."name" = 'Yajirobe'
```

* ActiveRecord ORM

```ruby
User.where(name: 'Yajirobe')
#=>  User Load (0.2ms)  SELECT "users".* FROM "users" WHERE "users"."name" = 'Yajirobe'
```

INNER JOINをつかうならActiveRecord ORM一択。

```ruby
User.joins(blogs: :comments).merge(Comment.where(document: 'abc'))
#=>  User Load (0.3ms)  SELECT "users".* FROM "users" INNER JOIN "blogs" ON "blogs"."user_id" = "users"."id" INNER JOIN "comments" ON "comments"."blog_id" = "blogs"."id" WHERE "comments"."document" = ?  [["document", "abc"]]
```

#### Relationあり

Ransackを使ううま味はrelationがあるときですね。 Ransackほど簡単にかけないけど、ActiveRecordで`left_joins` と `merge`をつかうとかけます。

* Ransack

```ruby
User.ransack(blogs_comments_document_eq: 'abc').result
#=> User Load (0.2ms)  SELECT "users".* FROM "users" LEFT OUTER JOIN "blogs" ON "blogs"."user_id" = "users"."id" LEFT OUTER JOIN "comments" ON "comments"."blog_id" = "blogs"."id" WHERE "comments"."document" = 'abc'
```

* ActiveRecord

```ruby
User.left_joins(blogs: :comments).merge(Comment.where(document: 'abc'))
#=> User Load (0.3ms)  SELECT "users".* FROM "users" LEFT OUTER JOIN "blogs" ON "blogs"."user_id" = "users"."id" LEFT OUTER JOIN "comments" ON "comments"."blog_id" = "blogs"."id" WHERE "comments"."document" = ?  [["document", "abc"]]
```

### *_not_eq

`where.not`をつかうとかけます。

* ransack

```ruby
User.ransack(name_not_eq: 'Yajirobe').result
#=> User Load (0.2ms)  SELECT "users".* FROM "users" WHERE "users"."name" != 'Yajirobe'
```

* ActiveRecord ORM

```ruby
User.where.not(name: 'Yajirobe')
#=> User Load (0.2ms)  SELECT "users".* FROM "users" WHERE "users"."name" != ?  [["name", "Yajirobe"]]
```

### `*_in`

配列を直接渡すと自動的に IN句になります。

```ruby
User.ransack(name_in: ['Yajirobe', 'Raditz']).result
#=> User Load (0.2ms)  SELECT "users".* FROM "users" WHERE "users"."name" IN ('Yajirobe', 'Raditz')
```

```ruby
User.where(name: ['Yajirobe', 'Raditz'])
#=>User Load (0.2ms)  SELECT "users".* FROM "users" WHERE "users"."name" IN (?, ?)  [["name", "Yajirobe"], ["name", "Raditz"]]
```

### `*_lt`

Range オブジェクトを渡します。

#### Integer

```ruby
User.ransack(age_lt: 20).result
#=> User Load (0.2ms)  SELECT "users".* FROM "users" WHERE "users"."age" < 20
```

```ruby
User.where(age: ...20)
#=> User Load (0.2ms)  SELECT "users".* FROM "users" WHERE "users"."age" < ?  [["age", 20]]
```

#### Date

* ransack

```ruby
Blog.ransack(published_dt_lt: Date.new(2021, 1, 1)).result
#=> Blog Load (0.2ms)  SELECT "blogs".* FROM "blogs" WHERE "blogs"."published_dt" < '2021-01-01'
```

* ActiveRecord

```ruby
Blog.where(published_dt: ...Date.new(2021, 1, 1))
#=> Blog Load (0.1ms)  SELECT "blogs".* FROM "blogs" WHERE "blogs"."published_dt" < ?  [["published_dt", "2021-01-01"]]
```

### `*_lteq`

Range オブジェクトを渡します。

#### Integer

```ruby
User.ransack(age_lteq: 20).result
#=> User Load (0.2ms)  SELECT "users".* FROM "users" WHERE "users"."age" <= 20
```

```ruby
User.where(age: ..20)
#=> User Load (0.2ms)  SELECT "users".* FROM "users" WHERE "users"."age" <= ?  [["age", 20]]
```

#### Date

* ransack

```ruby
Blog.ransack(published_dt_lteq: Date.new(2021, 1, 1)).result
#=> Blog Load (0.2ms)  SELECT "blogs".* FROM "blogs" WHERE "blogs"."published_dt" <= '2021-01-01'
```

* ActiveRecord

```ruby
Blog.where(published_dt: ..Date.new(2021, 1, 1))
#=> Blog Load (0.2ms)  SELECT "blogs".* FROM "blogs" WHERE "blogs"."published_dt" <= ?  [["published_dt", "2021-01-01"]]
```

### `*_gteq` `*_gt`

`*_lteq` `*_lt` と同様なので省略

### `*_null`

* ransack

```ruby
User.ransack(name_null: true).result
#=> User Load (0.1ms)  SELECT "users".* FROM "users" WHERE "users"."name" IS NULL
```

* ActiveRecord

```ruby
User.where(name: nil)
#=> User Load (0.1ms)  SELECT "users".* FROM "users" WHERE "users"."name" IS NULL
```

### `*_gteq` and `*_lteq` (`BETWEEN`)

Range objectを渡すだけです。 これについては、ActiveRecordのほうがかなりすっきりかけます。

* ransack

```ruby
Blog.ransack(published_dt_gteq: Date.new(2020, 12, 1), published_dt_lteq: Date.new(2021, 1, 1)).result
#=> Blog Load (0.2ms)  SELECT "blogs".* FROM "blogs" WHERE ("blogs"."published_dt" >= '2020-12-01' AND "blogs"."published_dt" <= '2021-01-01')
```

* ActiveRecord

range`..`を渡すとBETWEENを発行してくれます。ransackよりもきれい。

```ruby
Blog.where(published_dt: Date.new(2020, 12, 1)..Date.new(2021, 1, 1))
#=> Blog Load (0.1ms)  SELECT "blogs".* FROM "blogs" WHERE "blogs"."published_dt" BETWEEN ? AND ?  [["published_dt", "2020-12-01"], ["published_dt", "2021-01-01"]]
```

### おまけ2 enumフィールドの検索

Ransackはenum使えないので、数値に変換するひつようあります。 しかし、ActiveRecordは当然ながら数値変換不要で検索できます。

* ransack

```ruby
User.ransack!(blogs_status_eq: Blog.statuses[:published]).result
#=> User Load (0.2ms)  SELECT "users".* FROM "users" LEFT OUTER JOIN "blogs" ON "blogs"."user_id" = "users"."id" WHERE "blogs"."status" = 2
```

* ActiveRecord

```ruby
User.left_joins(:blogs).merge(Blog.where(status: :published))
#=> User Load (0.3ms)  SELECT "users".* FROM "users" LEFT OUTER JOIN "blogs" ON "blogs"."user_id" = "users"."id" WHERE "blogs"."status" = ?  [["status", 2]]
```

