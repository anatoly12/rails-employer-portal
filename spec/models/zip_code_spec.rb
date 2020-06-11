require "rails_helper"

RSpec.describe ZipCode, type: :model do
  let(:zip) { subject.zip }
  subject { create :zip_code }

  it "uses cache" do
    zip_code = ZipCode[zip]
    ZipCode.dataset.delete
    expect(ZipCode[zip]).to be(zip_code)
    ZipCode.cache_delete_pk(zip)
    expect(ZipCode[zip]).to be_nil
  end
end
