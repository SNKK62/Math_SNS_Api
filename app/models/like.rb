class Like < ApplicationRecord

    belongs_to :user 
    belongs_to :problem, optional: true
    belongs_to :solution, optional: true
end
