require "rails_helper"

RSpec.describe ZipCode, type: :model do
  let(:zip) { Faker::Address.zip_code }
  let(:city) { Faker::Address.city }
  let(:state) { Faker::Address.state_abbr }
  let(:lat) { Faker::Address.latitude }
  let(:long) { Faker::Address.longitude }
  let(:point) { "POINT(#{lat} #{long})" }
  let(:geopoint) { Sequel.function(:GeomFromText, point) }

  it "uses cache" do
    ZipCode.create(zip: zip, city: city, state: state, geopoint: geopoint)
    zip_code = ZipCode[zip]
    ZipCode.dataset.delete
    expect(ZipCode[zip]).to be(zip_code)
    ZipCode.cache_delete_pk(zip)
    expect(ZipCode[zip]).to be_nil
  end
end
