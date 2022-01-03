class Api::V1::LikesController < ApplicationController
skip_before_action :verify_authenticity_token

    def problem_create
        problem = Problem.find(params[:id])
        current_user.plike(problem)
        render json: {message: 'success like problem'}
    end
    
    def problem_destroy
        problem = Problem.find(params[:id])
        current_user.punlike(problem)
        render json: {message: 'success unlike problem'}
    end

    def ifplike
        problem = Problem.find(params[:id])
        iflike = current_user.plike?(problem)
        render json: {iflike: iflike}
    end

    def solution_create
        solution = Solution.find(params[:id])
        current_user.slike(solution)
        render json: {message: 'success like solution'}
    end

    def solution_destroy
        solution = Solution.find(params[:id])
        current_user.sunlike(solution)
        render json: {message: 'success unlike solution'}
    end

    def ifslike
        solution = Solution.find(params[:id])
        iflike = current_user.slike?(solution)
        render json: {iflike: iflike}
    end
end
