class WelcomeController < ApplicationController

  skip_before_action :authenticate_user!
  def index
  end

  def faq
  end

  def services
  end


end
