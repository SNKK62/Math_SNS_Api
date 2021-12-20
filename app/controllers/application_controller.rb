class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    after_action :set_csrf_token
    include ActionController::Cookies
    include SessionsHelper
    include ActionController::RequestForgeryProtection
#   skip_before_action :verify_authenticity_token

    def set_csrf_token
        response.set_header('CSRF-TOKEN', form_authenticity_token)
    end
end
