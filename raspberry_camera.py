#The real code which will be loaded on the RaPi when it will fly on our first
#mission. The objective here is to continously take pictures until an
#interruption from the user is detected.
#The quality of the images should be the higher possible.
#A 2-positions switch might be more suitable
#At the reboot, When the buttoon is pressed again it ovewrites
#the photos with the same name, this is unacceptable.

#from picamera import PiCamera
from time import sleep
import subprocess
import RPi.GPIO as GPIO
import os
import time
GPIO.setmode(GPIO.BOARD)
GPIO.setup(5,GPIO.IN,pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(11,GPIO.OUT)
GPIO.setup(16,GPIO.OUT)

ledpin=11
buzpin=16
#camera = PiCamera()

def blink(ledpin):
  GPIO.output(ledpin,GPIO.HIGH)
  time.sleep(0.05)
  GPIO.output(ledpin,GPIO.LOW)
  time.sleep(0.05)
  return

def buzzer(buzpin):
   GPIO.output(buzpin,GPIO.HIGH)
   time.sleep(0.01)
   GPIO.output(buzpin,GPIO.LOW)
   time.sleep(0.01)
   return

#Lock implementation
tp_prev=0
tp_aft=0

#camera.rotation = 180
#camera.resolution=(2592,1944)
#camera.framerate =15

# Photo dimensions and rotation
photo_width  = 3280
photo_height = 2464
photo_rotate = 180

photo_interval = 0.01 # Interval between photos (seconds)
photo_counter  = 0    # Photo counter

total_photos = 1000

# Delete all previous image files
try:
  os.remove("photo_*.jpg")
except OSError:
  pass

#k=0
try:
  while True:
    input_state=GPIO.input(5)
    while input_state==0:
      photo_counter = photo_counter + 1
      filename = 'photo_' + str(photo_counter) + '.jpg'    
      cmd = 'raspistill -o /media/pi/TONYDRIVE/Photoscan/' + filename + ' -t 10 ' + ' -w ' + str(photo_width) + ' -h ' + str(photo_height) + ' -rot ' + str(photo_rotate) + ' -n'
      pid = subprocess.call(cmd, shell=True)
      print(' [' + str(photo_counter) + ' of ' + str(total_photos) + '] ' + filename)  
      time.sleep(photo_interval)
      blink(11)
      buzzer(16)
      #k=k+1
      input_state=GPIO.input(5)
      if input_state!=0:
        break
        
    
     
except KeyboardInterrupt:
  GPIO.cleanup()
  # User quit
  print("\nGoodbye!")



