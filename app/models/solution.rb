class Solution < ApplicationRecord
    include Rails.application.routes.url_helpers

    has_one_attached :image1
    has_one_attached :image2
    has_one_attached :image3

    has_many :comments,dependent: :destroy
    belongs_to :user
    belongs_to :problem
    validates :user_id, presence: true
    validates :problem_id, presence: true

    has_many :likes, dependent: :destroy
    has_many :users, through: :likes

    def image1s_url
        # 紐づいている画像のURLを取得する
        image1.attached? ? url_for(image1) : ''
    end
    def image2s_url
        # 紐づいている画像のURLを取得する
        image2.attached? ? url_for(image2) : ''
    end
    def image3s_url
        # 紐づいている画像のURLを取得する
        image3.attached? ? url_for(image3) : ''
    end
    def user_image
        # user.image.attached? ? url_for(user.image) : ''
        user.image.url
    end
    def user_name
        user.name
    end

    def slike_count
        users.count
    end

    def category
        problem.category
    end
end
