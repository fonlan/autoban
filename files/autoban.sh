#!/bin/sh

BAN_TIME=86400
MAX_ATTEMPTS=3
DB_FILE=/tmp/autoban.db

get_recent_bad_password_log() {
    current_time=$(date "+%s")
    logread -t -e "Bad password attempt" | awk '{gsub(/\[|\]|:[0-9]+/, ""); print $6, $15}' | while read timestamp ip
    do
        timestamp=${timestamp%.*}
        log_time=$(date -d @$timestamp "+%s")
        time_diff=$((current_time - log_time))
        if [ $time_diff -le $BAN_TIME ]; then
            echo "$ip"
        fi
    done
}

if [ -f "$DB_FILE" ]; then
    cat "$DB_FILE" | while read ip ban_to_time; do
        ban_to_time=$(echo -n "$ban_to_time" | tr -d '\n')
        current_time=$(date "+%s")
        if [ $current_time -ge $ban_to_time ]; then
            logger -t autoban "$ip has been removed from block list"
            iptables -D INPUT -s $ip -j DROP
        fi
    done
fi

ips=$(get_recent_bad_password_log)
if [ -z "$ips" ]; then
    exit 0
fi
echo -e "$ips" | sort -u | while read ip
do
    attempts=$(echo -e "$ips" | grep -c "$ip")
    if [ $attempts -ge $MAX_ATTEMPTS ]; then
        current_time=$(date "+%s")
        ban_to_time=$((current_time + BAN_TIME))
        if [ -f "$DB_FILE" ]; then
            if ! grep -q "^$ip " $DB_FILE; then
                iptables -I INPUT -s $ip -j DROP
                echo "$ip $ban_to_time" >> $DB_FILE
                logger -t autoban "$ip has been added to block list"
            fi
        else
            iptables -I INPUT -s $ip -j DROP
            echo "$ip $ban_to_time" >> $DB_FILE
            logger -t autoban "$ip has been added to block list"
        fi
    fi
done