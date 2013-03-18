class Spree::Gateway::PayanywayController < Spree::StoreController
  skip_before_filter :verify_authenticity_token, :only => [:result, :success, :fail]

  before_filter :load_order, :only => [:result, :success, :fail]

  def show
    @order =  Spree::Order.find(params[:order_id])
    @gateway = @order.available_payment_methods.find{|x| x.id == params[:gateway_id].to_i }

    if @order.blank? || @gateway.blank?
      flash[:error] = I18n.t('invalid_arguments')
      redirect_to :back
    else
      @signature = Digest::MD5.hexdigest([ @gateway.options[:id], @order.id, format("%.2f", @order.total), @gateway.options[:currency_code], @gateway.mode, @gateway.options[:signature] ].join)
    end
  end

  def result
    if complete_or_create_payment(@order, @gateway)
      render :text => 'SUCCESS'
    else
      render :text => 'FAIL'
    end
  end

  def success
    @order.next! until @order.state == "complete"
    @order.update!
    if @order && @gateway && @order.complete?
      session[:order_id] = nil
      redirect_to after_success_path(@order), :notice => I18n.t("order_processed_successfully")
    else
      flash[:error] = t("payment_fail")
      redirect_to root_url
    end
  end

  def fail
    flash[:error] = t('payment_fail')
    redirect_to @order.blank? ? root_url : checkout_state_path('payment')
  end

  protected

  def after_success_path(resource)
    order_path(resource)
  end

  private

  def load_order
    @order = Spree::Order.find_by_id(params['MNT_TRANSACTION_ID'])
    @gateway = @order.payment_method
  end
  
  def complete_or_create_payment(order, gateway)
    return unless order && gateway

    unless (payment = order.payments.first) && payment.complete!
      order.payments.destroy_all

      order.payments.create! do |p|
        p.payment_method = gateway
        p.amount = order.total
        p.state = 'completed'
      end
    end

    order.update!
  end
end