'# MWS Version: Version 2022.5 - Jun 03 2022 - ACIS 31.0.1 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 95 fmax = 105
'# created = '[VERSION]2022.0|31.0.1|20210823[/VERSION]


'@ use template: Antenna - Waveguide_1.cfg

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
Solver.FrequencyRange "95", "105"

'----------------------------------------------------------------------------

Plot.DrawBox True

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
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "expanded open"
     .Ymax "expanded open"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
End With

' switch on FD-TET setting for accurate farfields

FDSolver.ExtrudeOpenBC "True"

Mesh.FPBAAvoidNonRegUnite "True"
Mesh.ConsiderSpaceForLowerMeshLimit "False"
Mesh.MinimumStepNumber "5"

With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "20"
End With

With MeshSettings
     .SetMeshType "HexTLM"
     .Set "RatioLimitGeometry", "20"
End With

PostProcess1D.ActivateOperation "vswr", "true"
PostProcess1D.ActivateOperation "yz-matrices", "true"

With FarfieldPlot
	.ClearCuts ' lateral=phi, polar=theta
	.AddCut "lateral", "0", "1"
	.AddCut "lateral", "90", "1"
	.AddCut "polar", "90", "1"
End With

'----------------------------------------------------------------------------

With MeshSettings
     .SetMeshType "Hex"
     .Set "Version", 1%
End With

With Mesh
     .MeshType "PBA"
End With

'set the solver type
ChangeSolverType("HF Time Domain")

'----------------------------------------------------------------------------

'@ new component: C1

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Component.New "C1"

'@ define brick: C1:Main_Outer

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Brick
     .Reset 
     .Name "Main_Outer" 
     .Component "C1" 
     .Material "PEC" 
     .Xrange "-1.77", "1.77" 
     .Yrange "-1.135", "1.135" 
     .Zrange "-7.5", "7.5" 
     .Create
End With

'@ define brick: C1:Main_Inner

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Brick
     .Reset 
     .Name "Main_Inner" 
     .Component "C1" 
     .Material "PEC" 
     .Xrange "-1.27", "1.27" 
     .Yrange "-0.635", "0.635" 
     .Zrange "-7.5", "7.5" 
     .Create
End With

'@ boolean subtract shapes: C1:Main_Outer, C1:Main_Inner

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Solid.Subtract "C1:Main_Outer", "C1:Main_Inner"

'@ define brick: C1:Side_Outer

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Brick
     .Reset 
     .Name "Side_Outer" 
     .Component "C1" 
     .Material "PEC" 
     .Xrange "0", "5.02" 
     .Yrange "-1.135", "1.135" 
     .Zrange "-1.77", "1.77" 
     .Create
End With

'@ define brick: C1:Side_Inner

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Brick
     .Reset 
     .Name "Side_Inner" 
     .Component "C1" 
     .Material "PEC" 
     .Xrange "0", "5.02" 
     .Yrange "-0.635", "0.635" 
     .Zrange "-1.27", "1.27" 
     .Create
End With

'@ boolean subtract shapes: C1:Side_Outer, C1:Side_Inner

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Solid.Subtract "C1:Side_Outer", "C1:Side_Inner"

'@ define brick: C1:solid1

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "C1" 
     .Material "PEC" 
     .Xrange "-1.27", "1.27" 
     .Yrange "-0.635", "0.635" 
     .Zrange "-7.5", "7.5" 
     .Create
End With

'@ boolean insert shapes: C1:Main_Outer, C1:solid1

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Solid
     .Version 10
     .Insert "C1:Main_Outer", "C1:solid1" 
     .Version 1
End With

'@ boolean subtract shapes: C1:Side_Outer, C1:solid1

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Solid.Subtract "C1:Side_Outer", "C1:solid1"

'@ pick edge

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEdgeFromId "C1:Main_Outer", "41", "30"

'@ pick edge

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEdgeFromId "C1:Main_Outer", "39", "26"

'@ pick edge

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEdgeFromId "C1:Main_Outer", "43", "32"

'@ pick edge

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEdgeFromId "C1:Main_Outer", "37", "27"

'@ define port: 1

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Port 
     .Reset 
     .PortNumber "1" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "0"
     .Coordinates "Picks"
     .Orientation "positive"
     .PortOnBound "False"
     .ClipPickedPortToBound "False"
     .Xrange "-1.27", "1.27"
     .Yrange "-0.635", "0.635"
     .Zrange "7.5", "7.5"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "0.0", "0.0"
     .ZrangeAdd "0.0", "0.0"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ pick edge

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEdgeFromId "C1:Main_Outer", "42", "31"

'@ pick edge

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEdgeFromId "C1:Main_Outer", "40", "29"

'@ pick edge

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEdgeFromId "C1:Main_Outer", "38", "25"

