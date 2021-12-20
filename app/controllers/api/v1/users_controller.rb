
class Api::V1::UsersController < ApplicationController

  def show
    user = User.find(params[:id])
    render json: {user: user, followings: user.followings.count, followers: user.followers.count},methods: [:image_url]
  end
 
  def index 
    users = User.all 
    render json: {users: users}, methods: [:follower_count,:following_count,:problem_count]
  end

  def create
    user = User.new(user_params.except(:image))
    if user_params[:image]==''
      user.image.attach(io: File.open('public/newuserimage.png'),filename: 'newuserimage.png')
    else
      user.image.attach(user_params[:image])
    end
    if user.save
      log_in user
      remember user
      render json: {user: user }
    else
      puts user.errors.full_messages
      render json: {error: user.errors.full_messages}, status: 422
    end
  end

  def destroy
    user = User.find(params[:id])
    if user.destroy
      render json: {message: "削除しました"}
    else
      render json: {error: user.errors}, status: 422
    end
  end

  def update
    user = User.find(params[:id])
    
    if user.update(user_params.except(:image))
      if user_params[:image]=='default'
        user.image.attach(io: File.open('public/newuserimage.png'),filename: 'newuserimage.png')
      elsif user_params[:image]=='nondefault'
        
      else 
        user.image.attach(user_params[:image])
      end
      #編集成功の処理
      render json: {user: user, message: "編集に成功しました"}
    else
      #編集失敗の処理
      render json: {error: user.errors}, status: 422
    end
  end

  def search
    query = params[:name]
    times = params[:times]
    users = User.where('name = ?', query).limit(20).offset(20*times)
    render json: {user: users}

  end

  private
    def user_params
      params.require(:user).permit(:name,:password,:password_confirmation,:image)
    end

end
