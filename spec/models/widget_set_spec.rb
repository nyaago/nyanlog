require 'spec_helper'

describe WidgetSet do
  
  before do
    @site = Site.make
    @user = User.make(:site => @site)
    @folder = Folder.make(:site => @site, :owner => @user)
    
  end
  
  describe "sort_elements_by_id_list" do

    it " sorted correctly " do
      widget_set = WidgetSet.create(:site => @site)
      elements = []
      (1..10).each do |i|
        folder = Folder.make(:site => @site, :owner => @user, :name => "folder_#{i}")
        widget = MonthlyWidget.create(:folder => folder)
        elements << WidgetSetElement.create(:widget => widget, :widget_set => widget_set)
      end
      ids = elements.collect do |element|
        element.id
      end.reverse
      widget_set.sort_elements_by_id_list(ids.join(','))
      widget_set = WidgetSet.find_by_id(widget_set.id)
      widget_set.elements.each_with_index do |element, i|
        element.id.should == ids[i]
      end
    end
    
  end
  
end
