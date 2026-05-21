| Module         | Inputs           | Outputs       | Responsibility |
| -------------- | ---------------- | ------------- | -------------- |
| phase_engine   | tick             | phases        | timing         |
| serializer     | load/shift       | serial_bit    | serialization  |
| bit_tx_engine  | serial_bit       | sda_drive_low | SDA TX         |
| ack_handler    | sda_in           | ack_received  | ACK RX         |
| byte_tx_engine | protocol control | enables       | orchestration  |


SIGNAL OWNERSHIP-
| Signal        | Producer       | Consumer                    |
| ------------- | -------------- | --------------------------- |
| load          | byte_tx_engine | serializer                  |
| shift_enable  | byte_tx_engine | serializer                  |
| serial_bit    | serializer     | bit_tx_engine               |
| ack_phase     | byte_tx_engine | bit_tx_engine + ack_handler |
| sda_drive_low | bit_tx_engine  | line_controller             |
| sda_in        | physical bus   | ack_handler                 |
| ack_received  | ack_handler    | byte_tx_engine              |
