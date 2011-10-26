class Article < ActiveRecord::Base

  include ::OpenAndCloseAt
  
  @@ordering_map = {
    'ByCreatedAtDesc' =>  'created_at desc',
    'ByUpdatedAtDesc' => 'updated_at desc',
    'ByCreatedAtAsc' =>  'created_at asc',
    'ByCreatedAtAsc' =>  'updated_at asc',
    'Specifying' => 'order_of_display, created_at asc'
  }
  
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
  
  
end
