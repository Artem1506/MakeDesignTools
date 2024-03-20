import json
import urllib.request

URL = 'https://api.exchangerate-api.com/v4/latest/USD'
exchangerate_json_bin = urllib.request.urlopen(URL)
exchangerate = json.load(exchangerate_json_bin)

def WriteDataFile(data, filename):
    data = json.dumps(data)
    data = json.loads(str(data))
    with open(filename, 'w', encoding = 'utf-8') as file:
        json.dump(data, file, indent = 4, ensure_ascii = False, separators = (',', ': '))
WriteDataFile(exchangerate, "d:/Test.json")

print("1 доллар стоит", exchangerate.get("rates").get("RUB"), "рублей")

currencies = exchangerate.get("rates")
RUB = currencies.get("RUB")
EUR = currencies.get("EUR")
print("1 евро стоит", round(RUB/EUR, 2), "рублей")

kopilka = []
# Для каждого названия валюты в списке валют:
for currency in currencies:
    # Добавляем в копилку (название валюты, отношение курса рубля к курсу валюты)
    kopilka.append((currency, RUB/currencies.get(currency)))
# Сортируем копилку по ключу, который - вторая колонка, т.е. курсы валют
kopilka.sort(key=lambda row: row[1])
# печатаем курс самой дешевой валюты - Индонезийская рупия
print(kopilka[0])
#>>> ('IDR', 0.004854)
# печатаем курс самой дорогой валюты - Фунт стерлингов
print(kopilka[-1])
#>>> ('GBP', 98.704728)

