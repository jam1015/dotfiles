#!/usr/bin/env python3

import sys
import numpy as np
import matplotlib.pyplot as plt
import time
import os
from matplotlib.colors import LinearSegmentedColormap, Normalize
plt.style.use('dark_background')

# Use current time as random seed
seed = int(time.time() * 1000) % (2**32 - 1)
np.random.seed(seed)

# Get the output path, screen dimensions, and fractal type from command line arguments
if len(sys.argv) != 5:
    print("Usage: python3 generative_art.py <output_path> <screen_width> <screen_height> <fractal_type>")
    sys.exit(1)

output_path = sys.argv[1]
screen_width = int(sys.argv[2]) * 1.125
screen_height = int(sys.argv[3]) * 1.125
fractal_type = sys.argv[4]

# Set maximum iterations for detailed computation
max_iter = 1250

# Function to generate the Julia set
def julia_set(h_range, w_range, max_iterations):
    y, x = np.ogrid[-1.5:1.5:h_range*1j, -1.5:1.5:w_range*1j]
    z_array = x + y * 1j
    # Randomly generate the complex number for the Julia set
    c_value = np.random.uniform(-0.8, 0.8) + np.random.uniform(-0.8, 0.8) * 1j
    iterations_until_divergence = np.full(z_array.shape, max_iterations, dtype=int)

    # Iterate to find the number of iterations till divergence
    for i in range(max_iterations):
        mask = iterations_until_divergence == max_iterations
        z_array[mask] = z_array[mask] ** 2 + c_value
        diverging = np.abs(z_array) > 2
        diverging_now = diverging & mask
        iterations_until_divergence[diverging_now] = i

    # Apply a logarithmic scale to enhance the visual separation
    iterations_until_divergence = np.log(iterations_until_divergence + 1)
    return iterations_until_divergence

# Function to generate the Mandelbrot set
def mandelbrot(h_range, w_range, max_iterations):
    y, x = np.ogrid[-1.5:1.5:h_range*1j, -2.0:1.0:w_range*1j]
    c = x + y * 1j
    z = np.zeros_like(c)
    div_time = np.full(c.shape, max_iterations, dtype=int)

    for i in range(max_iterations):
        mask = div_time == max_iterations
        z[mask] = z[mask] ** 2 + c[mask]
        diverged = np.abs(z) > 2
        div_time[diverged & mask] = i

    # Apply a logarithmic scale to enhance the visual separation
    div_time = np.log(div_time + 1)
    return div_time

# Determine which set to generate
if fractal_type == 'julia':
    fractal_set = julia_set(screen_height, screen_width, max_iter)
elif fractal_type == 'mandelbrot':
    fractal_set = mandelbrot(screen_height, screen_width, max_iter)
else:
    print("Invalid fractal type. Choose either 'mandelbrot' or 'julia'.")
    sys.exit(1)

# Define the custom colormap for the Julia set appearance
def normalize(color):
    return tuple(component / 255 for component in color)

colors = [
    (0.0, normalize((50, 50, 50))),    # Lighter grey
    (0.2, normalize((50, 50, 50))),    # Darker grey
    (0.4, normalize((220, 220, 220))), # Pinkish grey
    (0.6, normalize((255, 182, 193))), # Lighter pink
    (0.75, normalize((186, 85, 211))), # Dark pink
    (0.85, normalize((75, 0, 130))),   # Lighter purple
    (1.0, normalize((48, 0, 48)))      # Deep purple for the set itself
]

cmap = LinearSegmentedColormap.from_list('custom_palette', colors, N=256)

# Normalize the colormap based on the log-scaled data range
norm = Normalize(vmin=0, vmax=fractal_set.max())

# Directly create the figure using exact pixel dimensions
fig = plt.figure(figsize=(screen_width / 100, screen_height / 100), dpi=100)
ax = fig.add_axes((0, 0, 1, 1))  # Use the full figure without any padding

# Display the fractal set
ax.imshow(
    fractal_set,
    cmap=cmap,
    extent=(-1.5, 1.5, -1.5, 1.5),
    origin='lower',
    interpolation='lanczos',  # No smoothing for precise pixel output
    norm=norm
)
ax.axis('off')

# Save the generated image as a TIFF file for lossless quality
output_path = os.path.expanduser(output_path)
plt.savefig(output_path, format='tiff', dpi=100, bbox_inches='tight', pad_inches=0)
plt.close()
