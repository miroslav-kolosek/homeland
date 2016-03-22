module Homeland
  class Topic < ActiveRecord::Base
    include Homeland::Concerns::SoftDelete
    include Homeland::Concerns::MarkdownBody

    belongs_to :user, class_name: Homeland.config.user_class.to_s
    belongs_to :last_reply_user, class_name: Homeland.config.user_class.to_s
    belongs_to :node, class_name: 'Homeland::Node'
    has_many :replies, class_name: 'Homeland::Reply'

    validates :user_id, :title, :body, :node_id, presence: true

    scope :recent, -> { order('id desc') }
    scope :latest, -> { order('last_active_mark desc, id desc') }
    scope :features, -> { where('replies_count >= 20').latest }

    before_create :set_last_active_mark
    def set_last_active_mark
      self.last_active_mark = Time.now.to_i
    end
  end
end