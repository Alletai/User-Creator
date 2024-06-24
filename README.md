<h1>USER CREATION</h1>
<p>Um script criado para testar algumas funcionalidades do powershell.</p>
<p>Cria usuarios novos no ActiveDirectory do Microsoft Windows e no Microsoft Azure</p>

<p>Para utilizar corretamente você precisará alterar algumas variaveis (ainda estou aprendendo, farei isso mais seguro e funcional futuramente)</p>
<p>A variavel $user_adm deve ser alterada para seu e-mail de Admin do microsoft azure, assim como sua senha deve ser definida na variavel $senha_adm</p>

<p>A função tratar nome cria logins, senhas e-mails padronizados. </p>
<h2>EXEMPLO</h2>
<p>Nome: Matheus Cauã </p>
<p>User: matheusc </p>
<p>E-mail: metheusc@email.com.br </p>
<p>Senha: [algumaCoisa] + "mc" </p>
<p>Pode ser definida uma senha, porem por padrão e para atender os requerimentos do MSAD, a senha terminará com a primeira letra do nome e do sobrenome do usuário</p>

<p>Agora para definir em qual setor o usuário será criado, defina nos campos OU, DC, DC, Os nomes dos "diretorios" do seu AD </p>

<h2>EXEMPLO</h2>
<p>Organization Unit (OU) Setor da empresa</p>
<p>OU = TI </p>
<p>Domain Component (DC) Nome da empresa que engloba os OU's</p>
<p>DC = empresaFeliz </p>
<p>DC = local</p>


<p>Acredito que seja somente isso, se alguém por algum motivo, ver e utilizar isso, perdoe o README mal feito e o código sujo... sabe como é ainda estou aprendendo :P </p>
