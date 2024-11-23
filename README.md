# Project WS2812 RGB example

Use Verilog HDL to implement control WS2812 RGB with T-core.

## Core Concepts
  - Transmit series data to RGB implement control.  
  - The data fram and format show as below:  

### RGB data frame of 24bit data  

   |MSB < --- > LSB|  
   |-----|
   |G[7:0],R[7:0],[7:0]|  
   
   
### RGB Data Format    
  
                             
    ** 0 code  |<--->|<----->¢x  
                 T0H    T0L   
                 
    ** 1 code  |<----->|<--->¢x  
                 T1H    T1L   

### Code Timeing  
 

   |Code Status|Description|Timing|
   | ----- | ----- |-----|
   |T0H|0 code, high voltage time.|220nS ~ 380nS|
   |T0L|0 code, high voltage time.|580nS ~ 1uS|
   |T1H|1 code, high voltage time.|580nS ~ 1uS|
   |T1L|1 code, high voltage time.|220nS ~ 420nS|  
   

  - Reference : WS2812B-2020 datasheet

## Environment
### Tool
  - Quartus Prime 20.1
### Development board
  - [Terasic T-Core](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=Taiwan&CategoryNo=219&No=1240) 
## Author
  - Kamen Fu, 2021/11/16