'# MWS Version: Version 2022.5 - Jun 03 2022 - ACIS 31.0.1 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 1 fmax = 10
'# created = '[VERSION]2022.0|31.0.1|20210823[/VERSION]


'@ use template: PCB_1.cfg

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
'set the units
With Units
    .Geometry "mm"
    .Frequency "GHz"
    .Voltage "V"
    .Resistance "Ohm"
    .Inductance "NanoH"
    .TemperatureUnit  "Kelvin"
    .Time "ns"
    .Current "A"
    .Conductance "Siemens"
    .Capacitance "PikoF"
End With

'----------------------------------------------------------------------------

'set the frequency range
Solver.FrequencyRange "2", "4"

'----------------------------------------------------------------------------

With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mu "1.0"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With

With Boundary
     .Xmin "electric"
     .Xmax "electric"
     .Ymin "electric"
     .Ymax "electric"
     .Zmin "electric"
     .Zmax "electric"
End With

' mesh - Tetrahedral
With Mesh
     .MeshType "Tetrahedral"
     .SetCreator "High Frequency"
End With
With MeshSettings
     .SetMeshType "Tet"
     .Set "Version", 1%

     .Set "StepsPerWaveNear", "6"
     .Set "StepsPerBoxNear", "10"
     .Set "CellsPerWavelengthPolicy", "automatic"

     .Set "CurvatureOrder", "2"
     .Set "CurvatureOrderPolicy", "automatic"

     .Set "CurvRefinementControl", "NormalTolerance"
     .Set "NormalTolerance", "60"

     .Set "SrfMeshGradation", "1.5"

     .Set "UseAnisoCurveRefinement", "1"
     .Set "UseSameSrfAndVolMeshGradation", "1"
     .Set "VolMeshGradation", "1.5"
End With

With MeshSettings
     .SetMeshType "Unstr"
     .Set "MoveMesh", "1"
     .Set "OptimizeForPlanarStructures", "0"
End With

With Mesh
     .MeshType "PBA"
     .SetCreator "High Frequency"
     .AutomeshRefineAtPecLines "True", "4"

     .UseRatioLimit "True"
     .RatioLimit "50"
     .LinesPerWavelength "20"
     .MinimumStepNumber "10"
     .Automesh "True"
End With

With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "50"
     .Set "StepsPerWaveNear", "20"
     .Set "EdgeRefinementOn", "1"
     .Set "EdgeRefinementRatio", "4"
End With

' mesh - Multilayer (Preview)
' default

' solver - FD settings
With FDSolver
     .Reset
     .Method "Tetrahedral Mesh" ' i.e. general purpose

     .AccuracyHex "1e-6"
     .AccuracyTet "1e-5"
     .AccuracySrf "1e-3"

     .SetUseFastResonantForSweepTet "False"

     .Type "Direct"
     .MeshAdaptionHex "False"
     .MeshAdaptionTet "True"

     .InterpolationSamples "5001"
End With

With MeshAdaption3D
    .SetType "HighFrequencyTet"
    .SetAdaptionStrategy "Energy"
    .MinPasses "3"
    .MaxPasses "10"
End With

FDSolver.SetShieldAllPorts "True"

With FDSolver
     .Method "Tetrahedral Mesh (MOR)"
     .HexMORSettings "", "5001"
End With

FDSolver.Method "Tetrahedral Mesh" ' i.e. general purpose

' solver - TD settings
With MeshAdaption3D
    .SetType "Time"

    .SetAdaptionStrategy "Energy"
    .CellIncreaseFactor "0.5"
    .AddSParameterStopCriterion "True", "0.0", "10", "0.01", "1", "True"
End With

With Solver
     .Method "Hexahedral"
     .SteadyStateLimit "-40"

     .MeshAdaption "True"
     .NumberOfPulseWidths "50"

     .FrequencySamples "5001"

     .UseArfilter "True"
End With

' solver - M settings

'----------------------------------------------------------------------------

Dim sDefineAt As String
sDefineAt = "2;3;4"
Dim sDefineAtName As String
sDefineAtName = "2;3;4"
Dim sDefineAtToken As String
sDefineAtToken = "f="
Dim aFreq() As String
aFreq = Split(sDefineAt, ";")
Dim aNames() As String
aNames = Split(sDefineAtName, ";")

Dim nIndex As Integer
For nIndex = LBound(aFreq) To UBound(aFreq)

