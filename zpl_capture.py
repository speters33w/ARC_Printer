import socket

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as server_socket:
    server_socket.bind(('localhost', 5964))
    server_socket.listen()
    print("Waiting for ZPL data... Send a print job to localhost:5964")
    client_connection, client_address = server_socket.accept()
    with client_connection:
        # with open('c:\OneDrive\Documents\ProblemSolve\output.zpl', 'wb') as output_file:
        with open('output.zpl', 'wb') as output_file:
            while True:
                received_data = client_connection.recv(1024)
                if not received_data:
                    break
                output_file.write(received_data)