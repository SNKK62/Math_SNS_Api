class Api::V1::RelationshipsController < ApplicationController
    before_action :set_user

    def create
        following = current_user.follow(@user)
        if following.save
            # フォロー成功の処理
        else
            # フォロー失敗の処理
        end
    end

    def destroy
        following = current_user.unfollow(@user)
        if following.destroy
            # フォロー解除成功の処理
        else
            # フォロー解除失敗の処理
        end
    end

    private
    def set_user
        @user = User.find(params[:relationship][:follow_id])
    end
    
end
