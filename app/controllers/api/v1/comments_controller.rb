class Api::V1::CommentsController < ApplicationController
    def show
        comment = Comment.find(params[:id])
        user = comment.user
        user_name = user.name
        user_image = user.image_url
        render json: {comment: comment, user_name: user_name, user_image: user_image}, methods: [:image_comment_url]
    end

    def problem_create
        comment = current_user.comments.new(comment_params.except(:image))
        comment[:problem_id] = params[:id]
        if comment.save
            if comment_params[:image] != ''
                comment.image.attach(comment_params[:image])
            end
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
            if comment_params[:image] != ''
                comment.image.attach(comment_params[:image])
            end
            render json: {id: comment.id}
        else
            render json: {error: comment.errors}, status: 422
        end
    end

    def update
        comment = Comment.find(params[:id])
        if comment.update_attribute(:text, comment_params[:text])
            if comment_params[:image] == '' && comment.image.attached?
                comment.image.purge
            elsif comment_params[:image] ==  'keep'
            elsif comment_params[:image] != '' && comment.image.attached?
                comment.image.purge
                comment.image.attach(comment_params[:image])
            elsif comment_params[:image] != '' && !comment.image.attached?
                comment.image.attach(comment_params[:image])
            end
            render json: {comment: comment}
        else
            puts 'a'
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

    private
    def comment_params
        params.require(:comment).permit(:text, :image)
    end
end
