#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class LineItemGroupRefinery < ApplicationRefinery
  def root
    false # LineItems don't have forms, they get controlled
  end

  def update
    [:unified_transport, :unified_payment, :unified_payment_method, :tos_accepted, :message]
  end

  def checkout_session # this is no controller action but a piece of code in the session form
    [:unified_transport_maximum_articles,
     :unified_transport_provider,
     :unified_transport_price_cents,
     :free_transport_at_price_cents]
  end
end
