require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "GET #new" do
    it "renders the :new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "GET #new_driver" do
    it "renders the :new_driver template" do
      get :new_driver
      expect(response).to render_template :new_driver
    end
  end

  describe "POST #create" do
    before :each do
      @umarkotak = create(:user, username: 'umarkotak', password: 'umarkotak', password_confirmation: 'umarkotak')
    end

    context "with valid username and password" do
      it "assigns user_id to session variables" do
        post :create, params: { username: 'umarkotak', password: 'umarkotak' }
        expect(session[:user_id]).to eq(@umarkotak.id)
      end

      it "redirects to users_path" do
        post :create, params: { username: 'umarkotak', password: 'umarkotak' }
        expect(response).to redirect_to users_path
      end
    end

    context "with invalid username and password" do
      it "redirects to login page" do
        post :create, params: { username: 'umarkotak', password: 'wrongpassword' }
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "POST #create_driver" do
    before :each do
      @umarkotakd = create(:driver, username: 'umarkotakd', password: 'umarkotak', password_confirmation: 'umarkotak')
    end

    context "with valid username and password" do
      it "assigns driver_id to session variables" do
        post :create_driver, params: { username: 'umarkotakd', password: 'umarkotak' }
        expect(session[:driver_id]).to eq(@umarkotakd.id)
      end

      it "redirects to drivers_path" do
        post :create_driver, params: { username: 'umarkotakd', password: 'umarkotak' }
        expect(response).to redirect_to drivers_path
      end
    end

    context "with invalid username and password" do
      it "redirects to login page" do
        post :create_driver, params: { username: 'umarkotakd', password: 'wrongpassword' }
        expect(response).to redirect_to login_driver_path
      end
    end
  end

  describe "DELETE #destroy" do
    before :each do
      @umarkotak = create(:user, username: 'umarkotak', password: 'umarkotak', password_confirmation: 'umarkotak')
      @umarkotakd = create(:driver, username: 'umarkotakd', password: 'umarkotak', password_confirmation: 'umarkotak')
    end

    it "removes user_id from session variables" do
      delete :destroy, params: { id: @umarkotak  }
      expect(session[:user_id]).to eq(nil)
    end

    it "removes driver_id from session variables" do
      delete :destroy, params: { id: @umarkotakd  }
      expect(session[:driver_id]).to eq(nil)
    end

    it "redirects user to login page" do
      delete :destroy, params: { id: @umarkotak }
      expect(response).to redirect_to login_path
    end
  end
end
