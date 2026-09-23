from machine import Pin,ADC
import time

adc = ADC(Pin(2))

try:
    while True:
        # adc_value = adc.read()
        # print(adc_value)
        
        # 40.2k / 10k divider restoration: (40.2 + 10) / 10 = 5.02
        voltage = adc.read()/4095*5.02*0.96
        percent = (voltage - 3.0) / (4.25 - 3.0) * 100
        percent = max(0, min(100, percent))
        print(voltage, percent)
        
        time.sleep(1.0)
        
except KeyboardInterrupt:
    print("코드를 종료합니다.")
