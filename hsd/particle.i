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
  type = GeneratedMesh
  dim = 1
  nx = 20000
  xmin = 0
  xmax = ${stainsby_sphere_radius}
[]

[MeshModifiers]
  [./UO2]
    type = SubdomainBoundingBox
    block_id = '1'
    bottom_left = '0.0 0.0 0.0'
    top_right = '${rUO2} 0.0 0.0'
  [../]
  [./buffer]
    type = SubdomainBoundingBox
    block_id = '2'
    bottom_left = '${rUO2} 0.0 0.0'
    top_right = '${rbuffer} 0.0 0.0'
  [../]
  [./ipyc]
    type = SubdomainBoundingBox
    block_id = '3'
    bottom_left = '${rbuffer} 0.0 0.0'
    top_right = '${ripyc} 0.0 0.0'
  [../]
  [./sic]
    type = SubdomainBoundingBox
    block_id = '4'
    bottom_left = '${ripyc} 0.0 0.0'
    top_right = '${rSiC} 0.0 0.0'
  [../]
  [./opyc]
    type = SubdomainBoundingBox
    block_id = '5'
    bottom_left = '${rSiC} 0.0 0.0'
    top_right = '${ropyc} 0.0 0.0'
  [../]
  [./graphite]
    type = SubdomainBoundingBox
    block_id = '6'
    bottom_left = '${ropyc} 0.0 0.0'
    top_right = '${stainsby_sphere_radius} 0.0 0.0'
  [../]
[]

[Variables]
  [./T_unshifted]
  [../]
[]

[AuxVariables]
  [./superficial_heat_source]
  [../]
  [./T]
  [../]
[]

[AuxKernels]
  [./T]
    type = ShiftedAux
    variable = T
    unshifted_variable = T_unshifted
    shift_postprocessor = negative_average_T_unshifted
    execute_on = 'TIMESTEP_END'
  [../]
[]

[Kernels]
  [./diffusion]
    type = HeatConduction
    variable = T_unshifted
    diffusion_coefficient = 'k_s'
    block = '1 2 3 4 5 6'
  [../]
  [./heat_source]
    type = HeatSrc
    variable = T_unshifted
    heat_source = superficial_heat_source
    scaling_factor = ${fparse 1.0/(1.0-0.4)/fuel_matrix_phase_fraction/TRISO_phase_fraction/UO2_phase_fraction}
    block = '1'
  [../]
  [./heat_sink]
    type = HeatSrc
    variable = T_unshifted
    heat_source = superficial_heat_source
    scaling_factor = ${fparse -1.0/(1.0-0.4)/fuel_matrix_phase_fraction}
    block = '1 2 3 4 5 6'
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
    cp_const = 1300.0
    k_const = 13.9
  [../]
  [./matrix_and_shell]
    type = ConstantSolidProperties
    rho_const = 1600.0
    cp_const = 1800.0
    k_const = 15.0
  [../]
[]

[Materials]
  # the temperature coulped to these materials is not actually used since all properties
  # are constant w.r.t. temperature
  [./pyc]
    type = PronghornSolidMaterialPT
    solid = pyc
    block = '3 5'
    T_solid = T_unshifted
  [../]
  [./UO2]
    type = PronghornSolidMaterialPT
    solid = UO2
    block = '1'
    T_solid = T_unshifted
  [../]
  [./buffer]
    type = PronghornSolidMaterialPT
    solid = buffer
    block = '2'
    T_solid = T_unshifted
  [../]
  [./SiC]
    type = PronghornSolidMaterialPT
    solid = sic
    block = '4'
    T_solid = T_unshifted
  [../]
  [./matrix_and_shell]
    type = PronghornSolidMaterialPT
    solid = matrix_and_shell
    block = '6'
    T_solid = T_unshifted
  [../]
[]

[BCs]
  [./right]
    type = DirichletBC
    variable = T_unshifted
    value = 0.0
    boundary = 'right'
  [../]
[]

[Postprocessors]
  [./average_T_unshifted]
    type = ElementAverageValue
    variable = T_unshifted
    execute_on = 'LINEAR'
  [../]
  [./negative_average_T_unshifted]
    type = ScalePostprocessor
    value = average_T_unshifted
    scaling_factor = -1.0
    execute_on = 'TIMESTEP_END'
  [../]
  [./surface_T]
    type = PointValue
    variable = T
    point = '${stainsby_sphere_radius} 0.0 0.0'
    execute_on = 'TIMESTEP_END'
  [../]

  # for visualization only
  [./max_T_UO2]
    type = ElementExtremeValue
    variable = T
    value_type = max
    block = '1'
    execute_on = 'TIMESTEP_END'
  [../]
  [./average_T_UO2]
    type = ElementAverageValue
    variable = T
    block = '1'
    execute_on = 'TIMESTEP_END'
  [../]
  [./average_T_matrix]
    type = ElementAverageValue
    variable = T
    block = '6'
    execute_on = 'TIMESTEP_END'
  [../]
  [./average_T_buffer]
    type = ElementAverageValue
    variable = T
    block = '2'
    execute_on = 'TIMESTEP_END'
  [../]
  [./average_T_ipyc]
    type = ElementAverageValue
    variable = T
    block = '3'
    execute_on = 'TIMESTEP_END'
  [../]
  [./average_T_sic]
    type = ElementAverageValue
    variable = T
    block = '4'
    execute_on = 'TIMESTEP_END'
  [../]
  [./average_T_opyc]
    type = ElementAverageValue
    variable = T
    block = '5'
    execute_on = 'TIMESTEP_END'
  [../]
[]

[Executioner]
  type = Transient
  num_steps = 1
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  solve_type = PJFNK
  nl_abs_tol = 1e-6
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Outputs]
  print_linear_residuals = false
  hide = 'average_T_unshifted negative_average_T_unshifted'
[]
