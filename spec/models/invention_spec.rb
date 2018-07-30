require "rails_helper"

RSpec.describe Invention, type: :model do
  let(:bit) { Bit.new(name: %w(bargraph bend-sensor branch bright-led button buzzer coin-battery).sample) }

  # Knowing that rails won't try to save if validation fails, just check the .valid? behavior
  #   This is also enforced at the DB level, could test against .save/.save! behavior
  context 'validations' do
    let(:invention) do
      Invention.new(title: Faker::Name.name, description: Faker::Lorem.sentence(2), bits: [bit])
    end

    it { expect(invention).to be_valid }

    context 'required fields' do
      it 'requires title' do
        invention.title = nil
        expect(invention).to_not be_valid
      end

      it 'requires description' do
        invention.description = nil
        expect(invention).to_not be_valid
      end

      it 'requires a bit' do
        invention.bits = []
        expect(invention).to_not be_valid
      end
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
