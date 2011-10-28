class Folder < ActiveRecord::Base

  include ::OpenAndCloseAt
  
  MAX_ARTICLE_COUNT_BY_PAGE = 15
  
  # 
  ORDERING_BY_CREATED_AT_DESC = 'ByCreatedAtDesc' 
  ORDERING_BY_UPDATED_AT_DESC = 'ByUpdatedAtDesc'
  ORDERING_BY_CREATED_AT_ASC = 'ByCreatedAtAsc'
  ORDERING_BY_UPDATED_AT_ASC = 'ByUpdatedAtAsc'
  ORDERING_SPECIFYING = 'Specifying'
  ORDERING_TYPES = [
    ORDERING_BY_CREATED_AT_DESC,
    ORDERING_BY_UPDATED_AT_DESC,
    ORDERING_BY_CREATED_AT_ASC,
    ORDERING_BY_UPDATED_AT_ASC,
    ORDERING_SPECIFYING
    ]
  
  belongs_to  :site
  belongs_to  :updated_by, :class_name => 'User',
              :foreign_key => 'updated_by_id'
  belongs_to  :created_by, :class_name => 'User',
              :foreign_key => 'created_by_id'
  belongs_to  :owner, :class_name => 'User',
              :foreign_key => 'owner_id'
  has_many    :articles,  :dependent => :destroy

  scope   :listing, order('updated_at desc')
  
  scope   :by_id, lambda { |id|
    where("name = ?", id)
  }
  
  scope   :by_name, lambda { |name|
    where("name = ?", name)
  }

  validates_presence_of   :name
  validates_uniqueness_of :name, :scope => :site_id
  validates_inclusion_of  :ordering_type, :in => ORDERING_TYPES,
                          :allow_blank => false
  validates_numericality_of :article_count_by_page,
                            :greater_than_or_equal_to => 1,
                            :less_than_or_equal_to => MAX_ARTICLE_COUNT_BY_PAGE,
                            :allow_nil => false,
                            :only_integer => 1
  
  # 公開開始日時の入力チェック.日付け要素が未入力または、全て入力されて有効な日時になっていればOK?
  validate :opened_at_must_completed_or_nil
  # 公開停止日時の入力チェック.日付け要素が未入力または、全て入力されて有効な日時になっていればOK?
  validate :closed_at_must_completed_or_nil
  
  
  # array of ordeting types
  # each element - [<name for displaying>,<value for saving>]
  def self.ordering_types
    ORDERING_TYPES.collect do |type|
      [I18n.t(type.underscore, 
        :scope => [:activerecord,:attributes,:folder,:ordering_types]), 
      type]
    end
  end

  private 
  
end
