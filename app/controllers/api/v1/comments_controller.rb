class Api::V1::CommentsController < ApplicationController
skip_before_action :verify_authenticity_token

    def show
        comment = Comment.find(params[:id])
        user = comment.user
        user_name = user.name
        user_image = user.image_url
        render json: {comment: comment, user_name: user_name, user_image: user_image}
    end

    def problem_create
        comment = current_user.comments.new(comment_params.except(:image))
        comment[:problem_id] = params[:id]
        if comment.save
            render json: {id: comment.id}
        else
            puts comment.errors.full_messages
            render json: {error: comment.errors}, status: 422
        end
    end

    def solution_create
        comment = current_user.comments.new(comment_params.except(:image))
        comment[:solution_id] = params[:id]
        if comment.save
            render json: {id: comment.id}
        else
            render json: {error: comment.errors}, status: 422
        end
    end

    def update
        comment = Comment.find(params[:id])
        if comment.update_attribute(:text, comment_params[:text])
            render json: {comment: comment}
        else
            render json: {message: comment.errors}, status: 422
        end
    end

    def destroy
        comment = Comment.find(params[:id])
        if comment.destroy
            render json: {message: '削除しました'}
        else
            render json: {error: comment.errors}, status: 422
        end
    end
    def search_from_problem 
        times =params[:times].to_i
        problem = Problem.find(params[:id])
        comments = problem.comments.order(updated_at: :DESC).limit(10).offset(10*times)
        ifend = problem.comments.length < 10*times+10
        render json: {comment: comments, ifend: ifend}, methods: [:user_image,:user_name]
    end
    def search_from_solution 
        times =params[:times].to_i
        solution = Solution.find(params[:id])
        comments = solution.comments.order(updated_at: :DESC).limit(10).offset(10*times)
        ifend = solution.comments.length < 10*times+10
        render json: {comment: comments, ifend: ifend}, methods: [:user_image,:user_name]
    end

    private
    def comment_params
        params.require(:comment).permit(:text)
    end
end
