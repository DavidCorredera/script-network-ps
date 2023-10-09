#
# SCRIPT MENÚ COMPLETO DE POWERSHELL
#
# Scripted by: Davoda
#

# Funciones y variables -> camelCase

# FUNCIÓN DE MENÚ PRINCIPAL
function mainMenu {
    Clear-Host
    Write-Host "Bienvenido al menú de administración de PowerShell" -ForegroundColor Green
    Write-Host ""
    Write-Host "1. SERVICIOS."
    Write-Host "2. PROCESOS."
    Write-Host "3. CREACIÓN DE USUARIOS"
    Write-Host "4. TAREAS PROGRAMADAS"
    Write-Host "5. IMPRESORA"
    Write-Host "6. CONFIGURACIÓN DE RED"
    Write-Host "7. EVENTOS"
    Write-Host "8. WMI"
    Write-Host "9. DISCOS"
    Write-Host "10. NOTAS"
    Write-Host ""
    Write-Host "11. Salir"
    Write-Host ""
}
#

# FUNCIÓN DE SUBMENÚ DE SERVICIOS
function servicesSubmenu {
    do {
        Clear-Host
        Write-Host ""
        Write-Host "Submenú de servicios"
        Write-Host ""
        Write-Host "1. Listar todos los servicios"
        Write-Host "2. Iniciar un servicio"
        Write-Host "3. Detener un servicio"
        Write-Host ""
        Write-Host "4. Volver al menú principal"
        Write-Host "5. Salir"
        Write-Host ""

        $optionServices = Read-Host "Ingrese el número de la opción deseada"

        switch ($optionServices) {
            '1' { Get-Service }
            '2' {
                $serviceName = Read-Host "Ingrese el nombre del servicio a iniciar"
                if (Get-Service $serviceName -ErrorAction SilentlyContinue) {
                    Start-Service $serviceName
                    Write-Host "El servicio $serviceName ha sido iniciado."
                } else {
                    Write-Host "El servicio $serviceName no se encuentra en el sistema."
                }
            }
            '3' {
                $serviceName = Read-Host "Ingrese el nombre del servicio a detener"
                if (Get-Service $serviceName -ErrorAction SilentlyContinue) {
                    Stop-Service $serviceName
                    Write-Host "El servicio $serviceName ha sido detenido."
                } else {
                    Write-Host "El servicio $serviceName no se encuentra en el sistema."
                }
            }
            '4' { return; break } # RETURN PARA SALIR AL DO Y BREAK PARA ROMPER EL DO, ASÍ SALE DE LA FUNCIÓN Y SALTA AL DO DE ABAJO DEL TODO
            '5' { exit }
            default { Write-Host "Opción incorrecta" -ForegroundColor Red;pause}
        }
    } while ($true)
}
#

function processesSubmenu {
    do {
        Clear-Host
        Write-Host ""
        Write-Host "Submenú de procesos"
        Write-Host ""
        Write-Host "1. Listar todos los procesos"
        Write-Host "2. Detener un proceso"
        Write-Host "3. Ver información de un proceso"
        Write-Host ""
        Write-Host "4. Volver al menú principal"
        Write-Host "5. Salir"
        Write-Host ""

        $optionProcesses = Read-Host "Ingrese el número de la opción deseada"

        switch ($optionProcesses) {
            '1' { Get-Process }
            '2' {
                $processName = Read-Host "Ingrese el nombre del proceso a detener"
                if (Get-Process $processName -ErrorAction SilentlyContinue) { # OBTENER QUE EL PROCESO EXISTE
                    Stop-Process -Name $processName
                    Write-Host "El proceso $processName ha sido detenido."
                } else {
                    Write-Host "El proceso $processName no se encuentra en el sistema."
                }
            }
            '3' {
                $processName = Read-Host "Ingrese el nombre del proceso a ver información"
                if (Get-Process $processName -ErrorAction SilentlyContinue) {
                    Get-Process -Name $processName | Format-Table -AutoSize
                } else {
                    Write-Host "El proceso $processName no se encuentra en el sistema."
                }
            }
            '4' { return;break }
            '5' { exit }
            default { Write-Host "Opción incorrecta" -ForegroundColor Red;pause}
        }
    } while ($true)
}

