# = OpenAndCloseAt
# mix-in module for the activerecord class which has 'opened_at' and 'closed_at' attribute.
module OpenAndCloseAt
  
  # Gets the opened year.
  def opened_year
    @opened_year || if opened_at;opened_at.year;else;nil;end
  end

  # Gets the opened minute.
  def opened_month
    @opened_month || if opened_at;opened_at.month;else;nil;end
  end

  # Gets the opened day.
  def opened_day
    @opened_day || if opened_at;opened_at.day;else;nil;end
  end

  # Gets the opened hour.
  def opened_hour
    @opened_hour || if opened_at;opened_at.hour;else;nil;end
  end
  
  # Gets the opened minute.
  def opened_min
    @opened_min || if opened_at;opened_at.min;else;nil;end
  end
  
  # Gets the closed year.
  def closed_year
    @closed_year || if closed_at;closed_at.year;else;nil;end
  end

  # Gets the closed minute.
  def closed_month
    @closed_month || if closed_at;closed_at.month;else;nil;end
  end

  # Gets the closed day.
  def closed_day
    @closed_day || if closed_at;closed_at.day;else;nil;end
  end

  # Gets the closed hour.
  def closed_hour
    @closed_hour || if closed_at;closed_at.hour;else;nil;end
  end

  # Gets the closed minute.
  def closed_min
    @closed_min ||  if closed_at;closed_at.min;else;nil;end
  end
  
  # Sets the opened year.
  def opened_year=(year)
    @opened_year = year
    set_opened_at
    self
  end

  # Sets the opened month.
  def opened_month=(month)
    @opened_month = month
    set_opened_at
    self
  end
  
  # Sets the opened day.
  def opened_day=(day)
    @opened_day = day
    set_opened_at
    self
  end
  
  # Sets the opened hour.
  def opened_hour=(hour)
    @opened_hour = hour
    set_opened_at
    self
  end
  
  # Sets the opened min.
  def opened_min=(min)
    @opened_min = min
    set_opened_at
    self
  end
  
  # Sets the closed year.
  def closed_year=(year)
    @closed_year = year
    set_closed_at
    self
  end

  # Sets the closed month.
  def closed_month=(month)
    @closed_month = month
    set_closed_at
    self
  end
  
  # Sets the closed day.
  def closed_day=(day)
    @closed_day = day
    set_closed_at
    self
  end
  
  # Sets the closed hour.
  def closed_hour=(hour)
    @closed_hour = hour
    set_closed_at
    self
  end
  
  # Sets the clsed min.
  def closed_min=(min)
    @closed_min = min
    set_closed_at
    self
  end
  
  protected
  
  # 
  def set_opened_at
    self[:opened_at] = 
    if !@opened_year.blank? || !@opened_month.blank? || !@opened_day.blank? || 
      !@opened_hour.blank? || !@opened_min.blank?
      if !@opened_year.blank? && !@opened_month.blank? && !@opened_day.blank? && 
        !@opened_hour.blank? && !@opened_min.blank?
        begin
          tm = Time.new(@opened_year.to_i,@opened_month.to_i,@opened_day.to_i,
          @opened_hour.to_i,@opened_min.to_i)
          if tm.month != @opened_month.to_i
            nil
          else
            tm
          end
        rescue
          nil
        end
      else
        nil
      end
    else
      self[:opened_at]
    end
  end

  # 
  def set_closed_at
    self[:closed_at] = 
    if !@closed_year.blank? || !@closed_month.blank? || !@closed_day.blank? || 
      !@closed_hour.blank? || !@closed_min.blank?
      if !@closed_year.blank? && !@closed_month.blank? && !@closed_day.blank? && 
        !@closed_hour.blank? && !@closed_min.blank?
        begin
          tm = Time.new(@closed_year.to_i,@closed_month.to_i,@closed_day.to_i,
          @closed_hour.to_i,@closed_min.to_i)
          if tm.month != @closed_month.to_i
            nil
          else
            tm
          end
        rescue
          nil
        end
      else
        nil
      end
    else
      self[:closed_at]
    end
  end
  
  # 公開開始日時の入力チェック.日付け要素が未入力または、全て入力されて有効な日時になっていればOK?
  def opened_at_must_completed_or_nil
    if !@opened_year.blank? || !@opened_month.blank? || !@opened_day.blank? 
      if opened_at.nil?
         errors.add(:opened_at, 
         I18n.t(:invalid_date, :scope => [:errors, :folder, :messages]))
      end
    end
  end

  # 公開停止日時の入力チェック.日付け要素が未入力または、全て入力されて有効な日時になっていればOK?
  def closed_at_must_completed_or_nil
    if !@closed_year.blank? || !@closed_month.blank? || !@closed_day.blank?
      if closed_at.nil?
        errors.add(:closed_at, 
        I18n.t(:invalid_date, :scope => [:errors, :folder, :messages]))
      end
    end
  end
  
  # Gets entries for year select box
  # == parameters
  # * record - record object which has 'opened_at' and 'closed_at' attribute.
  def years(record)
    first_year = Date.today.year
    first_year = 
    if record.opened_at && record.opened_at.year < first_year
      record.opened_at.year
    else
      first_year
    end
    first_year = 
    if record.closed_at &&  record.closed_at.year < first_year
      record.closed_at.year
    else
      first_year
    end
    last_year = Date.today.year + 10
    last_year = if first_year > last_year;first_year;else;last_year;end
    (first_year..last_year).to_a
  end
  
  # Gets entries for month select box
  def months
    (1..12).to_a
  end
  
  # Gets entries for day select box
  def days
    (1..31).to_a
  end
  
  # Gets entries for hour select box
  def hours
    (0..23).to_a
  end
  
  # Gets entries for minute select box
  def minutes
    (0..59).to_a.keep_if {|n| n % 5 == 0}
  end
  
  
end