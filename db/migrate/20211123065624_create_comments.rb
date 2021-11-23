# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :blog, comment: 'ブログ記事', null: false
      t.references :user, comment: 'コメント者', null: false
      t.text :document, comment: 'コメント', null: false
      t.datetime :published_dt, null: false
      t.timestamps
    end
  end
end
