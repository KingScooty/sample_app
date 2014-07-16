module SessionsHelper
  def sign_in(user)
    # create new remember token
    remember_token = User.new_remember_token
    
    # store remember token in client browser cookies
    cookies.permanent[:remember_token] = remember_token
    
    # save hashed token to database
    user.update_attribute(:remember_token, User.digest(remember_token))
    
    # set current user equal to given user
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.digest(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end
end
