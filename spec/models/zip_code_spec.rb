require "rails_helper"

RSpec.describe ZipCode, type: :model do
  it "uses cache" do
    ZipCode.create(
      zip: "10001",
      city: "New York",
      state: "NY",
      geopoint: Sequel.function(:GeomFromText, "POINT(40.750742 -73.99653)"),
    )
    zip_code = ZipCode["10001"]
    ZipCode.dataset.delete
    expect(ZipCode["10001"]).to be(zip_code)
  end
end
