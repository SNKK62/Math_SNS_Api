class Api::V1::SessionsController < ApplicationController
#   skip_before_action :verify_authenticity_token
skip_before_action :verify_authenticity_token

    def create
        user = User.find_by(name: params[:session][:name])
        puts params[:sessoin]
        if user && user.authenticate(params[:session][:password])
            #ログイン成功
            log_in user
            remember user
            render json: {id: user[:id]}
        else
            #ログイン失敗
            render json: {error: 'ログインできませんでした'}, status: 422
        end
    end

    def destroy
        log_out if logged_in?
        render json: {messages: 'ログアウトしました'}
    end

end
