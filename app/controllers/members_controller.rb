class MembersController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html

  def index
    @q = User.search(params[:q])
    @members = @q.result().page(params[:page]).per_page(PER_PAGE)
  end

  def create
    flash[:notice] = t("labels.user_added_succesfully") if member.save
    respond_with(member, location: members_url)
  end

  def update
    flash[:notice] = t("labels.user_updated_succesfully") if member.update_attributes(params[:user])
    respond_with(member, location: members_url)
  end

  def destroy
    member.destroy
    flash[:alert] = t("labels.user_deleted_succesfully")
    respond_with(member, location: members_url)
  end

  private
    def member
      @member ||= params[:id] ? User.find(params[:id]) : User.new(params[:user])
    end
    helper_method :member

end
