class CellUnit < ActiveRecord::Base
  belongs_to :cell
  belongs_to :user
end
