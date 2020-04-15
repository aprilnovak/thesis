# Superficial heat source W/m^3:
superficial_heat_source       = 2.06972700e+07

# Outer radius of representative matrix sphere around TRISO particle:
sphere_radius                 = 7.24061863e-04

# Phase fractions of layers in TRISO particle w.r.t. TRISO volume:
UO2_phase_fraction            = 1.20427291e-01
buffer_phase_fraction         = 2.86014816e-01
ipyc_phase_fraction           = 1.59496539e-01
sic_phase_fraction            = 1.96561801e-01
opyc_phase_fraction           = 2.37499553e-01

# Outer radii of each layer of the TRISO particle:
rUO2                          = 2.00000000e-04
rbuffer                       = 3.00000000e-04
ripyc                         = 3.35000000e-04
rSiC                          = 3.70000000e-04
ropyc                         = 4.05000000e-04

# Phase fractions of TRISO particles in fuel-matrix region:
TRISO_phase_fraction          = 1.75000000e-01

# Phase fractions of layers of the pebble:
core_phase_fraction           = 5.12000000e-01
fuel_matrix_phase_fraction    = 3.01037037e-01
shell_phase_fraction          = 1.86962963e-01

# Outer radii of each layer of the pebble:
rcore                         = 1.20000000e-02
rfuel_matrix                  = 1.40000000e-02
rshell                        = 1.50000000e-02

# Representative particle 1
left_matrix_or_0  = 1.23150366e-02
left_opyc_or_0    = 1.23304858e-02
left_sic_or_0     = 1.23432428e-02
left_ipyc_or_0    = 1.23535749e-02
left_buffer_or_0  = 1.23720596e-02
uo2_or_0          = 1.23875829e-02
right_buffer_or_0 = 1.24059665e-02
right_ipyc_or_0   = 1.24161945e-02
right_sic_or_0    = 1.24287763e-02
right_opyc_or_0   = 1.24439446e-02

left_matrix_dr_0  = 3.15036582e-04
left_opyc_dr_0    = 1.54491976e-05
left_sic_dr_0     = 1.27570060e-05
left_ipyc_dr_0    = 1.03320973e-05
left_buffer_dr_0  = 1.84847169e-05
uo2_dr_0          = 1.55233467e-05
right_buffer_dr_0 = 1.83835882e-05
right_ipyc_dr_0   = 1.02280137e-05
right_sic_dr_0    = 1.25817585e-05
right_opyc_dr_0   = 1.51682471e-05

# Representative particle 2
left_matrix_or_1  = 1.30184485e-02
left_opyc_or_1    = 1.30322760e-02
left_sic_or_1     = 1.30436978e-02
left_ipyc_or_1    = 1.30529512e-02
left_buffer_or_1  = 1.30695119e-02
uo2_or_1          = 1.30834253e-02
right_buffer_or_1 = 1.30999092e-02
right_ipyc_or_1   = 1.31090834e-02
right_sic_or_1    = 1.31203720e-02
right_opyc_or_1   = 1.31339858e-02

left_matrix_dr_1  = 2.80774046e-04
left_opyc_dr_1    = 1.38274593e-05
left_sic_dr_1     = 1.14218714e-05
left_ipyc_dr_1    = 9.25339278e-06
left_buffer_dr_1  = 1.65607296e-05
uo2_dr_1          = 1.39133968e-05
right_buffer_dr_1 = 1.64838179e-05
right_ipyc_dr_1   = 9.17423441e-06
right_sic_dr_1    = 1.12885924e-05
right_opyc_dr_1   = 1.36137949e-05

# Representative particle 3
left_matrix_or_2  = 1.36530965e-02
left_opyc_or_2    = 1.36656701e-02
left_sic_or_2     = 1.36760589e-02
left_ipyc_or_2    = 1.36844771e-02
left_buffer_or_2  = 1.36995471e-02
uo2_or_2          = 1.37122120e-02
right_buffer_or_2 = 1.37272212e-02
right_ipyc_or_2   = 1.37355768e-02
right_sic_or_2    = 1.37458603e-02
right_opyc_or_2   = 1.37582650e-02

left_matrix_dr_2  = 2.54527262e-04
left_opyc_dr_2    = 1.25736057e-05
left_sic_dr_2     = 1.03888242e-05
left_ipyc_dr_2    = 8.41823974e-06
left_buffer_dr_2  = 1.50699978e-05
uo2_dr_2          = 1.26648576e-05
right_buffer_dr_2 = 1.50091971e-05
right_ipyc_dr_2   = 8.35566321e-06
right_sic_dr_2    = 1.02834648e-05
right_opyc_dr_2   = 1.24047020e-05

[Problem]
  coord_type = 'RSPHERICAL'
[]

[Mesh]
  type = MeshGeneratorMesh
  uniform_refine = 1
[]