Dim zz_val As String
zz_val = aFreq (nIndex)
Dim zz_name As String
zz_name = sDefineAtToken & aNames (nIndex)

' Define E-Field Monitors
With Monitor
    .Reset
    .Name "e-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Efield"
    .MonitorValue  zz_val
    .Create
End With

Next

'----------------------------------------------------------------------------

With MeshSettings
     .SetMeshType "Tet"
     .Set "Version", 1%
End With

With Mesh
     .MeshType "Tetrahedral"
End With

'set the solver type
ChangeSolverType("HF Frequency Domain")

'----------------------------------------------------------------------------

'@ define material: FR-4 (lossy)

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Material
     .Reset
     .Name "FR-4 (lossy)"
     .Folder ""
.FrqType "all"
.Type "Normal"
.SetMaterialUnit "GHz", "mm"
.Epsilon "4.3"
.Mu "1.0"
.Kappa "0.0"
.TanD "0.025"
.TanDFreq "10.0"
.TanDGiven "True"
.TanDModel "ConstTanD"
.KappaM "0.0"
.TanDM "0.0"
.TanDMFreq "0.0"
.TanDMGiven "False"
.TanDMModel "ConstKappa"
.DispModelEps "None"
.DispModelMu "None"
.DispersiveFittingSchemeEps "General 1st"
.DispersiveFittingSchemeMu "General 1st"
.UseGeneralDispersionEps "False"
.UseGeneralDispersionMu "False"
.Rho "0.0"
.ThermalType "Normal"
.ThermalConductivity "0.3"
.SetActiveMaterial "all"
.Colour "0.94", "0.82", "0.76"
.Wireframe "False"
.Transparency "0"
.Create
End With

'@ new component: component1

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Component.New "component1"

'@ define brick: component1:solid1

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "FR-4 (lossy)" 
     .Xrange "-w_substrate/2", "w_substrate/2" 
     .Yrange "-length", "0" 
     .Zrange "-h", "0" 
     .Create
End With

'@ pick face

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickFaceFromId "component1:solid1", "2"

'@ define extrude: component1:Ground_Plane

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Extrude 
     .Reset 
     .Name "Ground_Plane" 
     .Component "component1" 
     .Material "PEC" 
     .Mode "Picks" 
     .Height "G_PEC" 
     .Twist "0.0" 
     .Taper "0.0" 
     .UsePicksForHeight "False" 
     .DeleteBaseFaceSolid "False" 
     .KeepMaterials "False" 
     .ClearPickedFace "True" 
     .Create 
End With

'@ define curve line: curve1:line1

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Line
     .Reset 
     .Name "line1" 
     .Curve "curve1" 
     .X1 "0" 
     .Y1 "-6" 
     .X2 "0" 
     .Y2 "-length" 
     .Create
End With


'@ define tracefromcurve: component1:Trace

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With TraceFromCurve 
     .Reset 
     .Name "Trace" 
     .Component "component1" 
     .Material "PEC" 
     .Curve "curve1:line1" 
     .Thickness "G_PEC" 
     .Width "w" 
     .RoundStart "False" 
     .RoundEnd "False" 
     .DeleteCurve "True" 
     .GapType "2" 
     .Create 
End With

'@ rename block: component1:solid1 to: component1:dielectric_FR4

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Solid.Rename "component1:solid1", "dielectric_FR4"

'@ pick face

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickFaceFromId "component1:Trace", "2"

'@ define port:1

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
' Port constructed by macro Solver -> Ports -> Calculate port extension coefficient


With Port
  .Reset
  .PortNumber "1"
  .NumberOfModes "1"
  .AdjustPolarization False
  .PolarizationAngle "0.0"
  .ReferencePlaneDistance "0"
  .TextSize "50"
  .Coordinates "Picks"
  .Orientation "Positive"
  .PortOnBound "True"
  .ClipPickedPortToBound "False"
  .XrangeAdd "1*5.21", "1*5.21"
  .YrangeAdd "0", "0"
  .ZrangeAdd "1", "1*5.21"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ define boundaries

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Boundary
     .Xmin "open"
     .Xmax "open"
     .Ymin "open"
     .Ymax "open"
     .Zmin "open"
     .Zmax "open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
     .ApplyInAllDirections "False"
End With

'@ define frequency domain solver parameters

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Mesh.SetCreator "High Frequency" 

