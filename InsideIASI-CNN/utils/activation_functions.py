import numpy as np
import matplotlib.pyplot as plt


def relu(n):
    return np.maximum(0, n)


x = np.linspace(-5, 5, 100)

y = relu(x)

plt.plot(x, y)
plt.title('ReLU')
plt.savefig('../results/relu.jpg')
plt.show()
