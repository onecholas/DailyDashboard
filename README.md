# DailyDashboard
FPGA-based security camera system with built in room ambient statistics tracking

## Hardware
1. ARTY Z7 Development Board
2. OV7670 Camera
3. BMP390 Barometric Sensor
4. 5 Inch TFT LCD Screen 800x480
5. SD Card for temperature statistics and hallway images

## Description
- BMP390 -> I2C -> FPGA
- OV7670 -> I2C -> FPGA
- FPGA -> SPI -> TFT

## Development Plan
- Write SPI Master
- Verify SPI Master
- Write SPI Implementation for TFT Display
- Write I2C Master
- Verify I2C Master
- Write I2C Implementation for BMPP390
- Write I2C Implementation for OV7670

## Acknowledgements
- I self learned this by watching Nandland and reading online forums!
