# Read about factories at https://github.com/thoughtbot/factory_girl
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
require 'ffaker'

FactoryGirl.define do
  factory :business_transaction do
    article { FactoryGirl.create :article, :without_build_business_transaction, :with_all_transports }
    seller { article.seller }
    selected_transport 'pickup'
    selected_payment 'cash'
    forename { Faker::Name.first_name }
    surname  { Faker::Name.last_name }
    street   { Faker::AddressDE.street_address }
    city     { Faker::AddressDE.city }
    zip      { Faker::AddressDE.zip_code }
    country  "Deutschland"
    sold_at { Time.now }
    discount_value_cents 0
    quantity_bought 1
    buyer
    line_item_group

    factory :single_transaction do
      forename { Faker::Name.first_name }
      surname  { Faker::Name.last_name }
      street   { Faker::AddressDE.street_address }
      city     { Faker::AddressDE.city }
      zip      { Faker::AddressDE.zip_code }
      country  "Deutschland"
      quantity_bought 1
    end

    factory :multiple_transaction do
      article { FactoryGirl.create :article, quantity: 50 }
      quantity_available 50
    end

    trait :legal_transaction do
      article { FactoryGirl.create :article, :with_legal_entity}
    end

    trait :private_transaction do
      article { FactoryGirl.create :article, :with_private_user}
    end

    factory :business_transaction_with_friendly_percent, class: 'SingleFixedPriceTransaction'  do
      article { FactoryGirl.create :article, :with_friendly_percent}
    end

    trait :incomplete do
       forename {nil}
    end

    trait :bought_nothing do
       quantity_bought 0
    end

    trait :transport_type_1_selected do
      selected_transport :type1
    end

    trait :transport_type_2_selected do
      selected_transport :type2
    end

    trait :cash_on_delivery_selected do
      selected_payment :cash_on_delivery
    end

    trait :fastbill_profile do
      seller { FactoryGirl.create :seller, fastbill_id: rand(1...1000), fastbill_subscription_id: rand(1...1000) }
    end

    trait :old do
      sold_at { 27.days.ago }
    end

    trait :older do
      sold_at { 44.days.ago }
    end

    trait :discountable do
      article { FactoryGirl.create :article, :with_discount }
    end
  end
end
