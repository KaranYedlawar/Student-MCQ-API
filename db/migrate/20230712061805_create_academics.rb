class CreateAcademics < ActiveRecord::Migration[7.0]
  def change
    create_table :academics do |t|
      t.string :college_name
      t.string :career_goals
      t.string :known_languages
      t.string :other_languages
      t.boolean :currently_working
      t.string :specialization
      t.string :total_experience
      t.boolean :availability
      t.references :user, null: false, foreign_key: true, unique: true
      t.references :interest, null: false, foreign_key: true
      t.references :qualification, null: false, foreign_key: true
      t.timestamps
    end
  end
end
