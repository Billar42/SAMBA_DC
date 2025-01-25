#!/bin/bash

# Путь к сертификату
CERT_PATH="/etc/letsencrypt/live/example.com/fullchain.pem"

# Получаем дату окончания действия сертификата
EXPIRATION_DATE=$(openssl x509 -enddate -noout -in $CERT_PATH | cut -d= -f2)

# Преобразуем дату в формат timestamp
EXPIRATION_TIMESTAMP=$(date -d "$EXPIRATION_DATE" +%s)

# Получаем текущую дату в формате timestamp
CURRENT_TIMESTAMP=$(date +%s)

# Разница в днях между текущей датой и датой окончания действия сертификата
DAYS_LEFT=$(( (EXPIRATION_TIMESTAMP - CURRENT_TIMESTAMP) / 86400 ))

# Проверяем, осталось ли меньше 90 дней
if [ "$DAYS_LEFT" -lt 90 ]; then
    echo "Сертификат истекает через $DAYS_LEFT дней. Обновляем сертификат..."
    sudo certbot renew
else
    echo "Сертификат действителен еще $DAYS_LEFT дней. Обновление не требуется."
fi
