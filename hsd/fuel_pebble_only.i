inlet_T_fluid                = 8.73150000e+02
pebble_diameter              = 0.03
superficial_heat_source      = 2.069727e+07
infinite_porosity            = 4.00e-01
OR_porosity                  = 4.00e-01
plenum_porosity              = 5.00e-01

UO2_phase_fraction           = 1.20427291e-01
buffer_phase_fraction        = 2.86014816e-01
ipyc_phase_fraction          = 1.59496539e-01
sic_phase_fraction           = 1.96561801e-01
opyc_phase_fraction          = 2.37499553e-01
rUO2                         = 2.00000000e-04
rbuffer                      = 3.00000000e-04
ripyc                        = 3.35000000e-04
rSiC                         = 3.70000000e-04
ropyc                        = 4.05000000e-04
TRISO_phase_fraction         = 3.09266232e-01
core_phase_fraction          = 5.12000000e-01
fuel_matrix_phase_fraction   = 3.01037037e-01
shell_phase_fraction         = 1.86962963e-01
rcore                        = 1.20000000e-02
rfuel_matrix                 = 1.40000000e-02
rshell                       = 1.50000000e-02
stainsby_sphere_radius       = 5.98886039e-04

[Problem]
  coord_type = 'RSPHERICAL'
[]

[Mesh]
  # this mesh has the block IDs defined, with a pebble radius of 0.015 m
  file = 'fuel_pebble_mesh_out.e'
  uniform_refine = 1
[]

[MeshModifiers]
  [./fm_left]
    type = SideSetsAroundSubdomain
    block = 1
    new_boundary = 'fm_left'
    normal = '-1 0 0'
  [../]
  [./fm_right]
    type = SideSetsAroundSubdomain
    block = 1
    new_boundary = 'fm_right'
    normal = '1 0 0'
  [../]
[]

[Variables]
  [./T_fuel_matrix]
    initial_condition = 1000.0
    block = '1'
  [../]
  [./T_shell]
    initial_condition = 1000.0
    block = '0 2'
  [../]
[]

[AuxVariables]
  [./superficial_heat_source]
    initial_condition = ${superficial_heat_source}
  [../]
[]

[Kernels]
  [./diffusion]
    type = HeatConduction
    variable = T_fuel_matrix
    diffusion_coefficient = 'k_s'
    block = '1'
  [../]
  [./heat_source]
    type = HeatSrc
    variable = T_fuel_matrix
    heat_source = superficial_heat_source
    scaling_factor = ${fparse 1.0/(1.0-infinite_porosity)/fuel_matrix_phase_fraction}
    block = '1'
  [../]

  [./diffusion2]
    type = HeatConduction
    variable = T_shell
    diffusion_coefficient = 'k_s'
    block = '0 2'
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
    rho_s = 11000.0
    cp_s = 400.0
    k_s = 3.5
  [../]
  [./sic]
    type = ConstantSolidProperties
    rho_s = 3180.0
    cp_s = 1300.0
    k_s = 13.9
  [../]
  [./matrix_and_shell]
    type = ConstantSolidProperties
    rho_s = 1600.0
    cp_s = 1800.0
    k_s = 15.0
  [../]
  [./core]
    type = ConstantSolidProperties
    rho_s = 1450.0
    cp_s = 1800.0
    k_s = 15.0
  [../]
  [./triso]
    type = CompositeSolidProperties
    materials = 'UO2 buffer pyc sic pyc'
    fractions = '${UO2_phase_fraction} ${buffer_phase_fraction} ${ipyc_phase_fraction} ${sic_phase_fraction} ${opyc_phase_fraction}'
    k_mixing = 'parallel'
    rho_mixing = 'parallel'
    cp_mixing = 'parallel'
  [../]
  [./compact]
    type = CompositeSolidProperties
    materials = 'triso matrix_and_shell'
    fractions = '${TRISO_phase_fraction} ${fparse 1.0 - TRISO_phase_fraction}'
    k_mixing = 'chiew'
    rho_mixing = 'chiew'
    cp_mixing = 'chiew'
  [../]
[]

[Materials]
  # coupled temperature is dummy because all properties are constant
  [./fuel_matrix]
    type = PronghornSolidMaterialPT
    T_solid = T_fuel_matrix
    solid = compact
    block = '1'
  [../]
  [./shell]
    type = PronghornSolidMaterialPT
    T_solid = T_shell
    solid = matrix_and_shell
    block = '2'
  [../]
  [./core]
    type = PronghornSolidMaterialPT
    T_solid = T_shell
    solid = core
    block = '0'
  [../]
[]

[BCs]
  [./right]
    type = DirichletBC
    variable = T_shell
    value = 1000.0
    boundary = 'right'
  [../]
  [./interface]
    type = LinearCombinationMatchedValueBC
    variable = T_fuel_matrix
    v = T_shell
    pp_names = 'particle_surface_T'
    pp_coefs = '-1.0'
    boundary = 'fm_left fm_right'
  [../]
[]

[InterfaceKernels]
  [./diffusion]
    type = HeatDiffusionInterface
    variable = T_fuel_matrix
    neighbor_var = T_shell
    boundary = 'fm_left fm_right'
    k = 'k_s'
    k_neighbor = 'k_s'
  [../]
[]

