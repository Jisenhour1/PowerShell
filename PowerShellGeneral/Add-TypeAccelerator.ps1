$accelerators = [PSObject].Assembly.GetType('System.Management.Automation.TypeAccelerators')

$accelerators::Add('MyStackType','System.Collections.Stack')