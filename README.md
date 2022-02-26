# JPEG: Encoder/Decoder

This repository contains the implementation of a JPEG encoder and decoder for which its performance is compared with that of the Matlab implementation. The [jpeg.mlx](jpeg.mlx) live script performs the compression of a JPEG image and compare its performance with the JPEG compression that Matlab implements. In this live script an image is selected and compressed for different values of the compression quality parameter and different metrics are evaluated: SSIM, MSE, the size of the compressed image in bits/pixel and the speed of encoding and decoding.
