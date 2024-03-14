import struct

# Определение структуры "Билет"
class Ticket:
    def __init__(self, destination, departure, date, cost):
        self.destination = destination
        self.departure = departure
        self.date = date
        self.cost = cost

# Создание трех экземпляров структуры "Билет"
tickets = [
    Ticket("Москва", "Санкт-Петербург", "20240301", "5000"),
    Ticket("Санкт-Петербург", "Москва", "20240302", "5000"),
    Ticket("Москва", "Казань", "20240303", "3000")
]

# Открытие файла для записи в бинарном формате
with open("input.txt", "wb") as f:
    for ticket in tickets:
        # Упаковка данных в бинарный формат и запись в файл
        f.write(struct.pack('50s50s10s4s', ticket.destination.encode(), ticket.departure.encode(), ticket.date.encode(), ticket.cost.encode()))
