x = float(input("Enter: x = "))
a = float(input("Enter: a = "))

def calc_y1():
    if x <= 4:
        return 4 * x
    return x - a

def calc_y2():
    if x % 2 != 0:
        return 7
    return x/2 + a

for i in range(0, 10):
    x += i
    y1 = calc_y1()
    y2 = calc_y2()
    y = y1 + y2
    print("y = " + str(y))
