require "webrick"

class Server < WEBrick::HTTPServer
  def service(_request, response)
    super
    response["access-control-allow-origin"] = "*"
    response["cross-origin-resource-policy"] = "cross-origin"
  end
end

root = File.expand_path("dist")
server = Server.new(Port: 8000, DocumentRoot: root)

trap("INT") { server.shutdown } # Ctrl-C to stop

server.start
