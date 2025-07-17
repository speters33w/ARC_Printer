"""
ZPL Capture Tool

This program acts as a virtual printer for testing ZPL label printing without a physical printer.
It listens to port 5964 (standard ZPL port) and captures any print jobs sent to localhost:5964.
The captured ZPL data is saved to 'output.zpl' for inspection and debugging.

Usage:
1. Run this script
2. Send ZPL print jobs to localhost:5964 from your application (you may need to refresh the page to see the print job).
3. Check output.zpl for the captured print data
4. Check the ZPL using a tool such as the LabelZoom ZPL viewer
   https://www.labelzoom.net/app/converter/from-zpl

This is useful for testing label printing applications like ARC Label Printer
without requiring a physical Zebra printer to be connected.
"""

import socket

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as server_socket:
    server_socket.bind(('localhost', 5964))
    print("Waiting for ZPL data... Send a print job to localhost:5964")
    server_socket.listen()
    client_connection, client_address = server_socket.accept()
    with client_connection:
        with open('output.zpl', 'wb') as output_file:
            while True:
                received_data = client_connection.recv(1024)
                if not received_data:
                    break
                output_file.write(received_data)