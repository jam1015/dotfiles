#!/usr/bin/env python3

import sys
import numpy as np
import matplotlib.pyplot as plt
import time
import os
import random
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

# --- Fractal Computation Functions ---

def compute_julia_set(h_range, w_range, c_value, max_iterations):
    """
    Compute a Julia set for a given complex parameter c_value.
    """
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

def mandelbrot(h_range, w_range, max_iterations):
    """
    Compute the Mandelbrot set.
    """
    y, x = np.ogrid[-1.5:1.5:h_range*1j, -2.0:1.0:w_range*1j]
    c = x + y * 1j
    z = np.zeros_like(c)
    div_time = np.full(c.shape, max_iterations, dtype=int)

    for i in range(max_iterations):
        mask = div_time == max_iterations
        if not mask.any():
            break
        z[mask] = np.square(z[mask]) + c[mask]
        diverged = np.abs(z) > 2
        div_time[diverged & mask] = i

    return np.log(div_time + 1)

# --- Convex Set Sampling on the Complex Plane ---

def random_point_in_triangle(a, b, c):
    """
    Sample a point uniformly inside a triangle defined by complex vertices a, b, c.
    Uses barycentric coordinates.
    """
    r1 = np.random.random()
    r2 = np.random.random()
    if r1 + r2 > 1:
        r1, r2 = 1 - r1, 1 - r2
    return a + r1 * (b - a) + r2 * (c - a)

def triangle_area(a, b, c):
    """
    Compute the area of a triangle defined by complex vertices a, b, c.
    """
    return 0.5 * abs((b - a).real * (c - a).imag - (b - a).imag * (c - a).real)

def random_point_in_convex_polygon(vertices):
    """
    Sample a point uniformly from a convex polygon defined by a list of complex vertices.
    
    The polygon is triangulated from the first vertex.
    """
    vertices = np.array(vertices)
    v0 = vertices[0]
    triangles = []
    areas = []
    
    # Triangulate the polygon: (v0, vertices[i], vertices[i+1])
    for i in range(1, len(vertices) - 1):
        a, b, c = v0, vertices[i], vertices[i+1]
        triangles.append((a, b, c))
        areas.append(triangle_area(a, b, c))
        
    areas = np.array(areas)
    total_area = areas.sum()
    probabilities = areas / total_area
    
    # Randomly choose a triangle weighted by area
    index = np.random.choice(len(triangles), p=probabilities)
    a, b, c = triangles[index]
    return random_point_in_triangle(a, b, c)

def tuples_to_complex(vertices_tuples):
    """
    Convert a list of (x, y) tuples into complex numbers.
    """
    return [complex(x, y) for (x, y) in vertices_tuples]

def random_point_from_random_convex_set(convex_sets):
    """
    Given a list of convex sets (each defined as a list of (x, y) tuples),
    randomly select one, convert its vertices to complex numbers, and
    sample a point uniformly from its interior.
    
    Returns:
      (selected_set, point) where selected_set is the list of tuples.
    """
    selected_set = random.choice(convex_sets)
    selected_set_complex = tuples_to_complex(selected_set)
    point = random_point_in_convex_polygon(selected_set_complex)
    return selected_set, point

# Define example convex sets as lists of (x, y) tuples
convex_sets = [
    # Example Triangle
    #[(,),(,),(,),(,),]
    [(0.06,0.63),(0.061,0.63),(0.061,0.631),(0.06,0.63),],
    [(.311,-0.03),(.311,-0.029),(.31, -0.029),(.31,-0.03),]
    #[(.2401267,-0.5127249),(0.0944565,0.613290),(0.1043697,-0.6165101)],
    # Example Quadrilateral
    #[(0.115, -0.644), (0.1200,-0.63), (0.9907, -0.61), (0.0713, -0.6546)]
]

# --- Determine Which Fractal Set to Generate ---

if fractal_type == 'julia':
    # For the Julia set, use a random point from one of the convex sets as the parameter c_value.
    selected_set, c_value = random_point_from_random_convex_set(convex_sets)
    print("Using parameter c_value from convex set:", c_value)
    fractal_set = compute_julia_set(int(screen_height), int(screen_width), c_value, max_iter)
elif fractal_type == 'mandelbrot':
    fractal_set = mandelbrot(int(screen_height), int(screen_width), max_iter)
else:
    print("Invalid fractal type. Choose either 'mandelbrot' or 'julia'.")
    sys.exit(1)

# --- Visualization and Saving the Image ---

def normalize(color):
    return tuple(component / 255 for component in color)

colors = [
    (0.0, normalize((2, 9, 28))),    # Inverted from (253,246,227)
    (0.5, normalize((4, 14, 56))),    # Inverted from (251,241,199)
    (0.75, normalize((153,51,204))), # Inverted from (186,85,211)
    (0.85, normalize((153,51,204))), # Inverted from (186,85,211)
    (1.0, normalize((153,51,204))), # Inverted from (186,85,211)
    #(0.85, normalize((139, 135, 124))),# Inverted from (116,120,131)
    #(1.0, normalize((206, 245, 197)))  # Inverted from (49,10,58)
]
cmap = LinearSegmentedColormap.from_list('custom_palette', colors, N=256)
norm = Normalize(vmin=0, vmax=fractal_set.max())

fig = plt.figure(figsize=(screen_width / 100, screen_height / 100), dpi=100)
ax = fig.add_axes((0, 0, 1, 1))  # Use the full figure without any padding

ax.imshow(
    fractal_set,
    cmap=cmap,
    extent=(-1.5, 1.5, -1.5, 1.5),
    origin='lower',
    interpolation='lanczos',
    norm=norm
)
ax.axis('off')

# Save the generated image as a TIFF file for lossless quality
output_path = os.path.expanduser(output_path)
plt.savefig(output_path, format='tiff', dpi=100, bbox_inches='tight', pad_inches=0)
plt.close()
