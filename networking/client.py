#client.py
import socket

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect(('localhost', 9999))
client.send("HELLO WORLD".encode())
print("📤Alice sent: 'HELLO WORLD'")
client.close()