from PIL import Image
import sys
import binascii

def s2b(s):
   return bin(int(binascii.hexlify(s),16))[2:]

def b2s(binary):
   hex_stuff = '%x' % int(binary, 2)
   if len(hex_stuff) % 2 == 1:
      hex_stuff = '0' + hex_stuff
   return binascii.unhexlify(hex_stuff)

img = Image.open(sys.argv[1])
img_data = img.tobytes()

# print image data in case solution is in raw color data
print(img_data)

num_bits_per_pixel = len(img.getpixel((0,0)))*8

image_data_binary = s2b(img_data)

for i in range(num_bits_per_pixel):
   print b2s(image_data_binary[i::num_bits_per_pixel])

for i in range(8):
   print b2s(image_data_binary[i::8])