[MeshGenerators]
  [./mesh]
    type = CartesianMeshGenerator
    dim = 1
    dx = '${rcore} ${left_matrix_dr_0} ${left_opyc_dr_0} ${left_sic_dr_0} ${left_ipyc_dr_0} ${left_buffer_dr_0} ${uo2_dr_0} ${right_buffer_dr_0} ${right_ipyc_dr_0} ${right_sic_dr_0} ${right_opyc_dr_0} ${fparse left_matrix_or_1-right_opyc_or_0} ${left_opyc_dr_1} ${left_sic_dr_1} ${left_ipyc_dr_1} ${left_buffer_dr_1} ${uo2_dr_1} ${right_buffer_dr_1} ${right_ipyc_dr_1} ${right_sic_dr_1} ${right_opyc_dr_1} ${fparse left_matrix_or_2-right_opyc_or_1} ${left_opyc_dr_1} ${left_sic_dr_2} ${left_ipyc_dr_2} ${left_buffer_dr_2} ${uo2_dr_2} ${right_buffer_dr_2} ${right_ipyc_dr_2} ${right_sic_dr_2} ${right_opyc_dr_2} ${fparse rfuel_matrix-right_opyc_or_2} ${fparse rshell-rfuel_matrix}'
    ix = '10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10'
    subdomain_id = '0 2 3 4 5 6 7 6 5 4 3 2 3 4 5 6 7 6 5 4 3 2 3 4 5 6 7 6 5 4 3 2 1'
  [../]
[]

[Variables]
  [./T]
    initial_condition = 1000.0
  [../]
[]

[AuxVariables]
  [./superficial_heat_source]
    initial_condition = ${superficial_heat_source}
  [../]
  [./k]
    family = MONOMIAL
    order = CONSTANT
  [../]
[]

[AuxKernels]
  [./k]
    type = MaterialRealAux
    variable = k
    property = k_s
  [../]
[]

[Kernels]
inactive = 'time'
  [./time]
    type = HeatConductionTimeDerivative
    variable = T
    specific_heat = 'cp_s'
    density_name = 'rho_s'
    block = '0 1 2 3 4 5 6 7'
  [../]
  [./diffusion]
    type = HeatConduction
    variable = T
    diffusion_coefficient = 'k_s'
    block = '0 1 2 3 4 5 6 7'
  [../]
  [./heat_source]
    type = HeatSrc
    variable = T
    heat_source = superficial_heat_source
    scaling_factor = ${fparse 1.0/(1.0-0.4)/fuel_matrix_phase_fraction/TRISO_phase_fraction/UO2_phase_fraction}
    block = '7'
  [../]
[]

[UserObjects]
  [./pyc]
    type = PyroliticGraphite
  [../]
  [./buffer]
    type = PorousGraphite
  [../]
  [./UO2]
    type = ConstantSolidProperties
    rho_const = 11000.0
    cp_const = 400.0
    k_const = 3.5
  [../]
  [./sic]
    type = ConstantSolidProperties
    rho_const = 3180.0
    cp_const = 130.0
    k_const = 13.9
  [../]
  [./matrix_and_shell]
    type = ConstantSolidProperties
    rho_const = 1600.0
    cp_const = 1800.0
    k_const = 15.0
  [../]
  [./core]
    type = ConstantSolidProperties
    rho_const = 1450.0
    cp_const = 1800.0
    k_const = 15.0
  [../]
[]

[Materials]
  # all coupled temperatures are dummy because properties are constant
  [./pyc]
    type = PronghornSolidMaterialPT
    T_solid = T
    solid = pyc
    block = '3 5'
  [../]
  [./sic]
    type = PronghornSolidMaterialPT
    T_solid = T
    solid = sic
    block = '4'
  [../]
  [./buffer]
    type = PronghornSolidMaterialPT
    T_solid = T
    solid = buffer
    block = '6'
  [../]
  [./uo2]
    type = PronghornSolidMaterialPT
    T_solid = T
    solid = UO2
    block = '7'
  [../]
  [./matrix_and_shell]
    type = PronghornSolidMaterialPT
    T_solid = T
    solid = matrix_and_shell
    block = '1 2'
  [../]
  [./core]
    type = PronghornSolidMaterialPT
    T_solid = T
    solid = core
    block = '0'
  [../]
[]

[BCs]
  [./right_constant]
    type = DirichletBC
    variable = T
    boundary = 'right'
    value = 1000.0
  [../]
[]

[Postprocessors]
  [./average_T_core]
    type = ElementAverageValue
    variable = T
    block = '0'
  [../]
  [./average_T_shell]
    type = ElementAverageValue
    variable = T
    block = '1'
  [../]
  [./max_T_UO2]
    type = ElementExtremeValue
    variable = T
    block = '7'
  [../]
  [./average_T_UO2]
    type = ElementAverageValue
    variable = T
    block = '7'
  [../]
  [./average_T_matrix]
    type = ElementAverageValue
    variable = T
    block = '2'
  [../]
  [./average_T_buffer]
    type = ElementAverageValue
    variable = T
    block = '6'
  [../]
  [./average_T_ipyc]
    type = ElementAverageValue
    variable = T
    block = '5'
  [../]
  [./average_T_sic]
    type = ElementAverageValue
    variable = T
    block = '4'
  [../]
  [./average_T_opyc]
    type = ElementAverageValue
    variable = T
    block = '3'
  [../]

  # postprocessors for verifying correct volume preservation
  [./particle_vol]
    type = VolumePostprocessor
    block = '3 4 5 6 7'
  [../]
  [./fuel_matrix_vol]
    type = VolumePostprocessor
    block = '2 3 4 5 6 7'
  [../]
  [./kernel_vol]
    type = VolumePostprocessor
    block = '7'
  [../]
  [./shell_vol]
    type = VolumePostprocessor
    block = '1'
  [../]
[]

[Executioner]
  type = Transient
  num_steps = 1
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  nl_abs_tol = 5e-6
[]

[Preconditioning]
  [./SMP_Newton]
    type = SMP
    full = true
    petsc_options = '-snes_ksp_ew'
    petsc_options_iname = '-pc_type'
    petsc_options_value = ' lu     '
  [../]
[]

[Outputs]
  exodus = true
  print_linear_residuals = false
  csv = true
[]
