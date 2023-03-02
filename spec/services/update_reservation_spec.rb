require 'rails_helper'

describe UpdateReservation do
  describe '.perform' do
    let(:error_instance) { double(to_h: error_response) }
    let(:error_response) { double }
    let(:guest) { double(attributes: double) }
    let(:guest_id) { 'some_id' }
    let(:is_reservation_blank?) { false }
    let(:is_reservation_update_valid?) { true }
    let(:reservation) { double }
    let(:reservation_code) { 'some_code' }

    let(:args) do
      {
        code: reservation_code,
        params: { some_key: 'some_value' }
      }
    end

    before do
      allow(Guest).to receive(:find).and_return(guest)
      allow(Reservation).to receive(:find_by).and_return(reservation)
      allow(Reservations::ErrorFormatter).to receive(:new).and_return(error_instance)
      allow(reservation).to receive_messages(
        attributes: reservation,
        blank?: is_reservation_blank?,
        merge: reservation,
        update: is_reservation_update_valid?,
        guest_id: guest_id
      )
    end

    subject { described_class.new(args).perform }

    after { subject }

    context 'when reservation does not exist' do
      let(:is_reservation_blank?) { true }

      it 'returns error' do
        expect(Reservations::ErrorFormatter).to receive(:new)
          .with(
            errors: "No reservation with code #{reservation_code} exists.",
            http_code: 400
          )

        expect(subject).to eq(error_response)
      end
    end

    it 'updates and returns updated reservation details' do
      expect(reservation).to receive(:update).with(args[:params].compact)
      expect(reservation).to receive(:merge).with(guest: guest.attributes)

      expect(subject).to eq({
        data: reservation,
        status: 200
      })
    end

    context 'when update fails' do
      let(:is_reservation_update_valid?) { false }
      
      it 'returns error' do
        expect(Reservations::ErrorFormatter).to receive(:new)
          .with(
            errors: "There was an error in updating the reservation.",
            http_code: 400
          )

        expect(subject).to eq(error_response)
      end
    end
  end
end