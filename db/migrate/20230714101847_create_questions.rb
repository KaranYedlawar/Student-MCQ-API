class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.string :ques
      t.string :correct_answer
      t.string :difficulty_level
      t.string :language

      t.timestamps
    end
  end
end
