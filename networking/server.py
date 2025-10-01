# server.py
import socket
server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(('localhost', 9999))
server.listen(1)
print("🏠 Bob's server is listening...")
client_socket, address = server.accept()
message = client_socket.recv(11)
print(f"📨 Bob received: '{message.decode()}'")
client_socket.close()