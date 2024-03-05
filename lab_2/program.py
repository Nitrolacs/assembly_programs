
def calc_y1(x, a):
    if x <= 4:
        return 4 * x
    return x - a

def calc_y2(x, a):
    if x % 2 != 0:
        return 7
    return x//2 + a



def main():
    x = float(input("Enter: x = ")) - 1
    a = float(input("Enter: a = "))

    for _ in range(0, 10):
        x += 1
        print(x)
        y1 = calc_y1(x, a)
        y2 = calc_y2(x, a)
        y = y1 + y2
        print("y = " + str(y))
if __name__ == "__main__":
    main()