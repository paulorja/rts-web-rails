class EventBuildingUp < ActiveRecord::Base
  belongs_to :event
  belongs_to :cell
end
