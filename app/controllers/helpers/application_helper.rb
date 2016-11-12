conn = Bunny.new
conn.start
conn = Bunny.new(:hostname => "rabbit.local")
conn.start
ch   = conn.create_channel
q    = ch.queue("hello")
ch.default_exchange.publish("Hello World!", :routing_key => q.name)
puts " [x] Sent 'Hello World!'"
