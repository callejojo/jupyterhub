# Configurazione base
c.JupyterHub.bind_url = 'http://0.0.0.0:8000'

# Configurazione spawner per ambienti limitati
c.Spawner.default_url = '/lab'  # Usa JupyterLab invece di Notebook
c.Spawner.args = ['--NotebookApp.allow_origin=*']

# Memoria limitata
c.Spawner.mem_limit = '512M'
c.Spawner.cpu_limit = 1

# Autenticazione PAM (usa utenti sistema)
c.JupyterHub.authenticator_class = 'jupyterhub.auth.PAMAuthenticator'

# Utenti amministratori
c.Authenticator.admin_users = {'admin'}

# Utenti consentiti
c.Authenticator.allowed_users = {'admin', 'giorgio'}

# Permetti creazione utenti via web
c.JupyterHub.admin_access = True

# Timeout più lunghi
c.Spawner.start_timeout = 120  # 2 minuti invece di 30 secondi
c.Spawner.http_timeout = 60

# Configurazione spawner per container
c.JupyterHub.spawner_class = 'jupyterhub.spawner.SimpleLocalProcessSpawner'
