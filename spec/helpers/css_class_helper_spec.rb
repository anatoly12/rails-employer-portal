require "rails_helper"

describe CssClassHelper do
  describe "#text_field_class" do
    subject { helper.text_field_class(has_error).split " " }

    context "without error" do
      let(:has_error) { false }

      it { is_expected.to contain_exactly "appearance-none", "border-b", "w-full", "py-1", "select-none", "focus:outline-none", "text-blue-500", "focus:text-blue-800", "focus:border-blue-800" }
    end

    context "with error" do
      let(:has_error) { true }

      it { is_expected.to contain_exactly "appearance-none", "border-b", "w-full", "py-1", "select-none", "focus:outline-none", "text-red-500", "border-red-300", "focus:text-red-800", "focus:border-red-800", "placeholder-red-300" }
    end
  end

  describe "#text_area_class" do
    subject { helper.text_area_class(has_error).split " " }

    context "without error" do
      let(:has_error) { false }

      it { is_expected.to contain_exactly "appearance-none", "border", "w-full", "py-1", "select-none", "focus:outline-none", "text-blue-500", "focus:text-blue-800", "focus:border-blue-800" }
    end

    context "with error" do
      let(:has_error) { true }

      it { is_expected.to contain_exactly "appearance-none", "border", "w-full", "py-1", "select-none", "focus:outline-none", "text-red-500", "border-red-300", "focus:text-red-800", "focus:border-red-800", "placeholder-red-300" }
    end
  end

  describe "#select_class" do
    subject { helper.select_class(has_error).split " " }

    context "without error" do
      let(:has_error) { false }

      it { is_expected.to contain_exactly "bg-white", "border-b", "w-full", "py-1", "select-none", "focus:outline-none", "text-blue-500", "focus:text-blue-800", "focus:border-blue-800" }
    end

    context "with error" do
      let(:has_error) { true }

      it { is_expected.to contain_exactly "bg-white", "border-b", "w-full", "py-1", "select-none", "focus:outline-none", "text-red-500", "border-red-300", "focus:text-red-800", "focus:border-red-800", "placeholder-red-300" }
    end
  end

  describe "#primary_link_class" do
    subject { helper.primary_link_class.split " " }

    it { is_expected.to contain_exactly "text-xs", "font-bold", "underline", "focus:outline-none", "text-blue-400", "hover:text-blue-600", "focus:text-blue-600" }
  end

  describe "#secondary_link_class" do
    subject { helper.secondary_link_class.split " " }

    it { is_expected.to contain_exactly "text-xs", "font-bold", "underline", "focus:outline-none", "text-blue-300", "hover:text-blue-500", "focus:text-blue-500" }
  end

  describe "#primary_button_class" do
    subject { helper.primary_button_class(color).split " " }

    context "when color is blue" do
      let(:color) { :blue }

      it { is_expected.to contain_exactly "appearance-none", "bg-white", "text-blue-400", "border-blue-400", "hover:border-blue-700", "hover:text-blue-800", "focus:outline-none", "focus:border-blue-700", "border-2", "w-full", "py-3", "font-bold", "text-lg", "uppercase", "tracking-widest" }
    end

    context "when color is gray" do
      let(:color) { :gray }

      it { is_expected.to contain_exactly "appearance-none", "bg-white", "text-gray-400", "border-gray-400", "hover:border-gray-700", "hover:text-gray-800", "focus:outline-none", "focus:border-gray-700", "border-2", "w-full", "py-3", "font-bold", "text-lg", "uppercase", "tracking-widest" }
    end
  end

  describe "#secondary_button_class" do
    subject { helper.secondary_button_class(color).split " " }

    context "when color is blue" do
      let(:color) { :blue }

      it { is_expected.to contain_exactly "appearance-none", "bg-white", "text-blue-400", "border-blue-400", "hover:border-blue-700", "hover:text-blue-800", "focus:outline-none", "focus:border-blue-700", "border-2", "px-3", "py-1", "leading-6", "font-semibold" }
    end

    context "when color is red" do
      let(:color) { :red }

      it { is_expected.to contain_exactly "appearance-none", "bg-white", "text-red-400", "border-red-400", "hover:border-red-700", "hover:text-red-800", "focus:outline-none", "focus:border-red-700", "border-2", "px-3", "py-1", "leading-6", "font-semibold" }
    end
  end

  describe "#thin_button_class" do
    subject { helper.thin_button_class(color).split " " }

    context "when color is blue" do
      let(:color) { :blue }

      it { is_expected.to contain_exactly "appearance-none", "bg-white", "text-blue-400", "border-blue-400", "hover:border-blue-700", "hover:text-blue-800", "focus:outline-none", "focus:border-blue-700", "border", "inline-block", "whitespace-no-wrap", "px-3", "leading-tight" }
    end

    context "when color is gray" do
      let(:color) { :gray }

      it { is_expected.to contain_exactly "appearance-none", "bg-white", "text-gray-400", "border-gray-400", "hover:border-gray-700", "hover:text-gray-800", "focus:outline-none", "focus:border-gray-700", "border", "inline-block", "whitespace-no-wrap", "px-3", "leading-tight" }
    end
  end
end
