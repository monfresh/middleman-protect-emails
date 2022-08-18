require 'middleman-core/util'

class Middleman::ProtectEmailsExtension < ::Middleman::Extension

  # option :file, 'text_replace.yml', 'The file that defines the text to be replaced'

  def initialize(app, options_hash={}, &block)
    super
  end

  def after_configuration
    app.use Middleware, middleman_app: app
  end

  class Middleware
    def initialize(app, options = {})
      @rack_app = app
      @middleman_app = options[:middleman_app]
    end

    def call(env)
      status, headers, response = @rack_app.call(env)

      # Get path
      path = ::Middleman::Util.full_path(env['PATH_INFO'], @middleman_app)

      # Match only HTML documents
      if path =~ /(^\/$)|(\.(htm|html)$)/
        body = ::Middleman::Util.extract_response_text(response)
        if body
          status, headers, response = Rack::Response.new(rewrite_response(body), status, headers).finish
        end
      end

      headers['Content-Length'] = body.bytesize.to_s if body

      [status, headers, response]
    end

    private

    def rewrite_response(body)
      root_path = ::Middleman::Application.root
      config_file_path = File.join(root_path, 'text_replace.txt')

      lines = File.readlines(config_file_path)

      lines.each_with_object(body) do |line, body|
        key = line.split('=>')[0].strip
        value = line.split('=>')[1].strip

        body.gsub!(/(?!<.*?)#{key}(?![^<>]*?>)/, value)
      end
    end
  end
end
