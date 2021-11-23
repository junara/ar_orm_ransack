# frozen_string_literal: true

class CreateBlogs < ActiveRecord::Migration[6.1]
  def change
    create_table :blogs do |t|
      t.references :user, comment: '作成者', null: false
      t.date :published_dt, comment: '発行日'
      t.integer :status, comment: 'ステータス', null: false
      t.text :document, comment: '投稿', null: false
      t.timestamps
    end
  end
end
