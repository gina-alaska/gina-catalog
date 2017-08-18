require "test_helper"

class Catalog::EntryExportsControllerTest < ActionController::TestCase
  def entry_export
    @entry_export ||= entry_exports :one
  end

  def test_create
    assert_difference('EntryExport.count') do
      post :create, entry_export: { collections: entry_export.collections, contacts: entry_export.contacts, data: entry_export.data, description: entry_export.description, description_chars: entry_export.description_chars, format_type: entry_export.format_type, info: entry_export.info, iso: entry_export.iso, limit: entry_export.limit, links: entry_export.links, location: entry_export.location, organizations: entry_export.organizations, serialized_search: entry_export.serialized_search.to_json, tags: entry_export.tags, title: entry_export.title, url: entry_export.url }
    end

    assert_redirected_to catalog_entry_export_path(assigns(:entry_export))
  end

  def test_show
    get :show, id: entry_export
    assert_response :success
  end

  def test_update
    put :update, id: entry_export, entry_export: { collections: entry_export.collections, contacts: entry_export.contacts, data: entry_export.data, description: entry_export.description, description_chars: entry_export.description_chars, format_type: entry_export.format_type, info: entry_export.info, iso: entry_export.iso, limit: entry_export.limit, links: entry_export.links, location: entry_export.location, organizations: entry_export.organizations, serialized_search: entry_export.serialized_search.to_json, tags: entry_export.tags, title: entry_export.title, url: entry_export.url }
  end

  test 'should get html exports' do
    get :download, format: 'html', id: entry_export.id

    assert_response :success
    assert_not_nil assigns(:entries)
    assert_not_nil assigns(:facets)
    assert_not_nil assigns(:search_params)
  end

  test 'should get csv exports' do
    get :download, format: 'csv', id: entry_export.id

    assert_response :success
    assert_not_nil assigns(:entries)
    assert_not_nil assigns(:facets)
    assert_not_nil assigns(:search_params)
  end
end
