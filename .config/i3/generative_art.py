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

# Original Julia set computation function
def compute_julia_set(h_range, w_range, c_value, max_iterations):
    y, x = np.ogrid[-1.5:1.5:h_range*1j, -1.5:1.5:w_range*1j]
    z_array = x + y * 1j
    iterations_until_divergence = np.full(z_array.shape, max_iterations, dtype=int)

    for i in range(max_iterations):
        mask = iterations_until_divergence == max_iterations
        if not mask.any():
            break  # Early exit if all points have diverged
        z_array[mask] = np.square(z_array[mask]) + c_value
        diverging = np.abs(z_array) > 2
        diverging_now = diverging & mask
        iterations_until_divergence[diverging_now] = i

    return np.log(iterations_until_divergence + 1)

# Function to generate the Mandelbrot set with early exit and np.square usage
def mandelbrot(h_range, w_range, max_iterations):
    y, x = np.ogrid[-1.5:1.5:h_range*1j, -2.0:1.0:w_range*1j]
    c = x + y * 1j
    z = np.zeros_like(c)
    div_time = np.full(c.shape, max_iterations, dtype=int)

    for i in range(max_iterations):
        mask = div_time == max_iterations
        if not mask.any():
            break  # Early exit if all points have diverged
        z[mask] = np.square(z[mask]) + c[mask]
        diverged = np.abs(z) > 2
        div_time[diverged & mask] = i

    return np.log(div_time + 1)

# Determine which set to generate
if fractal_type == 'julia':
    # Hard-code the parameter for the Julia set
    c_value = -0.7577111 + 0.0681141j
    print(f"Using fixed parameter c_value: {c_value}")
    fractal_set = compute_julia_set(int(screen_height), int(screen_width), c_value, max_iter)
elif fractal_type == 'mandelbrot':
    fractal_set = mandelbrot(int(screen_height), int(screen_width), max_iter)
else:
    print("Invalid fractal type. Choose either 'mandelbrot' or 'julia'.")
    sys.exit(1)

# Define a function to normalize color components
def normalize(color):
    return tuple(component / 255 for component in color)

colors = [
    (0.0, normalize((253,246,227))),    # Lighter grey
    #(0.2, normalize((251,241,199))),    # Darker grey
    (0.5, normalize((251,241,199))),    # Pinkish grey
    #(0.6, normalize((229, 182, 255))),    # Lighter pink
    (0.75, normalize((186, 85, 211))),    # Dark pink
    (0.85, normalize((116, 120, 131))),   # Lighter purple
    (1.0, normalize((49, 10, 58)))        # Deep purple for the set itself
]
cmap = LinearSegmentedColormap.from_list('custom_palette', colors, N=256)
norm = Normalize(vmin=0, vmax=fractal_set.max())

# Directly create the figure using exact pixel dimensions
fig = plt.figure(figsize=(screen_width / 100, screen_height / 100), dpi=100)
ax = fig.add_axes((0, 0, 1, 1))  # Use the full figure without any padding

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
