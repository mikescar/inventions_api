require 'rails_helper'

RSpec.describe Invention, type: :model do
  let(:bit) do
    Bit.new(name: %w[bargraph bend-sensor branch bright-led button buzzer coin-battery].sample)
  end

  let(:invention) do
    Invention.new(title: Faker::Name.name, description: Faker::Lorem.sentence(2), bits: [bit])
  end

  # Knowing that rails won't try to save if validation fails, just check the .valid? behavior
  #   This is also enforced at the DB level, could test against save behavior here or rely on controller specs
  context 'validations' do
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

    describe 'email' do
      it do
        invention.email = 'asdf@asdf.com'
        expect(invention).to be_valid
      end

      it do
        invention.email = 'asdf.com'
        expect(invention).to_not be_valid
      end
    end
  end

  # Extremely contrived and overdone example of verifying save behavior
  describe 'materials' do
    let(:dupe_materials) { %w[yarn scissors tape yarn] }
    let(:unique_materials) { %w[yarn scissors tape] }

    it 'will throw exception if set to nil' do
      invention.materials = nil
      expect { invention.save! }.to raise_error NoMethodError
    end

    it 'accepts array' do
      invention.materials = unique_materials
      expect { invention.save! }.to_not raise_error

      invention.reload
      expect(invention.materials).to eq unique_materials
    end

    it 'dedupes before saving' do
      invention.materials = dupe_materials
      invention.save!
      invention.reload
      expect(invention.materials).to eq unique_materials
    end
  end
end
