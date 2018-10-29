class ApplicationController < ActionController::Base
  helper AuthHelper

  protect_from_forgery with: :exception
end