'@ pick edge

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEdgeFromId "C1:Main_Outer", "44", "28"

'@ define port: 2

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Port 
     .Reset 
     .PortNumber "2" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "0"
     .Coordinates "Picks"
     .Orientation "positive"
     .PortOnBound "False"
     .ClipPickedPortToBound "False"
     .Xrange "-1.27", "1.27"
     .Yrange "-0.635", "0.635"
     .Zrange "-7.5", "-7.5"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "0.0", "0.0"
     .ZrangeAdd "0.0", "0.0"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ pick edge

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEdgeFromId "C1:Side_Outer", "43", "25"

'@ pick edge

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEdgeFromId "C1:Side_Outer", "39", "30"

'@ pick edge

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEdgeFromId "C1:Side_Outer", "37", "26"

'@ pick edge

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEdgeFromId "C1:Side_Outer", "42", "29"

'@ define port: 3

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Port 
     .Reset 
     .PortNumber "3" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "0"
     .Coordinates "Picks"
     .Orientation "positive"
     .PortOnBound "False"
     .ClipPickedPortToBound "False"
     .Xrange "5.02", "5.02"
     .Yrange "-0.635", "0.635"
     .Zrange "-1.27", "1.27"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "0.0", "0.0"
     .ZrangeAdd "0.0", "0.0"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ define monitor: e-field (f=100)

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Monitor 
     .Reset 
     .Name "e-field (f=100)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Efield" 
     .MonitorValue "100" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-1.77", "5.02", "-1.135", "1.135", "-7.5", "7.5" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ define time domain solver parameters

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Mesh.SetCreator "High Frequency" 

With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-40"
     .MeshAdaption "False"
     .AutoNormImpedance "False"
     .NormingImpedance "50"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .RunDiscretizerOnly "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

'@ set PBA version

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Discretizer.PBAVersion "2021082322"

'@ define brick: C1:E_Outer

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Brick
     .Reset 
     .Name "E_Outer" 
     .Component "C1" 
     .Material "PEC" 
     .Xrange "-1.77", "1.77" 
     .Yrange "0", "4.385" 
     .Zrange "-1.135", "1.135" 
     .Create
End With

'@ define brick: C1:E_Inner

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Brick
     .Reset 
     .Name "E_Inner" 
     .Component "C1" 
     .Material "PEC" 
     .Xrange "-1.27", "1.27" 
     .Yrange "0", "4.385" 
     .Zrange "-0.635", "0.635" 
     .Create
End With

'@ boolean insert shapes: C1:E_Outer, C1:E_Inner

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Solid
     .Version 10
     .Insert "C1:E_Outer", "C1:E_Inner" 
     .Version 1
End With

'@ boolean insert shapes: C1:Main_Outer, C1:E_Inner

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Solid
     .Version 10
     .Insert "C1:Main_Outer", "C1:E_Inner" 
     .Version 1
End With

'@ boolean subtract shapes: C1:Side_Outer, C1:E_Inner

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Solid.Subtract "C1:Side_Outer", "C1:E_Inner"

'@ define brick: C1:Main_Inner

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Brick
     .Reset 
     .Name "Main_Inner" 
     .Component "C1" 
     .Material "PEC" 
     .Xrange "-1.27", "1.27" 
     .Yrange "-0.635", "0.635" 
     .Zrange "-7.5", "7.5" 
     .Create
End With

'@ boolean insert shapes: C1:E_Outer, C1:Main_Inner

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Solid
     .Version 10
     .Insert "C1:E_Outer", "C1:Main_Inner" 
     .Version 1
End With

'@ boolean insert shapes: C1:Main_Outer, C1:Main_Inner

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Solid
     .Version 10
     .Insert "C1:Main_Outer", "C1:Main_Inner" 
     .Version 1
End With

'@ boolean subtract shapes: C1:Side_Outer, C1:Main_Inner

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Solid.Subtract "C1:Side_Outer", "C1:Main_Inner"

'@ pick edge

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
Pick.PickEdgeFromId "C1:E_Outer", "39", "31"

'@ pick edge

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
Pick.PickEdgeFromId "C1:E_Outer", "44", "30"

'@ pick edge

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
Pick.PickEdgeFromId "C1:E_Outer", "41", "28"

'@ pick edge

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
Pick.PickEdgeFromId "C1:E_Outer", "38", "25"

'@ define port: 4

'[VERSION]2022.5|31.0.1|20220603[/VERSION]
With Port 
     .Reset 
     .PortNumber "4" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "0"
     .Coordinates "Picks"
     .Orientation "positive"
     .PortOnBound "False"
     .ClipPickedPortToBound "False"
     .Xrange "-1.27", "1.27"
     .Yrange "4.385", "4.385"
     .Zrange "-0.635", "0.635"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "0.0", "0.0"
     .ZrangeAdd "0.0", "0.0"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

