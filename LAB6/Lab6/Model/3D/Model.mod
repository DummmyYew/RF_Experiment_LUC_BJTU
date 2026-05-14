'# MWS Version: Version 2022.5 - Jun 03 2022 - ACIS 31.0.1 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 95 fmax = 105
'# created = '[VERSION]2022.0|31.0.1|20210823[/VERSION]


'@ use template: Lab6.cfg

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

Dim sDefineAt As String
sDefineAt = "95;100;105"
Dim sDefineAtName As String
sDefineAtName = "95;100;105"
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

' Define H-Field Monitors
With Monitor
    .Reset
    .Name "h-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Hfield"
    .MonitorValue  zz_val
    .Create
End With

Next

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

'@ new component: component1

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Component.New "component1"

'@ define brick: component1:solid1

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "PEC" 
     .Xrange "-2", "2" 
     .Yrange "-1", "1" 
     .Zrange "-7", "7" 
     .Create
End With

'@ define brick: component1:solid2

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Brick
     .Reset 
     .Name "solid2" 
     .Component "component1" 
     .Material "PEC" 
     .Xrange "-2.5", "2.5" 
     .Yrange "-1.5", "1.5" 
     .Zrange "-7", "7" 
     .Create
End With

'@ boolean subtract shapes: component1:solid2, component1:solid1

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Solid.Subtract "component1:solid2", "component1:solid1"

'@ pick edge

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEdgeFromId "component1:solid2", "27", "18"

'@ pick edge

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEdgeFromId "component1:solid2", "25", "19"

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
     .Xrange "-2", "2"
     .Yrange "-1", "1"
     .Zrange "7", "7"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "0.0", "0.0"
     .ZrangeAdd "0.0", "0.0"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ pick edge

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEdgeFromId "component1:solid2", "32", "20"

'@ pick edge

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Pick.PickEdgeFromId "component1:solid2", "26", "17"

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
     .Xrange "-2", "2"
     .Yrange "-1", "1"
     .Zrange "-7", "-7"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "0.0", "0.0"
     .ZrangeAdd "0.0", "0.0"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ modify port: 1

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Port 
     .Reset 
     .LoadContentForModify "1" 
     .Label ""
     .Folder ""
     .NumberOfModes "4"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "0"
     .Coordinates "Picks"
     .Orientation "positive"
     .PortOnBound "False"
     .ClipPickedPortToBound "False"
     .Xrange "-2", "2"
     .Yrange "-1", "1"
     .Zrange "7", "7"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "0.0", "0.0"
     .ZrangeAdd "0.0", "0.0"
     .SingleEnded "False"
     .Shield "none"
     .WaveguideMonitor "False"
     .Modify 
End With

'@ modify port: 2

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
With Port 
     .Reset 
     .LoadContentForModify "2" 
     .Label ""
     .Folder ""
     .NumberOfModes "4"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "0"
     .TextSize "50"
     .TextMaxLimit "0"
     .Coordinates "Picks"
     .Orientation "positive"
     .PortOnBound "False"
     .ClipPickedPortToBound "False"
     .Xrange "-2", "2"
     .Yrange "-1", "1"
     .Zrange "-7", "-7"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "0.0", "0.0"
     .ZrangeAdd "0.0", "0.0"
     .SingleEnded "False"
     .Shield "none"
     .WaveguideMonitor "False"
     .Modify 
End With

'@ define time domain solver parameters

'[VERSION]2022.0|31.0.1|20210823[/VERSION]
Mesh.SetCreator "High Frequency" 

With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "1"
     .StimulationMode "3"
     .SteadyStateLimit "-30"
     .MeshAdaption "False"
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

