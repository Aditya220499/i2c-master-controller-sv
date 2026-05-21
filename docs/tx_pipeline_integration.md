| Module         | Inputs           | Outputs       | Responsibility |
| -------------- | ---------------- | ------------- | -------------- |
| phase_engine   | tick             | phases        | timing         |
| serializer     | load/shift       | serial_bit    | serialization  |
| bit_tx_engine  | serial_bit       | sda_drive_low | SDA TX         |
| ack_handler    | sda_in           | ack_received  | ACK RX         |
| byte_tx_engine | protocol control | enables       | orchestration  |
