# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name, comment: '氏名', null: false
      t.integer :age, comment: '年齢', null: false
      t.timestamps
    end
  end
end
