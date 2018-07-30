class CreateBits < ActiveRecord::Migration[5.2]
  def change
    create_table :bits do |t|
      t.string :name, null: false

      t.timestamps
    end

    bit_names = %w[bargraph bend-sensor branch bright-led button buzzer coin-battery dc-motor dimmer
                   doubleand doubleor fan fork inverter led light-sensor light-trigger light-wire long-led
                   motion-trigger power pressure-sensor pulse rgb-led roller-switch servo-motor slide-dimmer
                   slide-switch sound-trigger temperature-sensor timeout toggle-switch usb-power uv-led
                   vibration-motor wire]

    bit_names.each do |bit_name|
      Bit.create!(name: bit_name)
    end

    create_join_table :bits, :inventions

    add_index :bits_inventions, :bit_id
    add_index :bits_inventions, :invention_id

    add_foreign_key :bits_inventions, :bits
    add_foreign_key :bits_inventions, :inventions
  end
end
