class User < ApplicationRecord
    include Rails.application.routes.url_helpers

    attr_accessor :remember_token
    has_one_attached :image

    validates :name, presence: true, length: {maximum: 30}, uniqueness: true, allow_nil: true
    has_secure_password
    validates :password, presence: true, length: {minimum: 6},allow_nil: true
    validates :password_confirmation, presence: true, length: {minimum: 6}, allow_nil: true

    has_many :relationships, dependent: :destroy
    has_many :followings, through: :relationships, source: :follow
    has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id', dependent: :destroy
    has_many :followers, through: :reverse_of_relationships, source: :user

    has_many :problems, dependent: :destroy
    has_many :solutions, dependent: :destroy
    has_many :comments, dependent: :destroy

    has_many :likes, dependent: :destroy
    has_many :like_problem, through: :likes, source: :problem
    has_many :like_solution, through: :likes, source: :solution

    def problem_count
        problems.count
    end

    def solution_count
        solutions.count
    end
     
    def follower_count
        followers.count
    end

    def following_count
        followings.count
    end


    def image_url
        # 紐づいている画像のURLを取得する
        image.attached? ? url_for(image) : nil
        # image.url
      end

    def follow(other_user)
        unless self == other_user
            self.relationships.find_or_create_by(follow_id: other_user.id)
        end
    end

    def unfollow(other_user)
        relationship = self.relationships.find_by(follow_id: other_user.id)
        relationship.destroy if relationship
    end

    def following?(other_user)
        self.followings.include?(other_user)
    end
    
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    def User.new_token
        SecureRandom.urlsafe_base64
    end

    def remember 
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    def authenticated?(remember_token)
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    def forget
        update_attribute(:remember_digest,nil)
    end

    def plike(problem)
        likes.find_or_create_by(problem: problem)
    end

    def plike?(problem)
        like_problem.include?(problem)
    end

    def punlike(problem)
        like_problem.delete(problem)
    end

    def slike(solution)
        likes.find_or_create_by(solution: solution)
    end

    def slike?(solution)
        like_solution.include?(solution)
    end

    def sunlike(solution)
        like_solution.delete(solution)
    end
end
