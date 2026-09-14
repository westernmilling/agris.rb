# frozen_string_literal: true
require 'spec_helper'

describe Agris::Api::PostResult do
  def build_response(result_xml)
    double(
      'response',
      output_hash: Hash.from_xml("<results>#{result_xml}</results>")
    )
  end

  describe '#reject_reasons' do
    context 'when the post was processed' do
      it 'returns an empty list' do
        # Arrange
        response = build_response(
          '<result document="AZGD04670" status="Processed">' \
          '<rejects><reject /></rejects>' \
          '</result>'
        )

        # Act
        reasons = described_class.new(response).reject_reasons

        # Assert
        expect(reasons).to eq([])
      end
    end

    context 'when the post was rejected' do
      it 'returns the reason of every rejection' do
        # Arrange
        response = build_response(
          '<result document="AZGD04670" status="Rejected"><rejects>' \
          '<reject code="Q" reason="INVOICE NUMBER ALREADY USED" />' \
          '<reject code="O" reason="TOTAL DOES NOT EQUAL THE INVOICE" />' \
          '<reject />' \
          '</rejects></result>'
        )

        # Act
        reasons = described_class.new(response).reject_reasons

        # Assert
        expect(reasons).to eq(
          [
            'INVOICE NUMBER ALREADY USED',
            'TOTAL DOES NOT EQUAL THE INVOICE'
          ]
        )
      end
    end
  end
end
