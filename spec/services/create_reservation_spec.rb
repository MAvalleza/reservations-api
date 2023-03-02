require 'rails_helper'

describe CreateReservation do
  describe '.perform' do
    let(:error_instance) { double(to_h: error_response) }
    let(:error_response) { double }
    let(:guest) { double }
    let(:is_guest_valid?) { true }
    let(:is_reservation_valid?) { true }
    let(:is_validation_errors_empty?) { true }
    let(:reservation) { double }
    let(:validation_instance) { double(validate: validation_errors) }
    let(:validation_errors) { double(empty?: is_validation_errors_empty?) }

    let(:params) do
      {
        code: 'some_code',
        guest_email: 'some_email',
        guest_first_name: 'some_first_name',
        guest_last_name: 'some_last_name',
        guest_phone: 'some_phone'
      }
    end

    before do
      allow(CreateReservationResourceValidation).to receive(:new).and_return(validation_instance)
      allow(Guest).to receive(:new).and_return(guest)
      allow(guest).to receive_messages(
        as_json: guest,
        build_reservation: reservation,
        errors: double(full_messages: double),
        valid?: is_guest_valid?,
        save: guest,
      )
      allow(Reservations::ErrorFormatter).to receive(:new).and_return(error_instance)
      allow(reservation).to receive_messages(
        as_json: reservation,
        errors: double(full_messages: double),
        merge: reservation,
        valid?: is_reservation_valid?,
        save: reservation,
      )
    end

    subject { described_class.new(params).perform }

    after do |example|
      subject unless example.metadata[:skip_after]
    end

    it 'validates the resource' do
      expect(CreateReservationResourceValidation).to receive(:new)
        .with(
          code: params[:code],
          guest_email: params[:guest_email]
        )
    end

    context 'when validation is invalid' do
      let(:is_validation_errors_empty?) { false }

      it 'returns validation errors', skip_after: true do
        expect(subject).to eq(validation_errors)
      end
    end

    it 'prepares a new guest' do
      expect(Guest).to receive(:new)
        .with(
          email: params[:guest_email],
          first_name: params[:guest_first_name],
          last_name: params[:guest_last_name],
          phone: params[:guest_phone]
        )
    end

    context 'when guest details are invalid' do
      let(:is_guest_valid?) { false }

      it 'returns error', skip_after: true do
        expect(Reservations::ErrorFormatter).to receive(:new)
          .with(
            errors: guest.errors.full_messages,
            http_code: 400
          )

        expect(subject).to eq(error_response)
      end
    end

    it 'generates a reservation' do
      expect(guest).to receive(:build_reservation).with(
        params.except(:guest_email, :guest_first_name, :guest_last_name, :guest_phone)
      )
    end

    context 'when reservation details are invalid' do
      let(:is_reservation_valid?) { false }

      it 'returns error', skip_after: true do
        expect(Reservations::ErrorFormatter).to receive(:new)
          .with(
            errors: reservation.errors.full_messages,
            http_code: 400
          )

        expect(subject).to eq(error_response)
      end
    end

    it 'saves and returns reservation details' do
      expect(guest).to receive(:save).with(no_args)
      expect(reservation).to receive(:save).with(no_args)

      expect(subject).to eq({
        data: reservation,
        status: 200
      })
    end
  end
end