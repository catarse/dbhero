require 'rails_helper'

RSpec.shared_examples "user not authenticated" do
  let(:method_name) { :get }
  let(:options) { nil }

  before do
    allow(Dbhero).to receive(:authenticate).and_return(true)
    allow(controller).to receive(:_current_user).and_return(nil)
  end

  it "should raise forbidden error" do
    expect {
      send(method_name, *options)
    }.to redirect_to '/users/sign_in'
  end
end

RSpec.shared_examples "user authenticated" do
  let(:method_name) { :get }
  let(:options) { nil }
  let(:expect_method) { :be_success }

  before do
    current_user = double()
    allow(current_user).to receive(:email).and_return('foo@bar.com')
    allow(controller).to receive(:_current_user).and_return(current_user)
    allow(Dbhero).to receive(:authenticate).and_return(true)

    send(method_name, *options)
  end

  it("response should be success") { expect(response).to send(expect_method) }
end

RSpec.shared_examples "user authenticated match for custom role" do
  let(:method_name) { :get }
  let(:options) { nil }
  let(:expect_method) { :be_success }

  before do
    current_user = double()
    allow(current_user).to receive(:email).and_return('foo@bar.com')
    allow(current_user).to receive(:admin?).and_return(true)
    allow(controller).to receive(:_current_user).and_return(current_user)
    allow(Dbhero).to receive(:authenticate).and_return(true)
    allow(Dbhero).to receive(:custom_user_auth_condition).and_return(->(u){u.admin?})

    send(method_name, *options)
  end

  it("response should be success") { expect(response).to send(expect_method) }
end

RSpec.shared_examples "user authenticated don't match for custom role" do
  let(:method_name) { :get }
  let(:options) { nil }

  before do
    current_user = double()
    allow(current_user).to receive(:email).and_return('foo@bar.com')
    allow(current_user).to receive(:admin?).and_return(false)
    allow(controller).to receive(:_current_user).and_return(current_user)
    allow(Dbhero).to receive(:authenticate).and_return(true)
    allow(Dbhero).to receive(:custom_user_auth_condition).and_return(->(u){u.admin?})
  end

  it "should raise forbidden error" do
    expect {
      send(method_name, *options)
    }.to redirect_to '/users/sign_in'
  end
end

RSpec.shared_examples "disabled auth" do
  let(:method_name) { :get }
  let(:options) { nil }
  let(:expect_method) { :be_success }

  before do
    allow(Dbhero).to receive(:authenticate).and_return(false)
    allow(controller).to receive(:_current_user).and_return(nil)
    send(method_name, *options)
  end

  it("response should be success") { expect(response).to send(expect_method) }
end

