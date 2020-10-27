# Waveform Generator
RTL schematic of the top level given as following.

![image](https://user-images.githubusercontent.com/45906647/97337378-40b72100-1891-11eb-9075-dab58e95c669.png)


| Module                     | Description                                                  |
| --------                   | -----------                                                  | 
| UART Module                | Communication                                                |
| Command Handler            | Handle inputs comes from UART                                | 
| Enable Generator           | Generate enable signal according to desired frequency        | 
| Waveform Generator         | Generate one byte signal according to desired wave type      | 
| Sclk Generator             | Generate clock signals which is required for PMOD DAC module | 
| Data Synchronization       | Generate 16 bit data and SYNC signal for PMOD DAC            | 
