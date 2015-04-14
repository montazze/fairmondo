#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
class CommentMailer < ActionMailer::Base
  include MailerHelper
  before_filter :inline_logos

  default from: EMAIL_ADDRESSES['default']
  layout 'email'

  def report_comment(comment, commentable_owner)
    @commentable = comment.commentable
    @commentable_owner = commentable_owner

    mail(to: @commentable_owner.email,
         subject: I18n.t('comment.mailer.notification_title'))
  end
end
