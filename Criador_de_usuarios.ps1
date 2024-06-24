Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Import-Module ActiveDirectory
Import-Module MSOnline
Import-Module AzureAD 

function tratar_nome 
{  
    param($nome_todo)

    $nome_capitalize = @($nome_todo.split(" "))
    $nome_separado = @($nome_todo.ToLower().split(" "))
    $pri_e_ult_nome = $nome_separado[0] + " " + $nome_separado[$nome_separado.Length-1]

    $nome_usuario =  $nome_separado[0] + $nome_separado[$nome_separado.Length-1][0]
    $senha =  "DEFINA_UMA_SENHA" + $nome_separado[0][0] + $nome_separado[$nome_separado.Length-1][0]
    $senha = ConvertTo-SecureString -String $senha -AsPlainText -Force
    $e_mail = $nome_usuario+"@ALGUM_SMTP.COM.BR"

    return 
    @{
        Nome_Completo = $nome_todo;
        Nome = $nome_capitalize[0];
        Sobrenome = $nome_capitalize[$nome_capitalize.Length-1];
        Senha = $senha; 
        Usuario = $nome_usuario; 
        Email =$e_mail
    }

}

function criar_usuario_ad_E_azure
{
    param($usuario)

    $departamento = $listBox.SelectedItem
    $caminho ='OU='+$departamento+',OU=Organization_Unit,DC=Domain_component,DC=Domain_component'
    $copy = $textBoxCopiarUsuario.Text 

     New-ADUser -SamAccountName $usuario.Usuario `
    -AccountPassword $usuario.Senha `
    -Name $usuario.Nome_Completo `
    -GivenName $usuario.Nome `
    -Surname $usuario.Sobrenome `
    -DisplayName $usuario.Nome_Completo `
    -EmailAddress $usuario.Email `
    -UserPrincipalName $usuario.Email `
    -Enabled $true `
    -Path $caminho `
    -ChangePasswordAtLogon $false `

    $PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile

    $PasswordProfile.Password = $usuario.Senha `
     
    New-AzureADUser -Displayname $usuario.Nome_Completo `
    -PasswordProfile $PasswordProfile `    -UserPrincipalName $usuario.Email `    -MailNickName 'teste'`    -GivenName $usuario.Nome `
    -Surname $usuario.Sobrenome `
    -CreationType $null `    -AccountEnable $true `
}

#esse bloco será remodelado em futuros commits, por enquanto vai ficar assi :P

$user_adm= 'Credenciais de ADM do MS Azure AD'
$senha_adm = ConvertTo-SecureString 'Senha desse mesmo adm' -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($user_adm, $senha_adm)

Connect-AzureAD -Credential $Credential

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Data Entry Form'
$form.Size = New-Object System.Drawing.Size(300,350)
$form.StartPosition = 'CenterScreen'

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(75,270)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150,270)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

#Primeiro dado: Usuario
$labelNomeCompleto = New-Object System.Windows.Forms.Label
$labelNomeCompleto.Location = New-Object System.Drawing.Point(10,40)
$labelNomeCompleto.Size = New-Object System.Drawing.Size(280,20)
$labelNomeCompleto.Text = 'INSRIA O NOME COMPLETO:'
$form.Controls.Add($labelNomeCompleto)

$textBoxNomeCompleto = New-Object System.Windows.Forms.TextBox
$textBoxNomeCompleto.Location = New-Object System.Drawing.Point(10,60)
$textBoxNomeCompleto.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBoxNomeCompleto)

#segundo Dado: Departamento
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,90)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'INSIRA O DEPARTAMENTO:'
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.Listbox
$listBox.Location = New-Object System.Drawing.Point(10,110)
$listBox.Size = New-Object System.Drawing.Size(260,20)

[void] $listBox.Items.Add('Setor')
[void] $listBox.Items.Add('Setor 2')
[void] $listBox.Items.Add('Setor 3')
[void] $listBox.Items.Add('Setor..')
[void] $listBox.Items.Add('Setor..N')
#[void] $listBox.Items.Add('Setor nome')
#para adicionar mais setores a lista


$listBox.Height = 90
$form.Controls.Add($listBox)

#terceiro dado: Quem copiar
$labelCopiarUsuario = New-Object System.Windows.Forms.Label
$labelCopiarUsuario.Location = New-Object System.Drawing.Point(10,213)#50p de difernça da label anterior
$labelCopiarUsuario.Size = New-Object System.Drawing.Size(280,20)
$labelCopiarUsuario.Text = 'INFORME O USUARIO A SER COPIADO:'
$form.Controls.Add($labelCopiarUsuario)

$textBoxCopiarUsuario = New-Object System.Windows.Forms.TextBox
$textBoxCopiarUsuario.Location = New-Object System.Drawing.Point(10,233)#50p de diferença da textbox anterior 
$textBoxCopiarUsuario.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBoxCopiarUsuario)

#Deixar o formulario sobreposto
$form.Topmost = $true
$result = $form.ShowDialog()
$new = $false
try
{
    if ($result -eq [System.Windows.Forms.DialogResult]::OK)
    {
        $new = $true

        $usuario = tratar_nome $textBoxNomeCompleto.Text

        criar_usuario_ad_E_azure $usuario
    }
}

catch
{
    "ERRO ALGUM DADO INVÁLIDO"
}

try
{
    if ($new -eq $true) 
    {
        Get-ADUser -Identity $copy -Properties memberof | Select-Object -ExpandProperty memberof | Add-ADGroupMember -Members $usuario.Usuario
        $new = $false
    }
}

catch
{
    "ERRO USUARIO NÂO ENCONTRADO"
}