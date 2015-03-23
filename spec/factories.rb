FactoryGirl.define do
  factory :dataclip, class: Dbhero::Dataclip do
    description "Dummy query\nwich describes a dummy string and database version"
    raw_query "select 'dummy_foo' as dummy_bar, vesion() as db_version"
    private false
  end
end

