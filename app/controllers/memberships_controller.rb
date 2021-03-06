class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update, :destroy]

  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  def approve_application
    membership = Membership.find(params[:id])
    membership.confirmed = true
    membership.save

    redirect_to beer_club_path(membership.beer_club), notice: "Application approved!"
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    @beer_clubs = Array.new()

    all_clubs = BeerClub.all
    user_memberships = User.find_by(id:current_user).beer_clubs

    all_clubs.each do |club|
      if not user_memberships.include? club
        @beer_clubs.push(club)
      end
    end

  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships
  # POST /memberships.json
  def create
    @membership = Membership.new(membership_params)
    @membership.user_id = current_user.id
    @beer_clubs = BeerClub.all

    respond_to do |format|
      if @membership.valid?
        @membership.save
        format.html { redirect_to beer_club_path(@membership.beer_club_id), notice: "Your application has been sent!" }
        format.json { render :show, status: :created, location: @membership }
      else
        format.html { render :new }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    beer_club_name = BeerClub.find_by(id: @membership.beer_club_id).name
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to user_path(current_user), notice: "Membership in #{beer_club_name} ended." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_params
      params.require(:membership).permit(:beer_club_id, :user_id)
    end
end
