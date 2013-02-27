# This migration comes from coursewareable (originally 20130227174547)
class FixAllowedSpaceIntegerSizeForCoursewareablePlan < ActiveRecord::Migration
  def change
    change_column :coursewareable_plans, :allowed_space, :integer, :limit => 8
    change_column :coursewareable_plans, :used_space, :integer, :limit => 8
  end
end
