from servo import Servo
import time as t
import random
import math as m
from machine import Pin


l = 1
m1 = Servo(1, freq=200)
m2 = Servo(2, freq=200)
L1 = 80
L2 = 80
increment = 15
v = 1 # degrees / sec

# LED on pin D4 and set it to ON
led = Pin(22, Pin.OUT)
led.value(0)

m1.write(0)
m2.write(0)
t.sleep(3)
c_a1 = 0
c_a2 = 0

# for i in range(increment*180+10000000):
#test for range
    #one time motion
# target2_array = list(range(-90, 91, 2))

# Mx = [50, 20, 90, 50, 120]
# My = [120, 50, 70, 20, 40]

Mx = [9, 20, 34, 53, 59]
Ex = [109, 80, 79, 109, 80, 105]
My = [76, 20, 76, 20, 76]
Ey = [20, 20, 76, 76, 47, 47]
M_l = [1, 1, 1, 1]
E_l = [1, 1, 1, 0, 1]

#compose each array
x_base = Mx + Ex
y_base = My + Ey
L_ed = M_l + [0] + E_l + [0]

print(x_base)


x_array = []
y_array = []
led_array = []

#interpolation
def linear_interpolation(x0, y0, x1, y1, x):
    return y0 + (y1 - y0) * (x - x0) / (x1 - x0)

for i in range(len(x_base) - 1):
    x0, x1 = x_base[i], x_base[i + 1]
    y0, y1 = y_base[i], y_base[i + 1]
    l0, l1 = L_ed[i], L_ed[i + 1]
    
    x_array.append(x0)
    y_array.append(y0)
    led_array.append(l0)
    n = 10 #num of interpolation
    
    step = (x1 - x0) / n  
    for j in range(1, n):
        x_interp = x0 + j * step
        y_interp = linear_interpolation(x0, y0, x1, y1, x_interp)
        led_interp = l0
        x_array.append(x_interp)
        y_array.append(y_interp)
        led_array.append(led_interp)

x_array.append(x_base[-1])
y_array.append(y_base[-1])
led_array.append(L_ed[-1])

index = 0

target1_array = [0] * len(x_array)
target2_array = [0] * len(x_array)

#next step: controlling light as an array so that Alphabets like E could be written precisely

def decartodegree(x_array, y_array):
    global target1_array, target2_array
    target1_index = target2_index = 0
    for index in range(len(x_array)):  
        L = (x_array[index] ** 2 + y_array[index] ** 2) ** 0.5
        theta2 = m.acos((L ** 2 - L1 ** 2 - L2 ** 2) / 2 / L1 / L2)
        
        target2_array[target2_index] = int(180 / 3.14 * theta2)        
        theta1 = m.atan(y_array[index] / x_array[index]) - 0.5 * theta2
        target1_array[target1_index] = int(180 / 3.14 * theta1)

        
        if target1_array[target1_index] < -90:
            target1_array[target1_index] = target1_array[target1_index] 
        else:
            pass
        target2_array[target2_index] = target2_array[target2_index] - 90
        
        print(target1_array[target1_index], target2_array[target2_index])
        
        target1_index += 1
        target2_index += 1
    print(target1_array, target2_array)
    return target1_array, target2_array

target1_array, target2_array = decartodegree(x_array, y_array)

target1_index = 0
target2_index = 0

led.value(0)

#drawing based on array
while target2_index < len(target2_array) :
    target1 = target1_array[target1_index]
    target2 = target2_array[target2_index]
    index = target1_index = target2_index
    
    while c_a1 != target1 or c_a2 != target2:
        v1 = int(abs((target1_array[target1_index] - target1_array[target1_index - 1]) / increment)) + 1
        v2 = int(abs((target2_array[target2_index] - target2_array[target2_index - 1]) / increment)) + 1
#         v1 = 1
#         v2 = 1
        if target1 > c_a1:
            if target1 - c_a1 > v1:
                c_a1 += v1
            elif target1 - c_a1 < v1:
                c_a1 += 1
            else:
                c_a1 += v1
        elif target1 < c_a1:
            if - target1 + c_a1 > v1:
                c_a1 -= v1
            elif - target1 + c_a1 < v1:
                c_a1 -= 1
            else:
                c_a1 -= v1
        else:
            pass
        if target2 > c_a2:
            if target2 - c_a2 > v2:
                c_a2 += v2
            elif target2 - c_a2 < v2:
                c_a2 += 1
            else:
                c_a2 += v2
        elif target2 < c_a2:
            if - target2 + c_a2 > v2:
                c_a2 -= v1
            elif - target2 + c_a2 < v2:
                c_a2 -= 1
            else:
                c_a2 -= v2
        else:
            pass
        led.value
        c_a1 = int(c_a1)
        c_a2 = int(c_a2)
        m1.write(c_a1)
        m2.write(c_a2)
        t.sleep(0.05)
        print(c_a1, target1, v1, target1_index, c_a2, target2, v2, target2_index)
        if target1_index > 0:
            led.value(led_array[index])
    target2_index += 1
    target1_index += 1
    
m1.off()
m2.off()


                                        
                                
    
        
