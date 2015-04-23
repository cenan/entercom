class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :check_license

  rescue_from Exception do |e|
    `mkdir -p #{Rails.root.join "tmp/exceptions"}`

    text = [e.class.to_s, e.to_s].join("\n") + "\n" +
        Rails.backtrace_cleaner.clean(e.backtrace).join("\n")

    File.open "tmp/exceptions/#{Time.now.to_i}", "w" do |f|
      f.write License.encrypt text
    end

    raise e
  end

  private
    def check_license
      redirect_to "/setup" unless License.present?
    end

    def admin?
      session[:admin]
    end
    helper_method :admin?
end
