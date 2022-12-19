class EntriesController < ApplicationController
  before_action :set_entry, only: %i[ show edit update destroy ]
    before_action :authenticate_user!

  # GET /entries or /entries.json
  def index
    @entries = Entry.where(user_id: current_user.id)
  end

  # GET /entries/1 or /entries/1.json
  def show
    if @entry.user != current_user
      render json: { message: "Not authorized to see this entry"}, status: :forbidden
    end
  end

  # GET /entries/new
  def new
    @entry = Entry.new
  end

  # GET /entries/1/edit
  def edit
    if @entry.user != current_user
      render json: { message: "Not authorized to edit this entry"}, status: :forbidden
    end
  end

  # POST /entries or /entries.json
  def create
    @entry = Entry.new(entry_params)
    @entry.user = current_user
    @entry.weather = GetWeatherFromPlace.call(entry_params[:place])

    respond_to do |format|
      if @entry.save
        format.html { redirect_to entry_url(@entry), notice: "Entry was successfully created." }
        format.json { render :show, status: :created, location: @entry }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entries/1 or /entries/1.json
  def update

    if @entry.user != current_user
      render json: { message: "Not authorized to edit this entry"}, status: :forbidden
    end

    respond_to do |format|
      if @entry.update(entry_params)
        format.html { redirect_to entry_url(@entry), notice: "Entry was successfully updated." }
        format.json { render :show, status: :ok, location: @entry }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entries/1 or /entries/1.json
  def destroy

    if @entry.user != current_user
      render json: { message: "Not authorized to delete this entry"}, status: :forbidden
    end

    @entry.destroy

    respond_to do |format|
      format.html { redirect_to entries_url, notice: "Entry was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry
      @entry = Entry.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def entry_params
      params.require(:entry).permit(:title, :place, :note, :weather)
    end
end
