Rails.application.routes.draw do
  namespace :gateway do
    match '/payanyway/:gateway_id/:order_id' => 'payanyway#show',    :as => :payanyway
    match '/payanyway/result'                => 'payanyway#result',  :as => :payanyway_result
    match '/payanyway/success'               => 'payanyway#success', :as => :payanyway_success
    match '/payanyway/fail'                  => 'payanyway#fail',    :as => :payanyway_fail
  end
end
