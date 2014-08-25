class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(req)
    @default || req.headers['Accept'].try('include?', ("application/vnd.example.v#{@version}"))
  end
end
