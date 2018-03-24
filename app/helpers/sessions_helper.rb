module SessionsHelper
  # 登入给出的用户
  def log_in(user)
    session[:user_id] = user.id # encrypt automatically
  end

  def current_user
    # @current_user ||= User.find_by(id: session[:user_id])
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id]) # may be nil
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user # may be nil
      end
    end
  end

  def logged_in?
    current_user
  end

  def log_out
    # session.delete(:user_id)   # if so test would fail
    forget(current_user)       # why here can't reverse the first two lines
    session.delete(:user_id)   # if so test would fail
    @current_user = nil
  end

  def remember(user)
    user.remember # this remember from user.rb
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget # set user.remember_digest = nil
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  # 存储最初访问的地址
  def store_location
    session[:forwarding_url] = request.original_url if request.get? # get以外的表单会发生重复提交的冲突
  end

  # 重定向到session中存的之前访问页面的地址或默认地址
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end



end
