class DeliveriesController < ApplicationController
  def index
    matching_deliveries = Delivery.all

    #@list_of_deliveries = matching_deliveries.order({ :created_at => :desc })
    @waiting_on_delivery = matching_deliveries.order({ :created_at => :desc })
    @received_delivery = matching_deliveries.order({:updated_at => :asc})

    render({ :template => "deliveries/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_deliveries = Delivery.where({ :id => the_id })

    @the_delivery = matching_deliveries.at(0)

    render({ :template => "deliveries/show" })
  end

  def create
    the_delivery = Delivery.new
    the_delivery.description = params.fetch("query_description")
    the_delivery.supposed_to_arrive_on = params.fetch("query_supposed_to_arrive_on")
    the_delivery.details = params.fetch("query_details")
    the_delivery.delivery_id = params.fetch("query_delivery_id")

    if the_delivery.valid?
      the_delivery.save
      redirect_to("/deliveries", { :notice => "Added to list." })
    else
      redirect_to("/deliveries", { :alert => the_delivery.errors.full_messages.to_sentence })
    end
  end

  def update
    # Parameters: {"arrived"=>"true", "path_id"=>"123"} # The path_id should be an actual ID, not a string ":path_id".
    the_id = params.fetch("path_id")
    the_delivery = Delivery.find(the_id) 
  
    the_delivery.arrived = params.fetch("arrived")
  
    if the_delivery.save
      redirect_to("/deliveries", { :notice => "Delivery marked as received." })
    else
      redirect_to("/deliveries", { :alert => the_delivery.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_delivery = Delivery.where({ :id => the_id }).at(0)

    the_delivery.destroy

    redirect_to("/deliveries", { :notice => "Deleted."} )
  end
end
