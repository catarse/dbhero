require 'rails_helper'

RSpec.describe Dbhero::Dataclip, type: :model do
  context "Validations" do
    it{ is_expected.to validate_presence_of(:description) }
    it{ is_expected.to validate_presence_of(:raw_query) }
  end

  context "before create" do
    describe ".set_token" do
      subject { build(:dataclip) }

      it "token should be nil when clip is not persisted" do
        expect(subject.token).to be_nil
      end

      it "token should be present after create clip" do
        subject.save
        expect(subject.token).not_to be_nil
      end
    end
  end

  context ".ordered" do
    before do
      @clip_01 = create(:dataclip, updated_at: 2.days.ago )
      @clip_02 = create(:dataclip, updated_at: 1.days.ago )
      @clip_03 = create(:dataclip, updated_at: 4.days.ago )
    end

    subject { Dbhero::Dataclip.ordered }

    it do
      is_expected.to eq([@clip_02, @clip_01, @clip_03])
    end
  end

  context "#to_param" do
    let(:dataclip) { create(:dataclip) }
    subject { dataclip.to_param }

    it { is_expected.to eq(dataclip.token) }
  end

  context "#title" do
    let(:dataclip) { create(:dataclip, description: "title\ndescription\nfoo") }
    subject { dataclip.title }

    it { is_expected.to eq("title") }
  end

  context "#description_without_title" do
    let(:dataclip) { create(:dataclip, description: "title\ndescription\nfoo") }
    subject { dataclip.description_without_title }

    it { is_expected.to eq("description\nfoo") }
  end

  context "#csv_string" do
    let(:dataclip) { create(:dataclip, raw_query: "select 'foo'::text as bar, 'bar'::text as foo") }
    subject { dataclip.csv_string }

    it { is_expected.to eq("bar,foo\nfoo,bar\n")}
  end

  context "#total_rows" do
    let(:dataclip) { create(:dataclip, raw_query: "select foo.nest from (select unnest(ARRAY[1,2,3]) as nest) foo") }
    before { dataclip.query_result }
    subject { dataclip.total_rows }

    it { is_expected.to eq(3) }
  end

  context "#query_result" do
    context "executes raw_query and return they result on q_result" do
      let(:dataclip) { create(:dataclip, raw_query: "select 'foo'::text as bar, 'bar'::text as foo") }
      before { dataclip.query_result }
      subject { dataclip.q_result }

      it "should be kind of ActiveRecord::Result" do
        is_expected.to be_an_instance_of(ActiveRecord::Result)
      end

      it "explore on result set" do
        expect(subject.columns).to eq(["bar", "foo"])
        expect(subject.rows).to eq([["foo", "bar"]])
      end
    end

    context "test some security" do
      context "with truncate" do
        let(:dataclip) { create(:dataclip, raw_query: "TRUNCATE table dbhero_dataclips") }

        before do
          5.times { create(:dataclip) }
        end

        it "should not truncate table dataclips" do
          dataclip.query_result
          expect(Dbhero::Dataclip.count).to eq(6)
        end
      end

      context "with commit" do
        let(:dataclip) { create(:dataclip, raw_query: "TRUNCATE table dbhero_dataclips; commit;") }

        before do
          5.times { create(:dataclip) }
        end

        it "should not truncate table dataclips" do
          dataclip.query_result
          expect(Dbhero::Dataclip.count).to eq(6)
          expect(dataclip.errors.full_messages.to_sentence.match(/(PG\:\:SyntaxError\: ERROR)/)).not_to be_nil
        end
      end
    end
  end
end