[Postprocessors]
  # receive from microscale solution
  [./particle_surface_T]
    type = Receiver
  [../]
  [./max_T_UO2_microscale]
    type = Receiver
  [../]
  [./average_T_UO2_microscale]
    type = Receiver
  [../]
  [./average_T_matrix_microscale]
    type = Receiver
  [../]
  [./average_T_buffer_microscale]
    type = Receiver
  [../]
  [./average_T_ipyc_microscale]
    type = Receiver
  [../]
  [./average_T_sic_microscale]
    type = Receiver
  [../]
  [./average_T_opyc_microscale]
    type = Receiver
  [../]

  # compute from present solution
  [./max_T_fuel_matrix_mesoscale]
    type = ElementExtremeValue
    variable = T_fuel_matrix
    value_type = max
    block = '1'
  [../]
  [./average_T_core]
    type = ElementAverageValue
    variable = T_shell
    block = '0'
  [../]
  [./average_T_shell]
    type = ElementAverageValue
    variable = T_shell
    block = '2'
  [../]
  [./average_T_fuel_matrix]
    type = ElementAverageValue
    variable = T_fuel_matrix
    block = '1'
  [../]

  # summations of mesoscale and microscale solutions
  [./max_T_UO2]
    type = LinearCombinationPostprocessor
    pp_names = 'max_T_UO2_microscale max_T_fuel_matrix_mesoscale'
    pp_coefs = '1.0 1.0'
  [../]
  [./average_T_UO2]
    type = LinearCombinationPostprocessor
    pp_names = 'average_T_UO2_microscale average_T_fuel_matrix'
    pp_coefs = '1.0 1.0'
  [../]
  [./average_T_matrix]
    type = LinearCombinationPostprocessor
    pp_names = 'average_T_matrix_microscale average_T_fuel_matrix'
    pp_coefs = '1.0 1.0'
  [../]
  [./average_T_buffer]
    type = LinearCombinationPostprocessor
    pp_names = 'average_T_buffer_microscale average_T_fuel_matrix'
    pp_coefs = '1.0 1.0'
  [../]
  [./average_T_ipyc]
    type = LinearCombinationPostprocessor
    pp_names = 'average_T_ipyc_microscale average_T_fuel_matrix'
    pp_coefs = '1.0 1.0'
  [../]
  [./average_T_sic]
    type = LinearCombinationPostprocessor
    pp_names = 'average_T_sic_microscale average_T_fuel_matrix'
    pp_coefs = '1.0 1.0'
  [../]
  [./average_T_opyc]
    type = LinearCombinationPostprocessor
    pp_names = 'average_T_opyc_microscale average_T_fuel_matrix'
    pp_coefs = '1.0 1.0'
  [../]
[]

[MultiApps]
  [./particle]
    type = TransientMultiApp
    execute_on = 'TIMESTEP_BEGIN'
    input_files = 'particle.i'
  [../]
[]

[Transfers]
  [./particle_heat_source]
    type = MultiAppVariableValueSampleTransfer
    direction = to_multiapp
    multi_app = particle
    source_variable = superficial_heat_source
    variable = superficial_heat_source
  [../]
  [./particle_surface_temp]
    type = MultiAppPostprocessorTransfer
    direction = from_multiapp
    multi_app = particle
    from_postprocessor = surface_T
    to_postprocessor = particle_surface_T
    reduction_type = average
  [../]

  # for visualization
  [./max_T_UO2]
    type = MultiAppPostprocessorTransfer
    direction = from_multiapp
    multi_app = particle
    from_postprocessor = max_T_UO2
    to_postprocessor = max_T_UO2_microscale
    reduction_type = average
  [../]
  [./average_T_UO2]
    type = MultiAppPostprocessorTransfer
    direction = from_multiapp
    multi_app = particle
    from_postprocessor = average_T_UO2
    to_postprocessor = average_T_UO2_microscale
    reduction_type = average
  [../]
  [./average_T_matrix]
    type = MultiAppPostprocessorTransfer
    direction = from_multiapp
    multi_app = particle
    from_postprocessor = average_T_matrix
    to_postprocessor = average_T_matrix_microscale
    reduction_type = average
  [../]
  [./average_T_buffer]
    type = MultiAppPostprocessorTransfer
    direction = from_multiapp
    multi_app = particle
    from_postprocessor = average_T_buffer
    to_postprocessor = average_T_buffer_microscale
    reduction_type = average
  [../]
  [./average_T_ipyc]
    type = MultiAppPostprocessorTransfer
    direction = from_multiapp
    multi_app = particle
    from_postprocessor = average_T_ipyc
    to_postprocessor = average_T_ipyc_microscale
    reduction_type = average
  [../]
  [./average_T_sic]
    type = MultiAppPostprocessorTransfer
    direction = from_multiapp
    multi_app = particle
    from_postprocessor = average_T_sic
    to_postprocessor = average_T_sic_microscale
    reduction_type = average
  [../]
  [./average_T_opyc]
    type = MultiAppPostprocessorTransfer
    direction = from_multiapp
    multi_app = particle
    from_postprocessor = average_T_opyc
    to_postprocessor = average_T_opyc_microscale
    reduction_type = average
  [../]
[]

[Executioner]
  type = Transient
  num_steps = 1
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  solve_type = PJFNK
  nl_abs_tol = 1e-6
  picard_force_norms = true
  picard_abs_tol = 1e-2
  picard_max_its = 5
[]

[Preconditioning]
  [./SMP_Newton]
    type = SMP
    full = true
    solve_type = 'PJFNK'
    petsc_options = '-snes_ksp_ew'
    petsc_options_iname = '-pc_type' #-pc_factor_mat_solver_package'
    petsc_options_value = ' lu     ' # mumps                       '
  [../]
[]

[Outputs]
  exodus = false
  print_linear_residuals = false
  csv = true
  hide = 'max_T_UO2_microscale average_T_UO2_microscale average_T_matrix_microscale particle_surface_T'
[]
