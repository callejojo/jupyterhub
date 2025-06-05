# Usa l'immagine base di Jupyter DataScience
FROM jupyter/datascience-notebook:latest

# Cambia all'utente root per installazioni
USER root

# Installa curl se non presente
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

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

# Crea script keep-alive semplice
COPY <<EOF /usr/local/bin/keep-alive.sh
#!/bin/bash

# Funzione per fare richieste HTTP keep-alive
keep_alive() {
    # Aspetta che Jupyter si avvii
    sleep 30
    
    while true; do
        # Ogni 10 minuti fai una richiesta a te stesso
        sleep 600
        curl -s http://localhost:8888/api/status > /dev/null 2>&1 || true
        echo "$(date): Keep-alive ping sent"
    done
}

# Avvia keep-alive in background
keep_alive &

# Avvia Jupyter
exec start-notebook.sh --ServerApp.password_required=True --ServerApp.token=''
EOF

RUN chmod +x /usr/local/bin/keep-alive.sh

# Assicurati che i file appartengano all'utente jovyan
RUN chown -R jovyan:users /home/jovyan/.jupyter
RUN chown -R jovyan:users /home/jovyan/work

# Torna all'utente jovyan
USER jovyan

# Imposta la directory di lavoro
WORKDIR /home/jovyan/work

# Esponi la porta 8888
EXPOSE 8888

# Imposta le variabili d'ambiente di default
ENV JUPYTER_PASSWORD=password
ENV JUPYTER_ENABLE_LAB=yes

# Comando di avvio con keep-alive
CMD ["/usr/local/bin/keep-alive.sh"]
