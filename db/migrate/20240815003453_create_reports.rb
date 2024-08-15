class CreateReports < ActiveRecord::Migration[7.2]
  def change
    create_enum :report_status, ["processing", "avaiable", "failed"]
    create_table :reports do |t|
      t.string :title
      t.enum :status, enum_type: :report_status, default: "processing", null: false
      t.string :failure_reason
      t.references :user
      t.timestamps
    end
  end
end
