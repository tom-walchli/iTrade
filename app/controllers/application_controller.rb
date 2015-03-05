class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def after_sign_in_path_for(user)
    Wallet.create_or_update(user.id)

#    debug ann_eval model which runs in separate process as '$ rake ann_eval:do_stuff'
#    AnnEval.run()

    signed_in_root_path(user)
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
