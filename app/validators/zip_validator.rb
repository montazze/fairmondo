#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

# refs #198
class ZipValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    case record.country
    when 'Deutschland'
      length = 5
      if value.to_s.length != length
        record.errors[attribute] << I18n.t('errors.messages.zip_length', count: length)
      end
      unless only_numbers?(value)
        record.errors[attribute] << I18n.t('errors.messages.zip_format')
      end
    end
  end

  private

  def only_numbers?(value)
    value.to_s.match(/^\d*$/)
  end
end
