class ApplicationController < ActionController::Base

  def hello
    render html: "hello cutie!"
  end

end
