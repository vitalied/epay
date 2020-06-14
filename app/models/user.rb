# == Schema Information
#
# Table name: users
#
#  id                   :bigint           not null, primary key
#  email                :string(255)      default(""), not null
#  encrypted_password   :string(255)      default(""), not null
#  authentication_token :string(255)      default(""), not null
#  admin                :boolean          default(FALSE), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#
class User < ApplicationRecord
  devise :database_authenticatable, :token_authenticatable, :validatable

  has_one :merchant, dependent: :destroy
end
