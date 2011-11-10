class Article < ActiveRecord::Base

  include ::OpenAndCloseAt
  
  @@ordering_map = {
    Folder::ORDERING_BY_CREATED_AT_DESC =>  'created_at desc',
    Folder::ORDERING_BY_UPDATED_AT_DESC => 'updated_at desc',
    Folder::ORDERING_BY_CREATED_AT_ASC =>  'created_at asc',
    Folder::ORDERING_BY_UPDATED_AT_ASC =>  'updated_at asc',
    Folder::ORDERING_SPECIFYING => 'order_of_display, created_at asc'
  }
  
  # if ordering type of the folder is 'ordering_specifying'
  # set the order of display
  before_create :set_order_of_display!
  
  belongs_to  :folder
  belongs_to  :updated_by, :class_name => 'User',
              :foreign_key => 'updated_by_id'
  belongs_to  :created_by, :class_name => 'User',
              :foreign_key => 'created_by_id'
  scope   :listing, lambda { |folder|
    order( 
    if @@ordering_map.include?(folder.ordering_type)
      @@ordering_map[folder.ordering_type]
    else
      'created_at asc'
    end)
  }

  scope   :by_id, lambda { |id|
    where("id = ?", id)
  }

  # 公開開始日時の入力チェック.日付け要素が未入力または、全て入力されて有効な日時になっていればOK?
  validate :opened_at_must_completed_or_nil
  # 公開停止日時の入力チェック.日付け要素が未入力または、全て入力されて有効な日時になっていればOK?
  validate :closed_at_must_completed_or_nil
  
  
  # The order of a display is moved ahead. 
  def move_ahead!
    other = Article.where("order_of_display < ?", self.order_of_display).
                  order('order_of_display desc').
                  first
    if other 
      my_order = self.order_of_display
      self.order_of_display = other.order_of_display
      other.order_of_display = my_order
      class << self
        def record_timestamps; false; end
      end
      class << other
        def record_timestamps; false; end
      end
      begin 
        self.save!(:validate => false)
        other.save!(:validate => false)
      ensure
        class << self
          remove_method record_timestamps
        end
      end
    end
  end
  
  # The order of a display is moved behind. 
  def move_behind!
    other = Article.where("order_of_display > ?", self.order_of_display).
                  order('order_of_display asc').
                  first
    if other 
      class << self
        def record_timestamps; false; end
      end
      class << other
        def record_timestamps; false; end
      end
      my_order = self.order_of_display
      self.order_of_display = other.order_of_display
      other.order_of_display = my_order
      begin
        self.save!(:validate => false)
        other.save!(:validate => false)
      ensure
        class << self
          remove_method record_timestamps
        end
      end
    end
  end
  
  private
  
  # if ordering type of the folder is 'ordering_specifying',
  # set the order of display
  def set_order_of_display!
    if folder.ordered_by_specification?
      order_of_display = 
      if max = folder.articles.maximum('order_of_display')
        max + 1
      else
        1
      end
    end
  end
  
  
end
