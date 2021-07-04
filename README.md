# WhatFlower
An iOS app to identify the flower captured using camera and display info about it.
It uses Oxford's flower detection caffe model. First caffe model was converted to mlmodel by installing coremltools in python and running the python script.
The resulting mlmodel is used in the iOS app. After flower detection, the information related to it is fetched using wikipedia api and also the wikipedia image of that flower is displayed using SDWebImage pod.

Main screen of app:

![](https://github.com/shubham101096/WhatFlower/blob/main/screenshots/home.jpg)


Image captured using camera:

![](https://github.com/shubham101096/WhatFlower/blob/main/screenshots/capture.jpg)


Detected flower's info and image fetched from wikipedia:

![](https://github.com/shubham101096/WhatFlower/blob/main/screenshots/info.jpg)
