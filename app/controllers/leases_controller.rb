class LeasesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record

    def index
        render json: Lease.all, status: :ok
    end

    def create
        lease = Lease.create!(lease_params)
        render json: lease, status: :created
    end

    def destroy
        lease = find_lease
        render json: lease.destroy, status: :no_content
    end

    private

    def find_lease
        Lease.find(params[:id])
    end

    def lease_params
        params.permit(:rent, :apartment_id, :tenant_id)
    end

    def render_not_found_response
        render json: {error: "Tenant not found"}, status: :not_found 
    end

    def render_invalid_record(invalid)
        render json: {error: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end
end
