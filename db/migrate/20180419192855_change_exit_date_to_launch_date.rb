class ChangeExitDateToLaunchDate < ActiveRecord::Migration[5.1]
  def change
    remove_column :vendor_vintages, :exit_date
    add_column :vendor_vintages, :launch_date, :date
  end
end
