class ArticlesController < ApplicationController

  include ArticlesHelper
  include ::OpenAndCloseAt

  skip_auth :index

  PER_PAGE = 8

  # GET :site/:folder/articles/list
  # = instace fields receiced to the view
  # * @site
  # * @folder
  # * @articles
  def list
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      return render_404
    end
    @folder = @site.folders.by_name(params[:folder]).first
    if @folder.nil?
      return render_404
    end
    @articles = @folder.articles.listing(@folder).
                paginate(:per_page => PER_PAGE, :page => params[:page])
    respond_to do |format|
      format.html { render :action => :list}
    end
  end

  # GET :site/:folder
  # = instace fields receiced to the view
  # * @site
  # * @folder
  # * @articles
  def index
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      return render_404
    end
    @folder = @site.folders.by_name(params[:folder]).first
    if @folder.nil?
      return render_404
    end
    @articles = @folder.articles.listing(@folder).
                paginate(:per_page => @folder.article_count_by_page, 
                          :page => params[:page])
    respond_to do |format|
      format.html 
    end
  end

  # GET :site/:folder/:id/edit
  # = instace fields receiced to the view
  # * @site
  # * @folder
  # * @years
  # * @months
  # * @days
  def edit
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      return render_404
    end
    @folder = @site.folders.by_name(params[:folder]).first
    if @folder.nil?
      return render_404
    end
    @article = @folder.articles.by_id(params[:id]).first
    if @article.nil?
      return render_404
    end
    generate_selections!(@article)
    respond_to do |format|
      format.html
    end
  end

  # GET :site/:folder/new
  # = instace fields receiced to the view
  # * @site
  # * @folder
  # * @years
  # * @months
  # * @days
  def new
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      return render_404
    end
    @folder = @site.folders.by_name(params[:folder]).first
    if @folder.nil?
      return render_404
    end
    @article = Article.new(:folder => @folder)
    generate_selections!(@article)
    respond_to do |format|
      format.html
    end
  end

  # PUT :site/:folder/:id
  def update
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      return render_404
    end
    @folder = @site.folders.by_name(params[:folder]).first
    if @folder.nil?
      return render_404
    end
    @article = @folder.articles.by_id(params[:id]).first
    if @article.nil?
      return render_404
    end
    @article.attributes = params[:article]
    begin
      @article.save!(:validate => true)
      flash[:notice] = message(:articles, :updated)
      return redirect_to :action => 'list'
    rescue ActiveRecord::RecordInvalid  => ex
      generate_selections!(@article)
      render :action => :new
    end
  end

  # POST :site/:folder
  def create
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      return render_404
    end
    @folder = @site.folders.by_name(params[:folder]).first
    if @folder.nil?
      return render_404
    end
    @article = Article.new(:folder => @folder)
    @article.attributes = params[:article]
    begin
      @article.save!(:validate => true)
      flash[:notice] = message(:articles, :created)
      return redirect_to :action => 'list'
    rescue ActiveRecord::RecordInvalid  => ex
      generate_selections!(@article)
      render :action => :new
    end
  end
  
  # DELETE :site/:folder/:id
  def destroy
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      return render_404
    end
    @folder = @site.folders.by_name(params[:folder]).first
    if @folder.nil?
      return render_404
    end
    @article = @folder.articles.by_id(params[:id]).first
    begin
      @article.destroy
      flash[:notice] = message(:articles, :destroyed)
      return redirect_to :action => 'list'
    end
  end
  
  # PUT :site/:folder/:id/move_to_front (ajax)
  # moves the article ahead
  def move_ahead
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      return render_404
    end
    @folder = @site.folders.by_name(params[:folder]).first
    if @folder.nil?
      return render_404
    end
    @article = @folder.articles.by_id(params[:id]).first
    if @article.nil?
      return render_404
    end
    begin
      ActiveRecord::Base.transaction do
        @article.move_ahead!
      end
    end
    @articles = @folder.articles.listing(@folder).
                paginate(:per_page => PER_PAGE, :page => params[:page])
    respond_to do |format|
      format.html { render :file => '/articles/_article_table', :layout => false}
    end
  end

  # PUT :site/:folder/:id/move_to_front (ajax)
  # moves the article behind
  def move_behind
    @site = Site.find_by_name(params[:site])
    if @site.nil?
      return render_404
    end
    @folder = @site.folders.by_name(params[:folder]).first
    if @folder.nil?
      return render_404
    end
    @article = @folder.articles.by_id(params[:id]).first
    if @article.nil?
      return render_404
    end
    begin
      ActiveRecord::Base.transaction do
        @article.move_behind!
      end
    end
    @articles = @folder.articles.listing(@folder).
                paginate(:per_page => PER_PAGE, :page => params[:page])
    respond_to do |format|
      format.html { render :file => '/articles/_article_table', :layout => false}
    end
  end


  private 
  
  # フォームでの選択肢となるコレクションの生成
  def generate_selections!(article)
    @years = years(article)
    @months = months
    @days = days
    @hours = hours
    @minutes = minutes
  end
  


end
