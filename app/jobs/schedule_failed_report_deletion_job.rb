class ScheduleFailedReportDeletionJob < ApplicationJob
  queue_as :default

  def perform(report)
    report.destroy!
  end
end
