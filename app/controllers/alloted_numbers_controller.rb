class AllotedNumbersController < ApplicationController

  # GET /alloted_numbers
  def index
    @alloted_numbers = AllotedNumber.all

    render json: @alloted_numbers, each_serializer: AllotedNumberSerializer
  end

  # POST /alloted_numbers
  def create
    @alloted_number = AllotedNumber.new(alloted_number_params)

    if @alloted_number.save
      render json: @alloted_number, serializer: AllotedNumberSerializer, status: :created, location: @alloted_number
    else
      render json: @alloted_number.errors, status: :unprocessable_entity
    end
  end

  private

    # Only allow a trusted parameter "white list" through.
    def alloted_number_params
      params.require(:alloted_number).permit(:first_name, :last_name, :number)
    end
end
