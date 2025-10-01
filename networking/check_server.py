import socket
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

hostname = input("Enter hostname : ")
port = int(input("Enter port : "))
    
try:
    s.connect((hostname, port))
    print(f"Port {port} on {hostname} is Open")
    s.close()
except:
    print(f"Port {port} on {hostname} is Close")
