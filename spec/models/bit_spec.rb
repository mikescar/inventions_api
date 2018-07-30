require "rails_helper"

RSpec.describe Bit, type: :model do
  it { expect(Bit.new(name: '')).to_not be_valid }
  it { expect(Bit.new(name: Faker::Name.name)).to be_valid }
end
