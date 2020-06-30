require "rails_helper"

describe CssClassHelper do
  describe "#text_field_class" do
    subject { helper.text_field_class(has_error).split " " }

    context "without error" do
      let(:has_error) { false }

      it { is_expected.to contain_exactly "appearance-none", "border-b", "w-full", "py-1", "focus:outline-none", "text-blue-500", "focus:text-blue-800", "focus:border-blue-800" }
    end

    context "with error" do
      let(:has_error) { true }

      it { is_expected.to contain_exactly "appearance-none", "border-b", "w-full", "py-1", "focus:outline-none", "text-red-500", "border-red-300", "focus:text-red-800", "focus:border-red-800", "placeholder-red-300" }
    end
  end

  describe "#text_area_class" do
    subject { helper.text_area_class(has_error).split " " }

    context "without error" do
      let(:has_error) { false }

      it { is_expected.to contain_exactly "appearance-none", "border", "w-full", "py-1", "focus:outline-none", "text-blue-500", "focus:text-blue-800", "focus:border-blue-800" }
    end

    context "with error" do
      let(:has_error) { true }

      it { is_expected.to contain_exactly "appearance-none", "border", "w-full", "py-1", "focus:outline-none", "text-red-500", "border-red-300", "focus:text-red-800", "focus:border-red-800", "placeholder-red-300" }
    end
  end

  describe "#select_field_class" do
    subject { helper.select_field_class(has_error).split " " }

    context "without error" do
      let(:has_error) { false }

      it { is_expected.to contain_exactly "bg-white", "border-b", "w-full", "py-1", "focus:outline-none", "text-blue-500", "focus:text-blue-800", "focus:border-blue-800" }
    end

    context "with error" do
      let(:has_error) { true }

      it { is_expected.to contain_exactly "bg-white", "border-b", "w-full", "py-1", "focus:outline-none", "text-red-500", "border-red-300", "focus:text-red-800", "focus:border-red-800", "placeholder-red-300" }
    end
  end
end
