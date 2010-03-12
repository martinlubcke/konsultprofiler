class LoginController < ApplicationController
  before_filter :authenticate
  
  def index
    redirect_to profiles_path
  end
end
