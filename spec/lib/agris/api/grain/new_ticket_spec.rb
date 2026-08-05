# frozen_string_literal: true
require 'spec_helper'

describe Agris::Api::Grain::NewTicket do
  describe '#to_xml_hash' do
    it 'renders the freight fields as Agris ticket attributes' do
      ticket = described_class.new(
        freight_status: 'E',
        freight_rate: 1596,
        freight_uom: 'TONS',
        freight_weight: 3_023_664
      )

      expect(ticket.to_xml_hash).to include(
        :'@freightstatus' => 'E',
        :'@freightrate' => 1596,
        :'@freightuom' => 'TONS',
        :'@freightweight' => 3_023_664
      )
    end

    it 'omits attributes that were not set' do
      ticket = described_class.new(freight_rate: 1596)

      expect(ticket.to_xml_hash.keys).to_not include(:'@freightuom')
    end
  end

  describe 'freight_uom' do
    it 'is a readable and writable attribute' do
      ticket = described_class.new

      ticket.freight_uom = 'BU56'

      expect(ticket.freight_uom).to eq('BU56')
    end

    it 'round-trips from an Agris response hash' do
      ticket = described_class.from_xml_hash('freightuom' => 'TONS')

      expect(ticket.freight_uom).to eq('TONS')
    end
  end
end
