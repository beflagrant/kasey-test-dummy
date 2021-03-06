 require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/kasey/kases", type: :request do
  let(:kase) { create(:intake).kase }

  before do
    initialize_kasey
  end

  describe 'when not authenticated or authorized' do
    before do
      # authenticate! should redirect in all cases unless authenticated
      Kasey.configuration.authorize_function = ->(u,k) { true }
    end

    describe "GET /index" do
      it "does not render an unsuccessful response" do
        kase # exists
        get kasey.kases_url
        expect(response).not_to be_successful
      end
    end

    describe "GET /show" do
      it "does not render a successful response" do
        get kasey.kase_url(kase)
        expect(response).not_to be_successful
      end
    end

    describe "DELETE /destroy" do

      it "does not close the requested kase" do
        kase.review!

        delete kasey.kase_url(kase)
        expect(response).not_to be_successful
        expect(kase.reload.aasm.current_state).to equal(:reviewed)
      end
    end
  end

  describe 'when authenticated and authorized' do
    before { sign_in FactoryBot.create(:admin) }

    before do
      Kasey.configuration.authorize_function = ->(u,k) { true }
    end

    describe "GET /index" do
      it "renders a successful response" do
        kase # exists
        get kasey.kases_url
        expect(response).to be_successful
      end
    end

    describe "GET /show" do
      it "renders a successful response" do
        get kasey.kase_url(kase)
        expect(response).to be_successful
      end
    end

    describe "DELETE /destroy" do

      it "closes the requested kase" do
        kase.review!

        delete kasey.kase_url(kase)
        expect(kase.reload.aasm.current_state).to equal(:closed)
      end
    end
  end

  describe 'when authenticated but not authorized' do
    before { sign_in FactoryBot.create(:user) }

    before do
      Kasey.configuration.authorize_function = ->(u,k) { false }
    end

    describe "GET /index" do
      it "renders a successful response" do
        kase # exists
        get kasey.kases_url
        expect(response).to be_successful
      end
    end

    describe "GET /show" do
      it "renders a successful response" do
        get kasey.kase_url(kase)
        expect(response).not_to be_successful
      end
    end

    describe "DELETE /destroy" do

      it "closes the requested kase" do
        kase.review!

        delete kasey.kase_url(kase)
        expect(response).not_to be_successful
        expect(kase.reload.aasm.current_state).to equal(:reviewed)
      end
    end
  end
end
