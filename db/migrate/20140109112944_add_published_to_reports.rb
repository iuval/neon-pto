class AddPublishedToReports < ActiveRecord::Migration
  def change
    add_column :reports, :published, :boolean, default: false

    Report.all.each do |r|
      r.published = true;
      r.save
    end
  end
end
