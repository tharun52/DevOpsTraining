# server.py
import socket
server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(('localhost', 9090))
server.listen(1)
print("Curl server is listening...")
client_socket, address = server.accept()
message = client_socket.recv(5001)
print(f"'{message.decode()}'")
client_socket.close()