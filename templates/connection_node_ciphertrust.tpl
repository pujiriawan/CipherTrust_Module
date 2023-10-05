this_node_address: ${vm_ip_address}
this_node_private_ip: ${vm_ip_address}
this_node_username: admin
this_default_password: admin
this_node_password: P@ssw0rd.1!
this_node_connection_string:
  server_ip: "{{ this_node_address }}"
  server_private_ip: "{{ this_node_private_ip }}"
  server_port: 5432
  user: "{{ this_node_username }}"
  password: "{{ this_node_password }}"
  verify: False