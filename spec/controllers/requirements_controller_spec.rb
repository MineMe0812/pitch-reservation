require 'spec_helper'

describe RequirementsController, focus: true do
  before(:all) do
    @user = FactoryGirl.create(:admin)
    @app_config = FactoryGirl.create(:app_config)
  end
  after(:all) do
    @user.destroy
  end
  before(:each) do
    @controller.stub(:current_user).and_return(@user)
    @controller.stub(:first_time_user).and_return(nil)
    @controller.stub(:require_admin).and_return(true)
  end
  describe 'GET index' do
    before(:each) do
      @requirement = FactoryGirl.create(:requirement)
      get :index
    end
    # it "what does it redirect to?" do
    #   response.should redirect_to(catalog_path)
    # end
    it { should respond_with(:success) }
    it { should render_template(:index) }
    it { should_not set_the_flash }
    it 'should populate an array of all requirements' do
      expect(assigns(:requirements)).to eq([@requirement])
    end
  end
  describe 'GET #show' do
    it 'should assign the selected requirement to @requirement'
    it 'should render the :show view'
  end
  describe 'GET #new' do
    it 'should render the :new view'
    it 'assigns a new requirement to @requirement'

  end
  describe 'PUT #update' do
    context 'with valid attributes' do
    end
    context 'with invalid attributes' do
    end
  end
  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new requirement'
      it 'redirects to the show page for the new requirement'
      it 'flashes a success message'
    end
    context 'with invalid attributes' do
      it 'fails to save a new requirment'
      it 'redirects back to the :new view'
      it 'flashes errors'
    end
  end
  describe 'DELETE #destroy' do
    it 'assigns the selected requirement to @requirement'
    it 'removes @requirement from the database'
    it 'redirects to the :index view'
  end
end
