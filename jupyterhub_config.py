# Configurazione base
c.JupyterHub.bind_url = 'http://0.0.0.0:8000'

# Autenticazione PAM (usa utenti sistema)
c.JupyterHub.authenticator_class = 'jupyterhub.auth.PAMAuthenticator'

# Utenti amministratori
c.Authenticator.admin_users = {'admin'}

# Utenti consentiti
c.Authenticator.allowed_users = {'admin', 'giorgio'}

# Permetti creazione utenti via web
c.JupyterHub.admin_access = True

# Spawner locale
c.JupyterHub.spawner_class = 'jupyterhub.spawner.LocalProcessSpawner'
