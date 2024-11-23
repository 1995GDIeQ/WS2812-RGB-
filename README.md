# Project WS2812 RGB example

Use Verilog HDL to implement control WS2812 RGB with T-core.

## Core Concepts
  - Transmit series data to RGB implement control.  
  - The data fram and format show as below:
### RGB data frame of 24bit data
    ** ¢z¢w¢w¢s¢w¢w¢s¢w¢w¢s¢w¢w¢s¢w¢w¢s¢w¢w¢s¢w¢w¢s¢w¢w¢s¢w¢w¢s¢w¢w¢s¢w¢w¢s¢w¢w¢s¢w¢w¢s¢w¢w¢s¢w¢w¢s¢w¢w¢s¢w¢w¢s¢w¢w¢s¢w¢w¢s¢w¢w¢s¢w¢w¢s¢w¢w¢s¢w¢w¢s¢w¢w¢{  
    ** ¢xG7¢xG6¢xG5¢xG4¢xG3¢xG2¢xG1¢xG0¢xR7¢xR6¢xR5¢xR4¢xR3¢xR2¢xR1¢xR0¢xB7¢xB6¢xB5¢xB4¢xB3¢xB2¢xB1¢xB0¢x  
    ** ¢|¢w¢w¢r¢w¢w¢r¢w¢w¢r¢w¢w¢r¢w¢w¢r¢w¢w¢r¢w¢w¢r¢w¢w¢r¢w¢w¢r¢w¢w¢r¢w¢w¢r¢w¢w¢r¢w¢w¢r¢w¢w¢r¢w¢w¢r¢w¢w¢r¢w¢w¢r¢w¢w¢r¢w¢w¢r¢w¢w¢r¢w¢w¢r¢w¢w¢r¢w¢w¢r¢w¢w¢}  
  
  - RGB Data Format    
  
               ¢z¢w¢w¢w¢w¢w¢{  T0L     
    ** 0 code  ¢x<¢w¢w¢w>¢x<¢w¢w¢w¢w¢w>¢x  
                 T0H ¢|¢w¢w¢w¢w¢w¢w¢w¢}    
                 
               ¢z¢w¢w¢w¢w¢w¢w¢w¢{ T1L     
    ** 1 code  ¢x<¢w¢w¢w¢w¢w>¢x<¢w¢w¢w>¢x  
                  T1H  ¢|¢w¢w¢w¢w¢w¢}   

  - Code Timeing  
      
    T0H : 0 code, high voltage time. Timing : 220nS ~ 380nS 
    T0L : 0 code, low voltage time.  Timing : 580nS ~ 1uS  
    T1H : 1 code, high voltage time. Timing : 580nS ~ 1uS 
    T1L : 1 code, low voltage time.  Timing : 220nS ~ 420nS

  - Reference : [WS2812B-2020](chrome-extension://efaidnbmnnnibpcajpcglclefindmkaj/https://www.mouser.com/pdfDocs/WS2812B-2020_V10_EN_181106150240761.pdf?srsltid=AfmBOoq4kVTW1Kd4cecszxTfjnK4cY6bD8OjZAIEXLBvChCkqj7E89n8)  
  
## Environment
### Tool
  - Quartus Prime 20.1
### Development board
  - [Terasic T-Core](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=Taiwan&CategoryNo=219&No=1240) 
### Author
  - Kamen Fu, 2021/11/16