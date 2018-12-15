class AddBestToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :best, :boolean, default: false
    Answer.update_all(best: false)
    change_column :answers, :best, :boolean, default: false, null: false
  end
end