function usersSubmenu {
    do {
        Clear-Host
        Write-Host ""
        Write-Host "Submenú de usuarios"
        Write-Host ""
        Write-Host "1. Listar usuarios"
        Write-Host "2. Agregar usuario"
        Write-Host "3. Eliminar usuario"
        Write-Host ""
        Write-Host "4. Volver al menú principal"
        Write-Host "5. Salir"
        Write-Host ""

        $optionUsers = Read-Host "Ingrese el número de la opción deseada"

        switch ($optionUsers) {
            '1' { Get-LocalUser | Format-Table -AutoSize }
            '2' {
                $username = Read-Host "Ingrese el nombre del nuevo usuario"
                $password = Read-Host "Ingrese la contraseña del nuevo usuario" -AsSecureString
                $fullname = Read-Host "Ingrese el nombre completo del nuevo usuario"
                $description = Read-Host "Ingrese una descripción para el nuevo usuario"
                New-LocalUser -Name $username -Password $password -FullName $fullname -Description $description
                Write-Host "El usuario $username ha sido creado."
            }
            '3' {
                $username = Read-Host "Ingrese el nombre del usuario a eliminar"
                if (Get-LocalUser $username -ErrorAction SilentlyContinue) {
                    Remove-LocalUser -Name $username
                    Write-Host "El usuario $username ha sido eliminado."
                } else {
                    Write-Host "El usuario $username no se encuentra en el sistema."
                }
            }
            '4' { return;break }
            '5' { exit }
            default { Write-Host "Opción incorrecta" -ForegroundColor Red;pause}
        }
    } while ($true)
}

function taskSchedulerSubmenu {
    $script:taskName = Read-Host "Introduzca el nombre de la tarea programada (existente o nueva)."
    do {
        Clear-Host
        Write-Host ""
        Write-Host "Submenú de creación de tareas programadas"
        Write-Host ""
        Write-host "1.- Mostrar información de la tarea."
        Write-Host "2.- Crear tarea programada."
        Write-Host "3.- Eliminar tarea programada."
        Write-Host "4.- Activar tarea programada."
        Write-Host "5.- Desactivar tarea programada."
        Write-Host ""
        Write-Host "6. Volver al menú principal"
        Write-Host "7. Salir"
        Write-Host ""

        $optionTaskScheduler = Read-Host "Ingrese el número de la opción deseada"

        switch ($optionTaskScheduler) {
            '1'{
                Get-ScheduledTask -TaskName $taskName
            }
            '2'{
                $actionPathTask = Read-Host "Introduce la ruta con el archivo a ejecutar en la tarea programada"
                $actionTask = New-ScheduledAction -Execute "powershell.exe" -Argument "$actionPathTask"
                Write-Host "-------------------------------------"
                Write-Host "Frecuencia de la tarea"
                Write-Host ""
                Write-Host "1. Diario"
                Write-Host "2. Semanal"
                Write-Host "3. Aleatorio"
                Write-Host ""
                Write-Host "-------------------------------------"
                $frequencyTask = Read-Host "Selecciona la frecuencia de la tarea (el número)"
                switch ($frequencyTask) {
                    '1'{
                        $hourTask = Read-Host "Introduce a la hora que quieras que se ejecute la tarea programada (en hora militar)"
                        $triggerTask = New-ScheduledTaskTrigger -Daily -At $hourTask}
                    '2'{
                        $hourTask = Read-Host "Introduce a la hora que quieras que se ejecute la tarea programada (en hora militar)"
                        $triggerTask = New-ScheduledTaskTrigger -Weekly -At $hourTask}
                    '3'{
                        $triggerTask = New-ScheduledTaskTrigger -RandomDelay}
                    Default { # Por defecto, diario (si ponen alguna opción sin sentido)
                        $hourTask = Read-Host "Introduce a la hora que quieras que se ejecute la tarea programada (en hora militar)"
                        $triggerTask = New-ScheduledTaskTrigger -Daily -At $hourTask}
                }
                $taskDescription = Read-Host "Introduce la descripción de la tarea programada"
                Register-ScheduledTask -Action $actionTask -Trigger $triggerTask -TaskName "$taskName" -Description "$taskDescription"
            }
            '3' {
                Get-ScheduledTask -TaskName $taskName
                Unregister-ScheduledTask -TaskName "$taskName"
            }
            '4' {
                Get-ScheduledTask -TaskName $taskName
                Enable-ScheduledTask -TaskName "$taskName"
            }
            '5' {
                Get-ScheduledTask -TaskName $taskName
                Disable-ScheduledTask -TaskName "$taskName"
            }
            '6'{return;break}
            '7'{exit}
            Default {Write-Host "Opción incorrecta" -ForegroundColor Red;pause}
        }
    } while ($true)
}

