class StaticPagesController < ApplicationController
  def home
    if logged_in?
      # 左ページのtweetポスト画面へ
      @micropost  = current_user.microposts.build
      # 右ページのtweet一覧へ
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
