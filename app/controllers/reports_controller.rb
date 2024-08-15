class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    render plain: "OK"
  end
end
