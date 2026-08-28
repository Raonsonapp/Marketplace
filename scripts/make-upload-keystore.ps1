# Creates the Android upload keystore that signs YouShop's Play releases,
# and prints the four values to paste into GitHub repository secrets.
#
#   powershell -ExecutionPolicy Bypass -File scripts\make-upload-keystore.ps1
#
# Run this on YOUR OWN machine. The .jks it writes is the private key that
# signs every future release of the app: Google Play permanently binds the
# app to it, so if it is lost you cannot ship an update to the same
# listing, only a brand-new one with no installs and no reviews. Back the
# file up somewhere you will still have in five years, and never commit it.

$ErrorActionPreference = 'Stop'

$Keystore = if ($env:KEYSTORE) { $env:KEYSTORE } else { Join-Path (Get-Location) 'upload-keystore.jks' }
$Alias    = if ($env:ALIAS)    { $env:ALIAS }    else { 'upload' }
# 10000 days (~27 years). A key that expires makes the listing un-updatable.
$Validity = if ($env:VALIDITY) { $env:VALIDITY } else { '10000' }
$Dname    = if ($env:DNAME)    { $env:DNAME }    else { 'CN=YouShop, OU=Mobile, O=YouShop, L=Dushanbe, C=TJ' }

function Find-Keytool {
    $cmd = Get-Command keytool -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    # Android Studio bundles a JDK; this is where it puts it on Windows.
    $candidates = @(
        "$env:LOCALAPPDATA\Programs\Android Studio\jbr\bin\keytool.exe",
        "$env:ProgramFiles\Android\Android Studio\jbr\bin\keytool.exe",
        "$env:JAVA_HOME\bin\keytool.exe"
    )
    foreach ($c in $candidates) { if ($c -and (Test-Path $c)) { return $c } }
    return $null
}

$Keytool = Find-Keytool
if (-not $Keytool) {
    Write-Error @'
keytool not found.

keytool ships with any JDK. If you have Android Studio installed it has one
bundled; otherwise install a JDK (e.g. Temurin 17) and re-run. You can also
point this script straight at it:

  $env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
'@
    exit 1
}

if (Test-Path $Keystore) {
    Write-Error "Refusing to overwrite an existing keystore: $Keystore`nIf this is the key your app is already published with, keep it."
    exit 1
}

# Read the password without echoing it, rather than taking it as an
# argument — an argument would land in the PowerShell history file.
$secure1 = Read-Host -AsSecureString 'Choose a keystore password (at least 6 characters)'
$secure2 = Read-Host -AsSecureString 'Repeat it'
$pass1 = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure1))
$pass2 = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure2))
if ($pass1 -ne $pass2) { Write-Error 'Passwords do not match.'; exit 1 }
if ($pass1.Length -lt 6) { Write-Error 'keytool requires at least 6 characters.'; exit 1 }

# One password for both the store and the key: the workflow supports two,
# but a second distinct password buys nothing here and is one more thing to
# lose.
& $Keytool -genkeypair `
    -keystore $Keystore `
    -alias $Alias `
    -keyalg RSA -keysize 2048 `
    -validity $Validity `
    -dname $Dname `
    -storepass $pass1 `
    -keypass $pass1 `
    -storetype PKCS12 | Out-Null

$KeystoreBase64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($Keystore))

@"

Keystore written to:
  $Keystore

BACK THIS FILE UP NOW, somewhere you will still have in five years.
Losing it means never being able to update the published app again.

--------------------------------------------------------------------------
Add these four repository secrets on GitHub:
  Settings -> Secrets and variables -> Actions -> New repository secret
--------------------------------------------------------------------------

Name:  ANDROID_KEYSTORE_PASSWORD
Value: $pass1

Name:  ANDROID_KEY_ALIAS
Value: $Alias

Name:  ANDROID_KEY_PASSWORD
Value: $pass1

Name:  ANDROID_KEYSTORE_BASE64
Value: (the single long line saved to the file below, no spaces or breaks)

  $Keystore.base64.txt

Delete that .txt once the secret is set — it is the private key in text form.
--------------------------------------------------------------------------
"@ | Write-Host

# Written without a trailing newline: GitHub stores the secret verbatim, and
# a stray newline breaks the base64 decode in CI.
[IO.File]::WriteAllText("$Keystore.base64.txt", $KeystoreBase64)
