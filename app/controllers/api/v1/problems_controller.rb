class Api::V1::ProblemsController < ApplicationController
    def index
        problem = Problem.find(params[:id])
        render json: {problem: problem}
    end

    def show
        problem = Problem.find(params[:id])
        user = problem.user
        user_name = user.name
        user_image = user.image_url
        render json: {problem: problem, user_name: user_name, user_image: user_image}, methods: [:image1_url, :image2_url, :image3_url, :plike_count]
    end

    def create
        problem = current_user.problems.new(problem_params.except(:image1,:image2,:image3))
        if problem_params[:image1] != ''
            problem.image1.attach(problem_params[:image1])
        end
        if problem_params[:image2] != ''
            problem.image2.attach(problem_params[:image2])
        end
        if problem_params[:image3] != ''
            problem.image3.attach(problem_params[:image3])
        end
        if problem.save
            render json: {id: problem.id}
        else
            render json: {error: problem.errors}, status: 422
        end
    end

    def update
        problem = Problem.find(params[:id])
        if problem.update(problem_params.except(:image1,:image2,:image3))
            if problem_params[:image1] == '' && problem.image1.attached? 
                problem.image1.purge 
            elsif problem_params[:image1] != ''
                if problem_params[:image1] == '1'
                elsif problem.image1.attached?
                    problem.image1.purge
                    problem.image1.attach(problem_params[:image1])
                else
                    problem.image1.attach(problem_params[:image1])
                end
            end
            
            if problem_params[:image2] == '' && problem.image2.attached?
                problem.image2.purge 
            elsif problem_params[:image2] != '' 
                if problem_params[:image2] == '2'
                elsif problem.image2.attached?
                    problem.image2.purge
                    problem.image2.attach(problem_params[:image2])
                else
                    problem.image2.attach(problem_params[:image2])
                end
            end
            if problem_params[:image3] == '' && problem.image3.attached?
                problem.image3.purge 
            elsif problem_params[:image3] != '' 
                if problem_params[:image3] == '3'
                elsif problem.image3.attached?
                    problem.image3.purge
                    problem.image3.attach(problem_params[:image3])
                else 
                    problem.image3.attach(problem_params[:image3])
                end
            end
                
            render json: {problem: problem}
        else
            render json: {error: problem.errors}, status: 422
        end
    end
    
    def destroy
        problem = Problem.find(params[:id])
        if problem.destroy
            render json: {message: '削除しました'}
        else
            render json: {error: problem.errors}, status: 422
        end
    end

    def search
        query = params[:category]
        times = params[:times].to_i
        ifend = Problem.where('category LIKE ?', '%'+query+'%').order(updated_at: :DESC).length < 10*times+10
        problems = Problem.where('category LIKE ?', '%'+query+'%').limit(10).offset(10*times)
        render json: {problem: problems, ifend: ifend},methods: [:user_image,:user_name,:plike_count]
    end

    def search_none
        times = params[:times].to_i
        problems = Problem.limit(10).offset(10*times)
        ifend = Problem.all.order(updated_at: :DESC).length < 10*times+10
        render json: {problem: problems, ifend: ifend}, methods: [:user_image,:user_name,:plike_count]
    end

    def user_problem
        times = params[:times].to_i
        user = User.find(params[:id])
        ifend = user.problems.length < 10*times+10
        problems = user.problems.order(updated_at: :DESC).limit(10).offset(10*times)
        render json: {problem: problems, ifend: ifend}, methods: [:user_name,:plike_count]
    end

    private
        def problem_params
            params.require(:problem).permit(:image1, :image2, :image3, :description, :category)
        end
end
