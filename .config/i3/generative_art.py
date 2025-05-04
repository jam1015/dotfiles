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
        mask = iterations_until_divergence == max_iter
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

def generate_convex_vertices(n_points, radius, center=(0, 0)):
    """
    Generate the vertices of a regular convex polygon.

    Arguments:
      n_points: The number of vertices (points) of the polygon.
      radius: The distance of each vertex from the center.
      center: A tuple (x, y) representing the center of the polygon.

    Returns:
      A list of (x, y) tuples representing the vertices of the polygon.
    """
    cx, cy = center
    vertices = []
    for i in range(n_points):
        theta = 2 * np.pi * i / n_points  # even distribution around the circle
        x = cx + radius * np.cos(theta)
        y = cy + radius * np.sin(theta)
        vertices.append((x, y))
    return vertices

# Define example convex sets as lists of (x, y) tuples
convex_sets = [
    generate_convex_vertices(20, 0.003, center = (.3742, -0.17066)),
    generate_convex_vertices(20, 0.0003, center = (.2679249, -0.0039145)),
    generate_convex_vertices(20, 0.0005, center = (-0.1413072, 0.6498438))
]

# You can now easily generate a new convex set using the generate_convex_vertices function.
# For example, to create a pentagon (5 vertices) with a radius of 0.1 centered at (0.2, 0.2):
new_convex_set = generate_convex_vertices(5, 0.1, center=(0.2, 0.2))
print("New Convex Set:", new_convex_set)

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
    (0.0, normalize((2, 9, 28))),    
    (0.5, normalize((4, 14, 56))),    
    (0.75, normalize((5,16,60))), 
    #(0.75, normalize((143,51,204))), 
    (0.85, normalize((148,51,204))), 
    (1.0, normalize((163,51,190))), 
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
