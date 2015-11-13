class HiddenBooleanShouldDefaultToFalse < ActiveRecord::Migration
  def change
    change_column_default :collections, :hidden, false
    Collection.where(hidden: nil).update_all(hidden: false)
    change_column_null :collections, :hidden, false
  end
end
