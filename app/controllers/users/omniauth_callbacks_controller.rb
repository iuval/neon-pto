class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.find_for_google_oauth2(request.env['omniauth.auth'],
      current_user)

    if @user.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success',
        kind: 'Google'
      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.google_data'] = request.env['omniauth.auth']
      flash[:notice] = I18n.t 'auth.non_neonroots'
      redirect_to reports_path
    end
  end

  def after_sign_in_path_for(r)
    reports_path
  end
end