function printerSubmenu {
    do {
        Clear-Host
        Write-Host ""
        Write-Host "Submenú de gestión de impresoras"
        Write-Host ""
        Write-Host "1. Obtener impresoras"
        Write-Host "2. Obtener controladores"
        Write-Host "3. Instalar impresora"
        Write-Host ""
        Write-Host "4. Volver al menú principal"
        Write-Host "5. Salir"
        Write-Host ""

        $optionPrinter = Read-Host "Ingrese el número de la opción deseada"

        switch ($optionPrinter) {
            '1'{
                Get-Printer
            }
            '2'{
                Get-PrinterDriver
            }
            '3'{
                Write-Host "DESCARGA EL CONTROLADOR (DESDE GOOGLE)"
                Write-Host "AÑÁDELO AL ALMACÉN (INSTALAR ARCHIVO .INF DÁNDOLE CLIC DERECHO) (DESDE LA INTERFAZ DE WINDOWS)"
                $namePrinterDriver = Read-Host "Introduce el nombre del controlador de la impresora de dentro del .inf"
                Add-PrinterDriver -Name "$namePrinterDriver"
                $namePrinterPort = Read-Host "Introduce el nombre del puerto de la impresora"
                Add-PrinterPort -name "$namePrinterPort"
                $namePrinter = Read-Host "Introduce el nombre de la impresora"
                Add-Printer -Name "$namePrinter" -DriverName "$namePrinterDriver" -PortName "$namePrinterPort"
            }
            '4'{return;break}
            '5'{exit}
            Default {Write-Host "Opción incorrecta" -ForegroundColor Red;pause}
        }
    } while ($true)
}

function networkSubmenu {
    Get-NetAdapter|Format-Table -AutoSize
    $script:nameInterface = Read-Host "Introduzca el nombre (name) de la interfaz de red"
    do {
        Clear-Host
        Write-Host ""
        Write-Host "Submenú de configuración de red"
        Write-Host ""
        Write-Host "1. Ver información de red"
        Write-Host "2. Configurar IP estática"
        Write-Host "3. Configurar IP dinámica"
        Write-Host "4. Habilitar/deshabilitar adaptador de red"
        Write-Host "5. Ver conexiones de red activas"
        Write-Host ""
        Write-Host "6. Volver al menú principal"
        Write-Host "7. Salir"
        Write-Host ""

        $optionNetwork = Read-Host "Ingrese el número de la opción deseada"

        switch ($optionNetwork) {
            '1'{
                Get-NetAdapter|Format-Table -AutoSize
            }
            '2'{
                $ip = Read-host "Introduzca IP"
                $mask = Read-Host "Introduca la máscara (nºs de bits)"
                $gateway = Read-Host "Introduzca el gateway"
                $firstDNS = Read-host "Introduzca el primer DNS"
                $secondDNS = Read-host "Introduzca el segundo DNS"
                New-NetIPAddress -InterfaceAlias $nameInterface $ip -PrefixLength $mask -DefaultGateway $gateway
                Set-DnsClientServerAddress -InterfaceAlias $nameInterface -ServerAddresses ("$firstDNS","$secondDNS")
                Restart-NetAdapter -Name $nameInterface
            }
            '3'{
                Get-NetAdapter | Format-Table -AutoSize
                Set-NetIPInterface -InterfaceAlias $nameInterface -Dhcp enabled
                Set-DnsClientServerAddress -InterfaceAlias $nameInterface -ResetServerAddresses
                Restart-NetAdapter -Name $nameInterface
            }
            '4'{
                $state = (Get-NetAdapter -Name "$nameInterface").Status # Obtener la propiedad Status dentro del objeto del adaptador
                if ($state -eq "Up") {Enable-NetAdapter -Name $nameInterface}
                elseif ($state -eq "Down") {Disable-NetAdapter -Name $nameInterface }
                else {Write-Host "Opción no válida"}
            }
            '5'{Get-NetTCPConnection}
            '6'{return;break}
            '7'{exit}
            Default {Write-Host "Opción incorrecta" -ForegroundColor Red;pause}
        }
    } while ($true)
}

function eventSubmenu {
    do {
        Clear-Host
        Write-Host ""
        Write-Host "Submenú de gestión de eventos"
        Write-Host ""
        Write-Host "1. Ver registro de eventos"
        Write-Host "2. Filtrar eventos por fuente"
        Write-Host "3. Limpiar registro de eventos"
        Write-Host ""
        Write-Host "4. Volver al menú principal"
        Write-Host "5. Salir"
        Write-Host ""

        $optionEvent = Read-Host "Ingrese el número de la opción deseada"

        switch ($optionEvent) {
            '1' { Get-EventLog -LogName Application, System, Security }
            '2' { $source = Read-Host "Ingrese el nombre de la fuente"
                   Get-EventLog -LogName Application, System, Security -Source $source }
            '3' { Clear-EventLog -LogName Application, System, Security }
            '4' { return;break }
            '5' { exit }
            default { Write-Host "Opción incorrecta" }
        }
        pause
    } while ($true)
}

