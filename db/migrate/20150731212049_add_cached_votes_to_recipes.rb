class AddCachedVotesToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :cached_votes_total, :integer
    add_column :recipes, :cached_votes_score, :integer
    add_column :recipes, :cached_votes_up, :integer
    add_column :recipes, :cached_votes_down, :integer
    add_column :recipes, :cached_weighted_score, :integer
    add_column :recipes, :cached_weighted_total, :integer
    add_column :recipes, :cached_weighted_average, :float
    add_index  :recipes, :cached_votes_total
    add_index  :recipes, :cached_votes_score
    add_index  :recipes, :cached_votes_up
    add_index  :recipes, :cached_votes_down
    add_index  :recipes, :cached_weighted_score
    add_index  :recipes, :cached_weighted_total
    add_index  :recipes, :cached_weighted_average
  end
end
