from servo import Servo
import time
import random
import math as m

m1 = Servo(1, freq=200)
m2 = Servo(2, freq=200)
L1 = 80
L2 = 80
increment = 1
v = 1 # degrees / sec
m1.write(-90)
m2.write(90)
time.sleep(3)
c_a1 = -89
c_a2 = 89

# for i in range(increment*180+10000000):
#test for range
    #one time motion
target1_array = [-90, -90, -18, -30, 72, -60, -72, -90, 18, -30, -90]
target1_index = 0
target2_array = [90, 30, -90, 30, -90, 30, -90, 30, -90, 30, 90]
target2_index = 0

while target2_index < len(target2_array) :
    target1 = target1_array[target1_index]
    target2 = target2_array[target2_index]
    target1_index = target2_index

#reaching onetime target
    while c_a1 != target1 or c_a2 != target2:
        if target1 > c_a1:
            c_a1 += v
        elif target1 < c_a1:
            c_a1 -= v
        else:
            pass
        if target2 > c_a2:
            c_a2 += v
        elif target2 < c_a2:
            c_a2 -= v #(c_a2 - target2)/increment
        else:
            pass
        c_a1 = int(c_a1)
        c_a2 = int(c_a2)
        m1.write(c_a1)
        m2.write(c_a2)
        time.sleep(0.1)
        print(c_a1, target1, target1_index, c_a2, target2, target2_index)
    
    target2_index += 1
    target1_index += 1

m1.off()
m2.off()