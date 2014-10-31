require "./lib/assets/parseposting.rb"
class ArticlesController < ApplicationController
  
  #---------------- pc 版本
  
  def index
    @articles = Article.where(state: 0, haspic: 1).order("rand()").limit(5)
    render :template => 'articles/pc_index.html.erb', :layout => nil
  end
  
  def pc_show
    @article = Article.find(params[:id])
    updatehit @article, true # 更新点击次数
    render :template => 'articles/pc_show.html.erb', :layout => nil
  end
  
  def sitemap
    @articles = Article.where(state: 0).order("pubtime DESC")
    render :template => 'articles/sitemap.xml.builder', :layout => nil
  end
  
  
  #---------------- mobile 版本
  
  def m_show
    @article = Article.find(params[:id])
    updatehit @article, true # 更新点击次数
    render :template => 'articles/m_show.html.erb', :layout => nil
  end
  
  def m_new
    @article = Article.new
    render :template => 'articles/m_new.html.erb', :layout => nil
  end
  
  def m_create
    content = params[:article][:content]
    if(content.length > 20 and mobile_create(content))
      redirect_to '/articles/create/m/success.htm'
    else
      render :template => 'articles/m_new.html.erb', :layout => nil
    end
  end
  
  def m_create_success
    render :template => 'articles/m_create_success.html.erb', :layout => nil
  end

  #--------------- 后台管理.文章列表
  
  def admin_list
    return unless valid_auth? # 权限验证
    _state = params[:state] || 0
    _sign = params[:sign] || -1
    if(_sign == -1)
      @articles = Article.where(state: _state).order("pubtime DESC").page(params[:page]).per(20)
    else
      @articles = Article.where(state: _state, sign: _sign).order("pubtime DESC").page(params[:page]).per(20)
    end
    render :template => 'articles/admin/list.html.erb', :layout => 'admin'
  end
  
  def admin_new
    return unless valid_auth? # 权限验证
    if(params[:id].to_s.length == 0)
      @article = Article.new
      @article.pubtime = Time.now.in_time_zone(+8.hours).strftime('%Y-%m-%d %H:%M:%S')
    else
      @article = Article.find(params[:id].to_i)
      @article.pubtime = @article.pubtime.localtime.strftime('%Y-%m-%d %H:%M:%S')
    end
    
    render :template => 'articles/admin/new.html.erb', :layout => nil
  end
  
  def admin_create
    return unless valid_auth? # 权限验证
    params.permit!
    if(params[:id].to_s.length == 0)
      refrash_haspic
      params[:article][:pubtime] = toUTC(params[:article][:pubtime])
      @article = Article.new(params[:article])
      redirect_to action:'admin_new', success: (@article.save ? "1" : "0")
    end
  end
  
  def admin_update
    return unless valid_auth? # 权限验证
    params.permit!
    if(params[:id].to_s.length != 0)
      @article = Article.find(params[:id].to_i)
      refrash_haspic
      params[:article][:pubtime] = toUTC(params[:article][:pubtime])
      result = @article.update(params[:article])
      redirect_to '/admin/articles/new/' << params[:id] << '?success=' << (result ? "1" : "0")
    end
  end
  
  def admin_delete
    return unless valid_auth? # 权限验证
    if(params[:id].to_s.length != 0)
      article = Article.find(params[:id].to_i)
      result = article.update_columns(state: 2) # 已删除状态
      render plain: (result ? 1 : 0)
    end
  end
  
  # 批量发布
  def admin_posting
    if(request.get?)
      render :template => 'articles/admin/posting.html.erb', :layout => 'admin'
    elsif(request.post?)
      count = 0
      content = params[:content]
      arr = ParsePosting.new.parse(content)
      arr.each do|item|
        atc = Article.new
        atc.source = 0
        atc.state = 0
        atc.title = item["title"]
        atc.content = item["content"]
        atc.sign = item["sign"]
        atc.pubtime = Time.now.in_time_zone(-0.hours).strftime('%Y-%m-%d %H:%M:%S')
        count = count.next if(atc.save)
      end
      redirect_to :action => 'admin_posting', notice: count.to_s
    end
  end
  
  #--------------- 后台管理.登录
  
  def admin_login
    if(request.get?)
      render :template => 'articles/admin/login.html.erb', :layout => 'admin'
    else
      name = params[:name]
      pass = params[:pass]
      pwd = Digest::MD5.hexdigest(pass)
      if(name != 'jeky' or pwd != ENV['DOUSILE_ADMIN_PASS'].to_s)
        redirect_to action: 'admin_login', notice: 'err'
      else
        session[:admin_name] = name
        redirect_to '/admin/articles'
      end
    end
  end
  
  def admin_logout
    session[:admin_name] = nil
    redirect_to :action => 'admin_login', :notice => 'logout'
  end
  
  
  #--------------- 私有方法
  
  private
  
  # 刷新参数：haspic
  def refrash_haspic
    params[:article][:haspic] = (params[:article][:picpath].to_s.length > 5)
  end
  
  # 更新点击次数
  def updatehit(article, is_m)
    article.update_column('hitt', article.hitt.next)
    article.update_column('hitm', article.hitm.next) if is_m
  end
  
  # mobile 版发布
  def mobile_create(content)
    Article.create(source:1, state:1, title:'m版发布-无标题', content:content, pubtime:Time.now)
  end
  
  # 将时间字符串转换为 UTC 时间，在保存之前修正参数
  def toUTC(timeQueryString)
    Time.parse(timeQueryString).in_time_zone(-0.hours).strftime('%Y-%m-%d %H:%M:%S')
  end
  
  # 后台权限验证
  def valid_auth?
    if(session[:admin_name] == nil)
      redirect_to "/admin/login"
      return false
    end
    true
  end
  
  
end
