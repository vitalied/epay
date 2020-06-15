module TransactionsHelper
  def transaction_type_class(transaction)
    case transaction.type
    when Transaction::TYPE.authorize_transaction
      :primary
    when Transaction::TYPE.charge_transaction
      :success
    when Transaction::TYPE.refund_transaction
      :secondary
    when Transaction::TYPE.reversal_transaction
      :dark
    else
      :light
    end
  end

  def transaction_status_class(transaction)
    case transaction.status
    when Transaction::STATUS.approved
      :success
    when Transaction::STATUS.reversed
      :dark
    when Transaction::STATUS.refunded
      :secondary
    when Transaction::STATUS.error
      :danger
    else
      :light
    end
  end
end
