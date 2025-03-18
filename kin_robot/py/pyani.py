import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

# Robot link lengths
l1, l2, l3 = 3, 3, 4

# Tolerance value to handle floating point inaccuracies
TOLERANCE = 1e-5

# Function to calculate inverse kinematics
def inverse_kinematics(x, y):
    # Calculate the distance from the base to the target point
    r = np.sqrt(x**2 + y**2)
    
    # Check if the point is reachable with a small tolerance
    if r > l1 + l2 + l3 + TOLERANCE:
        raise ValueError("Target is out of reach")

    # Compute the third joint angle θ3
    cos_angle3 = (r**2 - l1**2 - l2**2 - l3**2) / (2 * l2 * l3)
    cos_angle3 = np.clip(cos_angle3, -1, 1)  # Clamp to avoid numerical errors
    sin_angle3 = np.sqrt(1 - cos_angle3**2)
    theta3 = np.arctan2(sin_angle3, cos_angle3)

    # Compute the second joint angle θ2
    cos_angle2 = (x**2 + y**2 - l1**2 - l2**2) / (2 * l1 * l2)
    cos_angle2 = np.clip(cos_angle2, -1, 1)  # Clamp to avoid numerical errors
    sin_angle2 = np.sqrt(1 - cos_angle2**2)
    theta2 = np.arctan2(sin_angle2, cos_angle2)

    # Compute the first joint angle θ1
    theta1 = np.arctan2(y, x) - theta2

    return theta1, theta2, theta3

# Function to calculate the position of each joint
def forward_kinematics(theta1, theta2, theta3):
    # Base coordinates
    x0, y0 = 0, 0
    # First joint
    x1 = l1 * np.cos(theta1)
    y1 = l1 * np.sin(theta1)
    # Second joint
    x2 = x1 + l2 * np.cos(theta1 + theta2)
    y2 = y1 + l2 * np.sin(theta1 + theta2)
    # Third joint (end effector)
    x3 = x2 + l3 * np.cos(theta1 + theta2 + theta3)
    y3 = y2 + l3 * np.sin(theta1 + theta2 + theta3)

    return [(x0, y0), (x1, y1), (x2, y2), (x3, y3)]

# Generate animation
fig, ax = plt.subplots()
ax.set_xlim(-10, 10)
ax.set_ylim(-10, 10)

line, = ax.plot([], [], lw=2)

# Initial and final target positions
start_pos = (2, 2)
end_pos = (3, 3)

# Create a list of intermediate points for smooth movement
x_values = np.linspace(start_pos[0], end_pos[0], 100)
y_values = np.linspace(start_pos[1], end_pos[1], 100)

# Initialize function for animation
def init():
    line.set_data([], [])
    return line,

# Update function for animation
def update(frame):
    x = x_values[frame]
    y = y_values[frame]

    try:
        # Calculate the inverse kinematics for the current point
        theta1, theta2, theta3 = inverse_kinematics(x, y)
    except ValueError as e:
        print(f"Error: {e}")
        return line,  # Skip this frame if the point is out of reach
    
    # Calculate the positions of the robot arm joints
    positions = forward_kinematics(theta1, theta2, theta3)
    
    # Extract the x and y coordinates of each joint
    x_coords, y_coords = zip(*positions)
    
    # Update the line plot
    line.set_data(x_coords, y_coords)
    
    return line,

# Create the animation
ani = animation.FuncAnimation(fig, update, frames=100, init_func=init, blit=True, interval=50)

# Show the animation
plt.title("3-Link Robotic Arm Animation")
plt.grid(True)
plt.show()

