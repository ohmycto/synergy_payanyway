CheckoutController.class_eval do
  before_filter :redirect_to_payanyway_form_if_needed, :only => :update

  private

  def redirect_to_payanyway_form_if_needed
    return unless params[:state] == 'payment'
    payment_method = PaymentMethod.find(params[:order][:payments_attributes].first[:payment_method_id])
    if payment_method.kind_of? Gateway::Payanyway
      @order.update_attributes(object_params)
      redirect_to(gateway_payanyway_path(:gateway_id => payment_method.id, :order_id => @order.id))
    end
  end
end
