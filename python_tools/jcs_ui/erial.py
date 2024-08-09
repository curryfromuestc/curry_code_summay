import  cv2
import  serial
import numpy as np


header = b"mage:0,153600,320,240,7\n"
header_length = len(header)

global rgb_image

    
def main():
    rgb_image = np.zeros((480, 640, 3), dtype=np.uint8)
    # open the serial
    ser = serial.Serial('COM10', 921600, timeout=0.3)
    cv2.namedWindow("preview", cv2.WINDOW_AUTOSIZE)

    #ser.write(b"(t/")

    while 1:
        read_data = ser.read(1)
        if read_data == b'i':
            if ser.read_until(header) == header:
                print("header received")
                #data = ser.read(153600)

                image_data = b""
                while len(image_data) < 153600:  # 图像数据的字节量
                    image_data += ser.read(153600 - len(image_data))
                image_array = np.frombuffer(image_data, dtype=np.uint16)

                r = ((image_array >> 11) & 0x1F) << 3
                g = ((image_array >> 5) & 0x3F) << 2
                b = (image_array & 0x1F) << 3

                # 重新组合RGB通道


                r_mul= np.zeros((240,320))
                g_mul= np.zeros((240,320))
                b_mul= np.zeros((240,320))

                for y in range(240):
                    for x in range(320):
                        r_mul[y,x]=r[y*320+x]
                        g_mul[y,x]=g[y*320+x]
                        b_mul[y,x]=b[y*320+x]


                rgb_image = np.dstack((r_mul, g_mul, b_mul))

                rgb_image = rgb_image.astype(np.uint8)

                rgb_image = cv2.resize(rgb_image, (640, 480))

                rgb_image = cv2.cvtColor(rgb_image, cv2.COLOR_RGB2BGR)

                cv2.imshow("preview", rgb_image)
                
        elif read_data == b'(':
            print("pos header received")
            position_data = b""
            while len(position_data) < 14:
                position_data += ser.read(14 - len(position_data))
            print("position_data = ", position_data)

            square_x = position_data[1] *256 + position_data[2]
            square_y = position_data[3] 
            print("square_x = ", square_x)
            print("square_y = ", square_y)
            circle_x = position_data[8] *256 + position_data[9]
            circle_y = position_data[10] 
            print("circle_x = ", circle_x)
            print("circle_y = ", circle_y)
            hexagon_x = position_data[11] *256 + position_data[12]
            hexagon_y = position_data[13] 
            print("hexagon_x = ", hexagon_x)
            print("hexagon_y = ", hexagon_y)
            square_left = position_data[4] * 256 + position_data[5]
            square_right = position_data[6] * 256 + position_data[7]
            print("square_left = ", square_left)
            print("square_right = ", square_right)

            rgb_image_copy = rgb_image.copy()
            rgb_image_copy = cv2.drawMarker(rgb_image_copy, (square_x*2, square_y*2), (0, 255, 0), markerType=cv2.MARKER_SQUARE, markerSize=6, thickness=2)
            rgb_image_copy = cv2.drawMarker(rgb_image_copy, (circle_x*2, circle_y*2), (0, 255, 0), markerType=cv2.MARKER_CROSS, markerSize=6, thickness=2)
            rgb_image_copy = cv2.drawMarker(rgb_image_copy, (hexagon_x*2, hexagon_y*2), (0, 255, 0), markerType=cv2.MARKER_DIAMOND, markerSize=6, thickness=2)
            rgb_image_copy = cv2.rectangle(rgb_image_copy, (square_left*2, 0), (square_right*2, 480), (0, 255, 0), 2)

            cv2.imshow("preview", rgb_image_copy)

        cv2.waitKey(1)
    

if __name__ == "__main__":
    main()