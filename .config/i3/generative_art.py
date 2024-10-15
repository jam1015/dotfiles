#!/usr/bin/env python3

import sys
import numpy as np
import matplotlib.pyplot as plt
import time
import os
from matplotlib.colors import LinearSegmentedColormap, Normalize

# Use current time as random seed
seed = int(time.time() * 1000) % (2**32 - 1)
np.random.seed(seed)

# Get the output path, screen dimensions, and fractal type from command line arguments
if len(sys.argv) != 5:
    print("Usage: python3 generative_art.py <output_path> <screen_width> <screen_height> <fractal_type>")
    sys.exit(1)

output_path = sys.argv[1]
screen_width = int(sys.argv[2])
screen_height = int(sys.argv[3])
fractal_type = sys.argv[4]

# Calculate aspect ratio
aspect_ratio = screen_width / screen_height

# Set maximum iterations for faster computation
max_iter = 500

# Generate the Mandelbrot set
def mandelbrot(h, w, x_min, x_max, y_min, y_max, max_iter):
    x = np.linspace(x_min, x_max, w)
    y = np.linspace(y_min, y_max, h)
    X, Y = np.meshgrid(x, y)
    C = X + 1j * Y
    Z = np.zeros_like(C, dtype=complex)
    div_time = np.full(C.shape, max_iter, dtype=int)

    for i in range(max_iter):
        mask = div_time == max_iter
        Z[mask] = Z[mask]**2 + C[mask]
        diverged = np.abs(Z) > 2
        div_time[diverged & mask] = i
        Z[diverged] = 2  # Prevent overflow

    return div_time

# Generate the Julia set with a centered and zoomed-in view
def julia(h, w, x_min, x_max, y_min, y_max, c, max_iter):
    # Zoom in to make the fractal visible, and center the view
    zoom_factor = 1.5  # Adjust this to zoom in more or less
    x_min, x_max = -zoom_factor, zoom_factor
    y_min, y_max = -zoom_factor / aspect_ratio, zoom_factor / aspect_ratio

    x = np.linspace(x_min, x_max, w)
    y = np.linspace(y_min, y_max, h)
    X, Y = np.meshgrid(x, y)
    Z = X + 1j * Y
    div_time = np.full(Z.shape, max_iter, dtype=int)

    for i in range(max_iter):
        mask = div_time == max_iter
        Z[mask] = Z[mask]**2 + c
        diverged = np.abs(Z) > 2
        div_time[diverged & mask] = i
        Z[diverged] = 2  # Prevent overflow

    return div_time

# Set up the figure and axes
dpi = 100
width_px = screen_width
height_px = screen_height
width_in = width_px / dpi
height_in = height_px / dpi

fig, ax = plt.subplots(figsize=(width_in, height_in), dpi=dpi)

# Mandelbrot random zoom level and center
x_center = np.random.uniform(-2.0, 0.5)
y_center = np.random.uniform(-1.5, 1.5)
scale = 10 ** np.random.uniform(-1.5, 0)
x_width = 3.5 * scale
y_height = x_width / aspect_ratio
x_min = x_center - x_width / 2
x_max = x_center + x_width / 2
y_min = y_center - y_height / 2
y_max = y_center + y_height / 2

# Select whether to generate Mandelbrot or Julia set
if fractal_type == 'mandelbrot':
    fractal_set = mandelbrot(height_px, width_px, x_min, x_max, y_min, y_max, max_iter)
elif fractal_type == 'julia':
    # Randomly seed Julia set with a complex number
    c = np.random.uniform(-0.5, 0.5) + 1j * np.random.uniform(-0.5, 0.5)
    fractal_set = julia(height_px, width_px, x_min, x_max, y_min, y_max, c, max_iter)
else:
    print("Invalid fractal type. Choose either 'mandelbrot' or 'julia'.")
    sys.exit(1)

# Define the custom colormap with positions and colors
colors = [
    (0.0, (128/255, 128/255, 128/255)),    # Grey at position 0.0
    (0.25, (230/255, 230/255, 250/255)),   # Lavender
    (0.5, (255/255, 182/255, 193/255)),    # Pink
    (0.75, (255/255, 105/255, 180/255)),   # Hot Pink
    (1.0, (102/255, 2/255, 60/255))        # Tyrian Purple at position 1.0
]
cmap = LinearSegmentedColormap.from_list('custom_palette', colors, N=256)

# Normalize the colormap to enhance contrast
norm = Normalize(vmin=0, vmax=fractal_set.max())

# Display the fractal set
ax.imshow(
    fractal_set.T,
    cmap=cmap,
    extent=(x_min, x_max, y_min, y_max),
    origin='lower',
    interpolation='bilinear',
    norm=norm
)
ax.axis('off')

# Save the generated image
output_path = os.path.expanduser(output_path)
plt.savefig(output_path, bbox_inches='tight', pad_inches=0)
plt.close()
