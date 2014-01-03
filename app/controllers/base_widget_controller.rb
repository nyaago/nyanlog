class BaseWidgetController < ApplicationController
  
  # 編集ページを表示
  # /site/<widget_type.underscore>/edit/<id> でリクエストされる.
  def edit
  
    @widget = model_class.find_by_id(params[:id])  or (render_404 and return)
    widget_set = @widget.widget_set or (render_404 and return)
    widget_set.site_id == @site.id or (render_404 and return)
    respond_to do |format|
      format.html do
        render :layout => false
      end
    end
  
  end

  # 
  # 
  def update
    
    @widget = model_class.find_by_id(params[:id])  or (render_404 and return)
    widget_set = @widget.widget_set or (render_404 and return)
    widget_set.site_id == @site.id or (render_404 and return)
    @widget.attributes = params[record_parameter_name.to_sym].permit(model_class.accessible_attributes)
    begin
      ActiveRecord::Base.transaction do
        @widget.save!(:validate => true)
        respond_to do |format|
          #p({ 'widget' => @widget, 'widget_set_element' => @widget.widget_set_element }.to_json)
          format.json { render :text => 
            { 'widget' => @widget, 'widget_set_element' => @widget.widget_set_element }.to_json }
        end
      end
    rescue => ex
      p "@@@@@@@@@"
      respond_to do |format|
        puts ex.message
        puts ex.backtrace
#        p({ 'error' => @widget.errors.full_messages}.to_json )
        format.json { render :text => { 'error' => @widget.errors.full_messages}.to_json }
      end
    end
  
  end

  # 編集内容での更新を行う
  # /site/<widget_type.underscore>/destroy/<id> でリクエストされる.
  def destroy
    site_widget = @site.site_widgets.where('id = :id', :id => params[:id]).first;
    if site_widget.nil? || site_widget.widget.nil?
      render :json => { :status => "NG" }
      return
    end
    if site_widget.site.id != @site.id
      render :json => { :status => "NG" }
      return
    end
    widget = site_widget.widget
    begin
      ActiveRecord::Base.transaction do
        if !widget.destroy
           raises ActiveResource::ResourceInvalid, "failed in destroing"
        end
        respond_to do |format|
          format.json { render :text => { 'widget_id' => widget.id }.to_json }
        end
      end
    rescue
      respond_to do |format|
        format.json { render :json => { :status => "NG" } }
      end
    end
  
  end  

#  def self.define_subclass(name)
#  end

  protected

  # 更新リクエストでのデータを格納するパラメータ名をを返す.
  # 各継承クラスでオーバーライドする.
  def record_parameter_name
    :widget
  end

  public

end

# = 各Widget Controller 生成
# 定義(config/layouts/widget.yml)を読み込み、各具象widget controller クラスを定義
AppConfig::Widget.array.each do |widget|
  puts "new class - #{widget.name.capitalize.camelize}Controller"
  Object.const_set("#{widget.name.capitalize.camelize}Controller", 
  Class.new(BaseWidgetController) {
    def record_parameter_name
#        widget.name
      self.class.name.split('::').last[0,self.class.name.split('::').last.
        index('Controller')].underscore
    end
    def model_class
      self.class.const_get(self.class.name.split('::').last[0,self.class.name.split('::').last.
        index('Controller')])
    end
  } )
end
