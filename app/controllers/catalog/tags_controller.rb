class Catalog::TagsController < ApplicationController
  authorize_resource class: false
  before_action :load_tag, only: %i[show remove]

  def index
    @tags = current_portal.entries.tag_counts_on(:tags).order(:name).page(params[:page])
    if params[:q].present?
      @tags = @tags.where('name ilike ?', "%#{params[:q]}%")
    end

    respond_to do |format|
      format.html
    end
  end

  def search
    @tags = current_portal.entries.find_by_name(params[:query])

    respond_to do |format|
      format.json
    end
  end

  def show
    @entries = current_portal.entries.tagged_with(@tag.name).order(:title).page(params[:page]) unless @tag.nil?

    respond_to do |format|
      format.html
    end
  end

  def remove
    @entry = Entry.where(id: params[:entry_id]).first if params[:entry_id]

    if @entry.nil?
      return_path = catalog_tags_path
      current_portal.entries.tagged_with(@tag.to_s).each do |entry|
        entry.tag_list.remove(@tag.to_s)
        entry.save
      end
    else
      return_path = catalog_tag_path(@tag.name)
      @entry.tag_list.remove(@tag.to_s)
      @entry.save
    end

    respond_to do |format|
      format.html { redirect_to return_path }
    end
  end

  private

  def load_tag
    @tag = Entry.all_tags.find_by(name: params[:id])
  end
end
