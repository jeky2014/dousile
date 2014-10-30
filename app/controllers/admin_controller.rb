class AdminController < ApplicationController

  def upyun

    return unless valid_auth? # 权限验证
    
    # 保存数据
    if(params[:code] != nil and params[:code].to_i == 200)
      up = Upyun.new
      up.url = params[:url]
      up.width = params[:url].to_i
      up.height = params[:url].to_i
      up.state = 1
      up.source = 0
      url = request.url.split('?')[0] + "?success=" + (up.save ? "1" : "0")
      redirect_to url
    end
    
    # 列表数据
    @upyuns = Upyun.all.order("updated_at DESC").page(params[:page]).per(10)
    
  end
  
  private
  
  # 后台权限验证
  def valid_auth?
    if(session[:admin_name] == nil)
      redirect_to "/admin/login"
      return false
    end
    true
  end
  

end
