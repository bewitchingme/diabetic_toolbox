class AddAttachmentReportDocumentToReports < ActiveRecord::Migration
  def self.up
    change_table :diabetic_toolbox_reports do |t|
      add_attachment :diabetic_toolbox_reports, :report_document
    end
  end

  def self.down
    remove_attachment :diabetic_toolbox_reports, :report_document
  end
end
