class Api::V1::RelationshipsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
        user = User.find(params[:id])
        following = current_user.follow(user)
        if following.save
            render json: {message: 'success to follow'}
        else
            render json: {error: 'fail to follow'}
        end
    end

    def destroy
        user = User.find(params[:id])
        following = current_user.unfollow(user)
        if following.destroy
            render json: {message: 'success to unfollow'}
        else
            render json: {error: 'fail to unfollow'}
        end
    end

    def iffollow
        user = User.find(params[:id])
        follow = current_user.following?(user)
        render json: {follow: follow}
    end

    
    
end
