from machine import Pin, PWM
import time  

# Servo motor PWM settings
SERVO_PIN = 0  # GPIO0
FREQ = 50  # Standard servo frequency (50Hz)
servo = PWM(Pin(SERVO_PIN), freq=FREQ, duty_ns=1500000)  # Default stop position (1500µs)

# PWM range
STOP_DUTY = 1500000   # 1500µs = stop
MAX_CW_DUTY = 2000000 # 2000µs = max speed clockwise
MAX_CCW_DUTY = 1000000 # 1000µs = max speed counterclockwise

start_time = None  

def set_speed(pwm_us):
    """Set servo speed based on PWM value"""
    global start_time
    if 1000 <= pwm_us <= 2000:
        pwm_value = int((pwm_us - 1000) * (MAX_CW_DUTY - MAX_CCW_DUTY) / 1000 + MAX_CCW_DUTY)
        servo.duty_ns(pwm_value)
        
        if pwm_us == 1500:
            if start_time is not None:
                elapsed_us = time.ticks_diff(time.ticks_us(), start_time) / 1000
                print(f"Stopped | Run time: {elapsed_us} ms")
                start_time = None  
            else:
                print("Already stopped")
        else:
            if start_time is None:
                start_time = time.ticks_us()  
            elapsed_us = time.ticks_diff(time.ticks_us(), start_time) / 1000  
            print(f"PWM: {pwm_us} µs | Run time: {elapsed_us} ms")
    else:
        print("Enter a value between 1000 and 2000")

try:
    while True:
        set_speed(int(input("Enter PWM (1000-2000 µs, 1500=stop): ")))

except KeyboardInterrupt:
    set_speed(1500)  
    print("\nExited, motor stopped.")