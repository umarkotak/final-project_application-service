require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before :each do
    @user = create(:user)
    session[:user_id] = @user.id
  end

  describe "GET #index" do
    it "populates an array of all users" do
      user1 = create(:user, username: "umar1")
      user2 = create(:user, username: "umar2")
      
      get :index
      expect(assigns(:users)).to eq(User.all)
    end

    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    it "assigns the requested user to @user" do
      get :show, params: { id: @user }
      expect(assigns(:user)).to eq(@user)
    end

    it "renders the :show template" do
      get :show, params: { id: @user}
      expect(response).to render_template :show
    end

    it "redirect to @user if user try to show another user" do
      user1 = create(:user, username: "umar1")
      get :show, params: { id: user1 }
      expect(response).to redirect_to(@user)
    end
  end

  describe "GET #new" do

  end

  describe "GET #edit" do
    it "assigns the requested user to @user" do
      get :edit, params: { id: @user }
      expect(assigns(:user)).to eq(@user)
    end

    it "renders the :edit template" do
      get :edit, params: { id: @user}
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    it "assigns 50000 credit to new users" do
      expect(@user.credit).to eq 50000
    end

    it "saves the new user in the database" do
      expect {
        post :create, params: { user: attributes_for(:user, username: 'umar1') }
      }.to change(User, :count).by(1)
    end

    it "is redirected to login page" do
      post :create, params: { user: attributes_for(:user, username: 'umar1') }
      expect(response).to redirect_to(login_path)
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "locates the requested user" do

      end

      it "saves the new password" do
        patch :update, params: { id: @user, user: attributes_for(:user, password: 'newlongpassword', password_confirmation: 'newlongpassword') }
        @user.reload
        expect(@user.authenticate('newlongpassword')).to eq(@user)
      end

      it "redirects to user#index" do
        patch :update, params: { id: @user, user: attributes_for(:user) }
        expect(response).to redirect_to(user_path(assigns[:user]))
      end

      it "disables login with old password" do
        patch :update, params: { id: @user, user: attributes_for(:user, password: 'newlongpassword', password_confirmation: 'newlongpassword')}
        @user.reload
        expect(@user.authenticate('oldpassword')).to eq(false)
      end
    end

    context "with invalid attributes" do
      it "does not update the user in the database" do
        patch :update, params: { id: @user, user: attributes_for(:user, password: nil, password_confirmation: nil) }
        @user.reload
        expect(@user.authenticate(nil)).to eq(false)
      end

      it "re-renders the :edit template" do
        patch :update, params: { id: @user, user: attributes_for(:user, username: nil) }
        expect(response).to render_template :edit
      end
    end
  end

end
