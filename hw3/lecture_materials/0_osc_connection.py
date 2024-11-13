# Sender
from pythonosc import udp_client

ip = "127.0.0.1"  # Replace with receiver's IP address
port = 5005       # Replace with desired port number
client = udp_client.SimpleUDPClient(ip, port)

client.send_message("/synth/volume", 0.75)  # Send a volume control message


# Receiver
from pythonosc import dispatcher, osc_server

def print_message(address, *args):
    print(f"Received message on {address}: {args}")

dispatcher = dispatcher.Dispatcher()
dispatcher.map("/synth/volume", print_message)  # Map address to a handler function

server = osc_server.ThreadingOSCUDPServer((ip, port), dispatcher)
print(f"Serving on {server.server_address}")
server.serve_forever()

