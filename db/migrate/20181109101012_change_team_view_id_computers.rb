class ChangeTeamViewIdComputers < ActiveRecord::Migration[5.1]
  def change
    Computer.find_each do |computer|
      team_id = (computer.teamview_id).gsub '-', ' '
      computer.update_attributes(teamview_id: team_id)
    end
  end
end