With FDSolver
     .Reset 
     .SetMethod "Tetrahedral", "General purpose" 
     .OrderTet "Second" 
     .OrderSrf "First" 
     .Stimulation "All", "All" 
     .ResetExcitationList 
     .AutoNormImpedance "True" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .ConsiderPortLossesTet "True" 
     .SetShieldAllPorts "True" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-5" 
     .AccuracySrf "1e-3" 
     .LimitIterations "False" 
     .MaxIterations "0" 
     .SetCalcBlockExcitationsInParallel "True", "True", "" 
     .StoreAllResults "False" 
     .StoreResultsInCache "False" 
     .UseHelmholtzEquation "True" 
     .LowFrequencyStabilization "True" 
     .Type "Direct" 
     .MeshAdaptionHex "False" 
     .MeshAdaptionTet "True" 
     .AcceleratedRestart "True" 
     .FreqDistAdaptMode "Distributed" 
     .NewIterativeSolver "True" 
     .TDCompatibleMaterials "False" 
     .ExtrudeOpenBC "False" 
     .SetOpenBCTypeHex "Default" 
     .SetOpenBCTypeTet "Default" 
     .AddMonitorSamples "True" 
     .CalcPowerLoss "True" 
     .CalcPowerLossPerComponent "False" 
     .StoreSolutionCoefficients "True" 
     .UseDoublePrecision "False" 
     .UseDoublePrecision_ML "True" 
     .MixedOrderSrf "False" 
     .MixedOrderTet "False" 
     .PreconditionerAccuracyIntEq "0.15" 
     .MLFMMAccuracy "Default" 
     .MinMLFMMBoxSize "0.3" 
     .UseCFIEForCPECIntEq "True" 
     .UseEnhancedCFIE2 "True" 
     .UseFastRCSSweepIntEq "false" 
     .UseSensitivityAnalysis "False" 
     .UseEnhancedNFSImprint "False" 
     .RemoveAllStopCriteria "Hex"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Hex", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Hex", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Hex", "False"
     .RemoveAllStopCriteria "Tet"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Tet", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "All Probes", "0.05", "2", "Tet", "True"
     .RemoveAllStopCriteria "Srf"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Srf", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Srf", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Srf", "False"
     .SweepMinimumSamples "3" 
     .SetNumberOfResultDataSamples "5001" 
     .SetResultDataSamplingMode "Automatic" 
     .SweepWeightEvanescent "1.0" 
     .AccuracyROM "1e-4" 
     .AddSampleInterval "", "", "1", "Automatic", "True" 
     .AddSampleInterval "", "", "", "Automatic", "False" 
     .MPIParallelization "False"
     .UseDistributedComputing "False"
     .NetworkComputingStrategy "RunRemote"
     .NetworkComputingJobCount "3"
     .UseParallelization "True"
     .MaxCPUs "1024"
     .MaximumNumberOfCPUDevices "2"
End With

With IESolver
     .Reset 
     .UseFastFrequencySweep "True" 
     .UseIEGroundPlane "False" 
     .SetRealGroundMaterialName "" 
     .CalcFarFieldInRealGround "False" 
     .RealGroundModelType "Auto" 
     .PreconditionerType "Auto" 
     .ExtendThinWireModelByWireNubs "False" 
     .ExtraPreconditioning "False" 
End With

With IESolver
     .SetFMMFFCalcStopLevel "0" 
     .SetFMMFFCalcNumInterpPoints "6" 
     .UseFMMFarfieldCalc "True" 
     .SetCFIEAlpha "0.500000" 
     .LowFrequencyStabilization "False" 
     .LowFrequencyStabilizationML "True" 
     .Multilayer "False" 
     .SetiMoMACC_I "0.0001" 
     .SetiMoMACC_M "0.0001" 
     .DeembedExternalPorts "True" 
     .SetOpenBC_XY "True" 
     .OldRCSSweepDefintion "False" 
     .SetRCSOptimizationProperties "True", "100", "0.00001" 
     .SetAccuracySetting "Custom" 
     .CalculateSParaforFieldsources "True" 
     .ModeTrackingCMA "True" 
     .NumberOfModesCMA "3" 
     .StartFrequencyCMA "-1.0" 
     .SetAccuracySettingCMA "Default" 
     .FrequencySamplesCMA "0" 
     .SetMemSettingCMA "Auto" 
     .CalculateModalWeightingCoefficientsCMA "True" 
     .DetectThinDielectrics "True" 
