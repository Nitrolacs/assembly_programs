import struct

# Определение структуры "Билет"
class Ticket:
    def __init__(self, destination, departure, date, cost):
        self.destination = destination
        self.departure = departure
        self.date = date
        self.cost = cost

    def __str__(self):
        return f"Пункт назначения: {self.destination}, Пункт вылета: {self.departure}, Дата: {self.date}, Стоимость: {self.cost}"

# Открытие файла для чтения в бинарном формате
with open("input.txt", "rb") as f:
    while True:
        # Чтение данных из файла
        data = f.read(struct.calcsize('50s50s10s4s'))
        if not data:  # Конец файла
            break

        # Распаковка данных
        destination, departure, date, cost = struct.unpack('50s50s10s4s', data)

        # Создание экземпляра структуры "Билет" и вывод его на экран
        ticket = Ticket(destination.decode().strip('\x00'), departure.decode().strip('\x00'), date.decode().strip('\x00'), cost.decode().strip('\x00'))
        print(ticket)
