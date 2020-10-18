param([Parameter(Mandatory=$True)]$ProjectName)
mkdir $ProjectName
Set-Location .\$ProjectName
mkdir Srcs
mkdir Srcs\sim
mkdir Srcs\source
mkdir Srcs\constraint
mkdir IP
mkdir output
mkdir BlockDesign

vivado.bat -mode batch -source ..\CreatNewProject.tcl
Remove-Item *.jou
Remove-Item *.log
Remove-Item .Xil/

Copy-Item ..\CreatNewProject.tcl .\build_project.tcl

New-Item "build_project.ps1"
Write-Output "vivado -mode batch -source .\build_project.tcl" >> "build_project.ps1"
Write-Output "Remove-Item *.jou" >> "build_project.ps1"
Write-Output "Remove-Item *.log" >> "build_project.ps1"
Write-Output "Remove-Item .Xil/" >> "build_project.ps1"