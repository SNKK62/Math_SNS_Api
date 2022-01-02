
class Api::V1::UsersController < ApplicationController
  include Rails.application.routes.url_helpers
  skip_before_action :verify_authenticity_token



  def show
    user = User.find(params[:id])
    render json: {user: user, followings: user.followings.count, followers: user.followers.count},methods: [:image_url]
  end
 
  def index 
    users = User.all.order(updated_at: :DESC)
    render json: {users: users}, methods: [:follower_count,:following_count,:problem_count,:solution_count,:image_url]
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
    times = params[:times].to_i
    ifend = User.where('name LIKE ?', '%'+query+'%').length < 10*times+10
    users = User.where('name LIKE ?', '%'+query+'%').order(updated_at: :DESC).limit(10).offset(10*times)
    render json: {user: users, ifend: ifend},methods: [:follower_count,:following_count,:problem_count,:solution_count,:image_url]
  end

  def search_none
    times = params[:times].to_i
    users = User.order(updated_at: :DESC).limit(10).offset(10*times)
    ifend = User.all.length < 10*times+10
    render json: {user: users, ifend: ifend}, methods: [:follower_count, :following_count,:problem_count, :solution_count,:image_url]
  end

  def logged_in
    iflog = logged_in? ? true : false
    current_id = iflog ? current_user.id : -1
    user_image = iflog ? url_for(current_user.image) : ''
    user_name = iflog ? current_user.name : ''
    render json: {bool: iflog, id: current_id, image: user_image,name: user_name}
  end

  def followers 
    user = User.find(params[:id])
    followers = user.followers
    render json: {user: followers, user_name: user.name}, methods: [:follower_count, :following_count,:problem_count, :solution_count,:image_url]
  end

  def followings 
    user = User.find(params[:id])
    followings = user.followings
    render json: {user: followings, user_name: user.name}, methods: [:follower_count, :following_count,:problem_count, :solution_count,:image_url]
  end

  def like_problems
    times = params[:times].to_i
    problems = current_user.like_problem.order(updated_at: :DESC).limit(15).offset(15*times)
    ifend = current_user.like_problem.count < 15*times+15
    render json: {problem: problems, ifend: ifend}, methods: [:plike_count,:user_name,:user_image]
  end

  def like_solutions
    times = params[:times].to_i
    solutions = current_user.like_solution.order(updated_at: :DESC).limit(15).offset(15*times)
    ifend = current_user.like_solution.count < 15*times+15
    render json: {solution: solutions, ifend: ifend}, methods: [:category,:user_name,:slike_count, :user_image]
  end

  private
    def user_params
      params.require(:user).permit(:name,:password,:password_confirmation,:image,:description)
    end

end
