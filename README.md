# Water Leak Detector

h/w used: esp8266 with wifi and flash with esp_easy. 

Moisture sensor. Xenon Smart WiFi control Water Valve 

Raspberry Pi to run /usr/sbin/mosquitto server where esp8266 will publish state change of moisture sensor. 

Same Raspberry pi will also run leakdetect2ifttt.sh <-- file in this project 

When leak is detected, leakdetect2ifttt.sh will POST to ifttt webhook, 

which will notify via phone-call/email/sms etc... 

and sample cronjob file cronjob-leakdetect2ifttt.sh
