#!/usr/bin/python
# -*- coding: utf-8 -*-
#####################################################
## lecture de sondes de temperature 1-wire DS18B20 ##
## 15/07/2014 Jahislove                            ##
## lancement : sudo python ...                     ##
#####################################################
from os import system
from time import sleep
import OPi.GPIO as GPIO
from time import sleep          # this lets us have a time delay

GPIO.setboard(GPIO.ZERO)    # Orange Pi PC board
GPIO.setmode(GPIO.BOARD)        # set up BOARD BCM numbering
GPIO.setup(7, GPIO.OUT)

## module GPIO 1-wire et capteur de temperature #####
system('modprobe w1-gpio')
system('modprobe w1-therm')
## chemin vers les sondes ###########################
base_dir = '/sys/bus/w1/devices/'
## Remplacez les repertoires 28-xxxxxxxxxxx #########
## par vos propres repertoires . ####################
## Et si vous avez un nombre de sonde different #####
## supprimer (ou ajouter) les lignes ci dessous #####
sonde1 = "/sys/bus/w1/devices/w1_bus_master1/28-3c01a8160ce7/w1_slave"
## et ajuster aussi les 2 lignes ci dessous #########
sondes = [sonde1]
sonde_value = [0]
## fonction ouverture et lecture d'un fichier #######
def lire_fichier(fichier):
    f = open(fichier, 'r')
    lignes = f.readlines()
    f.close()
    return lignes
## code principal ###################################
try:
    print ("Press CTRL+C to exit")
    while True:
        for (i, sonde) in enumerate(sondes):
            lignes = lire_fichier(sonde)
            while lignes[0].strip()[-3:] != 'YES': # lit les 3 derniers char de la ligne 0 et recommence si pas YES
               sleep(0.2)
               lignes = lire_fichier(sonde)
            temp_raw = lignes[1].split("=")[1] # quand on a eu YES, on lit la temp apres le signe = sur la ligne 1
            sonde_value[i] = round(int(temp_raw) / 1000.0, 2) # le 2 arrondi a 2 chiffres apres la virgule
            print("sonde",i,"=",sonde_value[i]) # affichage a l'ecran
            GPIO.output(7, 1)       # set port/pin value to 1/HIGH/True
            sleep(0.1)
            GPIO.output(7, 0)       # set port/pin value to 0/LOW/False
            sleep(0.1)
            GPIO.output(7, 1)       # set port/pin value to 1/HIGH/True
            sleep(0.1)
            GPIO.output(7, 0)       # set port/pin value to 0/LOW/False
            sleep(0.1)
            sleep(0.5)
except KeyboardInterrupt:
    print ("Bye.")
