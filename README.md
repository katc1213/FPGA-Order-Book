# FPGA Order Book
This project is based off an orderbook created by [FPGAnow](https://fpganow.com/index.php/fpga-order-book/). While their version utilizes LabVIEW FPGA and an Arty Artix-7 A100T Board, I will be referring off his documentation to create an orderbook on a Xilinx Pynq-Z2 board (with Zynq-7000 SoC) as a Vivado project, which will allow me to later apply other open-source interfaces or communication protocols to retrieve and display real-time market data.  

  # Structure and Implementation  
  ![hash_ob](https://github.com/user-attachments/assets/2b2970ac-5709-467a-a26d-f85472902961)  
  Note: There will most likely be a downside in adding in all the order information as values into the hash table, especially if the values are linked lists. This is not the most efficient way to store our orders, but for the time being, I will try to implement the order book in this structure.  
  ### Modules
- orderbook (hash table)
- parser (parse incoming market data or commands)

## Specifications, Protocols, Fundamentals
[BATS PITCH Documentation](https://cdn.cboe.com/resources/membership/BATS_PITCH_Specification.pdf)

### Market Data
[Polygon.io](https://polygon.io/)

### Hash Table for Orderbook Template
[Simple Hash Table in Verilog](https://github.com/Aarun2/Hash_Verilog/blob/main/hash.v) <br />
[More about Hashing](https://adamwalker.github.io/Building-Better-Hashtable/)

## References and Readings
[High Frequency Trading FPGA System](https://github.com/muditbhargava66/High-Frequency-Trading-FPGA-System/tree/main) <br />
[FPGAnow Orderbook Repo](https://github.com/HFTConsultancy/Order-Book-FPGA/tree/main) <br />
[HFT Accelerator](https://web.mit.edu/6.111/volume2/www/f2019/projects/endrias_Project_Proposal_Revision.pdf) <br />
[More reading](https://www.doc.ic.ac.uk/~wl/papers/17/fpl17ch.pdf)

