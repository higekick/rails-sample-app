module SessionsHelper
    # 引数のuserでログインする 
    def log_in(user)
        session[:user_id] = user.id
    end

    # セッションを永続的にする
    def remember(user)
        # remember_tokenを生成、ハッシュ化してDBに永続化
        user.remember
        # userIdを20年間、暗号化してcookiesに保存
        cookies.permanent.signed[:user_id] = user.id
        # remember_tokenを20年間cookiesに保存
        cookies.permanent[:remember_token] = user.remember_token
    end

    def current_user
        if (user_id = session[:user_id])
            @current_user ||= User.find_by(id: session[:user_id])
        elsif (user_id = cookies.signed[:user_id])
            user = User.find_by(id: user_id)
            if user&.authenticated?(:remember, cookies[:remember_token])
                log_in user
                @current_user = user
            end
        end
    end

    def current_user?(user)
        user && user == current_user
    end

    def logged_in?
        !current_user.nil?
    end

    # ログイン時に永続化したDBのトークンを破棄する。cookiesに保存しているログイン情報を破棄する
    def forget(user)
        user.forget
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end
    
    def log_out
        forget(current_user)
        session.delete(:user_id)
        @current_user = nil
    end

    # 記憶したURL（もしくはデフォルト値）にリダイレクト
    def redirect_back_or(default)
      redirect_to(session[:forwarding_url] || default)
      session.delete(:forwarding_url)
    end

    # アクセスしようとしたURLを覚えておく
    def store_location
      session[:forwarding_url] = request.original_url if request.get?
    end

end
