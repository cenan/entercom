class MainController < ApplicationController
  skip_before_filter :check_license, only: :setup
  def setup
    render inline: "This should be a response from the app-loader."
  end

  def verify_admin
    if License.verify(params[:license])
      session[:admin] = true
      redirect_to root_path, notice: "Admin verified!"
    else
      redirect_to :back, notice: "Invalid license!"
    end
  end

  def error_500
    raise "error"
  end

  def download_support
    path = "tmp/support-package.esp"

    `tar -czf #{path} tmp/exceptions/*`

    encrypted_package = License.encrypt(File.read(path))
    File.open(path, 'w'){|f| f.write encrypted_package}
    send_file path
  end

  def import
    file = params[:file]

    cmd = "PGPASSWORD=#{db_password} pg_restore --verbose --clean "
    cmd += "--username #{db_username} " if db_username
    cmd += "--host #{db_host} " if db_host
    cmd += "--no-owner --no-acl --dbname #{db_name} #{file.path}"
    system cmd

    redirect_to root_path, notice: "Data import done!"
  end

  def export
    file = Tempfile.new('export')

    cmd ="PGPASSWORD=#{db_password} pg_dump --verbose --clean "
    cmd += "--username #{db_username} " if db_username
    cmd += "--host #{db_host} " if db_host
    cmd += "--no-owner --no-acl --format=c #{db_name} > #{file.path}"
    system cmd

    send_file file.path, filename: "entercom.dump"
  end

  private
    def db_host; ActiveRecord::Base.connection_config[:host] end
    def db_username;  ActiveRecord::Base.connection_config[:username] end
    def db_password;  ActiveRecord::Base.connection_config[:password] || 'none' end
    def db_name; ActiveRecord::Base.connection_config[:database] end
end
