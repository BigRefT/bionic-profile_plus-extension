module ProfilePlus
  module CustomerControllerMixin

    def update_address
      if current_profile.address_ids.include? params[:id].to_i
        update_model("Address")
      else
        flash[:error] = "Invalid address id. Update failed."
        show_failure(nil)
      end
    end

    def create_address
      address = Address.new(params[:address])
      address.profile_id = current_profile.id
      save_and_show(address, "Address")
    end
    
    def delete_address
      if current_profile.address_ids.include? params[:id].to_i
        destroy_model("Address")
      else
        flash[:error] = "Invalid address id. Delete failed."
        show_failure(nil)
      end
    end

  end
end