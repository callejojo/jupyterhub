# Usa l'immagine base di Jupyter DataScience
FROM jupyter/datascience-notebook:latest

# Cambia all'utente root per installazioni
USER root

# Installa eventuali dipendenze aggiuntive se necessario
# RUN apt-get update && apt-get install -y \
#     curl \
#     && rm -rf /var/lib/apt/lists/*

# Crea la directory di lavoro per i notebook
RUN mkdir -p /home/jovyan/work

# Crea il file di configurazione Jupyter
RUN mkdir -p /home/jovyan/.jupyter

# Crea il file di configurazione
COPY <<EOF /home/jovyan/.jupyter/jupyter_server_config.py
import os
from jupyter_server.auth import passwd

# Configurazione server
c.ServerApp.ip = '0.0.0.0'
c.ServerApp.port = 8888
c.ServerApp.open_browser = False
c.ServerApp.allow_origin = '*'
c.ServerApp.allow_remote_access = True
c.ServerApp.allow_root = True

# Configura password da variabile d'ambiente
password = os.environ.get('JUPYTER_PASSWORD', 'password')
if password:
    c.ServerApp.password = passwd(password)

# Disabilita token se c'è una password
if password:
    c.ServerApp.token = ''

# Directory di lavoro
c.ServerApp.notebook_dir = '/home/jovyan/work'
EOF

# Assicurati che il file di configurazione appartenga all'utente jovyan
RUN chown -R jovyan:users /home/jovyan/.jupyter
RUN chown -R jovyan:users /home/jovyan/work

# Torna all'utente jovyan
USER jovyan

# Imposta la directory di lavoro
WORKDIR /home/jovyan/work

# Esponi la porta 8888
EXPOSE 8888

# Imposta le variabili d'ambiente di default
ENV JUPYTER_PASSWORD=aimasterclass2025
ENV JUPYTER_ENABLE_LAB=yes

# Comando di avvio
CMD ["start-notebook.sh", "--ServerApp.password_required=True", "--ServerApp.token=''"]
