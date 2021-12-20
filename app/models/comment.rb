class Comment < ApplicationRecord
    include Rails.application.routes.url_helpers
    has_one_attached :image
    belongs_to :user
    belongs_to :problem, optional: true
    belongs_to :solution, optional: true
    validates :user_id, presence: true
    
    def image_comment_url
        # 紐づいている画像のURLを取得する
        image.attached? ? url_for(image) : ''
    end
end