End With

'@ pick face

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickFaceFromId "component1:Trace", "4"

'@ define port:2

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
' Port constructed by macro Solver -> Ports -> Calculate port extension coefficient


With Port
  .Reset
  .PortNumber "2"
  .NumberOfModes "1"
  .AdjustPolarization False
  .PolarizationAngle "0.0"
  .ReferencePlaneDistance "0"
  .TextSize "50"
  .Coordinates "Picks"
  .Orientation "Positive"
  .PortOnBound "True"
  .ClipPickedPortToBound "False"
  .XrangeAdd "1*5.21", "1*5.21"
  .YrangeAdd "0", "0"
  .ZrangeAdd "1", "1*5.21"
  .Shield "PEC"
  .SingleEnded "False"
  .Create
End With

'@ define brick: component1:filter

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Brick
     .Reset 
     .Name "filter" 
     .Component "component1" 
     .Material "PEC" 
     .Xrange "-0.1", "0" 
     .Yrange "-17", "-13" 
     .Zrange "0", "0.1" 
     .Create
End With

'@ boolean add shapes: component1:filter, component1:Trace

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
Solid.Add "component1:filter", "component1:Trace"

'@ define frequency range

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
Solver.FrequencyRange "2", "12"

'@ delete port: port2

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
Port.Delete "2"

'@ pick edge

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
Pick.PickEdgeFromId "component1:filter", "11", "7"

'@ pick edge

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
Pick.PickEdgeFromId "component1:dielectric_FR4", "8", "8"

'@ define lumped face element: Folder1:element1

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
With LumpedFaceElement
     .Reset 
     .SetName "element1" 
     .Folder "Folder1" 
     .SetType "RLCSerial"
     .SetR "50"
     .SetL "0"
     .SetC "0"
     .SetGs "0"
     .SetI0 "1e-14"
     .SetT "300"
     .SetMonitor "True"
     .CircuitFileName ""
     .CircuitId "1"
     .UseCopyOnly "True"
     .UseRelativePath "False"
     .SetP1 "True", "0", "0", "0.10000000000000001" 
     .SetP2 "True", "0", "0", "-1" 
     .SetInvert "False" 
     .UseProjection "False" 
     .ReverseProjection "False" 
     .Create
End With

'@ delete lumped element: Folder1:element1

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
LumpedElement.Delete "Folder1:element1"

'@ define curve line: curve1:line1

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
With Line
     .Reset 
     .Name "line1" 
     .Curve "curve1" 
     .X1 "0" 
     .Y1 "0" 
     .X2 "0" 
     .Y2 "-6" 
     .Create
End With

'@ define tracefromcurve: component1:solid1

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
With TraceFromCurve 
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "PEC" 
     .Curve "curve1:line1" 
     .Thickness "G_PEC" 
     .Width "0.01612" 
     .RoundStart "False" 
     .RoundEnd "False" 
     .DeleteCurve "True" 
     .GapType "2" 
     .Create 
End With

'@ pick edge

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
Pick.PickEdgeFromId "component1:solid1", "11", "7"

'@ pick edge

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
Pick.PickEdgeFromId "component1:dielectric_FR4", "8", "8"

'@ define lumped face element: Folder1:element1

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
With LumpedFaceElement
     .Reset 
     .SetName "element1" 
     .Folder "Folder1" 
     .SetType "RLCSerial"
     .SetR "1000"
     .SetL "0"
     .SetC "0"
     .SetGs "0"
     .SetI0 "1e-14"
     .SetT "300"
     .SetMonitor "True"
     .CircuitFileName ""
     .CircuitId "1"
     .UseCopyOnly "True"
     .UseRelativePath "False"
     .SetP1 "True", "0", "0", "0.1" 
     .SetP2 "True", "0", "0", "-1" 
     .SetInvert "False" 
     .UseProjection "False" 
     .ReverseProjection "False" 
     .Create
End With

'@ define frequency range

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
Solver.FrequencyRange "1", "4"

'@ define boundaries

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
With Boundary
     .Xmin "open"
     .Xmax "open"
     .Ymin "expanded open"
     .Ymax "expanded open"
     .Zmin "open"
     .Zmax "open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
     .ApplyInAllDirections "False"
     .OpenAddSpaceFactor "0.5"
End With

'@ define frequency range

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
Solver.FrequencyRange "1", "10"

