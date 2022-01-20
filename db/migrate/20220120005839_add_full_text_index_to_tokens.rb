class AddFullTextIndexToTokens < ActiveRecord::Migration[6.1]
  def up
    execute 'ALTER TABLE tokens ADD FULLTEXT INDEX name_description_index (name, description) WITH PARSER ngram;'
  end

  def down
    execute 'DROP INDEX name_description_index ON tokens'
  end
end