function WMISubmenu {
    do {
        Clear-Host
        Write-Host ""
        Write-Host "Submenú de WMI"
        Write-Host ""
        Write-Host "1. Ver información del sistema"
        Write-Host "2. Ver información del procesador"
        Write-Host "3. Ver información del disco"
        Write-Host "4. Ver información de la memoria"
        Write-Host ""
        Write-Host "5. Volver al menú principal"
        Write-Host "6. Salir"
        Write-Host ""

        $optionWMI = Read-Host "Ingrese el número de la opción deseada"

        switch ($optionWMI) {
            '1' { Clear-Host;Get-WmiObject -Class Win32_ComputerSystem }
            '2' { Clear-Host;Get-WmiObject -Class Win32_Processor }
            '3' { Clear-Host;Get-WmiObject -Class Win32_LogicalDisk }
            '4' { Clear-Host;Get-WmiObject -Class Win32_PhysicalMemory }
            '5' { return;break }
            '6' { exit }
            default { Write-Host "Opción incorrecta" }
        }
        pause
    } while ($true)
}

function diskSubmenu {
    do {
        Clear-Host
        Write-Host ""
        Write-Host "Submenú de Discos"
        Write-Host ""
        Write-Host "1. Ver información de todos los discos"
        Write-Host "2. Ver espacio libre y usado de un disco"
        Write-Host "3. Ver la lista de unidades montadas"
        Write-Host "4. Ver información de un disco específico"
        Write-Host "5. Ver la lista de particiones de un disco"
        Write-Host ""
        Write-Host "6. Volver al menú principal"
        Write-Host "7. Salir"
        Write-Host ""

        $optionDisk = Read-Host "Ingrese el número de la opción deseada"

        switch ($optionDisk) {
            '1' { Get-Disk }
            '2' {
                $driveLetter = Read-Host "Ingrese la letra del disco a verificar"
                Get-Volume -DriveLetter $driveLetter | Select-Object -Property DriveLetter, SizeRemaining, Size
            }
            '3' { Get-PSDrive -PSProvider FileSystem }
            '4' {
                $diskNumber = Read-Host "Ingrese el número de disco a verificar"
                Get-Disk -Number $diskNumber | Select-Object -Property *
            }
            '5' {
                $diskNumber = Read-Host "Ingrese el número de disco a verificar"
                Get-Partition -DiskNumber $diskNumber
            }
            '6' { return;break }
            '7' { exit }
            default { Write-Host "Opción incorrecta" }
        }
        pause
    } while ($true)
}

function notesSubmenu {
    do { 
        Clear-Host
        Write-Host ""
        Write-Host "Submenú de notas"
        Write-Host ""
        Write-Host "1. Bloc de notas"
        Write-Host "2. Notas rápidas"
        Write-Host "3. Notepad++"
        Write-Host ""
        Write-Host "4. Volver al menú principal"
        Write-Host "5. Salir"
        Write-Host ""

        $optionNotes = Read-Host "Ingrese el número de la opción deseada"

    
        switch ($optionNotes) {
            '1'{notepad}
            '2'{Start-Process shell:AppsFolder\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe!App}
            '3'{& "C:\Program Files (x86)\Notepad++\notepad++.exe"}
            '4'{return;break}
            '5'{exit}
            default {Write-Host "Opción incorrecta" -ForegroundColor Red;pause}
        }
    } while ($true)
}

# CLEAR-HOST INICIAL
Clear-Host
# BUCLE PRINCIPAL DEL SCRIPT
do {
    mainMenu
    $mainOption = Read-Host "Ingrese el número de la opción deseada"
    switch ($mainOption) {
        '1'{servicesSubmenu}
        '2'{processesSubmenu}
        '3'{usersSubmenu}
        '4'{taskSchedulerSubmenu}
        '5'{printerSubmenu}
        '6'{networkSubmenu}
        '7'{eventSubmenu}
        '8'{WMISubmenu}
        '9'{diskSubmenu}
        '10'{notesSubmenu}
        '11'{exit}
        default {Write-Host "Opción incorrecta"}
    }
} while ($true)