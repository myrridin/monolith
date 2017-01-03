module V1
  class LeadersController < ApplicationController
    before_action :verify_club_id, only: :intake

    def intake
      leader = Leader.new(leader_params.merge(club_ids: [club_id]))

      if leader.save
        welcome_letter_for_leader(leader).save!
        render json: leader, status: 201
      else
        render json: { errors: leader.errors }, status: 422
      end
    end

    protected

    def club_id
      params[:club_id]
    end

    def verify_club_id
      return unless club_id.nil?
      render json: { errors: { club_id: ["can't be blank"] } }, status: 422
    end

    def leader_params
      params.permit(
        :name, :email, :gender, :year, :phone_number, :slack_username,
        :github_username, :twitter_username, :address
      )
    end

    def welcome_letter_for_leader(leader)
      Letter.new(
        name: leader.name,
        # This is the type for club leaders
        letter_type: '9002',
        # This is the type for welcome letter + 3oz of stickers
        what_to_send: '9005',
        address: leader.address
      )
    end
  end
end