RSpec.describe Dbhero::DataclipsController, type: :controller do
  routes { Dbhero::Engine.routes }

  describe "GET index" do
    describe "with enabled auth" do
      it_should_behave_like "user not authenticated" do
        let(:options) { :index }
      end

      it_should_behave_like "user authenticated" do
        let(:options) { :index }
      end

      it_should_behave_like "user authenticated match for custom role" do
        let(:options) { :index }
      end

      it_should_behave_like "user authenticated don't match for custom role" do
        let(:options) { :index }
      end
    end

    describe "with disabled auth" do
      it_should_behave_like "disabled auth" do
        let(:options) { :index }
      end
    end
  end

  describe "GET new" do
    describe "with enabled auth" do
      it_should_behave_like "user not authenticated" do
        let(:options) { :new }
      end

      it_should_behave_like "user authenticated" do
        let(:options) { :new }
      end

      it_should_behave_like "user authenticated match for custom role" do
        let(:options) { :new }
      end

      it_should_behave_like "user authenticated don't match for custom role" do
        let(:options) { :new }
      end
    end

    describe "with disabled auth" do
      it_should_behave_like "disabled auth" do
        let(:options) { :new }
      end
    end
  end

  describe "POST create" do
    describe "with enabled auth" do
      it_should_behave_like "user not authenticated" do
        let(:method_name) { :post }
        let(:options) { [:create, { dataclip: { description: "foo bar", raw_query: "select 'foo' as bar" } }] }
      end

      it_should_behave_like "user authenticated" do
        let(:method_name) { :post }
        let(:options) { [:create, { dataclip: { description: "foo bar", raw_query: "select 'foo' as bar" } }] }
        let(:expect_method) { :be_redirect }

        it { expect(Dbhero::Dataclip.find_by(description: 'foo bar')).not_to be_nil }
      end

      it_should_behave_like "user authenticated match for custom role" do
        let(:method_name) { :post }
        let(:options) { [:create, { dataclip: { description: "foo bar", raw_query: "select 'foo' as bar" } }] }
        let(:expect_method) { :be_redirect }

        it "find dataclip" do
          clip = Dbhero::Dataclip.find_by(description: 'foo bar')

          expect(clip.user).to eq(controller._current_user.email)
          expect(clip.description).to eq("foo bar")
          expect(clip.raw_query).to eq("select 'foo' as bar")
        end
      end

      it_should_behave_like "user authenticated don't match for custom role" do
        let(:method_name) { :post }
        let(:options) { [:create, { dataclip: { description: "foo bar", raw_query: "select 'foo' as bar" } }] }
      end
    end

    describe "with disabled auth" do
      it_should_behave_like "disabled auth" do
        let(:method_name) { :post }
        let(:options) { [:create, { dataclip: { description: "foo bar disabled", raw_query: "select 'foo' as bar" } }] }
        let(:expect_method) { :be_redirect }

        it "find dataclip" do
          clip = Dbhero::Dataclip.find_by(description: 'foo bar disabled')

          expect(clip.user).to be_nil
          expect(clip.description).to eq("foo bar disabled")
          expect(clip.raw_query).to eq("select 'foo' as bar")
        end
      end
    end
  end


  describe "GET edit" do
    describe "with enabled auth" do
      it_should_behave_like "user not authenticated" do
        let(:dataclip) { create(:dataclip) }
        let(:options) { [:edit, { id: dataclip.token}] }
      end

      it_should_behave_like "user authenticated" do
        let(:dataclip) { create(:dataclip) }
        let(:options) { [:edit, { id: dataclip.token}] }
      end

      it_should_behave_like "user authenticated match for custom role" do
        let(:dataclip) { create(:dataclip) }
        let(:options) { [:edit, { id: dataclip.token}] }
      end

      it_should_behave_like "user authenticated don't match for custom role" do
        let(:dataclip) { create(:dataclip) }
        let(:options) { [:edit, { id: dataclip.token}] }
      end
    end

    describe "with disabled auth" do
      it_should_behave_like "disabled auth" do
        let(:dataclip) { create(:dataclip) }
        let(:options) { [:edit, { id: dataclip.token}] }
      end
    end
  end

  describe "PUT update" do
    describe "with enabled auth" do
      it_should_behave_like "user not authenticated" do
        let(:method_name) { :post }
        let(:options) { [:create, { dataclip: { description: "foo bar", raw_query: "select 'foo' as bar" } }] }
      end

      it_should_behave_like "user authenticated" do
        let(:method_name) { :put }
        let(:dataclip) { create(:dataclip, {description: "foo bar", raw_query: "select 'foo' as bar"}) }
        let(:options) { [:update, id: dataclip.token, dataclip: { description: "updated" } ] }
        let(:expect_method) { :be_redirect }

        it "find dataclip" do
          clip = Dbhero::Dataclip.find_by(description: 'updated')

          expect(clip.description).to eq("updated")
          expect(clip.raw_query).to eq("select 'foo' as bar")
        end
      end

      it_should_behave_like "user authenticated match for custom role" do
        let(:method_name) { :put }
        let(:dataclip) { create(:dataclip, {description: "foo bar", raw_query: "select 'foo' as bar"}) }
        let(:options) { [:update, id: dataclip.token, dataclip: { description: "updated" }] }
        let(:expect_method) { :be_redirect }

        it "find dataclip" do
          clip = Dbhero::Dataclip.find_by(description: 'updated')

          expect(clip.description).to eq("updated")
          expect(clip.raw_query).to eq("select 'foo' as bar")
        end
      end

      it_should_behave_like "user authenticated don't match for custom role" do
        let(:method_name) { :put }
        let(:dataclip) { create(:dataclip, {description: "foo bar", raw_query: "select 'foo' as bar"}) }
        let(:options) { [:update, id: dataclip.token, dataclip: { description: "updated" }] }
        let(:expect_method) { :be_redirect }

        it "not update dataclip" do
          clip = Dbhero::Dataclip.find dataclip.id

          expect(clip.description).to eq("foo bar")
        end
      end
    end

    describe "with disabled auth" do
      it_should_behave_like "disabled auth" do
        let(:method_name) { :put }
        let(:dataclip) { create(:dataclip, {description: "foo bar", raw_query: "select 'foo' as bar"}) }
        let(:options) { [:update, id: dataclip.token, dataclip: { description: "updated" }] }
        let(:expect_method) { :be_redirect }

        it "find dataclip" do
          clip = Dbhero::Dataclip.find_by(description: 'updated')

          expect(clip.description).to eq("updated")
          expect(clip.raw_query).to eq("select 'foo' as bar")
        end
      end
    end
  end
end
