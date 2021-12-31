class Api::V1::SolutionsController < ApplicationController

    def index
        solution = Solution.find(params[:id])
        render json: {solution: solution}
    end

    def show
        solution = Solution.find(params[:id])
        user = solution.user
        user_name = user.name
        user_image = user.image_url
        render json: {problem: solution, user_name: user_name, user_image: user_image}, methods: [:image1s_url, :image2s_url, :image3s_url,:slike_count]
    end

    def create
        solution = current_user.solutions.new(solution_params.except(:image1,:image2,:image3))
        solution[:problem_id] = params[:id]
        if solution_params[:image1] != ''
            solution.image1.attach(solution_params[:image1])
        end
        if solution_params[:image2] != ''
            solution.image2.attach(solution_params[:image2])
        end
        if solution_params[:image3] != ''
            solution.image3.attach(solution_params[:image3])
        end
        if solution.save
            render json: {id: solution.id}
        else
            render json: {error: solution.errors}, status: 422
        end
    end

    def update
        solution = Solution.find(params[:id])
        if solution.update(solution_params.except(:image1,:image2,:image3))
            if solution_params[:image1] == '' && solution.image1.attached? 
                solution.image1.purge 
            elsif solution_params[:image1] != ''
                if solution_params[:image1] == '1'
                elsif solution.image1.attached?
                    solution.image1.purge
                    solution.image1.attach(solution_params[:image1])
                else
                    solution.image1.attach(solution_params[:image1])
                end
            end
            
            if solution_params[:image2] == '' && solution.image2.attached?
                solution.image2.purge 
            elsif solution_params[:image2] != '' 
                if solution_params[:image2] == '2'
                elsif solution.image2.attached?
                    solution.image2.purge
                    solution.image2.attach(solution_params[:image2])
                else
                    solution.image2.attach(solution_params[:image2])
                end
            end
            if solution_params[:image3] == '' && solution.image3.attached?
                solution.image3.purge 
            elsif solution_params[:image3] != '' 
                if solution_params[:image3] == '3'
                elsif solution.image3.attached?
                    solution.image3.purge
                    solution.image3.attach(solution_params[:image3])
                else 
                    solution.image3.attach(solution_params[:image3])
                end
            end
                
            render json: {problem: solution}
        else
            render json: {error: solution.errors}, status: 422
        end
    end
    
    def destroy
        solution = Solution.find(params[:id])
        if solution.destroy
            render json: {message: '削除しました'}
        else
            render json: {error: solution.errors}, status: 422
        end
    end

    def search 
        times =params[:times].to_i
        problem = Problem.find(params[:id])
        solutions = problem.solutions.order(updated_at: :DESC).limit(10).offset(10*times)
        ifend = problem.solutions.length < 10*times+10
        render json: {solution: solutions, ifend: ifend}, methods: [:user_image,:user_name,:slike_count]
    end

    private
        def solution_params
            params.require(:solution).permit(:description,:image1,:image2,:image3)
        end
end
