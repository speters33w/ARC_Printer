import socket
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind(('localhost', 5964))
    s.listen()
    conn, addr = s.accept()
    with conn:
        with open('output.zpl', 'wb') as f:
            while True:
                data = conn.recv(1024)
                if not data:
                    break
                f.write(data)