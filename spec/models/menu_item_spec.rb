require 'spec_helper'

describe MenuItem do
  before do
    @site = Site.make
    @menu = Menu.make(:site => @site)
    @folder1 = Folder.make(:site => @site )
    @folder2 = Folder.make(:site => @site )
    @folder3 = Folder.make(:site => @site )
    @folder4 = Folder.make(:site => @site )
    @folder5 = Folder.make(:site => @site )
  end
  
  describe 'hierarchy_depth' do
    it " returns depth " do
      item1 = MenuItem.create(:folder => @folder1, :menu => @menu)
      item2 = MenuItem.create(:folder => @folder2, :menu => @menu, :parent => item1)
      item3 = MenuItem.create(:folder => @folder3, :menu => @menu, :parent => item2)
      item3.hierarchy_depth.should == 3
    end

    it " returns depth 1" do
      item1 = MenuItem.create(:folder => @folder1, :menu => @menu)
      item1.hierarchy_depth.should == 1
    end
  end

  describe 'tree_looped?' do
    it " returns true " do
      item1 = MenuItem.create(:folder => @folder1, :menu => @menu)
      item2 = MenuItem.create(:folder => @folder2, :menu => @menu, :parent => item1)
      item3 = MenuItem.create(:folder => @folder3, :menu => @menu, :parent => item2)
      item1.parent = item3
      item1.parent.tree_looped?.should == true
    end
    it " returns false " do
      item1 = MenuItem.create(:folder => @folder1, :menu => @menu)
      item2 = MenuItem.create(:folder => @folder2, :menu => @menu, :parent => item1)
      item3 = MenuItem.create(:folder => @folder3, :menu => @menu, :parent => item2)
      item3.parent.tree_looped?.should == false
    end
  end

  describe 'set order of display ' do
    it " set order of display when created " do
      item1 = MenuItem.create(:folder => @folder1, :menu => @menu)
      item1.order_of_display.should == 1
      item2_1 = MenuItem.create(:folder => @folder2, :menu => @menu, :parent => item1)
      item2_2 = MenuItem.create(:folder => @folder3, :menu => @menu, :parent => item1)
      item2_3 = MenuItem.create(:folder => @folder4, :menu => @menu, :parent => item1)
      item2_4 = MenuItem.create(:folder => @folder5, :menu => @menu, :parent => item1)
      item2_1.order_of_display.should == 1
      item2_2.order_of_display.should == 2
      item2_3.order_of_display.should == 3
      item2_4.order_of_display.should == 4

    end
  end


  describe 'move ahead' do
    it " move ahead " do
      item1 = MenuItem.create(:folder => @folder1, :menu => @menu)
      item2_1 = MenuItem.create(:folder => @folder2, :menu => @menu, :parent => item1)
      item2_2 = MenuItem.create(:folder => @folder3, :menu => @menu, :parent => item1)
      item2_3 = MenuItem.create(:folder => @folder4, :menu => @menu, :parent => item1)
      item2_4 = MenuItem.create(:folder => @folder5, :menu => @menu, :parent => item1)
      item2_3.move_ahead!
      item2_3 = item2_3.reload
      item2_2 = item2_2.reload
      item2_3.order_of_display.should == 2
      item2_2.order_of_display.should == 3
    end
  end


  describe 'move behind' do
    it " move behind " do
      item1 = MenuItem.create(:folder => @folder1, :menu => @menu)
      item2_1 = MenuItem.create(:folder => @folder2, :menu => @menu, :parent => item1)
      item2_2 = MenuItem.create(:folder => @folder3, :menu => @menu, :parent => item1)
      item2_3 = MenuItem.create(:folder => @folder4, :menu => @menu, :parent => item1)
      item2_4 = MenuItem.create(:folder => @folder5, :menu => @menu, :parent => item1)
      item2_2.move_behind!
      item2_3 = item2_3.reload
      item2_2 = item2_2.reload
      item2_3.order_of_display.should == 2
      item2_2.order_of_display.should == 3
    end
  end

  
end
