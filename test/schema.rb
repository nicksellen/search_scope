ActiveRecord::Schema.define(:version => 0) do
  create_table :bikes, :force => true do |t|
    t.string :manufacturer
    t.string :model
  end
  create_table :insults, :force => true do |t|
    t.string :content
    t.integer :offensiveness
  end
end
