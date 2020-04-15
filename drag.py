import matplotlib.pyplot as plt
from scipy.optimize import curve_fit
import numpy as np
from matplotlib.lines import Line2D

colors = ['r', 'k', 'b']

def func(x, a, b):
  return a / x + b

rho = 1962.2
mu = 0.0067808
Re1 = [250., 500., 750., 1000., 1250., 1500., 2000.]
Re2 = [250., 500., 750., 1000., 1250., 1500., 1750., 2000.]
Re3 = [250., 500., 1250., 1750., 2000.]

Re_fit = np.linspace(250.0, 2000.0, 1000.0)

horizontal = {}
vertical = {}

def friction_factor(x, Re):
  V = [Re[i] * mu / rho / x['D'] for i in range(len(Re))]
  f = [x['D'] / rho / (V[i] ** 2) * (x['dp'][i] / x['L']) for i in range(len(Re))]
  return f

def friction_fit(x, Re):
  popt, pcov  = curve_fit(func, Re, x['f'])
  fit = [popt[0] / Re_fit[i] + popt[1] for i in range(len(Re_fit))]
  print('\n', popt[0], popt[1])

  friction_err(x, Re)
  return fit

def friction_err(x, Re):
  popt, pcov  = curve_fit(func, Re, x['f'])
  fit = [popt[0] / Re[i] + popt[1] for i in range(len(Re))]
  percent_error = [abs(fit[i] - x['f'][i]) / x['f'][i] for i in range(len(Re))]
  print('max and average percent error: ', max(percent_error), np.mean(percent_error))


horizontal['1'] = {}
horizontal['1']['dp'] = [48.58515, 140.0029, 273.1424, 447.6863, 662.2723, 916.2921, 1220.075, 1542.5893]
horizontal['1']['D']  = 0.034311
horizontal['1']['e']  = 0.1459
horizontal['1']['L'] = 1.65 - 1.25
horizontal['1']['f'] = friction_factor(horizontal['1'], Re2)
horizontal['1']['fit'] = friction_fit(horizontal['1'], Re2)

vertical['1'] = {}
vertical['1']['dp'] = [49.246164, 142.5322, 274.55, 439.8888, 639.836, 873.2916, 1147.349, 1436.0337]
vertical['1']['D'] = 0.026516
vertical['1']['e'] = 0.1459
vertical['1']['L'] = 0.5
vertical['1']['f'] = friction_factor(vertical['1'], Re2)
vertical['1']['fit'] = friction_fit(vertical['1'], Re2)

horizontal['05'] = {}
horizontal['05']['dp'] = [269.088, 720.503, 1344.5103, 2139.88, 3109.245, 4249.27, 5546.2045, 6999.31]
horizontal['05']['D'] = 0.02582
horizontal['05']['e'] = 0.1123
horizontal['05']['L'] = 1.65 - 1.25
horizontal['05']['f'] = friction_factor(horizontal['05'], Re2)
horizontal['05']['fit'] = friction_fit(horizontal['05'], Re2)

vertical['05'] = {}
vertical['05']['dp'] = [302., 778.7369, 3292.6116, 5750.545, 7166.708]
vertical['05']['D'] = 0.020058
vertical['05']['e'] = 0.1123
vertical['05']['L'] = 0.5
vertical['05']['f'] = friction_factor(vertical['05'], Re3)
vertical['05']['fit'] = friction_fit(vertical['05'], Re3)

horizontal['025'] = {}
horizontal['025']['D'] = 0.02129
horizontal['025']['e'] = 0.09520
horizontal['025']['L'] = 1.65 - 1.25


plt.loglog(Re2, horizontal['1']['f'], marker = 'd', color = colors[0], linestyle = 'None')
plt.loglog(Re_fit, horizontal['1']['fit'], color = colors[0], linestyle = '--')

plt.loglog(Re2, vertical['1']['f'], marker = 'd', color = colors[0], linestyle = 'None')
plt.loglog(Re_fit, vertical['1']['fit'], color = colors[0])

plt.loglog(Re2, horizontal['05']['f'], marker = 'o', color = colors[1], linestyle = 'None')
plt.loglog(Re_fit, horizontal['05']['fit'], color = colors[1], linestyle = '--')

plt.loglog(Re3, vertical['05']['f'], marker = 'o', color = colors[1], linestyle = 'None')
plt.loglog(Re_fit, vertical['05']['fit'], color = colors[1])

custom_lines = [
Line2D([0], [0], color = colors[0], marker = 'd', linestyle = '--', lw = 1),
Line2D([0], [0], color = colors[0], marker = 'd', lw = 1),
Line2D([0], [0], color = colors[1], marker = 'o', linestyle = '--', lw = 1),
Line2D([0], [0], color = colors[1], marker = 'o', lw = 1)
]

plt.xlabel('Reynolds Number', fontsize=16)
plt.ylabel('Friction Factor', fontsize=16)
plt.xticks(fontsize=16)
plt.yticks(fontsize=16)
plt.legend(custom_lines, ['10 mm gap, horizontal', '10 mm gap, vertical', '5 mm gap, horizontal', '5 mm gap, vertical'], loc = 'lower right')
plt.grid()
plt.savefig('figure.pdf', bbox_inches = 'tight')

