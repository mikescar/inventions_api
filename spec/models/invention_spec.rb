require "rails_helper"

RSpec.describe Invention, :type => :model do
  # Knowing that rails won't try to save if validation fails, check the .valid? behavior
  #   This is also enforced at the DB level, and that could be tested by checking .save and expected errors
  context 'validations' do
    let(:invention) { Invention.new(title: Faker::Name.name, description: Faker::Lorem.sentence(2)) }

    it { expect(invention).to be_valid }

    it 'requires title' do
      invention.title = nil
      expect(invention).to_not be_valid
    end

    it 'requires description' do
      invention.description = nil
      expect(invention).to_not be_valid
    end

    context 'string lengths' do
      let(:too_long) { 'a' * 300 }

      it 'validates title' do
        invention.title = too_long
        expect(invention).to_not be_valid
      end

      it 'validates username' do
        invention.username = too_long
        expect(invention).to_not be_valid
      end

      it 'validates email' do
        invention.email = too_long
        expect(invention).to_not be_valid
      end
    end
  end
end
