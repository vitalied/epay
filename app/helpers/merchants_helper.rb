module MerchantsHelper
  def merchant_status_class(merchant)
    case merchant.status
    when Merchant::STATUS.active
      :success
    when Merchant::STATUS.inactive
      :warning
    else
      :light
    end
  end
end
