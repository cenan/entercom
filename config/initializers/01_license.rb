module License
  extend self

  def present?
    !!self[:version]
  end

  def path
    Rails.root.join "tmp/license.enc"
  end

  def shared_key
    ENV["ENTERCOM_SHARED_KEY"] || "asdfasdf"
  end

  def read
    @license = if File.exists?(path)
      contents = File.read path
      JSON.parse(decrypt(contents)).symbolize_keys rescue {}
    else
      {}
    end
  end

  def cipher
    @cipher ||= Gibberish::AES.new(shared_key)
  end

  def encrypt(data)
    cipher.encrypt data
  end

  def decrypt(data)
    cipher.decrypt data
  end

  def version
    @version ||= File.read Rails.root.join("VERSION")
  end

  def generate(opts={})
    opts.merge!({
      version: version,
      secret_token: securerandom.hex(64),
      devise_token: securerandom.hex(64)
    })

    file.open(path, 'w'){|f| f.write encrypt opts.to_json}
  end

  def verify(file)
    real = Digest::SHA256.file(path)
    real == Digest::SHA256.file(file.path)
  end

  def [](field)
    read unless @license
    @license[field]
  end
end
